/**
 * Created by booka on 14.11.2022.
 */

import {LightningElement, api, wire, track} from 'lwc';
import {getFieldValue, getRecord} from "lightning/uiRecordApi";
import { NavigationMixin } from 'lightning/navigation';

const FIELDS = [
    'Property__c.Owner__r.FirstName',
    'Property__c.Owner__r.LastName',
    'Property__c.Owner__r.Phone',
    'Property__c.Owner__r.HomePhone',
    'Property__c.Owner__r.Email',
    'Property__c.Owner__r.Total_Property_Price__c',
    'Property__c.Owner__r.Id',
    'Property__c.Owner__r.Name',
];

export default class PropertyOwner extends NavigationMixin(LightningElement) {
    @api recordId;
    @track dataCheck;
    @track error;
    @track ownerId;

    @track name;
    @track firstName;
    @track lastName;
    @track phone;
    @track homePhone;
    @track email;
    @track totalPropertyPrice;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredContact({ error, data }) {
        if(error){
            this.error = error;
            this.dataCheck = false;
        }else if(data){
            this.dataCheck = true;
            this.ownerId = getFieldValue(data, 'Property__c.Owner__r.Id');
            this.name = getFieldValue(data, 'Property__c.Owner__r.Name');
            this.firstName = getFieldValue(data, 'Property__c.Owner__r.FirstName');
            this.lastName = getFieldValue(data, 'Property__c.Owner__r.LastName');
            this.phone = getFieldValue(data, 'Property__c.Owner__r.Phone');
            this.homePhone = getFieldValue(data, 'Property__c.Owner__r.HomePhone');
            this.email = getFieldValue(data, 'Property__c.Owner__r.Email');
            this.totalPropertyPrice = getFieldValue(data, 'Property__c.Owner__r.Total_Property_Price__c');
        }
    }

    navigateToOwner() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.ownerId,
                objectApiName:'Contact',
                actionName: 'view',
            },
        });
    }
}