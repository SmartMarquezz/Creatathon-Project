public with sharing class TAC_FetchProjectReadmeQueueable implements Queueable, Database.AllowsCallouts {
    private final Id projectId;
    private final String repoUrl;

    public TAC_FetchProjectReadmeQueueable(Id projectId, String repoUrl) {
        this.projectId = projectId;
        this.repoUrl = repoUrl;
    }

    public void execute(QueueableContext context) {
        TAC_GitHubRepoParser.RepoRef ref = TAC_GitHubRepoParser.parse(repoUrl);
        if (ref == null) {
            return;
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.github.com/repos/' + ref.owner + '/' + ref.name + '/readme');
        req.setMethod('GET');
        req.setHeader('Accept', 'application/vnd.github.v3+json');
        req.setHeader('User-Agent', 'Salesforce-TAC-AgenticCampus/1.0');
        req.setTimeout(120000);

        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() != 200) {
            return;
        }

        Object parsed = JSON.deserializeUntyped(res.getBody());
        if (!(parsed instanceof Map<String, Object>)) {
            return;
        }
        Map<String, Object> body = (Map<String, Object>) parsed;
        String b64 = (String) body.get('content');
        if (String.isBlank(b64)) {
            return;
        }
        b64 = b64.replaceAll('\\s', '');
        String readme = EncodingUtil.base64Decode(b64).toString();

        String summary = readme;
        if (summary != null && summary.length() > 131072) {
            summary = summary.substring(0, 131072);
        }

        String extractedUseCases = TAC_GitHubRepoParser.extractPotentialUseCasesSection(readme);
        if (extractedUseCases != null && extractedUseCases.length() > 32768) {
            extractedUseCases = extractedUseCases.substring(0, 32768);
        }

        TAC_Project__c updateRow = new TAC_Project__c(Id = projectId, Project_Summary__c = summary);
        if (String.isNotBlank(extractedUseCases)) {
            updateRow.Potential_Use_Cases__c = extractedUseCases;
        }
        update updateRow;
    }
}
