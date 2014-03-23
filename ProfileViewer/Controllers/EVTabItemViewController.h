//
//  EVTabItemViewController.h
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/23/14.
//
//

#import <UIKit/UIKit.h>
#import "EVProfileViewerViewController.h"

@interface EVTabItemViewController : UIViewController <EVProfileViewerDelegate>

- (void)reloadData;

@end
