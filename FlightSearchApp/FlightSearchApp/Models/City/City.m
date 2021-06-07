//
//  City.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 16.05.2021.
//

#import "City.h"

@implementation City

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        _timezone = [dictionary valueForKey:@"time_zone"];
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _countryCode = [dictionary valueForKey:@"country_code"];
        _code = [dictionary valueForKey:@"code"];
        NSDictionary *coords = [dictionary valueForKey:@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]) {
            NSNumber *lon = [coords valueForKey:@"lon"];
            NSNumber *lat = [coords valueForKey:@"lat"];
            if (![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]]) {
                _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            }
        }
    }
    return self;
}


- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject: self.timezone forKey: @"timezone"];
    [coder encodeObject: self.translations forKey: @"translations"];
    [coder encodeObject: self.name forKey:@"name"];
    [coder encodeObject: self.countryCode forKey: @"countryCode"];
    [coder encodeObject: self.code forKey: @"code"];
    double lon = self.coordinate.longitude;
    double lat = self.coordinate.latitude;
    [coder encodeDouble: lon forKey: @"coorLon"];
    [coder encodeDouble: lat forKey: @"coorLat"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.timezone = [coder decodeObjectForKey: @"timezone"];
    self.translations = [coder decodeObjectForKey: @"translations"];
    self.name = [coder decodeObjectForKey: @"name"];
    self.countryCode = [coder decodeObjectForKey: @"countryCode"];
    self.code = [coder decodeObjectForKey: @"code"];
    double lon = [coder decodeDoubleForKey: @"coorLon"];
    double lat = [coder decodeDoubleForKey: @"coorLat"];
    self.coordinate = CLLocationCoordinate2DMake(lat, lon);

    return self;
}

@end
