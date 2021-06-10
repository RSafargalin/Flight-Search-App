//
//  PlaceViewController.h
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 23.05.2021.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

#pragma mark - Enums

typedef enum PlaceType {
    PlaceTypeArrival,
    PlaceTypeDeparture
} PlaceType;

#pragma mark - Protocol

@protocol PlaceViewControllerDelegate <NSObject>

- (void)selectPlace: (id)place
           withType: (PlaceType)placeType
        andDataType: (DataSourceType)dataType;

@end

#pragma mark - Interface

@interface PlaceViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *filtredDataSource;
@property (nonatomic, strong) id<PlaceViewControllerDelegate>delegate;

- (instancetype)initWithType:(PlaceType)type;

@end
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
