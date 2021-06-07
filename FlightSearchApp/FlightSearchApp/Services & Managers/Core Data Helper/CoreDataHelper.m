//
//  CoreDataHelper.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 06.06.2021.
//


#import "CoreDataHelper.h"

@interface CoreDataHelper ()
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@end

@implementation CoreDataHelper

+ (instancetype)sharedInstance
{
    static CoreDataHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataHelper alloc] init];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FavoriteTicket" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [docsURL URLByAppendingPathComponent:@"base.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    
    NSPersistentStore* store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    if (!store) {
        abort();
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
}

- (void)save {
    NSError *error;
    [_managedObjectContext save: &error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (TicketCoreData *)favoriteFromTicket:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TicketCoreData"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
}

- (FavoriteMapPrice *)favoriteMapPriceFromMapPrice: (MapPrice *) mapPrice {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
    
    NSString *format = @"destination == %@ AND origin == %@ AND actual == %@ AND departure == %@ AND distance == %d AND numberOfChanges == %d AND returnDate == %ld AND value ==%ld";
    NSData *destination = [NSKeyedArchiver archivedDataWithRootObject: mapPrice.destination requiringSecureCoding: NO error: nil];
    NSData *origin = [NSKeyedArchiver archivedDataWithRootObject: mapPrice.origin requiringSecureCoding: NO error: nil];
    request.predicate = [NSPredicate predicateWithFormat: format,
                         destination,
                         origin,
                         mapPrice.actual,
                         mapPrice.departure,
                         mapPrice.distance,
                         mapPrice.numberOfChanges,
                         mapPrice.returnDate,
                         mapPrice.value];
    
//    NSLog(@"destination == %@ AND origin == %@ AND actual == %@ AND departure == %@ AND distance == %d AND numberOfChanges == %d AND returnDate == %ld AND value ==%ld", destination,
//          origin,
//          mapPrice.actual,
//          mapPrice.departure,
//          (long)mapPrice.distance,
//          (long)mapPrice.numberOfChanges,
//          mapPrice.returnDate,
//          mapPrice.value);
    
    FavoriteMapPrice *favoriteMapPrice = [[_managedObjectContext executeFetchRequest:request error:nil] firstObject];
    
    NSLog(@"%@", favoriteMapPrice);
    return favoriteMapPrice;
}

- (BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTicket:ticket] != nil;
}

- (void)addToFavorite:(Ticket *)ticket {
    TicketCoreData *favorite = [NSEntityDescription insertNewObjectForEntityForName:@"TicketCoreData" inManagedObjectContext:_managedObjectContext];
    favorite.price = ticket.price.intValue;
    favorite.airline = ticket.airline;
    favorite.departure = ticket.departure;
    favorite.expires = ticket.expires;
    favorite.flightNumber = ticket.flightNumber.intValue;
    favorite.returnDate = ticket.returnDate;
    favorite.from = ticket.from;
    favorite.to = ticket.to;
    favorite.created = [NSDate date];
    [self save];
}

- (void)removeFromFavorite:(Ticket *)ticket {
    TicketCoreData *favorite = [self favoriteFromTicket:ticket];
    if (favorite) {
        [_managedObjectContext deleteObject:favorite];
        [self save];
    }
}

- (NSArray *)favorites {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TicketCoreData"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [_managedObjectContext executeFetchRequest:request error:nil];
}

@end
