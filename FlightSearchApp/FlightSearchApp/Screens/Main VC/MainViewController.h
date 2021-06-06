//
//  MainViewController.h
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 16.05.2021.
//

#import <UIKit/UIKit.h>
#import "PlaceViewController.h"
#import "DataManager.h"

@interface MainViewController: UIViewController

@property (nonatomic, strong) UIButton *departureButton;
@property (nonatomic, strong) UIButton *arrivalButton;
@property (nonatomic) SearchRequest searchRequest;

@end
