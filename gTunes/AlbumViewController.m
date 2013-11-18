//
//  AlbumViewController.m
//  gTunes
//
//  Created by Gregory Wicks on 10/12/13.
//  Copyright (c) 2013 Carney Labs. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

NSMutableArray *asongs;
NSMutableDictionary *albums;

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
    albums = [[NSMutableArray alloc] init];
    asongs = [[NSUserDefaults standardUserDefaults] objectForKey:@"songs"];
    
    
    NSLog(@"%d",[asongs count]);
    
   albums = [self songsToAlbums:asongs];
    
    NSLog(@"%@",albums);
	NSLog(@"%d",[albums count]);
    // Do any additional setup after loading the view.
}

- (NSMutableDictionary*)songsToAlbums:(NSMutableArray*)songs
{
    int i = 0;
    NSMutableDictionary *retDict = [[NSMutableDictionary alloc] init];
    for (NSArray *song in songs)
    {
        NSMutableArray *blank = [[NSMutableArray alloc] init];
        [retDict setValue:blank forKey:[song objectAtIndex:2]];
        /*if (i != 0)
        {
            NSArray *prevsong = [songs objectAtIndex:i-1];
            if ([[song objectAtIndex:2] isEqualToString:[prevsong objectAtIndex:2]])
            {
                if ([retDict objectForKey:[song objectAtIndex:2]])
                {
                    NSMutableArray *newArr = [retDict objectForKey:[song objectAtIndex:2]];
                    newArr = [newArr mutableCopy];
                    [newArr addObject:song];
                    
                    [retDict setValue:newArr forKey:[song objectAtIndex:2]];
                }
                else
                {
                    NSMutableArray *newArr = [[NSMutableArray alloc] initWithObjects:song, nil];
                    [retDict setValue:newArr forKey:[song objectAtIndex:2]];
                }
            }
        }
        else
        {
            NSMutableArray *newArr = [[NSMutableArray alloc] initWithObjects:song, nil];
            [retDict setValue:newArr forKey:[song objectAtIndex:2]];
        }
        i = i + 1;
        */
    }
    
    for (NSArray *alsong in songs)
    {
        if ([retDict objectForKey:[alsong objectAtIndex:2]])
        {
            NSMutableArray *currsongs = [retDict objectForKey:[alsong objectAtIndex:2]];
            [currsongs addObject:alsong];
            [retDict setObject:currsongs forKey:[alsong objectAtIndex:2]];
        }
        
    }
    return retDict;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [albums count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellID";
    NSArray *keys = [albums allKeys];
    keys = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSString *text = [keys objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    [cell.textLabel setText:text];
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *albumTitle = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    NSLog(albumTitle);
    NSArray *songs = albums[albumTitle];
    NSLog(@"%@",songs);
    
    AlbumDetailViewController *albumView = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumDetailView"];
    albumView.songs = songs;
    albumView.gadapi = _gaapi;
    
    [self.navigationController pushViewController:albumView animated:YES];
}



@end
