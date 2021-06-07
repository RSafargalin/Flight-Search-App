//
//  FavoriteMapPrice+CoreDataProperties.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 07.06.2021.
//
//

#import "FavoriteMapPrice+CoreDataProperties.h"

@implementation FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
}

@dynamic departure;
@dynamic returnDate;
@dynamic numberOfChanges;
@dynamic value;
@dynamic distance;
@dynamic destination;
@dynamic origin;

@end
