//
//  EVTabItemViewController.m
//  ProfileViewer
//
//  Created by Eric Velazquez on 3/23/14.
//
//

#import "EVTabItemViewController.h"

@interface EVTabItemViewController ()

@end

@implementation EVTabItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Subscribe
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:NC_USER_CHANGED object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)viewWillDisappear:(BOOL)animated
{

}

- (void)reloadData
{
    
}

@end
