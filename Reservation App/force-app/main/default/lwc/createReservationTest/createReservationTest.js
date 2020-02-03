import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

import RESERVATION_OBJECT from '@salesforce/schema/Reservation__c';
import ASSIGNED_ROOM_FIELD from '@salesforce/schema/Reservation__c.AssignedRoom__c';
import INITIAL_DATETIME_FIELD from '@salesforce/schema/Reservation__c.InitialTime__c';
import END_DATETIME_FIELD from '@salesforce/schema/Reservation__c.EndTime__c';


/**
 * Creates Account records.
 */
export default class AccountCreator extends LightningElement {
    reservationObject = RESERVATION_OBJECT;
    assignedRoomField = ASSIGNED_ROOM_FIELD;
    initialDatetimeField = INITIAL_DATETIME_FIELD;
    endDatetimeField = END_DATETIME_FIELD;
    
    errorMessage = " ";

    showToast() {
        const event = new ShowToastEvent({
            title: 'Reservation Created',
            message: 'Reservation successfully created.',
            variant: 'success'
        });
        this.dispatchEvent(event);
    }

    handleReservationCreated(event) {

        this.showToast(event);

    }

    handleReset(){
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }

    }

    handleError(event) {

        event.preventDefault();
        
        this.errorMessage = event.message;

    }

}