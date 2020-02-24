import { LightningElement, api } from 'lwc';

export default class Modal extends LightningElement {

    @api recordId;
    @api visible = false;
    /* @track : 
    Marks a property for internal monitoring. A template or function using
    this property forces a component to rerender when the property’s value changes.
    Use this to store values locally, especially as a user interacts with your
    component.
    */
    
    showModal(){
       //setting visible to true on button click for modal to be visible
       this.visible = true;
    }

    
    hideModal(){
       //setting visible to flase to hide/close modal
       this.visible = false;
    }

    handleConfirm(){
        this.dispatchEvent(new CustomEvent(
            'canceledreservation',
            {bubbles: true}
        ));
    }
    handleCancel(){
        this.dispatchEvent(new CustomEvent(
            'cancel',
            {bubbles: true}
        ));
    }
}