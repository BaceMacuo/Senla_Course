/**
 * Created by booka on 14.11.2022.
 */

import {LightningElement} from 'lwc';
import {
    COLUMNS_FOR_SORT_BY_PERSON_INFORMATION_PAGE,
    COLUMNS_FOR_TABLE_PERSON_INFORMATION_PAGE,
    GENDER,
    PERSONS,
} from 'c/utils';

export default class PersonsInformation extends LightningElement {
    personsValue = PERSONS;
    columns = COLUMNS_FOR_TABLE_PERSON_INFORMATION_PAGE;
    optionsForSortBy = COLUMNS_FOR_SORT_BY_PERSON_INFORMATION_PAGE;

    disableCheckboxFemale;
    disableCheckboxMale;
    valueCombobox = '';
    valueEmail = '';
    dateTo = '';
    dateFrom = '';
    genderByLabelInput = '';

    //combobox
    handleCombobox(event) {
        this.valueCombobox = event.detail.value;
        this.logic();
    }

    //date
    handleDate() {
        this.dateTo = this.template.querySelector('[data-id="inputDateTo"]').value ?? '';
        this.dateFrom = this.template.querySelector('[data-id="inputDateFrom"]').value ?? '';
        this.logic();
    }

    //checkbox
    handleCheckboxGender() {
        this.genderByLabelInput = '';
        this.template.querySelectorAll(".sorting-item-checkbox")
            .forEach(element => {
                if(element.checked == true){
                    this.genderByLabelInput = element.label;
                }
            });
        switch (this.genderByLabelInput) {
            case 'FEMALE':
                this.disableCheckboxMale = true;
                this.logic();
                break;
            case 'MALE':
                this.disableCheckboxFemale = true;
                this.logic();
                break;
            default:
                this.disableCheckboxFemale = false;
                this.disableCheckboxMale = false;
                this.logic();
        }
    }

    //email
    handleEmail(event) {
        this.valueEmail = event.target.value ?? '';
        this.logic();
    }

    //buttonReset
    handleReset() {
        this.valueCombobox = '';
        this.personsValue = PERSONS;
        this.template.querySelectorAll(".sorting-item")
            .forEach(element => element.value = null);
        this.template.querySelectorAll(".sorting-item-checkbox")
            .forEach(element => element.checked = false);
        this.disableCheckboxFemale = false;
        this.disableCheckboxMale = false;
    }

    logic(){
        this.personsValue = PERSONS
            .filter(item => this.genderByLabelInput != ''
                ? item.gender == GENDER[this.genderByLabelInput] : item)
            .filter(item => this.valueEmail != ''
                ? item.email.toLowerCase().includes(this.valueEmail.toLowerCase()): item)
            .filter(item => this.dateTo != ''
                ? new Date(item.birthday) <= new Date(this.dateTo) : item)
            .filter(item => this.dateFrom != ''
                ? new Date(item.birthday) >= new Date(this.dateFrom) : item);
        if(this.valueCombobox != ''){
            this.personsValue = JSON.parse(JSON.stringify(this.personsValue))
                .sort((first, second) => first[this.valueCombobox]
                    .localeCompare(second[this.valueCombobox]));
        }
    }
}