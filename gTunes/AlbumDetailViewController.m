//
//  AlbumDetailViewController.m
//  gTunes
//
//  Created by Gregory Wicks on 10/22/13.
//  Copyright (c) 2013 Carney Labs. All rights reserved.
//

#import "AlbumDetailViewController.h"

@interface AlbumDetailViewController ()

@end

@implementation AlbumDetailViewController



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
    _gadapi = [[GoogleMusicAPI alloc] init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_songs count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellID";
    NSArray *song = [_songs objectAtIndex:indexPath.row];
    NSString *text = [song objectAtIndex:0];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    [cell.textLabel setText:text];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PlaybackViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"playbackVC"];
    pvc.api = _gadapi;
    pvc.songArray = _songs;
    pvc.position = indexPath.row;
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController pushViewController:pvc animated:YES];
    //UIViewController *albumView = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumDetailView"];
    //[self.navigationController pushViewController:albumView animated:YES];
}

@end
