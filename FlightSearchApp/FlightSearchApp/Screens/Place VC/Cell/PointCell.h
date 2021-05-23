//
//  PointCell.h
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 23.05.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PointCell : UITableViewCell

- (void) configureWithName: (NSString*) name andCode: (NSString*) code;

@end

NS_ASSUME_NONNULL_END
