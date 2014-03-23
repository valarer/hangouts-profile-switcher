//
//  EVDashboardViewController.h
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import <UIKit/UIKit.h>
#import "EVProfileViewerViewController.h"
#import "EVProfileViewController.h"

@interface EVDashboardViewController : EVProfileViewerViewController <EVProfileViewControllerDelegate>

@property (strong, nonatomic) EVUser *currentUser;
@property (strong, nonatomic) UITabBarController *tabBarController;

- (instancetype)initWithTabBarController:(UITabBarController *)tabBarController;

@end
