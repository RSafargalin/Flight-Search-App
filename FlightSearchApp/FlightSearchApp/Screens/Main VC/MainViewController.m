//
//  MainViewController.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 16.05.2021.
//

#import "MainViewController.h"
#import "NetworkService.h"
#import "TicketsViewController.h"

@interface MainViewController () <PlaceViewControllerDelegate>

@end

@implementation MainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DataManager sharedInstance] loadData];
    [self setup];
    
}

#pragma mark - Methods

- (void) setup {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = NSLocalizedString(@"Search", @"");
    [self departureButtonSetup];
    [self arrivalButtonSetup];
    [self searchButtonSetup];
}

- (void) departureButtonSetup {
    _departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_departureButton setTitle: NSLocalizedString(@"From where", @"") forState: UIControlStateNormal];
    _departureButton.tintColor = [UIColor blackColor];

    _departureButton.layer.cornerRadius = 10;
    _departureButton.frame = CGRectMake(30.0, 160.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);

    _departureButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [_departureButton addTarget:self
                         action:@selector(placeButtonDidTap:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_departureButton];
}

- (void) arrivalButtonSetup {
    _arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_arrivalButton setTitle: NSLocalizedString(@"Where to", @"") forState: UIControlStateNormal];
    _arrivalButton.tintColor = [UIColor blackColor];
    _arrivalButton.layer.cornerRadius = 10;
    _arrivalButton.frame = CGRectMake(30.0, CGRectGetMaxY(_departureButton.frame) + 20.0, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    _arrivalButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [_arrivalButton addTarget:self
                       action:@selector(placeButtonDidTap:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_arrivalButton];
}

- (void) searchButtonSetup {
    _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_searchButton setTitle: NSLocalizedString(@"To find", @"") forState:UIControlStateNormal];
    _searchButton.tintColor = [UIColor whiteColor];
    _searchButton.frame = CGRectMake(30.0, CGRectGetMaxY(_arrivalButton.frame) + 20, [UIScreen mainScreen].bounds.size.width - 60.0, 60.0);
    _searchButton.backgroundColor = [UIColor blackColor];
    _searchButton.layer.cornerRadius =  10.0;
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightBold];
    [_searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchButton];
}

- (void)placeButtonDidTap:(UIButton *)sender {
    PlaceViewController *placeViewController;
    
    if ([sender isEqual:_departureButton]) {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeArrival];
    }
    
    placeViewController.delegate = self;
    [self.navigationController pushViewController: placeViewController animated:YES];
}

- (void)searchButtonDidTap:(UIButton *)sender {
    [_searchButton setEnabled: NO];
    if (_searchRequest.destionation == NULL || _searchRequest.origin == NULL) {
        [self showAlert: self with: NSLocalizedString(@"Ooops!", @"") with: NSLocalizedString(@"You have not chosen a direction", @"") and: NSLocalizedString(@"Ok", @"") completion:^(UIAlertAction *action) {
            [self->_searchButton setEnabled: YES];
        }];
        return;
    }
    [[NetworkService sharedInstance] ticketsWithRequest:_searchRequest withCompletion:^(NSArray *tickets) {
        if (tickets.count > 0) {
            TicketsViewController *ticketsViewController = [[TicketsViewController alloc] initWithTickets:tickets];
            [self->_searchButton setEnabled: YES];
            [self.navigationController showViewController:ticketsViewController sender:self];
        } else {
            [self showAlert: self with: NSLocalizedString(@"Ooops!", @"") with: NSLocalizedString(@"No tickets found for this direction", @"") and: NSLocalizedString(@"Ok", @"") completion:^(UIAlertAction *action) {
                [self->_searchButton setEnabled: YES];
            }];
        }
    }];
}

- (void) showAlert: (UIViewController*) parent with: (NSString*) title with: (NSString*) message and: (NSString*) buttonTitle completion: (void (^ __nullable)(UIAlertAction *action))handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title
                                                                             message: message
                                                                      preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle: buttonTitle
                                                     style: (UIAlertActionStyleDefault)
                                                   handler: handler];
    [alertController addAction: action];
    [parent presentViewController: alertController
                         animated: YES
                       completion: nil];
}

#pragma mark - PlaceViewControllerDelegate

- (void)selectPlace: (id)place withType: (PlaceType)placeType andDataType: (DataSourceType)dataType {
    [self setPlace: place
      withDataType: dataType
      andPlaceType: placeType
         forButton: (placeType == PlaceTypeDeparture) ? _departureButton : _arrivalButton ];
}

- (void)setPlace:(id)place withDataType: (DataSourceType)dataType andPlaceType: (PlaceType)placeType forButton: (UIButton *)button {
    NSString *title;
    NSString *iata;
    
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    }
    else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    
    if (placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
    } else {
        _searchRequest.destionation = iata;
    }
    
    [button setTitle: title forState: UIControlStateNormal];
}

@end
