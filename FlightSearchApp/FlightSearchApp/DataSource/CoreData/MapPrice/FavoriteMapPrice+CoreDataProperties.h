//
//  FavoriteMapPrice+CoreDataProperties.h
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 07.06.2021.
//
//

#import "FavoriteMapPrice+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nonatomic) int64_t numberOfChanges;
@property (nonatomic) int64_t value;
@property (nonatomic) int64_t distance;
@property (nullable, nonatomic, retain) NSData *destination;
@property (nullable, nonatomic, retain) NSData *origin;

@end

NS_ASSUME_NONNULL_END
