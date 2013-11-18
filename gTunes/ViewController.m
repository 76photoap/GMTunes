//
//  ViewController.m
//  gTunes
//
//  Created by Gregory Wicks on 9/19/13.
//  Copyright (c) 2013 Gregory Wicks. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumArt;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end

@implementation ViewController

NSArray* dataArr;
NSData* data;
NSString *finalResponse = @"";
NSArray *rawSongArr;
NSIndexPath *currIndexPath;
NSMutableArray *songArr;
NSInteger *currIndex;
AVPlayer *songPlayer;
AudioPlayer *streamer;
int mode = 0;
int recieved = 0;
GoogleMusicAPI *api;
NSTimer *songTimer;
//UIImage *currImage;

NSString *username = @"";
NSString *password = @"";
//AudioStreamer *streamer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    dataArr = @[@"Test One",@"Test Two"];
    data = [[NSData alloc] init];
    songArr = [[NSMutableArray alloc] init];
    streamer = [[AudioPlayer alloc] init];
    api = [[GoogleMusicAPI alloc] init];
    
   
    username = [[NSUserDefaults standardUserDefaults] stringForKey:@"uname"];
    password = [[NSUserDefaults standardUserDefaults] stringForKey:@"pass"];
    if (username && password)
    {
        [api loginWithUsername:username withPassword:password];
        [self performSelector:@selector(loadSongs) withObject:nil afterDelay:2.0];
    }
    else
    {
        UIAlertView *loginPrompt = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Enter your Google Play Login" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        loginPrompt.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        
        [loginPrompt show];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [songArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellID";
    NSString *text = [[songArr objectAtIndex:indexPath.row] objectAtIndex:0];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    [cell.textLabel setText:text];
    
    return cell;
    
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
        [self performSelector:@selector(loadSongs) withObject:nil afterDelay:2.0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}
- (IBAction)loginPressed:(id)sender {
    NSLog(@"Pressed");
    UIAlertView *loginPrompt = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Enter your Google Play Login" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    loginPrompt.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    [loginPrompt show];
    
    
    
}

-(void) loadSongs
{
    NSMutableArray *tempsongArr = [api getAllSongs];
    for (NSDictionary *song in tempsongArr)
    {
        NSArray *nsong;
        if ([song objectForKey:@"albumArtUrl"])
        {
            if ([song objectForKey:@"year"])
            {
                nsong = @[song[@"title"],song[@"artist"],song[@"album"],song[@"genre"],song[@"year"],song[@"id"],song[@"durationMillis"],song[@"albumArtUrl"]];
                [songArr addObject:nsong];
            }
            else
            {
                nsong = @[song[@"title"],song[@"artist"],song[@"album"],song[@"genre"],@"",song[@"id"],song[@"durationMillis"],song[@"albumArtUrl"]];
                [songArr addObject:nsong];
            }
        }
        else
        {
            if ([song objectForKey:@"year"])
            {
                nsong = @[song[@"title"],song[@"artist"],song[@"album"],song[@"genre"],song[@"year"],song[@"id"],song[@"durationMillis"],@""];
                [songArr addObject:nsong];
            }
            else
            {
                nsong = @[song[@"title"],song[@"artist"],song[@"album"],song[@"genre"],@"",song[@"id"],song[@"durationMillis"],@""];
                [songArr addObject:nsong];
            }
        }
        
        NSLog(@"%@",nsong);
    }
    songArr = [songArr sortedArrayUsingComparator:^(id a, id b) {
        return [[a objectAtIndex:0] compare:[b objectAtIndex:0]];
    }];
    [_tableView reloadData];
}

-(void) login:(NSString*)uname withPass:(NSString*)pass
{
    
    mode = 0;
    NSString *post = [NSString stringWithFormat:@"&uname=%@&pass=%@",uname,pass];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://107.20.177.55/gm/list.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currIndexPath = indexPath;
    currIndex = indexPath.row;
}

int nplaying = 0;

- (IBAction)playButtonPressed:(id)sender {
    finalResponse = @"";
    mode = 1;
    
    
    if (songPlayer)
    {
    if (nplaying == 0)
    {
        [_playButton setImage:[UIImage imageNamed:@"Pause-icon.png"] forState:UIControlStateNormal];
        [songPlayer play];
        nplaying = 1;
    }
    else
    {
        
        [_playButton setImage:[UIImage imageNamed:@"Play-icon.png"] forState:UIControlStateNormal];
        nplaying = 0;
        [songPlayer pause];
    }
    }
    else
    {
        [self refreshMetadata];
        [_playButton setImage:[UIImage imageNamed:@"Pause-icon.png"] forState:UIControlStateNormal];
        NSString *songID = [[songArr objectAtIndex:currIndex] objectAtIndex:5];
        NSString *songURL = [api getStreamUrl:songID];
        NSLog(songURL);
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[_albumArt image]];
        
        
        songPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:songURL]];
        CMTime dur = [[songPlayer currentItem] duration];
        int secs = (int)CMTimeGetSeconds(dur);
        currDuration = secs;
        NSLog(@"Duration: %d",currDuration);
        NSString *endingTime = [self intToTimer:currDuration];
        [_endTime setText:endingTime];
        
        NSDictionary *nowPlayingInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[[songArr objectAtIndex:currIndex] objectAtIndex:0],[[songArr objectAtIndex:currIndex] objectAtIndex:1],albumArt,[[songArr objectAtIndex:currIndex] objectAtIndex:2],[NSNumber numberWithInt:currDuration],nil] forKeys:[NSArray arrayWithObjects:MPMediaItemPropertyTitle,MPMediaItemPropertyArtist,MPMediaItemPropertyArtwork,MPMediaItemPropertyAlbumTitle,MPMediaItemPropertyPlaybackDuration,nil]];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlayingInfo];
        
        songTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:songTimer forMode:NSRunLoopCommonModes];
        
        [songPlayer play];
        nplaying = 1;
    }
}

