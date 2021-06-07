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
    @property NSMutableArray *dataSource;
@end

@implementation PlaceViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc]init];
    [self navigationControllerSetup];
    [self searchBarSetup];
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
    self.navigationController.view.backgroundColor = [UIColor systemBackgroundColor];
}

- (void) searchBarSetup {
    _searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    _searchBar.delegate = self;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: _searchBar];
    [_searchBar.topAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [_searchBar.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = YES;
    [_searchBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [_searchBar.heightAnchor constraintEqualToConstant: 44].active = YES;
}

- (void) tableViewSetup {
    _tableView = [[UITableView alloc]
                  initWithFrame: self.view.bounds
                  style: UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tableView];
    
    [_tableView.topAnchor constraintEqualToAnchor: _searchBar.bottomAnchor].active = YES;
    [_tableView.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor].active = YES;
    [_tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [_tableView.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor].active = YES;
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
            _dataSource = [[NSMutableArray alloc] initWithArray: [[DataManager sharedInstance] cities]];
            _filtredDataSource = [[NSMutableArray alloc] initWithArray: [[DataManager sharedInstance] cities]];
            _searchBar.searchTextField.text = @"";
            break;
        case 1:
            _dataSource = [[NSMutableArray alloc] initWithArray: [[DataManager sharedInstance] airports]];
            _filtredDataSource = [[NSMutableArray alloc] initWithArray: [[DataManager sharedInstance] airports]];
            _searchBar.searchTextField.text = @"";
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_filtredDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PointCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    
    if (!cell) {
        cell = [[PointCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = [_filtredDataSource objectAtIndex:indexPath.row];
        [cell configureWithName: city.name
                        andCode: city.code];
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = [_filtredDataSource objectAtIndex:indexPath.row];
        [cell configureWithName: airport.name
                        andCode: airport.code];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DataSourceType dataType = ((int)_segmentedControl.selectedSegmentIndex) + 1;
    [self.delegate selectPlace: [_filtredDataSource objectAtIndex: indexPath.row]
                      withType: _placeType
                   andDataType: dataType];
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - UISearchBar

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    @try
    {
        [_filtredDataSource removeAllObjects];
//        stringSearch = @"YES";
        NSString *name = @"";
        if ([searchText length] > 0)
        {
            for (int i = 0; i < [_dataSource count] ; i++)
            {
                if (_segmentedControl.selectedSegmentIndex == 0) {
                    City *city = [_dataSource objectAtIndex:i];
                    name = city.name;
                }
                else if (_segmentedControl.selectedSegmentIndex == 1) {
                    Airport *airport = [_dataSource objectAtIndex:i];
                    name = airport.name;
                }
                if (name.length >= searchText.length)
                {
                    NSRange titleResultsRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (titleResultsRange.length > 0)
                    {
                        [_filtredDataSource addObject:[_dataSource objectAtIndex:i]];
                    }
                }
            }
        }
        else
        {
            [_filtredDataSource addObjectsFromArray: _dataSource];
        }
        [_tableView reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@", exception);
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)SearchBar {
    SearchBar.showsCancelButton= YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *) SearchBar {
    [SearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)SearchBar {
    @try
    {
        SearchBar.showsCancelButton= NO;
        [SearchBar resignFirstResponder];
        [_tableView reloadData];
    }
    @catch (NSException *exception) {
        NSLog(@"Error: %@", exception);
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)SearchBar {
    [SearchBar resignFirstResponder];
}

//
@end
