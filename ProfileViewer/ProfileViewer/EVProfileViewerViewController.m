//
//  EVProfileViewerViewController.m
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import "EVProfileViewerViewController.h"

#define DEBUG_MODE 0
#define PROFILE_VIEW_MIN_HEIGHT 350.0f
#define ACTIVATOR_TRANSLATION_Y 150.0f

@interface EVProfileViewerViewController ()
{
    BOOL _hasNavigationController;
    BOOL _loadedFromNib;
    
    CGRect  _originalProfileActivatorFrame,
            _originalNavigationBarFrame,
            _originalContentViewFrame;
    
    CGPoint _originalProfileActivatorCenter;
}

@property (strong, nonatomic) UINavigationBar *navigationBar;
@property (strong, nonatomic) UINavigationItem *customNavigationItem;
@property (strong, nonatomic) UIView *profileActivatorView;
@property (strong, nonatomic) UIImageView *profileActivatorImageView;

@property (strong, nonatomic) UITapGestureRecognizer *profileActivatorTapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *profileActivatorPanGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *contentViewTapGestureRecognizer;

@end

@implementation EVProfileViewerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeValues];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _loadedFromNib = YES;
        [self initializeValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _loadedFromNib = YES;
        [self initializeValues];
    }
    return self;
}

- (void)initializeValues
{
    _profileContainerHeight = PROFILE_VIEW_MIN_HEIGHT;
    _scaleFactor = 2.0f;
    _animationDuration = 0.3f;
    _activatorDestinationCenterY = ACTIVATOR_TRANSLATION_Y;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    _hasNavigationController = self.navigationController != nil;
    
    /* Content View */
    
    // Frame for content view depends on navigationcontroller existence
    _originalContentViewFrame = _hasNavigationController ?
        CGRectMake(0, 0, mainScreenSize.width, mainScreenSize.height) :
        CGRectMake(0, _navigationBar.frame.size.height, mainScreenSize.width, mainScreenSize.height - _navigationBar.frame.size.height);
    _contentView = [[UIView alloc] initWithFrame:_originalContentViewFrame];
    
    if (_loadedFromNib)
        [self transferViewsFromControllerViewToContentView];

    [self.view addSubview:_contentView];
    
    /* ProfileContainerView */
    
    CGRect profileContainerViewFrame = CGRectMake(0, 0, mainScreenSize.width, _profileContainerHeight);
    _profileContainerView = [[UIView alloc] initWithFrame:profileContainerViewFrame];
    
    [self.view insertSubview:_profileContainerView atIndex:0];
    
    // If there is no navigation controller, then create our own navigation bar
    if (!_hasNavigationController)
        [self createNavigationBar];
    else
        _navigationBar = self.navigationController.navigationBar;
    
    _originalNavigationBarFrame = _navigationBar.frame;
    
    /* ProfileImageButton */
    
    _originalProfileActivatorFrame = CGRectMake(0, 0, 60, 35);
    _profileActivatorView = [[UIView alloc] initWithFrame:_originalProfileActivatorFrame];
    _originalProfileActivatorCenter =
        CGPointMake(_navigationBar.bounds.size.width / 2,
                    (_navigationBar.bounds.size.height + (!_hasNavigationController ? 20 : 0)) / 2);
    _profileActivatorView.center = _originalProfileActivatorCenter;
    
    [_navigationBar addSubview:_profileActivatorView];
    
    /* Gesture Recognizers */
    
    _profileActivatorTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfileActivator:)];
    [_profileActivatorView addGestureRecognizer:_profileActivatorTapGestureRecognizer];
    
    _profileActivatorPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanNavigationBar:)];
    [_navigationBar addGestureRecognizer:_profileActivatorPanGestureRecognizer];
    
    // Because we disable interaction with this view, we will calculate manually whether the user tapped the content view or not
    // Other solution would be iterating each subview of the contentview and disable interaction...
    _contentViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideProfileView)];
    _contentViewTapGestureRecognizer.delegate = self;
    _contentViewTapGestureRecognizer.enabled = NO;
    [self.view addGestureRecognizer:_contentViewTapGestureRecognizer];
    
#if DEBUG_MODE
    _profileActivatorView.backgroundColor = [UIColor redColor];
#endif
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters

- (void)setProfileImage:(UIImage *)profileImage
{
    _profileImage = profileImage;
    
    if (_profileImage) {
        _profileActivatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _profileActivatorImageView.image = _profileImage;
        _profileActivatorImageView.center = CGPointMake(_profileActivatorView.bounds.size.width / 2, _profileActivatorView.bounds.size.height / 2);
        _profileActivatorImageView.hidden = NO;
        // masks images to the bounds of the view
        CALayer *layer = _profileActivatorImageView.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = _profileActivatorImageView.bounds.size.width / 2.0;
        layer.borderWidth = 0.0;
        
        [_profileActivatorView addSubview:_profileActivatorImageView];
        
        _customNavigationItem.title = @"";
    }
    else {
        _profileActivatorImageView.hidden = YES;
        _customNavigationItem.title = self.title;
    }
}

#pragma mark - Private

- (void)createNavigationBar
{
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat navHeight = (orientation == UIInterfaceOrientationIsPortrait(orientation) ? 44 : 32) + 20;
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, mainScreenSize.width, navHeight)];
    
    _customNavigationItem = [[UINavigationItem alloc] initWithTitle:_profileImage ? @"" : self.title];
    _navigationBar.items = @[_customNavigationItem];
    
    [self.view addSubview:_navigationBar];
}

#pragma mark - Public

