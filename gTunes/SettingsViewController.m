//
//  SettingsViewController.m
//  gTunes
//
//  Created by Gregory Wicks on 10/9/13.
//  Copyright (c) 2013 Gregory Wicks. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)clearLogin:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pass"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
