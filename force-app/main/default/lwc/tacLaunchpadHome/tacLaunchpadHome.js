import { LightningElement, wire } from 'lwc';
import getStats from '@salesforce/apex/TAC_LaunchpadDashboardController.getStats';

export default class TacLaunchpadHome extends LightningElement {
    stats;
    error;

    @wire(getStats)
    wiredStats({ data, error }) {
        if (data) {
            this.stats = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.stats = undefined;
        }
    }

    get statusEntries() {
        if (!this.stats || !this.stats.statusCounts) {
            return [];
        }
        return Object.keys(this.stats.statusCounts).map((key) => ({
            label: key || 'Unknown',
            value: this.stats.statusCounts[key]
        }));
    }

    get hasTopSkills() {
        return this.stats && this.stats.topSkills && this.stats.topSkills.length > 0;
    }
}
