@IsTest
private class TAC_TalentPipelineTests {
    private class GithubReadmeMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            String md = '# Agentic Campus\n## Use Cases\n- Track talent\n- Referrals';
            String b64 = EncodingUtil.base64Encode(Blob.valueOf(md));
            res.setBody('{"content":"' + b64 + '","encoding":"base64"}');
            return res;
        }
    }

    @IsTest
    static void readmePull_populatesSummaryAndUseCases() {
        Test.setMock(HttpCalloutMock.class, new GithubReadmeMock());
        TAC_Talent__c talent = new TAC_Talent__c(Name = 'Alex Agent', Certifications__c = 'None Yet');
        insert talent;
        TAC_Project__c project = new TAC_Project__c(
            Name = 'Creatathon Build',
            TAC_Talent__c = talent.Id,
            GitHub_Repo_URL__c = 'https://github.com/octocat/Hello-World'
        );
        insert project;

        Test.startTest();
        Test.stopTest();

        TAC_Project__c updated = [
            SELECT Project_Summary__c, Use_Cases__c
            FROM TAC_Project__c
            WHERE Id = :project.Id
        ];
        System.assert(updated.Project_Summary__c != null && updated.Project_Summary__c.contains('Agentic'));
        System.assert(updated.Use_Cases__c != null && updated.Use_Cases__c.contains('talent'));
    }

    @IsTest
    static void dashboardController_returnsAggregates() {
        insert new TAC_Talent__c(
            Name = 'Bo Builder',
            Launch_Status__c = 'Job Ready',
            Skills__c = 'LWC, Apex, Flow'
        );
        insert new TAC_Talent__c(
            Name = 'Casey Coder',
            Launch_Status__c = 'Scouted',
            Skills__c = 'LWC; JavaScript'
        );

        Test.startTest();
        TAC_LaunchpadDashboardController.Stats stats = TAC_LaunchpadDashboardController.getStats();
        Test.stopTest();

        System.assertEquals(2, stats.totalTalents);
        System.assertEquals(1, stats.jobReadyCount);
        System.assert(stats.statusCounts.containsKey('Job Ready'));
        System.assert(!stats.topSkills.isEmpty());
    }

    @IsTest
    static void githubParser_extractsOwnerName() {
        TAC_GitHubRepoParser.RepoRef a = TAC_GitHubRepoParser.parse('https://github.com/octocat/Hello-World');
        System.assertEquals('octocat', a.owner);
        System.assertEquals('Hello-World', a.name);
        TAC_GitHubRepoParser.RepoRef b = TAC_GitHubRepoParser.parse('git@github.com:foo/bar.git');
        System.assertEquals('foo', b.owner);
        System.assertEquals('bar', b.name);
    }
}