-(void)updateTimer
{
    float currTime = CMTimeGetSeconds([songPlayer currentTime]);
    int currIntTime = (int)currTime;
    //double currDubTime = (double)currTime;
    
    [_startTime setText:[self intToTimer:currIntTime]];
    //NSDictionary *npinfo = [[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
    //NSMutableDictionary *mutablenpinfo = [NSMutableDictionary dictionaryWithDictionary:npinfo];
    //[mutablenpinfo setValue:[NSNumber numberWithDouble:currDubTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //npinfo = [NSDictionary dictionaryWithDictionary:mutablenpinfo];
    //[[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:npinfo];
    
    float result = currTime / currDuration;
    NSLog(@"%f %d %f",currTime,currDuration,result);
    if (result >= 1.0f)
    {
        [self next];
        
    }
    [_progressBar setProgress:result animated:YES];
    
}


-(NSString*)intToTimer:(int)seconds
{
    NSString *timeString = @"";
    
    int minutes = seconds / 60;
    int rseconds = seconds % 60;
    
    timeString = [NSString stringWithFormat:@"%d:%02d",minutes,rseconds];
    
    return timeString;
}

-(void)next
{
    NSIndexPath * actualIndexPath = _tableView.indexPathForSelectedRow;
    NSIndexPath * newIndexPath = [NSIndexPath  indexPathForRow:actualIndexPath.row+1 inSection:actualIndexPath.section];
    [_tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    currIndex = _tableView.indexPathForSelectedRow.row;
    if (songPlayer)
    {
        [songTimer invalidate];
        [songPlayer pause];
        songPlayer = nil;
        nplaying = 0;
        [self playButtonPressed:nil];
    }
}

-(void)previous
{
    NSIndexPath * actualIndexPath = _tableView.indexPathForSelectedRow;
    NSIndexPath * newIndexPath = [NSIndexPath  indexPathForRow:actualIndexPath.row-1 inSection:actualIndexPath.section];
    [_tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    currIndex = _tableView.indexPathForSelectedRow.row;
    if (songPlayer)
    {
        [songTimer invalidate];
        [songPlayer pause];
        songPlayer = nil;
        nplaying = 0;
        [self playButtonPressed:nil];
    }
}

int totalSeconds = 0;
int currDuration = 0;

-(void)refreshMetadata
{
    NSString *title = [NSString stringWithFormat:@"Title:   %@",[[songArr objectAtIndex:currIndex] objectAtIndex:0]];
    [_titleLabel setText:title];
    NSString *artist = [NSString stringWithFormat:@"Artist: %@",[[songArr objectAtIndex:currIndex] objectAtIndex:1]];
    [_artistLabel setText:artist];
    NSString *album = [NSString stringWithFormat:@"Album:   %@",[[songArr objectAtIndex:currIndex] objectAtIndex:2]];
    [_albumLabel setText:album];
    NSString *genre = [NSString stringWithFormat:@"Genre:   %@",[[songArr objectAtIndex:currIndex] objectAtIndex:3]];
    [_genreLabel setText:genre];
    NSString *year = [NSString stringWithFormat:@"Year:    %@",[[songArr objectAtIndex:currIndex] objectAtIndex:4]];
    [_yearLabel setText:year];
    
    [_progressBar setProgress:0.0];
    
    int seconds = [[songArr objectAtIndex:currIndex] objectAtIndex:6];
    seconds = seconds / 1000;
    
    NSString *endT = [self intToTimer:seconds];
    NSLog(@"End Time: %@",endT);
    
    
    NSString *artURL = [[songArr objectAtIndex:currIndex] objectAtIndex:7];
    if (![artURL isEqualToString:@""])
    {
    artURL = [@"http:" stringByAppendingString:artURL];
    NSURL *imageURL = [NSURL URLWithString:artURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    image = [self resizeImage:image newSize:CGSizeMake(512,512)];
    [_albumArt setImage:image];
    }
    else
    {
        [_albumArt setImage:[UIImage imageNamed:@"noart.png"]];
    }
}

- (IBAction)ff:(id)sender {
    [self next];
}

- (IBAction)rw:(id)sender {
    [self previous];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    NSLog(@"Recieved Data");
    
    
    NSString *responseText = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    if (mode == 0)
    {
        finalResponse = [finalResponse stringByAppendingString:responseText];
    }
    else if (mode == 1)
    {
        finalResponse = responseText;
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",[error description]);
}
- (IBAction)funkinPowah:(id)sender {
    //[streamer play:[NSURL URLWithString:@"http://107.20.177.55/gm/50k.mp3"]];
    
    //songPlayer = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"http://107.20.177.55/gm/50k.mp3"]];
    
    [self next];
    
    //UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    //[songPlayer play];
    //newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    
    //MPMediaQuery *query = [[MPMediaQuery alloc] init];
    
    //NSArray *items = [query items];
    //for (MPMediaItem *song in items) {
      //  NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
      //  NSLog (@"%@", songTitle);
    //}
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void) remoteControlReceivedWithEvent: (UIEvent*) event
{
    if (event.type == UIEventTypeRemoteControl) {

        switch (event.subtype) {
                
                
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"Play/Pause");
                [self playButtonPressed:nil];
                
                break;
                
                
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                
                [self previous];
                break;
                
                
                
            case UIEventSubtypeRemoteControlNextTrack:
                
                [self next];
                break;
                
                
                
            default:
                
                break;
                
        }
    }

}
- (IBAction)stopPlaying:(id)sender {
    //[streamer stop];
    [songTimer invalidate];
    [_playButton setImage:[UIImage imageNamed:@"Play-icon.png"] forState:UIControlStateNormal];
    if (songPlayer)
    {
        [songPlayer pause];
        songPlayer = nil;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    NSLog(@"Finished Loading");
    NSLog(finalResponse);
    if (mode == 0)
    {
    rawSongArr = [finalResponse componentsSeparatedByString:@"<>"];
    NSString *lastStr = @"";
    for (NSString *str in rawSongArr)
    {
        if (![str isEqualToString:lastStr])
        {
            NSArray *narr = [str componentsSeparatedByString:@";"];
            [songArr addObject:narr];
        }
        lastStr = str;
    }
        
    [_tableView reloadData];

    }
    else if (mode == 1)
    {
        NSLog(finalResponse);
        finalResponse = [finalResponse stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        [streamer play:[NSURL URLWithString:finalResponse]];
        
        
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSString *username = @"";
    NSString *password = @"";
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:username
                                                             password:password
                                                          persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

@end
