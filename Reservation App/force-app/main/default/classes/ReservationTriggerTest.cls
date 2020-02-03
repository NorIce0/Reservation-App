@isTest
public class ReservationTriggerTest {

	@isTest
    static void testDuplicateReservation() {
        List<Reservation__c> reservations = TestDataFactory.createReservations( 2 );
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        reservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        reservations.get( 0 ).InitialTime__c = defaultDatetime;
        reservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert reservations.get( 0 );
        
        reservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        reservations.get( 1 ).InitialTime__c = defaultDatetime;
        reservations.get( 1 ).EndTime__c = defaultDatetime.addHours( 1 );
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( reservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( !result.isSuccess(), 'Unexpected no overlap reservation' );
        System.assertEquals( 1, result.getErrors().size(), 'Unexpected quantity of errors: ' + result );
        System.assertEquals( 'A reservation cannot overlaps another existing reservation.',
                             result.getErrors()[ 0 ].getMessage(), 'Unexpected error message.' );
        
    }
    
    @isTest
    static void testNoOverlapDayBefore() {
        List<Reservation__c> reservations = TestDataFactory.createReservations( 2 );
        
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        reservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        reservations.get( 0 ).InitialTime__c = defaultDatetime;
        reservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
        
        
        reservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        reservations.get( 1 ).InitialTime__c = defaultDatetime.addDays( -1 );
        reservations.get( 1 ).EndTime__c = defaultDatetime.addDays( -1 ).addHours(1);
        
		Test.startTest();
        
		List<Database.SaveResult> result = Database.insert( reservations, true);
        
        Test.stopTest();
        
        System.assert( result.get( 0 ).isSuccess(), 'Unexpected error: ' + result.get( 0 ).getErrors() );
        
        System.assert( result.get( 1 ).isSuccess(), 'Unexpected error: ' + result.get( 1 ).getErrors() );
    }
    
    @isTest
    static void testNoOverlapBefore() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
        
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        Datetime defaultEndDatetime = defaultDatetime.addHours( 1 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addHours( -2 );
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours( -1 );
             
		Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( result.isSuccess(), 'Unexpected error: ' + result.getErrors() );
        
    }
    
    @isTest
    static void testNoOverlapBeforeLimit() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
        
        Room__c defaultRoom = TestDataFactory.insertRooms(1).get(0);
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addHours( -2 );
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours( -1 );
             
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( result.isSuccess(), 'Unexpected error: ' + result.getErrors() );
        
    }
    
