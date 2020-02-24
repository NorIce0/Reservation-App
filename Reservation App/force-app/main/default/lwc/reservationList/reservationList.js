import { LightningElement, wire, api, track } from 'lwc';
import getReservations from '@salesforce/apex/ReservationController.getReservations';
import { refreshApex } from '@salesforce/apex';

export default class ReservationList extends LightningElement {

    @track selectedId = null;
    @api
    refresh(value){
        if(value){
            refreshApex(this.reservations);
            this.dispatchEvent(new CustomEvent('refreshed'));
        }
    }

    @wire( getReservations ) reservations;

    handleSelected(event){

        if( this.selectedId === event.target.reservation.Id ){
            this.selectedId = null;
        }else{
            this.selectedId = event.target.reservation.Id;
        }

        const selectEvent = new CustomEvent('selectedreservation',
        {detail: {
            Id: event.target.reservation.Id,
            Name: event.target.reservation.Name,
            roomName: event.target.assignedRoomName
        }}, {bubbles: true});

        this.dispatchEvent(selectEvent);
    }
}