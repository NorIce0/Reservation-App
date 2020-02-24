import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { deleteRecord } from 'lightning/uiRecordApi';

export default class CancelReservation extends LightningElement {
    
    @track error;
    @track reservationToCancelId = null;
    @track reservationToCancelObject = null;
    @track hasSelected = false;
    @track refresh = false;

    @track visible = false;

    handleDelete(){
        if( this.reservationToCancelId ){
            this.visible = true;
        }
    }

    handleCancel() {
        this.visible = false;
        deleteRecord(this.reservationToCancelId)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Reservation canceled',
                    variant: 'success'
                })
            );
            this.clearFields();
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error deleting record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }

    handleSelectedRoom(event){

        if(this.reservationToCancelId === event.detail.Id ){
            this.reservationToCancelId = null;
            this.reservationToCancelObject = null;
            this.hasSelected = false;
        }else{
            this.reservationToCancelId = event.detail.Id;
            this.reservationToCancelObject = {
                Id: event.detail.Id,
                Name: event.detail.Name,
                AssignedRoom: event.detail.AssignedRoom__c,
                RoomName: event.detail.assignedRoomName,
                InitialDatetime: event.detail.InitialTime__c,
                EndDatetime: event.detail.EndTime__c
            }
            this.hasSelected = true;
            
        }

    }
    
    handleHideModal(){
        this.visible = false;
    }

    clearFields(){
        this.reservationToCancelId = null;
        this.reservationToCancelObject = null;
        this.hasSelected = false;
        this.refresh = true;
    }

    handleRefresh(){
        this.refresh = false;
    }

}