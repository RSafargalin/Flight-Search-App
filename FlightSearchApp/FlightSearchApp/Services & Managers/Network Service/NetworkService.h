//
//  NetworkService.h
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 30.05.2021.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkService : NSObject

+(instancetype) sharedInstance;
-(void)cityForCurrentIP:(void (^)(City *city))completion;
- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;
- (void)mapPricesFor:(City *)origin withCompletion:(void (^)(NSArray *prices))completion;

@end

NS_ASSUME_NONNULL_END
