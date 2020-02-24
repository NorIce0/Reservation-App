import { LightningElement, wire, api, track } from 'lwc';
import getFilteredRoomsByDatetime from '@salesforce/apex/RoomController.getFilteredRoomsByDatetime';
import { refreshApex } from '@salesforce/apex';



export default class FilteredRoomList extends LightningElement {

    @api initialDatetime;
    @api endDatetime;
    @track selectedId = null;
    @api
    refresh(value){
        if(value){
            refreshApex(this.rooms);
            this.dispatchEvent(new CustomEvent('refreshed'));

        }
    }
    

    @wire( getFilteredRoomsByDatetime, {initialTime:'$initialDatetime', endTime:'$endDatetime'} ) rooms;

    handleSelected(event){
        
        if( this.selectedId === event.target.room.Id ){
            this.selectedId = null;
        }else{
            this.selectedId = event.target.room.Id;
        }

        const selectEvent = new CustomEvent('selectedroom',
        {detail: {Id: event.target.room.Id, Name: event.target.room.Name}},
        {bubbles: true});
        
        this.dispatchEvent(selectEvent);
    }

}