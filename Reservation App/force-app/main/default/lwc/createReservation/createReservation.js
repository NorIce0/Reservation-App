import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/idsUtils';

import RESERVATION_OBJECT from '@salesforce/schema/Reservation__c';
import INITIAL_DATETIME_FIELD from '@salesforce/schema/Reservation__c.InitialTime__c';
import END_DATETIME_FIELD from '@salesforce/schema/Reservation__c.EndTime__c';
import ASSIGNED_ROOM_FIELD from '@salesforce/schema/Reservation__c.AssignedRoom__c';

export default class CreateReservation extends LightningElement {

    @track initialDatetime = '';
    @track endDatetime = '';
    @track reservationId = '';
    @track assignedRoom = '';
    @track name = '';
    @track refresh = false;

    handleSelectedRoom(event){

        if( this.assignedRoom === event.detail.Id ){
            this.assignedRoom = null;
            this.name = '';
            this.hasSelected = false;
        }else{
            this.assignedRoom = event.detail.Id;
            this.name = event.detail.Name;
            }
            this.hasSelected = true;

    }

    handleDatetimeChange(event) {

        if( event.target.name === 'endDT' ){
            this.endDatetime = event.target.value;
        }
        if( event.target.name === 'initialDT' ){
            this.initialDatetime = event.target.value;
        }

    }

    createReservation() {
        const fields = {};
        fields[INITIAL_DATETIME_FIELD.fieldApiName] = this.initialDatetime;
        fields[END_DATETIME_FIELD.fieldApiName] = this.endDatetime;
        fields[ASSIGNED_ROOM_FIELD.fieldApiName] = this.assignedRoom;
        const recordInput = { apiName: RESERVATION_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then(reservation => {
                this.reservationId = reservation.id;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Reservation created',
                        variant: 'success'
                    })
                );
                this.clearFields();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating reservation',
                        message: reduceErrors(error).join(', '),
                        variant: 'error'
                    })
                );
            });
    }


    get initialDTProperty(){

        return this.initialDatetime;

    }

    get endDTProperty(){

        return this.endDatetime;
        
    }

    clearFields(){
        this.initialDatetime = '';
        this.endDatetime = '';
        this.reservationId = '';
        this.assignedRoom = '';
        this.name = '';
        this.refresh = true;
    }

    handleRefresh(){
        this.refresh = false;
    }
}
