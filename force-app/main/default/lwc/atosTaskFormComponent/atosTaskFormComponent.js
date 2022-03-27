import { LightningElement, api, wire } from 'lwc';
import searchUsers from '@salesforce/apex/AtosTaskComponentController.searchUsers';
import getNameOfLead from '@salesforce/apex/AtosTaskComponentController.getNameOfLead';
import pushNewTask from '@salesforce/apex/AtosTaskComponentController.pushNewTask';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RecordFieldDataType } from 'lightning/uiRecordApi';

export default class AtosTaskFormComponent extends LightningElement {

    
    @api recordId;
    
    renderedCallback() {
        getNameOfLead({recordId : this.recordId})
        .then((result) => {
            this.leadFirstName = result[0];
            this.fields.FirstName = result[0];
            this.leadLastName = result[1];
            this.fields.LastName = result[1];
            this.leadName = result[0] + ' ' + result[1];
            this.fields.Subject = 'Other' + ' ' + result[0] + ' ' + result[1]
        })
    }

    pickListValue;
    searchValue;
    listOfUsersToDisplay;
    userId;
    taskDescription;
    taskDate;
    leadFirstName;
    leadLastName;
    leadName;
    columns = [
        { label: 'Id', fieldName: 'Id' },
        { label: 'Email', fieldName: 'Email', type: 'email' },
        { label: 'First Name', fieldName: 'FirstName', type: 'text' },
        { label: 'Last Name', fieldName: 'LastName', type: 'text' }
    ];
    fields = {
        'OwnerId' : this.userId,
        'Subject' : 'Other',
        'Priority': 'Normal',
        'Description': this.taskDescription,
        'FirstName' : this.FirstName,
        'LastName': this.LastName,
        'ActivityDate' : this.taskDate,
        'Status' : this.pickListValue,
    }
    
    
    get options() {
        return [
            { label: 'Not Started', value: 'Not Started' },
            { label: 'In Progress', value: 'In Progress' },
            { label: 'Completed', value: 'Completed' },
            { label: 'Waiting on someone else', value: 'Waiting on someone else' },
            { label: 'Deferred', value: 'Deferred' },
        ];
    }

    get disabledBtn(){
        return !(this.pickListValue && this.taskDescription && this.taskDate && this.userId);
    }

    get todaysDate() {
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = mm + '/' + dd + '/' + yyyy;
        return today
    }

    handleChange(event) {
        this.pickListValue = event.detail.value;
        this.fields.Status = this.pickListValue;
    }

    setNewInputValue(event) {
        this.searchValue = event.detail.value;
    }

    handleSearchKeyword() {
        searchUsers({searchValue: this.searchValue})
            .then((result) => {
                this.listOfUsersToDisplay = result;
            })
            .catch((error) => {
                console.log(error);
            })
    }

    rowTableHandler() {
        this.userId = this.template.querySelector("lightning-datatable").getSelectedRows()[0].Id;
        this.fields.OwnerId = this.userId;
    }

    getDescription(event) {
        this.taskDescription = event.target.value;
        this.fields.Description = this.taskDescription;
    }
    
    getDate(event){
        this.taskDate = event.target.value;
        this.fields.ActivityDate = this.taskDate;
    }
    sendTaskData(){
        let param = `${JSON.stringify(this.fields)}`;
        this.closeQuickAction();
        this.showNotification();
        pushNewTask({param : param})
        .then((result) => {
            console.log(result);
            
        })
        .catch((error) => {
            alert('did not work');
            console.log(error);
        })
    }

    closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: 'Success!',
            message: 'Task was created',
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

} 