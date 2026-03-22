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
     * Extracts the first matching "use cases" style section (case-insensitive headers),
     * from the header through the line before the next markdown ## heading.
     */
    public static String extractPotentialUseCasesSection(String readme) {
        if (String.isBlank(readme)) {
            return null;
        }
        List<String> headerPatterns = new List<String>{
            '## use cases',
            '## what this can be used for',
            '## potential use cases',
            '## problem',
            '## who is this for',
            '## real world applications'
        };
        String lower = readme.toLowerCase();
        Integer bestIdx = -1;
        String matchedLower = null;
        for (String h : headerPatterns) {
            Integer idx = lower.indexOf(h);
            if (idx >= 0 && (bestIdx < 0 || idx < bestIdx)) {
                bestIdx = idx;
                matchedLower = h;
            }
        }
        if (bestIdx < 0 || matchedLower == null) {
            return null;
        }
        Integer afterHeader = bestIdx + matchedLower.length();
        if (afterHeader > readme.length()) {
            return null;
        }
        String rest = readme.substring(afterHeader);
        rest = rest.replaceFirst('^[\\s\\r\\n]+', '');
        Integer cut = indexOfNextH2Line(rest);
        String section = cut >= 0 ? rest.substring(0, cut) : rest;
        section = section.trim();
        return String.isBlank(section) ? null : section;
    }

    private static Integer indexOfNextH2Line(String segment) {
        if (String.isBlank(segment)) {
            return -1;
        }
        Integer a = segment.indexOf('\n## ');
        Integer b = segment.indexOf('\r\n## ');
        if (a < 0) {
            return b;
        }
        if (b < 0) {
            return a;
        }
        return Math.min(a, b);
    }
}
