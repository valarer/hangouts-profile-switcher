//
//  EVModelController.m
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

static EVModelController *_sharedModelController;

@implementation EVModelController

+ (EVModelController *)sharedModelController
{
    if (!_sharedModelController)
        _sharedModelController = [EVModelController new];
    
    return _sharedModelController;
}

- (NSArray *)allAccounts
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
    
    return @[ericPrimary, ericWork];
}

- (NSArray *)otherAccountsNot:(EVUser *)currentUser
{
    NSMutableArray *allUsers = [NSMutableArray arrayWithArray:[self allAccounts]];
    
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

- (NSArray *)allContactsForCurrentUser
{
    return [self allContactsForAccount:_currentUser];
}

- (NSArray *)allContactsForAccount:(EVUser *)account
{
    NSMutableArray *contacts = [NSMutableArray array];
    NSArray *users;
    // Just return a bunch of users, pretending we got them from a data source
    if ([account.identifier isEqualToString:@"1"]) {
        EVUser *user3 = [EVUser new];
        user3.identifier = @"3";
        user3.name = @"Jorge";
        user3.email = @"jorge.email@gmail.com";
        user3.imageName = @"avatar_takayamaleaves";
        
        EVUser *user4 = [EVUser new];
        user4.identifier = @"4";
        user4.name = @"Juan";
        user4.email = @"work.email@gmail.com";
        user4.imageName = @"avatar_kyotogarden";
        
        EVUser *user5 = [EVUser new];
        user5.identifier = @"5";
        user5.name = @"María";
        user5.email = @"school.email@gmail.com";
        user5.imageName = @"avatar_kamakurashrine";
        
        users = @[user3, user4, user5];
    }
    if ([account.identifier isEqualToString:@"2"]) {
        EVUser *user6 = [EVUser new];
        user6.identifier = @"6";
        user6.name = @"Yumi";
        user6.email = @"your.email@gmail.com";
        user6.imageName = @"avatar_kamakurashrine";
        
        EVUser *user7 = [EVUser new];
        user7.identifier = @"7";
        user7.name = @"Eduardo";
        user7.email = @"work.email@gmail.com";
        user7.imageName = @"avatar_takayamaleaves";
        
        EVUser *user8 = [EVUser new];
        user8.identifier = @"8";
        user8.name = @"Kaori";
        user8.email = @"school.email@gmail.com";
        user8.imageName = @"avatar_kyotogarden";
        
        users = @[user6, user7, user8];
    }
    
    for (EVUser *user in users) {
        EVContact *contact = [EVContact new];
        contact.contactUser = user;
        contact.circleName = @"Friends";
        [contacts addObject:contact];
    }
    
    return contacts;
}

- (NSArray *)hangoutsForCurrentUser
{
    return [self hangoutsForAccount:_currentUser];
}

- (NSArray *)hangoutsForAccount:(EVUser *)account
{
    NSArray *contacts = [self allContactsForAccount:account];
    NSMutableArray *hangouts = [NSMutableArray array];
    for (EVContact *contact in contacts) {
        EVHangout *hangout = [EVHangout new];
        hangout.contactUser = contact.contactUser;
        hangout.text = @"Hi!";
        [hangouts addObject:hangout];
    }
    return hangouts;
}

@end
