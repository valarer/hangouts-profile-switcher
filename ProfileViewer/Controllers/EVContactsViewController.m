//
//  EVAnotherViewController.m
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/20/14.
//
//

#import "EVContactsViewController.h"
#import "EVUser.h"

@interface EVContactsViewController ()
{
    NSArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EVContactsViewController

- (instancetype)init
{
    self = [self initWithNibName:@"ContactsViewController" bundle:nil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50;
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Give top inset to the table view
    CGRect navBarFrame = APP_DELEGATE.dashboardVC.navigationController.navigationBar.frame;
    int height = navBarFrame.size.height + navBarFrame.origin.y;
    _tableView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)reloadData
{
    _dataArray = [[EVModelController sharedModelController] allContactsForCurrentUser];
    [_tableView reloadData];
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
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.layer.masksToBounds = YES;
    }
    
    EVContact *contact = _dataArray[indexPath.row];
    cell.textLabel.text = contact.contactUser.name;
    cell.detailTextLabel.text = contact.circleName;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_small", contact.contactUser.imageName]];
    cell.imageView.image = image;
    cell.imageView.layer.cornerRadius = image.size.width / 2;
    
    return cell;
}

#pragma mark Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
