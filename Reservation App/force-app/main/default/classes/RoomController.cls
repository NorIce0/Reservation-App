public with sharing class RoomController {
    public RoomController() {

    }

    @AuraEnabled( Cacheable=true )
    public static Room__c[] getRooms(){
        return [ SELECT Id, Name, MaximumCapacity__c, HasAProjector__c
                FROM Room__c ORDER BY Name ];
    }

    @AuraEnabled(cacheable=true)
    public static Room__c getRoomId(String name){
        return [SELECT Id FROM Room__c WHERE Name = :name];
    }

    @AuraEnabled( Cacheable=true )
    public static Room__c[] getFilteredRoomsByDatetime( Datetime initialTime, Datetime endTime ) {

        Datetime start = initialTime;
        Datetime endT = endTime;

        Reservation__c []reservations = new List<Reservation__c>();
        
        if( start != null && endT != null ) {
            reservations = [ SELECT r.AssignedRoom__c, r.InitialTime__c, r.EndTime__c 
                                FROM Reservation__c r
                                WHERE r.EndTime__c > :initialTime AND r.InitialTime__c < :endTime ];
        }

        Set<Id> existingRooms = new Set<Id>();
        for (Reservation__c reservation : reservations) {
            existingRooms.add( reservation.AssignedRoom__c );
        }

        return [SELECT  Id, Name, MaximumCapacity__c, HasAProjector__c 
                FROM Room__c rom
                WHERE rom.Id not in :existingRooms
                ORDER BY rom.Name];
    }

}