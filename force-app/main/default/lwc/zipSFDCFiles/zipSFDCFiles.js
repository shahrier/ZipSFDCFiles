/* eslint-disable no-console */
import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getRelatedFilesByRecordId from '@salesforce/apex/ZipSFDCFilesController.getRelatedFilesByRecordId';

export default class zipSFDCFiles extends NavigationMixin(LightningElement) {
    /* jshint ignore:start */
    @api recordId;
    @track fileID;
    @track filesToDownload = [];
    SFDCFiles = [];
    
    @wire(getRelatedFilesByRecordId, { recordId: '$recordId' })
    /* jshint ignore:end */
    wiredFieldValue({ error, data }) {
        if (data) {
            this.SFDCFiles = data;
            console.log(this.SFDCFiles);
            this.error = undefined;
            const fileIDs = Object.keys(data);
            this.fileID =  fileIDs.length ? fileIDs[0] : undefined; 
        } else if (error) {
            this.error = error;
            this.fileID = undefined; 
        }
    }

    get options() {
        if (!this.fileID) return [];

        const options = [];
        const files = Object.entries(this.SFDCFiles);
        for (const [ID, title] of files) {
            options.push({
                value: ID,
                label: title
            });
        }        
        return options;
    }

    handleChange(e) {
        this.filesToDownload = e.detail.value;
    }

    downloadZip() {
        if (this.filesToDownload.length > 0) {
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: '/sfc/servlet.shepherd/document/download/' + this.filesToDownload.join('/')
                }
            },
            false
            );
        }
    }
}