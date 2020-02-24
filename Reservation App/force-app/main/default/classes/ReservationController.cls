public with sharing class ReservationController {
    public ReservationController() {
    }

    @AuraEnabled(cacheable=true)
    public static List<Reservation__c> getReservations(){
        return [SELECT Id, Name, AssignedRoom__c, InitialTime__c, EndTime__c
                FROM Reservation__c];
    }

    @AuraEnabled(cacheable=true)
    public static String getAssignedRoomName(String assignedRoom){
        Room__c res = [SELECT Id, Name FROM Room__c WHERE Id = :assignedRoom LIMIT 1];
        return res.Name;
    }

}
