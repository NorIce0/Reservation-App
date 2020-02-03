public with sharing class RoomController {
    public RoomController() {

    }

    @AuraEnabled(Cacheable=true)
    public static Room__c[] getRooms(){
        return [SELECT Id, Name, MaximumCapacity__c, HasAProjector__c
                FROM Room__c];
    }

}