//
//  MapViewController.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 30.05.2021.
//

#import "MapViewController.h"
#import "LocationService.h"
#import "NetworkService.h"
#import <MapKit/MapKit.h>
#import "DataManager.h"
#import "MapPrice.h"
#import <CoreLocation/CoreLocation.h>
#import "CoreDataHelper.h"

@interface MapViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Карта цен";
    
    
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    
    [[DataManager sharedInstance] loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    _locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion: region animated: YES];
    
    if (currentLocation) {
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (_origin) {
            [[NetworkService sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}


- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations: _mapView.annotations];
 
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long)price.value];
            annotation.coordinate = price.destination.coordinate;
            
            [self->_mapView addAnnotation: annotation];
        });
    }
}

<<<<<<< Updated upstream
=======

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MKPointAnnotation *selectedAnnotation;
    selectedAnnotation = (MKPointAnnotation *) view.annotation;
    for (MapPrice *price in _prices) {
        if ((view.annotation.coordinate.latitude == price.destination.coordinate.latitude) &&
            (view.annotation.coordinate.longitude == price.destination.coordinate.longitude)) {
            Ticket *ticket = [Ticket new];
            ticket.departure = price.departure;
            ticket.airline = price.airline;
            ticket.from = price.origin.code;
            ticket.to = price.destination.code;
            ticket.price = [NSNumber numberWithLong: price.value];
            ticket.fromMap = YES;
            
            BOOL isInFavorites = [[CoreDataHelper sharedInstance] isFavorite: ticket];
            if (isInFavorites) {
                return;
            }
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"Ticket"
                                                                                     message: @"Please select action:"
                                                                              preferredStyle: UIAlertControllerStyleActionSheet];
            
            UIAlertAction *favoriteAction = [UIAlertAction actionWithTitle: @"Add to Favorites"
                                                                     style: UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                [[CoreDataHelper sharedInstance] addToFavorite: ticket];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"Cancel"
                                                                   style: UIAlertActionStyleCancel
                                                                 handler: nil];
            
            [alertController addAction: favoriteAction];
            [alertController addAction: cancelAction];
            [self presentViewController: alertController
                               animated: YES
                             completion: nil];
            
        }
    }
}

>>>>>>> Stashed changes
@end
