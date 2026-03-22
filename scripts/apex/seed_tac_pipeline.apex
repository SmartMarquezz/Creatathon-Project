delete [SELECT Id FROM TAC_Project__c];
delete [SELECT Id FROM TAC_Talent__c];

TAC_Talent__c eric = new TAC_Talent__c(
    Name = 'Eric Marquez',
    Full_Name__c = 'Eric Marquez',
    Email__c = 'ericlluhen@gmail.com',
    LinkedIn_URL__c = 'https://www.linkedin.com/in/smartmarquezz/',
    Current_Role__c = 'Developer',
    Location__c = 'New York, NY',
    Salesforce_Skills__c = 'Apex;LWC;Flow;Agentforce',
    Skills__c = 'Apex;LWC;Flow;Agentforce',
    Certifications__c = 'Admin;PD1',
    Creatathon_Participant__c = true,
    Creatathon_Edition__c = 'March 2026',
    Launch_Status__c = 'Job Ready',
    Job_Readiness_Score__c = 100,
    Readiness_Score__c = 100
);
insert eric;

TAC_Talent__c studentOne = new TAC_Talent__c(
    Name = 'Student One',
    Full_Name__c = 'Student One',
    Current_Role__c = 'Student',
    Location__c = 'New York, NY',
    Salesforce_Skills__c = 'Flow;LWC',
    Skills__c = 'Flow;LWC',
    Certifications__c = 'None Yet',
    Creatathon_Participant__c = true,
    Creatathon_Edition__c = 'March 2026',
    Launch_Status__c = 'In Progress',
    Job_Readiness_Score__c = 60,
    Readiness_Score__c = 60
);
insert studentOne;

TAC_Talent__c studentTwo = new TAC_Talent__c(
    Name = 'Student Two',
    Full_Name__c = 'Student Two',
    Current_Role__c = 'Student',
    Location__c = 'New York, NY',
    Salesforce_Skills__c = 'Flow',
    Skills__c = 'Flow',
    Certifications__c = 'None Yet',
    Creatathon_Participant__c = true,
    Creatathon_Edition__c = 'March 2026',
    Launch_Status__c = 'Scouted',
    Job_Readiness_Score__c = 30,
    Readiness_Score__c = 30
);
insert studentTwo;

String wowDetail =
    'Paste a GitHub URL and the app auto-reads the README, scores the builder, and tells you who is ready to hire';
String potentialUseCases =
    'Internal TAC talent pipeline, Salesforce community talent scouting, bootcamp graduate tracking, recruiter demo tool for Salesforce hiring managers';

TAC_Project__c launchpad = new TAC_Project__c(
    Name = 'The Launchpad',
    TAC_Talent__c = eric.Id,
    Project_Type__c = 'App',
    Complexity__c = 'Advanced',
    GitHub_Repo_URL__c = 'https://github.com/SmartMarquezz/Creatathon-Project',
    Deployed__c = true,
    Live_Demo_Ready__c = true,
    LinkedIn_Post_URL__c = 'https://www.linkedin.com/in/smartmarquezz/',
    Wow_Factor__c = 'High',
    Wow_Factor_Detail__c = wowDetail,
    Potential_Use_Cases__c = potentialUseCases,
    Build_Time_Hours__c = 2,
    Objects_Created__c = 2,
    Automations_Created__c = 1,
    Components_Created__c = 1
);
insert launchpad;

System.debug('Seeded Talent Ids: ' + eric.Id + ', ' + studentOne.Id + ', ' + studentTwo.Id);
System.debug('Seeded Project Id: ' + launchpad.Id);
