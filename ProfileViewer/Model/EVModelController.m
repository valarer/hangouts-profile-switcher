//
//  EVModelController.m
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import "EVModelController.h"

static EVModelController *_sharedModelController;

@implementation EVModelController

+ (EVModelController *)sharedModelController
{
    if (!_sharedModelController)
        _sharedModelController = [EVModelController new];
    
    return _sharedModelController;
}

- (NSArray *)allUsers
{
    EVUser *ericPrimary = [EVUser new];
    ericPrimary.identifier = @"1";
    ericPrimary.name = @"Eric Velázquez";
    ericPrimary.email = @"your.email@gmail.com";
    ericPrimary.imageName = @"avatar_takayamaleaves";
    
    EVUser *ericWork = [EVUser new];
    ericWork.identifier = @"2";
    ericWork.name = @"Eric Work";
    ericWork.email = @"work.email@gmail.com";
    ericWork.imageName = @"avatar_kyotogarden";
    
    EVUser *ericSchool = [EVUser new];
    ericSchool.identifier = @"3";
    ericSchool.name = @"Eric School";
    ericSchool.email = @"school.email@gmail.com";
    ericSchool.imageName = @"avatar_kamakurashrine";
    
    return @[ericPrimary, ericWork, ericSchool];
}

- (NSArray *)otherUsersNot:(EVUser *)currentUser
{
    NSMutableArray *allUsers = [NSMutableArray arrayWithArray:[self allUsers]];
    
    NSUInteger objectIndexToRemove;
    for (int i = 0; i < [allUsers count]; i ++) {
        if ([((EVUser *)allUsers[i]).identifier isEqualToString:currentUser.identifier]) {
            objectIndexToRemove = i;
            break;
        }
    }
    [allUsers removeObjectAtIndex:objectIndexToRemove];
    
    return allUsers;
}

@end
