//
//  EVModelController.h
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import <Foundation/Foundation.h>
#import "EVUser.h"
#import "EVHangout.h"
#import "EVContact.h"

@interface EVModelController : NSObject

+ (EVModelController *)sharedModelController;

@property (strong, nonatomic) EVUser *currentUser;

- (NSArray *)allAccounts;
- (NSArray *)otherAccountsNot:(EVUser *)currentUser;
- (NSArray *)allContactsForAccount:(EVUser *)account;
- (NSArray *)allContactsForCurrentUser;
- (NSArray *)hangoutsForAccount:(EVUser *)account;
- (NSArray *)hangoutsForCurrentUser;

@end
