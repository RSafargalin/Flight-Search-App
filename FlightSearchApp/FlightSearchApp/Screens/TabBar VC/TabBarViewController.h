//
//  TabBarViewController.h
//  FlightSearchApp
//
//  Created by Ruslan Safargalin on 30.05.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabBarViewController : UITabBarController

- (NSArray<UIViewController*> *)createViewControllers;

@end

NS_ASSUME_NONNULL_END
