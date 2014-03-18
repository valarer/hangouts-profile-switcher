//
//  EVDashboardViewController.m
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import "EVDashboardViewController.h"
#import "EVModelController.h"

@interface EVDashboardViewController ()
{
    NSArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) EVUser *currentUser;

@end

@implementation EVDashboardViewController

- (instancetype)init
{
    self = [self initWithNibName:@"DashboardViewController" bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = @[@"Hangout 1", @"Hangout 2", @"Hangout 3", @"Hangout 4"];
        _currentUser = [[[EVModelController sharedModelController] allUsers] objectAtIndex:0];
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
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // For use inside blocks
    __weak typeof(self) weakSelf = self;
    
    // Blocks for other custom animations while the profile is showing
    
    __block CGPoint originalTableViewCenter = _tableView.center;
    self.customShowAnimations = ^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        
        weakSelf.tableView.center = CGPointMake(weakSelf.tableView.center.x, originalTableViewCenter.y - 64);
    };
    
    self.customHideAnimations = ^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
        weakSelf.tableView.center = CGPointMake(weakSelf.tableView.center.x, originalTableViewCenter.y);
    };
    
    // Blocks for completed animations
    
    self.didShowProfileViewer = ^{
        [weakSelf.tableView reloadData];
    };
    
    self.didHideProfileViewer = ^{
        [weakSelf.tableView reloadData];
    };
    
    // Block for the pan gesture
    
    self.didTranslateYProfileViewer = ^(CGFloat yTranslate, CGFloat yGoal) {
        // we want the table view to move up each time the pan translates in y
        CGFloat yVelocity = 64 / yGoal;
        CGFloat yTranslateMax = MIN(yVelocity * yTranslate, 64);
        weakSelf.tableView.center = CGPointMake(weakSelf.tableView.center.x, originalTableViewCenter.y - yTranslateMax);
    };
    
    // update the profile height
    self.profileContainerHeight = profileVC.reportedHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView

#pragma mark Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = _dataArray[indexPath.row];
    
    if (self.isShowingProfileViewer)
        cell.textLabel.textColor = [UIColor lightGrayColor];
    else
        cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - EVProfileViewController Delegate

- (void)didSelectUser:(EVUser *)user
{
    self.profileImage = [UIImage imageNamed:user.imageName];
    [self hideProfileView];
}

@end
