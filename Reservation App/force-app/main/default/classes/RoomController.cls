public with sharing class RoomController {
    public RoomController() {

    }

    @AuraEnabled(Cacheable=true)
    public static Room__c[] getRooms(){
        return [SELECT Id, Name, MaximumCapacity__c, HasAProjector__c
                FROM Room__c];
    }
/*
    @AuraEnabled( Cacheable=true )
    public static Room__c[] getFilteredRoomsByDatetime(Datetime initialDatetime, Datetime endDatetime) {
        return [SELECT  Id, Name, MaximumCapacity__c, HasAProjector__c FROM Room__c WHERE Id IN (SELECT AssignedRoom__c, InitialTime__c, EndTime__c 
                            FROM Reservation 
                            WHERE InitialTime__c >= :endDatetime AND EndTime__c <= :initialDatetime) ];
    }
*/
}