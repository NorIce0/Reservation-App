public class ReservationTriggerHandler {
    
    public static void handleReservation( List<Reservation__c> posibleOverlapReservations ) {
		
        List<Reservation__c> reservationList = new List<Reservation__c>();
        Set<Id> roomSet = new Set<Id>();
            
        for( Reservation__c reservationToValidate : posibleOverlapReservations ) {
           for( Reservation__c reservation : reservationList ) {
                if( hasOverlap(reservationToValidate, reservation) ){
                  	reservationToValidate.addError('A reservation cannot overlaps another existing reservation.');
            	}
            }
           	System.debug(reservationToValidate);
            
            reservationList.add( reservationToValidate );
            roomSet.add( reservationToValidate.AssignedRoom__c );
        }
        
        //Map<Id, List<Reservation__c>> posibleOverlapReservationMap = createRoomIdToReservationsMap( posibleOverlapReservations );
       
        Datetime earlierDatetime = getEarlierInitialDate( posibleOverlapReservations );
        Datetime latestDatetime = getLatestEndDate( posibleOverlapReservations );

		List<Reservation__c> dbReservations = [ SELECT AssignedRoom__c, InitialTime__c, EndTime__c FROM Reservation__c
                                           		WHERE AssignedRoom__c IN :roomSet AND
                                              		InitialTime__c <= :latestDatetime AND EndTime__c >= :earlierDatetime ];
        
        Map<Id, List<Reservation__c>> dbReservationsMap = createRoomIdToReservationsMap( dbReservations );
        
        for ( Reservation__c posibleReservation : posibleOverlapReservations ) {
            if( dbReservationsMap.containsKey( posibleReservation.AssignedRoom__c ) ) {
               for( Reservation__c dbReservation : dbReservationsMap.get( posibleReservation.AssignedRoom__c ) ) {
           			System.debug(dbReservation);
                	if( hasOverlap( posibleReservation, dbReservation ) && 
                   	!(Trigger.isUpdate && !reservationList.contains( dbReservation )) ) {
                    	posibleReservation.addError('A reservation cannot overlaps another existing reservation.');
                	}
            	} 
            }
        }
        
        /*
        for ( Reservation__c posibleReservation : posibleOverlapReservations ) {
            if( !dbReservationsMap.containsKey( posibleReservation.AssignedRoom__c ) ){
            	dbReservationsMap.put( posibleReservation.AssignedRoom__c, new List<Reservation__c>() );
            } else {
            	for ( Reservation__c existentReservation : dbReservationsMap.get( posibleReservation.AssignedRoom__c )  ) {
                    System.debug(posibleReservation.Id);
                	if( !( Trigger.isUpdate && posibleReservation.Id == existentReservation.Id ) ){
        				if ( hasOverlap( posibleReservation, existentReservation ) ) {
    	        			String errorMsg = 'A reservation cannot overlaps another existing reservation.';
        	    			posibleReservation.addError( errorMsg );
                		}
               		} else {
               			Integer deleteItemIndex = dbReservationsMap.get( posibleReservation.AssignedRoom__c ).indexOf( existentReservation );
                		dbReservationsMap.get( posibleReservation.AssignedRoom__c ).remove( deleteItemIndex );
            		} 
            	}
            }
            dbReservationsMap.get( posibleReservation.AssignedRoom__c ).add( posibleReservation );
    	}
*/
	}
    
    public static Map<Id, List<Reservation__c>> createRoomIdToReservationsMap( List<Reservation__c> reservationList ) {
    	
        Map<Id, List<Reservation__c>> reservationMap = new Map<Id, List<Reservation__c>>();
        
        for ( Reservation__c listItem : reservationList ) {
            if( !reservationMap.containsKey( listItem.AssignedRoom__c ) ) {
                reservationMap.put( listItem.AssignedRoom__c, new List<Reservation__c>() );
            } 
			reservationMap.get( listItem.AssignedRoom__c ).add( listItem );               
        }
        
        return reservationMap;
    }
    
    public static Boolean hasOverlap( Reservation__c reservationOne, Reservation__c reservationTwo ) {
       
		return reservationOne.AssignedRoom__c == reservationTwo.AssignedRoom__c &&
               reservationOne.InitialTime__c < reservationTwo.EndTime__c &&
               reservationOne.EndTime__c > reservationTwo.InitialTime__c;
    }
    
    public static Datetime getEarlierInitialDate( List<Reservation__c> reservations ) {
        
        Datetime earlierDatetime = null;
        
        for ( Reservation__c res : reservations ) {
            if ( earlierDatetime == null || earlierDatetime > res.InitialTime__c ) {
                    earlierDatetime = res.InitialTime__c;
            }
        }
        return earlierDatetime;
    }
    
    public static Datetime getLatestEndDate( List<Reservation__c> reservations ) {
        
        Datetime latestDatetime = null;
        
        for ( Reservation__c res : reservations ) {
            if ( latestDatetime == null || latestDatetime < res.EndTime__c ) {
                    latestDatetime = res.EndTime__c;
            }
        }
        return latestDatetime;
    }
}