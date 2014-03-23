//
//  EVAppDelegate.h
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import <UIKit/UIKit.h>
#import "EVDashboardViewController.h"

@interface EVAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) EVDashboardViewController *dashboardVC;

@end
