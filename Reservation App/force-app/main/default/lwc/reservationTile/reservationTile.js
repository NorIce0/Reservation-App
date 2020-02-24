import { LightningElement, api, wire } from 'lwc';
import getAssignedRoomName from '@salesforce/apex/ReservationController.getAssignedRoomName';

export default class ReservationTile extends LightningElement {

    @api reservation;
    
    @api
    get selectedReservationProperty(){
        return this.selected;
    }
    
    set selectedReservationProperty(selectedId){
        const element = this.template.querySelector('.reservation-tile');
        if( element ){
            if( this.reservation.Id === selectedId ){
                element.classList.add('active');
            }else{
                element.classList.remove('active');
            }
        }
        
    }

    @wire(getAssignedRoomName, {assignedRoom: '$reservation.AssignedRoom__c'}) assignedRoomName;

    handleSelect(event) {
        event.preventDefault();
    
        const selectEvent = new CustomEvent('select',
        {bubbles: true}
        ); 
        this.dispatchEvent(selectEvent);

    }

}