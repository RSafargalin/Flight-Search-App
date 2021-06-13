//
//  TabBarViewController.m
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 30.05.2021.
//

#import "TabBarViewController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "TicketsViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray<UIViewController*> *)createViewControllers {
    MainViewController (*mainViewController) = [[MainViewController alloc] init];
    MapViewController (*mapViewController) = [[MapViewController alloc] init];
    TicketsViewController *favoriteViewController = [[TicketsViewController alloc] initFavoriteTicketsController];
    
    UINavigationController *mainNavController = [[UINavigationController alloc] initWithRootViewController: mainViewController];
    mainNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: NSLocalizedString(@"Search ticket", @"") image:[UIImage systemImageNamed:@"magnifyingglass"] selectedImage:[UIImage systemImageNamed:@"magnifyingglass.circle"]];
    
    UINavigationController *mapNavController = [[UINavigationController alloc] initWithRootViewController: mapViewController];
    mapNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: NSLocalizedString(@"Map price", @"") image:[UIImage systemImageNamed:@"mappin"] selectedImage:[UIImage systemImageNamed:@"mappin.circle"]];
    
    UINavigationController *favNavController = [[UINavigationController alloc] initWithRootViewController:favoriteViewController];
    favoriteViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle: NSLocalizedString(@"Favorites", @"") image:[UIImage systemImageNamed:@"star"] selectedImage:[UIImage systemImageNamed:@"star.circle"]];
    
    NSArray *viewControllers = [[NSArray alloc] initWithObjects: mainNavController, mapNavController, favNavController, nil];
    
    return viewControllers;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
