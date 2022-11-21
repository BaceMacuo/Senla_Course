/**
 * Created by booka on 20.11.2022.
 */
import {NavigationMixin} from "lightning/navigation";


function navigateToOwner(recordId, objectApiNameForNavigation, actionNameForNavigation) {
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: recordId,
            objectApiName: objectApiNameForNavigation,
            actionName: actionNameForNavigation,
        },
    });
}

const FIELDS_BY_PROPERTY = [
    'Property__c.Owner__r.FirstName',
    'Property__c.Owner__r.LastName',
    'Property__c.Owner__r.Phone',
    'Property__c.Owner__r.HomePhone',
    'Property__c.Owner__r.Email',
    'Property__c.Owner__r.Total_Property_Price__c',
    'Property__c.Owner__r.Id',
    'Property__c.Owner__r.Name',
];

//https://www.hitak.ru/gen/create
const PERSONS = [
    {
        Id: 1,
        firstName: 'Anthony',
        lastName: 'Hill',
        birthday: '1986-06-13',
        gender: 'MALE',
        email: 'freddie.davies@example.com'
    },
    {
        Id: 2,
        firstName: 'Paula',
        lastName: 'Taylor',
        birthday: '1953-07-13',
        gender: 'MALE',
        email: 'fmurphy@example.com'
    },
    {
        Id: 3,
        firstName: 'Ross',
        lastName: 'Evans',
        birthday: '1969-11-09',
        gender: 'FEMALE',
        email: 'asimpson@example.com'
    },
    {
        Id: 4,
        firstName: 'Helen',
        lastName: 'Rogers',
        birthday: '1977-06-15',
        gender: 'FEMALE',
        email: 'walker.chris@example.org'
    },
    {
        Id: 5,
        firstName: 'Elizabeth',
        lastName: 'Parker',
        birthday: '1958-11-04',
        gender: 'FEMALE',
        email: 'holmes.archie@example.net'
    },
    {
        Id: 6,
        firstName: 'Jim',
        lastName: 'Morris',
        birthday: '1947-01-12',
        gender: 'MALE',
        email: 'hunt.tanya@example.com'
    },
    {
        Id: 7,
        firstName: 'Jayden',
        lastName: 'Miller',
        birthday: '1993-12-28',
        gender: 'MALE',
        email: 'faye33@example.net'
    },
    {
        Id: 8,
        firstName: 'Erin',
        lastName: 'Roberts',
        birthday: '2002-08-30',
        gender: 'FEMALE',
        email: 'russell.evie@example.net'
    },
    {
        Id: 9,
        firstName: 'Ella',
        lastName: 'Robertson',
        birthday: '1976-06-24',
        gender: 'FEMALE',
        email: 'bell.christopher@example.com'
    },
    {
        Id: 10,
        firstName: 'Logan',
        lastName: 'Stewart',
        birthday: '1975-01-17',
        gender: 'MALE',
        email: 'jeremy06@example.net'
    },
];

const COLUMNS_FOR_TABLE_PERSON_INFORMATION_PAGE = [
    {label: 'First Name', fieldName: 'firstName'},
    {label: 'Last Name', fieldName: 'lastName'},
    {label: 'Birthday', fieldName: 'birthday', type: 'date'},
    {label: 'Gender', fieldName: 'gender'},
    {label: 'Email', fieldName: 'email', type: 'email'},
];

const COLUMNS_FOR_SORT_BY_PERSON_INFORMATION_PAGE = [
    {label: 'First Name', value: 'firstName'},
    {label: 'Last Name', value: 'lastName'},
    {label: 'Email', value: 'email'},
];

const GENDER = {
    'MALE': 'MALE',
    'FEMALE': 'FEMALE',
}

export {
    navigateToOwner,
    FIELDS_BY_PROPERTY,
    PERSONS,
    COLUMNS_FOR_TABLE_PERSON_INFORMATION_PAGE,
    COLUMNS_FOR_SORT_BY_PERSON_INFORMATION_PAGE,
    GENDER,
}