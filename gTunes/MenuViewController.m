//
//  MenuViewController.m
//  gTunes
//
//  Created by Gregory Wicks on 10/3/13.
//  Copyright (c) 2013 Carney Labs. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

GoogleMusicAPI *api;



- (IBAction)testComm:(id)sender {
    api = [[GoogleMusicAPI alloc] init];
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uname"];
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pass"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    //[api loginWithUsername:@"merauder75@gmail.com" withPassword:@"Yrogerg170"];
}

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)testLoad:(id)sender {
    
    NSMutableArray *songs = [api getAllSongs];
    //NSLog(@"%d",[songs count]);
    NSString *songURL = [api getStreamUrl:[[songs objectAtIndex:318] objectAtIndex:5]];
    NSLog(songURL);
    
}



@end
