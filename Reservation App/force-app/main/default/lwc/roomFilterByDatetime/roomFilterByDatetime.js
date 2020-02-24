import { LightningElement, track } from 'lwc';

export default class RoomFilterByDatetime extends LightningElement {

    @track initialTime = '';
    @track endTime = '';

    handleInitialTimeChange(event){

        this.initialTime = event.target.value;
        
    }

    handleEndTimeChange(event){

        this.endTime = event.target.value;

    }

}