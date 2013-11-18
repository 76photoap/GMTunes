//
//  PlaybackViewController.m
//  gTunes
//
//  Created by Gregory Wicks on 10/8/13.
//  Copyright (c) 2013 Gregory Wicks. All rights reserved.
//

#import "PlaybackViewController.h"


@interface PlaybackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
//@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumArt;
@property (weak, nonatomic) IBOutlet UIButton *pButton;

@end

@implementation PlaybackViewController

AudioPlayer *aplayer;
AVPlayer *player;

- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

NSArray *currSong;
int currentDur = 0;
int playing = 0;

- (IBAction)previous:(id)sender {
    NSLog(@"Previous");
    _position = _position - 1;
    [self refreshMetadata];
    [player pause];
    player = nil;
    [self play:nil];
}

- (IBAction)play:(id)sender {
    NSLog(@"Play");
    if (player)
    {
        
        if (playing == 0)
        {
            [_pButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
            playing = 1;
            [player play];
            
        }
        else
        {
            [_pButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            playing = 0;
            [player pause];
        
        }
    }
    else
    {
        [_pButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];

        NSString *url = [_api getStreamUrl:[currSong objectAtIndex:5]];
        NSLog(url);


        
        player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:url]];
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[_albumArt image]];
        
        CMTime dur = [[player currentItem] duration];
        int currDuration = (int)CMTimeGetSeconds(dur);
        
        NSDictionary *nowPlayingInfo = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[currSong objectAtIndex:0],[currSong objectAtIndex:1],albumArt,[currSong objectAtIndex:2],[NSNumber numberWithInt:currDuration],nil] forKeys:[NSArray arrayWithObjects:MPMediaItemPropertyTitle,MPMediaItemPropertyArtist,MPMediaItemPropertyArtwork,MPMediaItemPropertyAlbumTitle,MPMediaItemPropertyPlaybackDuration,nil]];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlayingInfo];
        
        [player play];
        playing = 1;
    }
}

- (IBAction)next:(id)sender {
    NSLog(@"Next");
    _position = _position + 1;
    [self refreshMetadata];
    [player pause];
    player = nil;
    [self play:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
	[self refreshMetadata];
    
    
    if (player)
    {
        [player pause];
        player = nil;
        [self play:nil];
    }
    
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
                [self play:nil];
                
                break;
                
                
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                
                [self previous:nil];
                break;
                
                
                
            case UIEventSubtypeRemoteControlNextTrack:
                
                [self next:nil];
                break;
                
                
                
            default:
                [self play:nil];
                break;
                
        }
    }
    
}

-(void)refreshMetadata
{
    NSArray *song = [_songArray objectAtIndex:[self position]];
    NSLog(@"Song: %@",song);
    currSong = song;
    [_titleLabel setText:[song objectAtIndex:0]];
    [_artistLabel setText:[song objectAtIndex:1]];
    [_albumLabel setText:[song objectAtIndex:2]];
    //[_genreLabel setText:[song objectAtIndex:3]];
    
    
    NSString *artURL = [song objectAtIndex:7];
    if (![artURL isEqualToString:@""])
    {
        artURL = [@"http:" stringByAppendingString:artURL];
        NSURL *imageURL = [NSURL URLWithString:artURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        [_albumArt setImage:image];
    }
    else
    {
        [_albumArt setImage:[UIImage imageNamed:@"noart.png"]];
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
