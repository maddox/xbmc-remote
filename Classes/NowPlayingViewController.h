//
//  NowPlaying.h
//  NavTest
//
//  Created by David Fumberger on 5/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteInterface.h";
#import "NowPlayingData.h";
#import "NPPlaylistViewController.h";
#import "MediaInfoViewController.h";


@interface NowPlayingViewController : UIViewController {
	IBOutlet UINavigationBar *navigationBar;
	IBOutlet UIButton *playButton;
	IBOutlet UIButton *pauseButton;	
	IBOutlet UISlider *volumeSlider;
	IBOutlet UISlider *trackingSlider;
	
	IBOutlet UIButton *shuffleButton;
	IBOutlet UIButton *repeatButton;
	
	IBOutlet UIImageView *coverImage;
	
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *titleLabelTwo;
	IBOutlet UILabel *titleLabelThree;
	
	IBOutlet UITextView *plotText;
	IBOutlet UIImageView *tvImage;
	
	IBOutlet UILabel *remainingLabel;
	IBOutlet UILabel *timeLabel;
	
	IBOutlet UIView *flipContainerView;
	IBOutlet UIView *nowPlayingContentView;
	IBOutlet UIImageView *flipImageContainerView;
	IBOutlet UIView *trackingView;	
	
	IBOutlet UIButton *trackingButton;
	
	IBOutlet UINavigationController *mediaInfoNavController;
	IBOutlet MediaInfoViewController *mediaInfoViewController;
 	RemoteInterface *XBMCInterface;
	//NowPlayingData *nowPlayingData;
	BOOL trackChanged;
	BOOL refreshing;
	BOOL isFingerDown;
	
	BOOL forceShuffle;
	BOOL forceShuffleState;	
	
	NSString *currentFilename;
	NSTimer *timer;
	
	UIView *playlistView;
	NPPlaylistViewController *playlistViewController;

	NSInteger shuffleState;
	NSInteger repeatState;
	
	//NowPlayingData *nowPlayingData;
}
- (IBAction)showMediaInfo:(id)sender;
- (IBAction)hideMediaInfo:(id)sender;

- (IBAction)goBack:(id)sender;
- (IBAction)showAlbumInfo:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)prevSong:(id)sender;
- (IBAction)nextSong:(id)sender;
- (IBAction)changeVolume:(id)sender;
- (IBAction)fingerDown:(id)sender;
- (IBAction)fingerUp:(id)sender;
- (IBAction)changePosition:(id)sender;
- (IBAction)toggleTracking:(id)sender;
- (IBAction)toggleShuffle:(id)sender;
- (IBAction)toggleRepeat:(id)sender;
- (void)flipAction:(id)sender;
- (void)getCoverImage:(NowPlayingData*)data;
- (void)refreshNowPlaying;
- (void)refreshVolume;
- (void)refreshAll;
- (void)loadData;
- (void)startTimer;
- (void)playingButtonState:(NSInteger)state;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) BOOL forceShuffle;
@property (nonatomic) BOOL forceShuffleState;
//@property (nonatomic, retain) NowPlayingData *nowPlayingData;
@end
