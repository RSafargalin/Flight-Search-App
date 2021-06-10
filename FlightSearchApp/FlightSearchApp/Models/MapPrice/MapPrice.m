//
//  MapPrice.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 30.05.2021.
//

#import "MapPrice.h"
#import "DataManager.h"

@implementation MapPrice


- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin: (City *)origin
{
    self = [super init];
    if (self)
    {
        _destination = [[DataManager sharedInstance] cityForIATA: [dictionary valueForKey:@"destination"]];
        _origin = origin;
        _departure = [self dateFromString:[dictionary valueForKey:@"depart_date"]];
        _returnDate = [self dateFromString:[dictionary valueForKey:@"return_date"]];
        _numberOfChanges = [[dictionary valueForKey:@"number_of_changes"] integerValue];
        _value = [[dictionary valueForKey:@"value"] integerValue];
        _distance = [[dictionary valueForKey:@"distance"] integerValue];
        _actual = [[dictionary valueForKey:@"actual"] boolValue];
        _airline = [dictionary valueForKey:@"airline"];
    }
    return self;
}

- (NSDate * _Nullable)dateFromString:(NSString *)dateString {
    if (!dateString) { return  nil; }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString: dateString];
}


- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject: self.destination forKey: @"destination"];
    [coder encodeObject: self.origin forKey: @"origin"];
    [coder encodeObject: self.departure forKey:@"departure"];
    [coder encodeObject: self.returnDate forKey: @"returnDate"];
    [coder encodeInt64: self.numberOfChanges forKey: @"numberOfChanges"];
    [coder encodeInteger: self.value forKey: @"value"];
    [coder encodeInt64: self.distance forKey: @"distance"];
    [coder encodeBool: self.actual forKey: @"actual"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.destination = [coder decodeObjectForKey: @"destination"];
    self.origin = [coder decodeObjectForKey: @"origin"];
    self.departure = [coder decodeObjectForKey: @"departure"];
    self.returnDate = [coder decodeObjectForKey: @"returnDate"];
    self.numberOfChanges = [coder decodeInt64ForKey: @"numberOfChanges"];
    self.value = [coder decodeBoolForKey: @"value"];
    self.distance = [coder decodeInt64ForKey: @"distance"];
    self.actual = [coder decodeBoolForKey: @"actual"];

    return self;
}


@end
