public with sharing class TAC_LaunchpadDashboardController {
    public class SkillCount {
        @AuraEnabled
        public String skill;
        @AuraEnabled
        public Integer count;
    }

    public class Stats {
        @AuraEnabled
        public Integer totalTalents;
        @AuraEnabled
        public Integer jobReadyCount;
        @AuraEnabled
        public Map<String, Integer> statusCounts;
        @AuraEnabled
        public List<SkillCount> topSkills;
    }

    @AuraEnabled(cacheable=true)
    public static Stats getStats() {
        Stats stats = new Stats();
        stats.totalTalents = [SELECT COUNT() FROM TAC_Talent__c];
        stats.jobReadyCount = [SELECT COUNT() FROM TAC_Talent__c WHERE Launch_Status__c = 'Job Ready'];
        stats.statusCounts = new Map<String, Integer>();
        for (AggregateResult ar : [
            SELECT Launch_Status__c st, COUNT(Id) cnt
            FROM TAC_Talent__c
            GROUP BY Launch_Status__c
        ]) {
            stats.statusCounts.put((String) ar.get('st'), (Integer) ar.get('cnt'));
        }

        Map<String, Integer> skillTotals = new Map<String, Integer>();
        for (TAC_Talent__c row : [SELECT Skills__c FROM TAC_Talent__c]) {
            if (String.isBlank(row.Skills__c)) {
                continue;
            }
            for (String token : row.Skills__c.split('[;,\\n]', 0)) {
                String sk = token.trim();
                if (String.isBlank(sk)) {
                    continue;
                }
                String key = sk.toLowerCase();
                skillTotals.put(key, (skillTotals.containsKey(key) ? skillTotals.get(key) : 0) + 1);
            }
        }

        List<SkillCount> ranked = new List<SkillCount>();
        for (String key : skillTotals.keySet()) {
            SkillCount sc = new SkillCount();
            sc.skill = key;
            sc.count = skillTotals.get(key);
            ranked.add(sc);
        }
        ranked.sort(new SkillCountComparator());
        while (ranked.size() > 10) {
            ranked.remove(ranked.size() - 1);
        }
        stats.topSkills = ranked;
        return stats;
    }

    private class SkillCountComparator implements Comparator<SkillCount> {
        public Integer compare(SkillCount a, SkillCount b) {
            if (a.count > b.count) {
                return -1;
            }
            if (a.count < b.count) {
                return 1;
            }
            return 0;
        }
    }
}
