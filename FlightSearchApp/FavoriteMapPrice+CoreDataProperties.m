//
//  FavoriteMapPrice+CoreDataProperties.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 13.06.2021.
//
//

#import "FavoriteMapPrice+CoreDataProperties.h"

@implementation FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
}

@dynamic departure;
@dynamic destination;
@dynamic distance;
@dynamic numberOfChanges;
@dynamic origin;
@dynamic returnDate;
@dynamic value;

@end
