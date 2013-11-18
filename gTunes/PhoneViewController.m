//
//  PhoneViewController.m
//  gTunes
//
//  Created by Gregory Wicks on 10/3/13.
//  Copyright (c) 2013 Gregory Wicks. All rights reserved.
//

#import "PhoneViewController.h"

@interface PhoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *phoneTable;

@end

@implementation PhoneViewController

NSArray* pdataArr;
NSData* pdata;
NSString *pfinalResponse = @"";
NSArray *prawSongArr;
NSMutableArray *psongArr;
NSInteger *pcurrIndex;
AudioPlayer *pstreamer;
int pmode = 0;
int precieved = 0;
GoogleMusicAPI *api;

NSString *username;
NSString *password;

UIStoryboard *storyboard;
PlaybackViewController *pvc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)stop:(id)sender {
    [pstreamer stop];
}
- (IBAction)lSongs:(id)sender {
    
    NSMutableArray *tempsongArr = [api getAllSongs];

    for (NSDictionary *song in tempsongArr)
    {
        NSArray *nsong;
        if ([song objectForKey:@"albumArtUrl"])
        {
            if ([song[@"album"] isEqualToString:@""])
            {
                nsong = @[song[@"title"],song[@"artist"],@"Unknown",song[@"genre"],@"",song[@"id"],song[@"durationMillis"],song[@"albumArtUrl"]];
            }
            else
            {
                nsong = @[song[@"title"],song[@"artist"],song[@"album"],song[@"genre"],@"",song[@"id"],song[@"durationMillis"],song[@"albumArtUrl"]];
            }
            [psongArr addObject:nsong];
        }
        else
        {
            if ([song[@"album"] isEqualToString:@""])
            {
                nsong = @[song[@"title"],song[@"artist"],@"Unknown",song[@"genre"],@"",song[@"id"],song[@"durationMillis"],@""];
            }
            else
            {
                nsong = @[song[@"title"],song[@"artist"],song[@"album"],song[@"genre"],@"",song[@"id"],song[@"durationMillis"],@""];
            }
            [psongArr addObject:nsong];
        }
        
        NSLog(@"%@",nsong);
    }
    psongArr = [psongArr sortedArrayUsingComparator:^(id a, id b) {
        return [[a objectAtIndex:0] compare:[b objectAtIndex:0]];
    }];
    [_phoneTable reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:psongArr forKey:@"songs"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    storyboard = self.storyboard;
    
    api = [[GoogleMusicAPI alloc] init];
    pvc = [storyboard instantiateViewControllerWithIdentifier:@"playbackVC"];
    pdata = [[NSData alloc] init];
    psongArr = [[NSMutableArray alloc] init];
    pstreamer = [[AudioPlayer alloc] init];
    
    username = [[NSUserDefaults standardUserDefaults] stringForKey:@"uname"];
    password = [[NSUserDefaults standardUserDefaults] stringForKey:@"pass"];
    if (username && password)
    {
        [api loginWithUsername:username withPassword:password];
        
        [self performSelector:@selector(lSongs:) withObject:nil afterDelay:1.5];
    }
    else
    {
        NSLog(@"Log In Required");
        UIAlertView *loginPrompt = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Enter your Google Play Login" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        loginPrompt.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        
        [loginPrompt show];
    }
	// Do any additional setup after loading the view.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        username = [[alertView textFieldAtIndex:0] text];
        password = [[alertView textFieldAtIndex:1] text];
        [api loginWithUsername:username withPassword:password];
        [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"uname"];
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"pass"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSelector:@selector(lSongs:) withObject:nil afterDelay:2.0];
        
    }
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
    return [psongArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellID";
    NSString *text = [[psongArr objectAtIndex:indexPath.row] objectAtIndex:0];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    [cell.textLabel setText:text];
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected Row: %d",indexPath.row);
    pvc = [storyboard instantiateViewControllerWithIdentifier:@"playbackVC"];
    
    NSArray *selectedSong = [psongArr objectAtIndex:indexPath.row];
    pvc.parentVC = self;
    pvc.api = api;
    pvc.songArray = psongArr;
    pvc.position = indexPath.row;
    //pvc.title = [selectedSong objectAtIndex:0];
    
    [self.navigationController pushViewController:pvc animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
    //[self presentViewController:pvc animated:YES completion:nil];
    //NSString *urlStr = [api getStreamUrl:[selectedSong objectAtIndex:5]];
    //NSLog(@"%@",urlStr);
    //[pstreamer play:[NSURL URLWithString:urlStr]];
}

@end