    @isTest
    static void testNoOverlapAfter() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
        
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addHours( 2 );
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours( 3 );
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( result.isSuccess(), 'Unexpected error: ' + result.getErrors() );
        
    }
        
    @isTest
    static void testNoOverlapAfterLimit() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
              
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addHours( 1 );
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours( 2 );
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( result.isSuccess(), 'Unexpected error: ' + result.getErrors() );
        
    }
        
    @isTest
    static void testNoOverlapNextDay() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
                    
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addDays( 1 );
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addDays( 1 ).addHours( 1 );
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( result.isSuccess(), 'Unexpected error: ' + result.getErrors() );
        
    }
    
    
    @isTest
    static void testOverlapInitialTime( ) {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
                    
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c =defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addMinutes(-30);
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours( 1 );
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( !result.isSuccess(), 'Unexpected no overlap reservation' );
        System.assert( result.getErrors().size() == 1, 'Unexpected quantity of errors' );
        System.assertEquals( 'A reservation cannot overlaps another existing reservation.',
                             result.getErrors()[ 0 ].getMessage(), 'Unexpected error: ' + result.getErrors() );
        
    }
       
    @isTest
    static void testOverlapInitialTimeRightLimit() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
                     
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addMinutes(-30);
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours( 1 );
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( !result.isSuccess(), 'Unexpected no overlap reservation' );
        System.assert( result.getErrors().size() == 1, 'Unexpected quantity of errors' );
        System.assertEquals( 'A reservation cannot overlaps another existing reservation.',
                             result.getErrors()[ 0 ].getMessage(), 'Unexpected error: ' + result.getErrors() );
        
    }
    
    
    @isTest
    static void testOverlapFull() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
                      
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addHours( -1 );
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours( 2 );
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( !result.isSuccess(), 'Unexpected no overlap reservation' );
        System.assert( result.getErrors().size() == 1, 'Unexpected quantity of errors' );
        System.assertEquals( 'A reservation cannot overlaps another existing reservation.',
                             result.getErrors()[ 0 ].getMessage(), 'Unexpected error: ' + result.getErrors()  );
        
    }
        
    @isTest
    static void testOverlapEndTimeLeftLimit() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
                       
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime;
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours(2);
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( !result.isSuccess(), 'Unexpected no overlap reservation' );
        System.assert( result.getErrors().size() == 1, 'Unexpected quantity of errors' );
        System.assertEquals( 'A reservation cannot overlaps another existing reservation.',
                             result.getErrors()[ 0 ].getMessage(), 'Unexpected error: ' + result.getErrors()  );
        
    }
        
    @isTest
    static void testOverlapEndTime() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
                       
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addMinutes(30);
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours( 2 );
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( !result.isSuccess(), 'Unexpected no overlap reservation' );
        System.assert( result.getErrors().size() == 1, 'Unexpected quantity of errors' );
        System.assertEquals( 'A reservation cannot overlaps another existing reservation.',
                             result.getErrors()[ 0 ].getMessage(), 'Unexpected error: ' + result.getErrors()  );
        
    }
        
    @isTest
    static void testInnerOverlap() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
                       
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addMinutes( 15 );
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addMinutes( 45 );
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( !result.isSuccess(), 'Unexpected no overlap reservation' );
        System.assert( result.getErrors().size() == 1, 'Unexpected quantity of errors' );
        System.assertEquals( 'A reservation cannot overlaps another existing reservation.',
                             result.getErrors()[ 0 ].getMessage(), 'Unexpected error: ' + result.getErrors()  );
        
    }
        
    @isTest
    static void testInnerOverlapLeftLimit() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
                       
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime;
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addMinutes( 30 );
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( !result.isSuccess(), 'Unexpected no overlap reservation' );
        System.assert( result.getErrors().size() == 1, 'Unexpected quantity of errors' );
        System.assertEquals( 'A reservation cannot overlaps another existing reservation.',
                             result.getErrors()[ 0 ].getMessage(), 'Unexpected error: ' + result.getErrors()  );
        
    }
    
    @isTest
    static void testInnerOverlapRightLimit() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
                       
        Room__c defaultRoom = TestDataFactory.insertRooms( 1 ).get( 0 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addMinutes(30);
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours( 1 );
        
        Test.startTest();
        
		Database.SaveResult result = Database.insert( newReservations.get( 1 ), false );
        
        Test.stopTest();
        
        System.assert( !result.isSuccess(), 'Unexpected no overlap reservation' );
        System.assert( result.getErrors().size() == 1, 'Unexpected quantity of errors' );
        System.assertEquals( 'A reservation cannot overlaps another existing reservation.',
                             result.getErrors()[ 0 ].getMessage(), 'Unexpected error: ' + result.getErrors()  );
        
    }

    @isTest
    static void testThreeInsertNoOverlap() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 3 );
                       
        List<Room__c> defaultRooms = TestDataFactory.insertRooms( 3 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
       	newReservations.get( 0 ).AssignedRoom__c = defaultRooms.get( 0 ).Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations.get( 0 );
	           
       	newReservations.get( 2 ).AssignedRoom__c = defaultRooms.get( 2 ).Id;
        newReservations.get( 2 ).InitialTime__c = defaultDatetime.addMinutes(30);
        newReservations.get( 2 ).EndTime__c = defaultDatetime.addHours( 1 );
                
       	newReservations.get( 2 ).AssignedRoom__c = defaultRooms.get( 1 ).Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addMinutes(-30);
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addMinutes(15);
        
        
        newReservations.remove( 0 );
        
        Test.startTest();
        
		List<Database.SaveResult> result = Database.insert( newReservations, false );
        
        Test.stopTest();
        
        System.assert( result.get( 0 ).isSuccess(), 'Unexpected overlap reservation' );
        System.assert( result.get( 1 ).isSuccess(), 'Unexpected overlap reservation' );
        
    }

    @isTest
    static void testOneHundredInsertsEmptyOrgNoOverlap() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 100 );
        
        Test.startTest();
        
		List<Database.SaveResult> result = Database.insert( newReservations, false );
        
        Test.stopTest();
        
        for ( Integer i = 0; i < 100; i++ ) {
            System.assert( result.get( i ).isSuccess(), 'Unexpected error: ' + result.get( i ).getErrors() );
        }
        
    }
    
    @isTest
    static void testOneHundredInsertsNoOverlap() {
        List<Reservation__c> dataBaseReservations = TestDataFactory.createReservations( 100 );
        insert dataBaseReservations;
        
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 100 );
        
        Test.startTest();
        
		List<Database.SaveResult> result = Database.insert( newReservations, false );
        
        Test.stopTest();
        
        for ( Integer i = 0; i < 100; i++ ) {
            System.assert( result.get( i ).isSuccess(), 'Unexpected error: ' + result.get( i ).getErrors() );
        }
        
    }
    
    @isTest
    static void testOneHundredInsertsEmptyOverlap() {
        List<Reservation__c> dataBaseReservations = TestDataFactory.createReservations( 500 );
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 201 );
                       
        List<Room__c> defaultRooms = TestDataFactory.insertRooms( 2 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        
        
        for ( Integer i = 0; i < 500; i++ ) {
            dataBaseReservations.get( i ).AssignedRoom__c = defaultRooms.get( 0 ).Id;
        	dataBaseReservations.get( i ).InitialTime__c = defaultDatetime.addDays( 1 ).addHours( i );
        	dataBaseReservations.get( i ).EndTime__c = defaultDatetime.addDays( 1 ).addHours( i + 1 );
        }

        dataBaseReservations.get( 99 ).InitialTime__c = defaultDatetime.addHours( -1 );
        dataBaseReservations.get( 99 ).EndTime__c = defaultDatetime.addMinutes( 30 );
        
        insert dataBaseReservations;
        
        for ( Integer i = 0; i < 201; i++ ) {
            newReservations.get( i ).AssignedRoom__c = defaultRooms.get( 1 ).Id;
        	newReservations.get( i ).InitialTime__c = defaultDatetime.addHours( i );
        	newReservations.get( i ).EndTime__c = defaultDatetime.addHours( i + 1 );
        }
        
        newReservations.get( 99 ).AssignedRoom__c = defaultRooms.get( 0 ).Id;
        newReservations.get( 99 ).InitialTime__c = defaultDatetime;
        newReservations.get( 99 ).EndTime__c = defaultDatetime.addHours( 1 );
        
        Test.startTest();
        
		List<Database.SaveResult> result = Database.insert( newReservations, false );
        
        Test.stopTest();
        
        for ( Integer i = 0; i < 201 ; i++ ){
            if( i != 99 ) {
            	System.assert( result.get( i ).isSuccess(), 'Reservation' + i + ': Unexpected error: ' + result.get( i ).getErrors() );
            }
        }
        
        System.assert( !result.get( 99 ).isSuccess(), 'Reservation 99: Unexpected no overlap reservation' );
        
        System.assert( result.get( 99 ).getErrors().size() == 1, 'Reservation 99: Unexpected quantity of errors' );
        
        System.assertEquals( 'A reservation cannot overlaps another existing reservation.',
							result.get( 99 ).getErrors()[ 0 ].getMessage(), 'Unexpected error: ' + result.get( 99 ).getErrors()  );
        
    }
    
    @isTest
    static void testUpdateNoOverlap() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 1 );
                      
        List<Room__c> defaultRoom = TestDataFactory.insertRooms( 1 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        Datetime defaultEndDate = Datetime.newInstance( 2020, 3, 5, 13, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.get( 0 ).Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations;
        
        newReservations.get( 0 ).InitialTime__c = defaultDatetime.addMinutes(-30);
        
        Test.startTest();
        
        Database.SaveResult result = Database.update( newReservations.get( 0 ), false );
        
        Test.stopTest();
        
        System.assert( result.isSuccess(), 'Unexpected failure, error: ' + result.getErrors() );
        
    }
    
    @isTest
    static void testTwoUpdateNoOverlap() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
                      
        List<Room__c> defaultRoom = TestDataFactory.insertRooms( 2 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.get( 0 ).Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.get( 1 ).Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime;
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours( 1 );
		        
        insert newReservations;
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.get( 1 ).Id;
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.get( 0 ).Id;
        
        Test.startTest();
        
        List<Database.SaveResult> result = Database.update( newReservations, false );
        
        Test.stopTest();
        
        System.assert( result[0].isSuccess(), 'Unexpected failure, error: ' + result[0].getErrors() );
        System.assert( result[1].isSuccess(), 'Unexpected failure, error: ' + result[1].getErrors() );
        
    }
    
        @isTest
    static void testOneInsertTwoUpdateOverlap() {
        List<Reservation__c> newReservations = TestDataFactory.createReservations( 2 );
                      
        List<Room__c> defaultRoom = TestDataFactory.insertRooms( 1 );
        Datetime defaultDatetime = Datetime.newInstance( 2020, 3, 5, 11, 00, 00 );
        
        newReservations.get( 0 ).AssignedRoom__c = defaultRoom.get( 0 ).Id;
        newReservations.get( 0 ).InitialTime__c = defaultDatetime;
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 1 );
        
        newReservations.get( 1 ).AssignedRoom__c = defaultRoom.get( 0 ).Id;
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addHours( 5 );
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addHours( 6 );
        
        insert newReservations;
        
        newReservations.get( 0 ).InitialTime__c = defaultDatetime.addHours( 1 );
        newReservations.get( 0 ).EndTime__c = defaultDatetime.addHours( 2 );
        
        newReservations.get( 1 ).InitialTime__c = defaultDatetime.addMinutes( -15 );
        newReservations.get( 1 ).EndTime__c = defaultDatetime.addMinutes( 30 );
        
        Test.startTest();
        
        List<Database.SaveResult> result = Database.update( newReservations, false );
        
        Test.stopTest();
        
        System.assert( result[0].isSuccess(), 'Unexpected failure, error: ' + result[0].getErrors() );
        System.assert( result[1].isSuccess(), 'Unexpected failure, error: ' + result[1].getErrors() );
        
    }

}