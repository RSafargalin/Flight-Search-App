//
//  TicketCoreData+CoreDataProperties.h
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 13.06.2021.
//
//

#import "TicketCoreData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TicketCoreData (CoreDataProperties)

+ (NSFetchRequest<TicketCoreData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *expires;
@property (nonatomic) int16_t flightNumber;
@property (nullable, nonatomic, copy) NSString *from;
@property (nonatomic) BOOL fromMap;
@property (nonatomic) int64_t price;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nullable, nonatomic, copy) NSString *to;

@end

NS_ASSUME_NONNULL_END
