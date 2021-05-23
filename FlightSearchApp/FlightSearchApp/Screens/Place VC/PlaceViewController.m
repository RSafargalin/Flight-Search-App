//
//  PlaceViewController.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 23.05.2021.
//

#import "PlaceViewController.h"
#import "DataManager.h"
#import "PointCell.h"

#define ReuseIdentifier @"CellIdentifier"

@interface PlaceViewController ()

@end

@implementation PlaceViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationControllerSetup];
    [self tableViewSetup];
    [self segmentedControlSetup];
    [self placeTypeChange];
}

#pragma mark - Init

- (instancetype)initWithType:(PlaceType)type {
    self = [super init];
    if (self) {
        _placeType = type;
    }
    return self;
}

#pragma mark - Methods

- (void) navigationControllerSetup {
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void) tableViewSetup {
    _tableView = [[UITableView alloc]
                  initWithFrame: self.view.bounds
                  style: UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void) segmentedControlSetup {
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Города", @"Аэропорты"]];
    [_segmentedControl addTarget:self
                          action:@selector(changeSource)
                forControlEvents:UIControlEventValueChanged];
    
    _segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    [self changeSource];
}

- (void) placeTypeChange {
    if (_placeType == PlaceTypeDeparture) {
        self.title = @"Откуда";
    } else {
        self.title = @"Куда";
    }
}

- (void)changeSource {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _currentArray = [[DataManager sharedInstance] cities];
            break;
        case 1:
            _currentArray = [[DataManager sharedInstance] airports];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PointCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    
    if (!cell) {
        cell = [[PointCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = [_currentArray objectAtIndex:indexPath.row];
        [cell configureWithName: city.name
                        andCode: city.code];
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = [_currentArray objectAtIndex:indexPath.row];
        [cell configureWithName: airport.name
                        andCode: airport.code];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DataSourceType dataType = ((int)_segmentedControl.selectedSegmentIndex) + 1;
    [self.delegate selectPlace: [_currentArray objectAtIndex: indexPath.row]
                      withType: _placeType
                   andDataType: dataType];
    [self.navigationController popViewControllerAnimated: YES];
}
@end
