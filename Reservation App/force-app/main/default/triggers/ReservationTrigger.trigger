trigger ReservationTrigger on Reservation__c ( before insert, before update ) {
       
    ReservationTriggerHandler.handleReservation( Trigger.New );
    
}