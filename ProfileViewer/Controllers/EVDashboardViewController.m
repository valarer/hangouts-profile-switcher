//
//  EVDashboardViewController.m
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import "EVDashboardViewController.h"

@interface EVDashboardViewController ()
{
    NSArray *_dataArray;
}

@end

@implementation EVDashboardViewController

- (instancetype)initWithTabBarController:(UITabBarController *)tabBarController
{
    self = [super init];
    if (self) {
        _tabBarController = tabBarController;
        _currentUser = [EVModelController sharedModelController].currentUser;
    }
    return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.profileImage = [UIImage imageNamed:_currentUser.imageName];
    
    EVProfileViewController *profileVC = [[EVProfileViewController alloc] initWithUser:_currentUser];
    profileVC.delegate = self;
    [self addChildViewController:profileVC];
    [self.profileContainerView addSubview:profileVC.view];
    
    self.profileContainerView.backgroundColor = [UIColor yellowColor];
    self.contentView.backgroundColor = [UIColor redColor];
    
    // Blocks for other custom animations while the profile is showing
    
    self.customShowAnimations = ^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    };
    
    self.customHideAnimations = ^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    };
    
    // Blocks for completed animations
    
    self.didShowProfileViewer = ^{
    };
    
    self.didHideProfileViewer = ^{
    };
    
    // Block for the pan gesture
    
    self.didTranslateYProfileViewer = ^(CGFloat yTranslate, CGFloat yGoal) {

    };
    
    // update the profile height
    self.profileContainerHeight = profileVC.reportedHeight;
    
    // if it has a TabBarController, then add it to the content view
    if (_tabBarController) {
        [self addChildViewController:_tabBarController];
        [self.contentView addSubview:_tabBarController.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EVProfileViewController Delegate

- (void)didSelectUser:(EVUser *)user
{
    self.profileImage = [UIImage imageNamed:user.imageName];
    [EVModelController sharedModelController].currentUser = user;
    [self hideProfileView];
}

@end
