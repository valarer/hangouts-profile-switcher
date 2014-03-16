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
    
    _usersArray = [[EVModelController sharedModelController] otherUsersNot:_currentUser];
    
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
    
    _usersArray = [[EVModelController sharedModelController] otherUsersNot:_currentUser];
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
    }
    
    EVUser *user = _usersArray[indexPath.row];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.email;
    cell.imageView.image = [self resizeImage:[UIImage imageNamed:user.imageName] newSize:CGSizeMake(20, 20)];
    
    return cell;
}

#pragma mark - Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVUser *user = _usersArray[indexPath.row];
    [self updateViewUserDataWithUser:user];
    if ([_delegate respondsToSelector:@selector(didSelectUser:)]) {
        [_delegate didSelectUser:user];
    }
}

#pragma mark - Helpers

// taken from StackOverflow
// http://stackoverflow.com/a/7775470

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
