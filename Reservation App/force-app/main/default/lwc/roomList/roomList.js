import { LightningElement, wire } from 'lwc';
import getRooms from '@salesforce/apex/RoomController.getRooms';

export default class RoomList extends LightningElement {

    @wire( getRooms ) rooms;

}