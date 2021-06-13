//
//  Ticket.h
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 30.05.2021.
//

#import <Foundation/Foundation.h>

@interface Ticket : NSObject

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *airline;
@property (nonatomic, strong) NSDate *departure;
@property (nonatomic, strong) NSDate *expires;
@property (nonatomic, strong) NSNumber *flightNumber;
@property (nonatomic, strong) NSDate *returnDate;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;
@property (nonatomic) BOOL fromMap;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
