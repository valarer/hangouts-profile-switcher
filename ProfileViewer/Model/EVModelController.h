//
//  EVModelController.h
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import <Foundation/Foundation.h>
#import "EVUser.h"

@interface EVModelController : NSObject

+ (EVModelController *)sharedModelController;

- (NSArray *)allUsers;
- (NSArray *)otherUsersNot:(EVUser *)currentUser;

@end
