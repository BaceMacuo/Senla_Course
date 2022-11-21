/**
 * Created by booka on 14.11.2022.
 */

import {LightningElement, api, wire} from 'lwc';
import {getFieldValue, getRecord} from "lightning/uiRecordApi";
import { NavigationMixin } from 'lightning/navigation';
import {navigateToOwner, FIELDS_BY_PROPERTY} from 'c/utils'

const CONTACT_OBJECT_API_NAME_FOR_NAVIGATION = 'Contact';
const VIEW_ACTION_NAME_FOR_NAVIGATION = 'view';

export default class PropertyOwner extends NavigationMixin(LightningElement) {
    @api recordId;
    dataCheck;
    error;
    ownerId;
    takeNavigateToOwnerMethod = navigateToOwner.bind(this);

    name;
    firstName;
    lastName;
    phone;
    homePhone;
    email;
    totalPropertyPrice;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS_BY_PROPERTY })
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

    handleClickNavigateToOwner() {
        this.takeNavigateToOwnerMethod(
            this.ownerId,
            CONTACT_OBJECT_API_NAME_FOR_NAVIGATION,
            VIEW_ACTION_NAME_FOR_NAVIGATION);
    }
}