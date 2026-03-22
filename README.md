# Creatathon Project — The Launchpad (Agentic Campus)

Salesforce DX source for **The Launchpad**, a talent-pipeline app for **The Agentic Campus**: track creatathon builders, pull GitHub READMEs, score job readiness, and surface a hiring dashboard.

## What’s in the box

- **Custom objects:** `TAC_Talent__c`, `TAC_Project__c` (project looks up talent)
- **Lightning app:** *The Launchpad* — Home dashboard LWC, Talent, Projects, Tasks (Outreach)
- **Automation:** Record-triggered Flow `TAC_Project_Readiness` (rubric → talent score/status + referral Task)
- **GitHub integration:** `TAC_FetchProjectReadmeQueueable` + Remote Site `GitHub_API` → `Project_Summary__c` and parsed `Potential_Use_Cases__c` when a repo URL is saved
- **Permission set:** `TAC_Launchpad_Access` (assign to users who need the app)

## Deploy

```bash
sf org login web --alias yourOrg
sf config set target-org yourOrg
sf project deploy start
sf apex run test --tests TAC_TalentPipelineTests --synchronous
```

Assign **TAC Launchpad Access** in Setup → Permission Sets.

## Sample data (optional)

```bash
sf apex run --file scripts/apex/seed_tac_pipeline.apex --target-org yourOrg
```

## Salesforce DX references

- [Development models](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models)
- [DX project configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm)
- [Salesforce CLI](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
