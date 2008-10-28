//
//  NPPlaylistViewController.h
//  NavTest
//
//  Created by David Fumberger on 8/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NowPlayingData.h";
#import "NPAlbumViewController.h";
@interface NPPlaylistViewController : UIViewController {
	IBOutlet UIView *contentView;
	NowPlayingData *nowPlayingData;
	NPAlbumViewController *albumViewController;
}

- (void)loadData;
@property (nonatomic, retain) NowPlayingData *nowPlayingData;

@end
