//
//  AlbumDetailViewController.h
//  gTunes
//
//  Created by Gregory Wicks on 10/22/13.
//  Copyright (c) 2013 Carney Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoogleMusicAPI.h"
#import "PlaybackViewController.h"

@interface AlbumDetailViewController : UIViewController

@property (weak,nonatomic) NSArray *songs;

@property (strong,nonatomic) GoogleMusicAPI *gadapi;

@end
