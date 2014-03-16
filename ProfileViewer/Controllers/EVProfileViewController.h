//
//  EVProfileViewController.h
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import <UIKit/UIKit.h>

@class EVUser;

@protocol EVProfileViewControllerDelegate <NSObject>

- (void)didSelectUser:(EVUser *)user;

@end

@interface EVProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<EVProfileViewControllerDelegate> delegate;
@property (nonatomic, readonly) CGFloat reportedHeight;

@property (weak, nonatomic) IBOutlet UIView *addContainerView;

- (instancetype)initWithUser:(EVUser *)user;
- (void)updateViewUserDataWithUser:(EVUser *)user;

@end
