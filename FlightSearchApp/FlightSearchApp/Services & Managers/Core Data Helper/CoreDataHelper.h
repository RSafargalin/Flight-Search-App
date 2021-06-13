//
//  CoreDataHelper.h
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 06.06.2021.
//

#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "Ticket.h"
#import "TicketCoreData+CoreDataClass.h"
#import "City.h"
#import "FavoriteMapPrice+CoreDataClass.h"
#import "MapPrice.h"

@interface CoreDataHelper : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;
- (NSArray *)favoritesFromMap: (BOOL)fromMap;
- (void)addToFavorite:(Ticket *)ticket;
- (void)removeFromFavorite:(Ticket *)ticket;

@end