- (void)showProfileView
{
    // Disable interation with views
    _contentView.userInteractionEnabled = NO;
    _profileContainerView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:_animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         // Drop content view
                         _contentView.frame = (CGRect){ CGPointMake(0, _profileContainerHeight), _contentView.bounds.size };
                         
                         // Animate the navigation bar ourselves because setNavigationBarHidden:animated causes problems
                         _navigationBar.frame =
                             (CGRect) {
                                 CGPointMake(0, -_navigationBar.bounds.size.height),
                                 _navigationBar.bounds.size
                             };
                         
                         // Animate profile activator
                         _profileActivatorView.transform = CGAffineTransformMakeScale(_scaleFactor, _scaleFactor);
                         _profileActivatorView.center = CGPointMake(_originalProfileActivatorCenter.x,
                                                                    _originalProfileActivatorCenter.y + _activatorDestinationCenterY);
                         
                         if (_customShowAnimations)
                             _customShowAnimations();
                         
                     } completion:^(BOOL finished) {
                         
                         _isShowingProfileViewer = YES;
                         // Enable the close recognizer
                         _contentViewTapGestureRecognizer.enabled = YES;
                         _profileContainerView.userInteractionEnabled = YES;
                         
                         // We need to change the superview of the activator in order for the gesture recognizer to work
                         // (the recognizer doesn't work if the view left the bounds of its superview)
                         // but before changing it, we need to calculate the new center and then assign it to the activator
                         CGPoint newCenter = [_navigationBar convertPoint:_profileActivatorView.center toView:_profileContainerView];
                         [_profileContainerView addSubview:_profileActivatorView];
                         _profileActivatorView.center = newCenter;
                         
                         if ([_delegate respondsToSelector:@selector(didShowProfileViewer)])
                             [_delegate didShowProfileViewer];
                         
                         if (_didShowProfileViewer)
                             _didShowProfileViewer();

                     }];
}

- (void)hideProfileView
{
    // Now we need to give back the activator to the navigation bar
    CGPoint newCenter = [_navigationBar convertPoint:_profileActivatorView.center fromView:_profileContainerView];
    [_navigationBar addSubview:_profileActivatorView];
    _profileActivatorView.center = newCenter;
    
    _profileContainerView.userInteractionEnabled = NO;

    [UIView animateWithDuration:_animationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [self resetViews];
                         
                         if (_customHideAnimations)
                             _customHideAnimations();
                         
                     } completion:^(BOOL finished) {
                         _isShowingProfileViewer = NO;
                         _contentView.userInteractionEnabled = YES;
                         _contentViewTapGestureRecognizer.enabled = NO;
                         
                         if ([_delegate respondsToSelector:@selector(didHideProfileViewer)])
                             [_delegate didHideProfileViewer];
                         
                         if (_didHideProfileViewer)
                             _didHideProfileViewer();

                     }];
}

- (void)transferViewsFromControllerViewToContentView
{
    _contentView.backgroundColor = self.view.backgroundColor;
    
    NSArray *controllerViews = [self.view subviews];
    for (UIView *view in controllerViews) {
        [_contentView addSubview:view];
    }
}

- (void)resetViews
{
    _contentView.frame = _originalContentViewFrame;
    
    _navigationBar.frame = _originalNavigationBarFrame;
    
    // Animate profile activator
    _profileActivatorView.transform = CGAffineTransformIdentity;
    _profileActivatorView.center = _originalProfileActivatorCenter;
}

#pragma mark - Events

- (void)didTapProfileActivator:(UIGestureRecognizer *)recognizer
{
    if (_isShowingProfileViewer) {
        [self hideProfileView];
    }
    else {
        [self showProfileView];
    }
}

- (void)didPanNavigationBar:(UIGestureRecognizer *)recognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)recognizer;
    CGPoint translationValues = [panGestureRecognizer translationInView:_navigationBar];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat yVelocity;
        
        if (translationValues.y <= 0)
            return;
        
        // v = d/t
        
        // Drop content view
        CGFloat yTranslationMax = MIN(_originalContentViewFrame.origin.y + translationValues.y, _profileContainerHeight);
        _contentView.frame = (CGRect){ CGPointMake(0, yTranslationMax), _contentView.bounds.size };
        
        // Animate the navigation bar ourselves because setNavigationBarHidden:animated causes problems
        yVelocity = (_navigationBar.bounds.size.height + _originalNavigationBarFrame.origin.y) / _profileContainerHeight;
        yTranslationMax = MIN(yVelocity * translationValues.y, _navigationBar.bounds.size.height + _originalNavigationBarFrame.origin.y);
        _navigationBar.frame =
            (CGRect) {
                CGPointMake(0, _originalNavigationBarFrame.origin.y - yTranslationMax),
                _navigationBar.bounds.size
            };
        
        // Animate profile activator
        yVelocity = (_scaleFactor - 1.0f) / _profileContainerHeight;
        yTranslationMax = MIN((translationValues.y * yVelocity) + 1.0f, _scaleFactor);
        _profileActivatorView.transform = CGAffineTransformMakeScale(yTranslationMax, yTranslationMax);
        yVelocity = _activatorDestinationCenterY / _profileContainerHeight;
        yTranslationMax = MIN(translationValues.y * yVelocity, _activatorDestinationCenterY);
        _profileActivatorView.center = CGPointMake(_originalProfileActivatorCenter.x, _originalProfileActivatorCenter.y + yTranslationMax);
        
        if (_didTranslateYProfileViewer)
            _didTranslateYProfileViewer(translationValues.y, _profileContainerHeight);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // get the completed percentage of the animation, and if it's above 50 then complete animation
        CGFloat completedPercentage = translationValues.y / (_profileContainerHeight / 100.0f);
        if (completedPercentage > 50) {
            [self showProfileView];
        }
        else {
            [self hideProfileView];
        }
    }
}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (CGRectContainsPoint(_contentView.bounds, [touch locationInView:_contentView]));
}

@end
