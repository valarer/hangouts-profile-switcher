//
//  EVAppDelegate.m
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import "EVAppDelegate.h"
#import "EVDashboardViewController.h"
#import "EVHangoutsViewController.h"
#import "EVContactsViewController.h"

@implementation EVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    // In a real scenario, this should retrieve the user from stored data
    [EVModelController sharedModelController].currentUser = [[[EVModelController sharedModelController] allAccounts] objectAtIndex:0];
    
    // Create the view controllers and add them to the TabBarController
    EVContactsViewController *contactsViewController = [[EVContactsViewController alloc] init];
    EVHangoutsViewController *hangoutsViewController = [[EVHangoutsViewController alloc] init];
    
    tabBarController.viewControllers = @[contactsViewController, hangoutsViewController];
    
    // The appdelegate will manage the tab controller
    tabBarController.delegate = self;

    // Initiate the Dashboard controller with the tabBarController to let it know it will contain one
    _dashboardVC = [[EVDashboardViewController alloc] initWithTabBarController:tabBarController];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_dashboardVC];
    self.window.rootViewController = navigationController;
    
    // Style the window tint color
    self.window.tintColor = RGB(38, 169, 63);
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - TabBarController Delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    _dashboardVC.delegate = (EVTabItemViewController *)viewController;
}

@end
