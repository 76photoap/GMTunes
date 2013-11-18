//
//  PlaybackViewController.h
//  gTunes
//
//  Created by Gregory Wicks on 10/8/13.
//  Copyright (c) 2013 Gregory Wicks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PhoneViewController.h"
#import "AudioPlayer.h"
#import "GoogleMusicAPI.h"

@class PhoneViewController;

@interface PlaybackViewController : UIViewController

@property (weak, nonatomic) PhoneViewController *parentVC;
@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *artist;
@property (weak, nonatomic) NSString *album;
@property (weak, nonatomic) NSString *genre;
@property (weak, nonatomic) NSMutableArray *songArray;
@property NSInteger position;
@property (weak, nonatomic) GoogleMusicAPI *api;

@end
