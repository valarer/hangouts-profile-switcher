//
//  EVUser.h
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/15/14.
//
//

#import <Foundation/Foundation.h>

@interface EVUser : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *imageName;

@end
