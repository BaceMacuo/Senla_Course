/**
 * Created by booka on 14.11.2022.
 */

import {LightningElement, track} from 'lwc';

//https://www.hitak.ru/gen/create
const persons = [
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

const columns = [
    {label: 'First Name', fieldName: 'firstName'},
    {label: 'Last Name', fieldName: 'lastName'},
    {label: 'Birthday', fieldName: 'birthday', type: 'date'},
    {label: 'Gender', fieldName: 'gender'},
    {label: 'Email', fieldName: 'email', type: 'email'},
];

export default class PersonsInformation extends LightningElement {
    @track persons = persons;
    @track personsDuplicated = persons;
    columns = columns;

    @track valueCheckboxFemale = false;
    @track valueCheckboxMale = false;
    @track valueCombobox = '';
    @track disableCheckboxFemale = false;
    @track disableCheckboxMale = false;
    @track valueEmail = '';

    //combobox-start
    get options() {
        return [
            {label: 'First Name', value: 'firstName'},
            {label: 'Last Name', value: 'lastName'},
            {label: 'Email', value: 'email'},
        ];
    }

    handleCombobox(event) {
        this.valueCombobox = event.detail.value;
        const result = JSON.parse(JSON.stringify(this.persons)).sort((first, second) => first[event.detail.value].localeCompare(second[event.detail.value]));
        this.persons = result;
    }

    //combobox-end

    //date-start
    handleDateFrom(event) {
        const choseDate = new Date(event.detail.value);
        const result = this.persons.filter(item => {
            return new Date(item.birthday) >= choseDate
        });
        this.persons = result;
    }

    handleDateTo(event) {
        const choseDate = new Date(event.detail.value);
        const result = this.persons.filter(item => {
            return new Date(item.birthday) <= choseDate
        });
        this.persons = result;
    }

    //date-end

    //checkbox-start
    handleCheckboxMale() {
        if (this.valueCheckboxMale == true) {
            this.valueCheckboxFemale = false;
            this.valueCheckboxMale = false;
            this.persons = this.personsDuplicated;
            this.disableCheckboxFemale = false;
        } else {
            this.valueCheckboxFemale = false;
            this.valueCheckboxMale = true;
            const result = this.persons.filter(item => {
                return item.gender == 'MALE';
            });
            this.persons = result;
            this.disableCheckboxFemale = true;
        }
    }

    handleCheckboxFemale() {
        if (this.valueCheckboxFemale == true) {
            this.valueCheckboxFemale = false;
            this.valueCheckboxMale = false;
            this.persons = this.personsDuplicated;
            this.disableCheckboxMale = false;
        } else {
            this.valueCheckboxFemale = true;
            this.valueCheckboxMale = false;
            this.personsDuplicated = this.persons;
            const result = this.persons.filter(item => {
                return item.gender == 'FEMALE';
            });
            this.persons = result;
            this.disableCheckboxMale = true;
        }
    }

    //checkbox-end

    //email
    handleEmail(event) {
        if (event.detail.value == '') {
            this.persons = this.personsDuplicated;
        } else {
            this.personsDuplicated = this.persons;
            const result = this.persons.filter(item => {
                return item.email.toLowerCase().includes(event.target.value.toLowerCase());
            });
            this.persons = result;
        }
    }

    //buttonReset
    handleReset() {
        this.valueCombobox = '';
        this.persons = persons;
        this.template.querySelectorAll(".sorting-item")
            .forEach(element => {
                element.value = null;
            });
        this.valueCheckboxFemale = false;
        this.valueCheckboxMale = false;
        this.disableCheckboxFemale = false;
        this.disableCheckboxMale = false;
    }


}