//
//  TicketCoreData+CoreDataProperties.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 06.06.2021.
//
//

#import "TicketCoreData+CoreDataProperties.h"

@implementation TicketCoreData (CoreDataProperties)

+ (NSFetchRequest<TicketCoreData *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TicketCoreData"];
}

@dynamic created;
@dynamic departure;
@dynamic expires;
@dynamic returnDate;
@dynamic airline;
@dynamic from;
@dynamic to;
@dynamic price;
@dynamic flightNumber;

@end
