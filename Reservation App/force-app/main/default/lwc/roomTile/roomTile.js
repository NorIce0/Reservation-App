import { LightningElement, api } from 'lwc';

export default class RoomTile extends LightningElement {

    @api room;

    @api
    get selectedProperty(){
        return this.selected;
    }
    
    set selectedProperty(selectedId){
        const element = this.template.querySelector('.room-tile');
            if( element ){
                if( this.room.Id === selectedId ){
                    element.classList.add('active');
                }else{
                    element.classList.remove('active');
                }
            }
        
    }

    handleSelect(event) {
        event.preventDefault();
/*
        this.template.querySelector('.room-tile').classList.remove('active');
        this.template.querySelector('.room-tile').classList.add('active');
        console.log('this: ');
        console.log(this);
        console.log('this template: ');
        console.log(this.template);
        console.log('this template query: ');
        console.log(this.template.querySelector('.room-tile'));
*/
        const selectEvent = new CustomEvent('select',
        {bubbles: true}
        );
        this.dispatchEvent(selectEvent);
    }

}