//
//  EVProfileViewController.m
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import "EVProfileViewController.h"
#import "EVModelController.h"

#define VIEW_MIN_HEIGHT 350.0f

@interface EVProfileViewController ()
{
    NSArray *_usersArray;
    
    // The height of the view is dynamic, dependent of the number of cells,
    // so we store the original value in this variable
    CGFloat _originalHeight;
}

@property (strong, nonatomic) EVUser *currentUser;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *currentUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentUserEmailLabel;

@end

@implementation EVProfileViewController

- (instancetype)initWithUser:(EVUser *)user
{
    self = [self initWithNibName:@"ProfileViewerView" bundle:nil];
    if (self) {
        _currentUser = user;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"frosted_glass"]];
    
    _addContainerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    
    _usersArray = [[EVModelController sharedModelController] otherAccountsNot:_currentUser];
    
    // set the current height as the original
    _originalHeight = self.view.bounds.size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getters

- (CGFloat)reportedHeight
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat rowHeight = _tableView.rowHeight;
    // The tableview.contentSize property hasn't been set at this point, so we calculate it ourselves
    // The added (+ 1) on the number of rows is for the "add account" row
    CGFloat tableViewContentHeight = rowHeight * ([_usersArray count] + 1);
    self.view.frame = CGRectMake(0, 0, screenSize.width, _originalHeight - _tableView.bounds.size.height + tableViewContentHeight);
    return self.view.bounds.size.height;
}

#pragma mark - Public

- (void)updateViewUserDataWithUser:(EVUser *)user
{
    _currentUser = user;
    _currentUserNameLabel.text = _currentUser.name;
    _currentUserEmailLabel.text = _currentUser.email;
    
    _usersArray = [[EVModelController sharedModelController] otherAccountsNot:_currentUser];
    [_tableView reloadData];
}

#pragma mark - TableView

#pragma mark - Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_usersArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, _tableView.rowHeight)];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.center = CGPointMake(50, _tableView.rowHeight / 2);
    addButton.tintColor = [UIColor whiteColor];
    UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, _tableView.rowHeight)];
    addLabel.center = CGPointMake(_tableView.bounds.size.width / 2, addLabel.center.y);
    addLabel.backgroundColor = [UIColor clearColor];
    addLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    addLabel.textColor = [UIColor whiteColor];
    addLabel.text = @"Add Account";
    
    [containerView addSubview:addButton];
    [containerView addSubview:addLabel];
    
    return containerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.layer.masksToBounds = YES;
    }
    
    EVUser *user = _usersArray[indexPath.row];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.email;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small", user.imageName]];
    cell.imageView.image = image;
    cell.imageView.layer.cornerRadius = image.size.width / 2;
    
    return cell;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVUser *user = _usersArray[indexPath.row];
    [self updateViewUserDataWithUser:user];
    
    [EVModelController sharedModelController].currentUser = user;
    
    // Different ways to notify other controllers (notification center and delegate)
    [[NSNotificationCenter defaultCenter] postNotificationName:NC_USER_CHANGED object:nil userInfo:@{ kUserKey: user }];
    if ([_delegate respondsToSelector:@selector(didSelectUser:)]) {
        [_delegate didSelectUser:user];
    }
}

@end
