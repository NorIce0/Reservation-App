@isTest
public class TestDataFactory{
    public static List<Room__c> createRooms( Integer roomsQuantity ) {
        List<Room__c> rooms = new List<Room__c>();
        
        for ( Integer i = 0; i < roomsQuantity; i++ ) {
            Room__c r = new Room__c( MaximumCapacity__c = 5 );
            rooms.add( r );
        }
        
        return rooms;
    }
    
    public static List<Room__c> insertRooms( Integer roomsQuantity ) {
        List<Room__c> rooms = createRooms(roomsQuantity);
        
        insert rooms;
        
        return rooms;
    }
    
    public static List<Reservation__c> createReservations(Integer quantity ) {
        List<Reservation__c> reservations = new List<Reservation__c>();
        List<Room__c> rooms = new List<Room__c>();
        
        rooms = insertRooms( quantity );
        
        for ( Integer i = 0; i < quantity; i++ ) {
            Reservation__c reservation = new Reservation__c( AssignedRoom__c = rooms.get( i ).Id,
                                                             InitialTime__c = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 ),
                                                             EndTime__c = Datetime.newInstance( 2020, 3, 5, 13, 00, 00 ) );
            reservations.add( reservation );
        }
        
        return reservations;
    }
    
    public static List<Reservation__c> insertReservations( Integer reservationQuantity ) {
        List<Reservation__c> reservations = createReservations( reservationQuantity );
        
        insert reservations;
        
        return reservations;
    }
    
}