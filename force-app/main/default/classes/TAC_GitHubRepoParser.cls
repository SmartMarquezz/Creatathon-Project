public with sharing class TAC_GitHubRepoParser {
    public class RepoRef {
        public String owner;
        public String name;
    }

    /**
     * Parses common GitHub repository URL patterns into owner/name for the REST API.
     */
    public static RepoRef parse(String rawUrl) {
        if (String.isBlank(rawUrl)) {
            return null;
        }
        String u = rawUrl.trim();
        if (u.endsWith('.git')) {
            u = u.substring(0, u.length() - 4);
        }
        if (u.toLowerCase().startsWith('git@github.com:')) {
            String path = u.substring('git@github.com:'.length());
            return splitOwnerName(path);
        }
        Integer gh = u.toLowerCase().indexOf('github.com/');
        if (gh >= 0) {
            String path = u.substring(gh + 'github.com/'.length());
            if (path.contains('?')) {
                path = path.substring(0, path.indexOf('?'));
            }
            return splitOwnerName(path);
        }
        return null;
    }

    private static RepoRef splitOwnerName(String path) {
        if (String.isBlank(path)) {
            return null;
        }
        if (path.startsWith('/')) {
            path = path.substring(1);
        }
        List<String> parts = path.split('/');
        if (parts.size() >= 2) {
            RepoRef r = new RepoRef();
            r.owner = parts[0];
            r.name = parts[1];
            if (String.isBlank(r.owner) || String.isBlank(r.name)) {
                return null;
            }
            return r;
        }
        return null;
    }

    /**
     * Best-effort extraction of a "use cases" style section from README markdown.
     */
    public static String extractUseCasesSection(String readme) {
        if (String.isBlank(readme)) {
            return null;
        }
        List<String> headers = new List<String>{
            '## use cases',
            '## use case',
            '## problem',
            '## overview',
            '## demo',
            '## features'
        };
        String lower = readme.toLowerCase();
        Integer start = -1;
        String matched = null;
        for (String h : headers) {
            Integer idx = lower.indexOf(h);
            if (idx >= 0 && (start < 0 || idx < start)) {
                start = idx;
                matched = h;
            }
        }
        if (start < 0 || matched == null) {
            return null;
        }
        Integer bodyStart = start + matched.length();
        String rest = readme.substring(bodyStart);
        Integer nextHeader = rest.toLowerCase().indexOf('\n## ');
        String section = nextHeader >= 0 ? rest.substring(0, nextHeader) : rest;
        section = section.trim();
        return String.isBlank(section) ? null : section;
    }
}
