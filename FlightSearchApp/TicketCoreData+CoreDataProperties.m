//
//  TicketCoreData+CoreDataProperties.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 13.06.2021.
//
//

#import "TicketCoreData+CoreDataProperties.h"

@implementation TicketCoreData (CoreDataProperties)

+ (NSFetchRequest<TicketCoreData *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"TicketCoreData"];
}

@dynamic airline;
@dynamic created;
@dynamic departure;
@dynamic expires;
@dynamic flightNumber;
@dynamic from;
@dynamic fromMap;
@dynamic price;
@dynamic returnDate;
@dynamic to;

@end
