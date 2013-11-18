//
//  AlbumViewController.h
//  gTunes
//
//  Created by Gregory Wicks on 10/12/13.
//  Copyright (c) 2013 Carney Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumDetailViewController.h"
#import "PlaybackViewController.h"

@interface AlbumViewController : UIViewController

@property (weak,nonatomic) GoogleMusicAPI *gaapi;

@end
