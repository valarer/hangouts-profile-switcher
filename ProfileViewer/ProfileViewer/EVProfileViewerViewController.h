//
//  EVProfileViewerViewController.h
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import <UIKit/UIKit.h>

@protocol EVProfileViewerDelegate <NSObject>

@optional
- (void)didShowProfileViewer;
- (void)didHideProfileViewer;

@end

@interface EVProfileViewerViewController : UIViewController

@property (weak, nonatomic) id<EVProfileViewerDelegate> delegate;

@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic, readonly) UIView *contentView;
@property (strong, nonatomic, readonly) UIView *profileContainerView;

@property (nonatomic, copy) void (^customShowAnimations)(void);
@property (nonatomic, copy) void (^customHideAnimations)(void);
@property (nonatomic, copy) void (^didShowProfileViewer)(void);
@property (nonatomic, copy) void (^didHideProfileViewer)(void);

@property (nonatomic, copy) void (^didTranslateYProfileViewer)(CGFloat yTranslate, CGFloat yGoal);

@property (nonatomic) CGFloat profileContainerHeight;
@property (nonatomic) CGFloat scaleFactor;
@property (nonatomic) CGFloat activatorDestinationCenterY;
@property (nonatomic) NSTimeInterval animationDuration;

@property (nonatomic, readonly) BOOL isShowingProfileViewer;

- (void)showProfileView;
- (void)hideProfileView;

@end
