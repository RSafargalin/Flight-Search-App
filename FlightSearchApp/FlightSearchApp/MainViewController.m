//
//  MainViewController.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 16.05.2021.
//

#import "MainViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

// MARK: Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [[DataManager sharedInstance] loadData];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

// MARK: Methods

- (void)loadDataComplete
{
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = [UIColor greenColor];
    viewController.navigationItem.title = @"New View Controller";
    
    [self.navigationController pushViewController: viewController animated: true];
}

@end

