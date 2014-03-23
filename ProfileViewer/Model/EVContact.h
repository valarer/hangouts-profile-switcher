//
//  EVContact.h
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/23/14.
//
//

#import <Foundation/Foundation.h>

@interface EVContact : NSObject

@property (strong, nonatomic) EVUser *contactUser;
@property (strong, nonatomic) NSString *circleName;

@end
