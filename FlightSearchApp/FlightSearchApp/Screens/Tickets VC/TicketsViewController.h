//
//  TicketsViewController.h
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 31.05.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@interface TicketsViewController : UITableViewController
//- (instancetype)initWithTickets:(NSArray *)tickets;
//@end

NS_ASSUME_NONNULL_END


@interface TicketsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

- (instancetype)initWithTickets:(NSArray *)tickets;
- (instancetype)initFavoriteTicketsController;

@end
