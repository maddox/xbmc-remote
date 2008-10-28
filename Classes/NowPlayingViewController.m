//
//  NowPlaying.m
//  NavTest
//
//  Created by David Fumberger on 5/08/08.
//  Copyright 2008 collect3. All rights reserved.
//
#import "InterfaceManager.h";
#import "NowPlayingViewController.h"
#import "NPPlaylistViewController.h";
#import "NPAlbumViewController.h";
#import "ArtistViewController.h";
#import "NavTestAppDelegate.h";
#import "TVShowData.h";
#import "Crc32.h";
#import "MediaInfoViewController.h";
#define PLAYING 1
#define PAUSED 0

@implementation NowPlayingViewController



@synthesize timer;
@synthesize forceShuffle;
@synthesize forceShuffleState;
- (IBAction)goBack:(id)sender {
	// Show now playing
	NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate hideNowPlaying];
}

- (void)viewDidLoad {
	trackChanged = YES;
	[ self loadData ];	
	//[ self refreshAll ];

	UIFont *font         = [UIFont boldSystemFontOfSize:10];
	titleLabel.font      = font;
	titleLabelTwo.font   = font;
	titleLabelThree.font = font;
	timeLabel.font       = font;
	remainingLabel.font  = font;
	plotText.font        = font;
	
	titleLabel.text        = @"";
	titleLabelTwo.text     = @"";	
	titleLabelThree.text   = @"";
	timeLabel.text         = @"";
	remainingLabel.text    = @"";
	plotText.text         = @"";
	trackingView.hidden    = true;
	//[ self setupDisplayList ];

	// Setup flip view
	playlistViewController = [[NPPlaylistViewController alloc] initWithNibName:@"NPPlaylistView" bundle: nil];
	playlistView = playlistViewController.view;
}


- (void)viewWillDisappear:(BOOL)animated {
	[self.timer invalidate];
	[self.timer release];
	self.timer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
	refreshing   = NO;	
	isFingerDown   = NO;
	trackChanged = YES;
	[ self startTimer];	
	[self refreshAll];
}

- (void)loadData {
	XBMCInterface = [InterfaceManager getSharedInterface];
}
	
- (void)startTimer {
	NSDate *date = [NSDate date];
	NSTimer *mytimer = [[NSTimer alloc] initWithFireDate:date interval:1 target:self selector:@selector(refreshAll) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:mytimer forMode:NSDefaultRunLoopMode];
	self.timer = mytimer;
	[timer release];	
}

- (void)refreshAll {
	if (refreshing) {
		return;
	}
	refreshing = YES;
	[NSThread detachNewThreadSelector:@selector(_refreshAllThread) toTarget:self withObject:nil];	
}
- (void)_refreshAllThread {	
	NSAutoreleasePool   *autoreleasepool = [[NSAutoreleasePool alloc] init];	
	[self refreshNowPlaying];
	[self refreshVolume];	
	refreshing = NO;
	[autoreleasepool release];		
}

// Handles refresh of items in the tracking bar
- (void)_refreshTrackingThread {
	NSAutoreleasePool   *autoreleasepool = [[NSAutoreleasePool alloc] init];	
	[self refreshRepeat];
	[self refreshShuffle];	
	[autoreleasepool release];	
}
- (void)refreshRepeat {
	
}
- (void)refreshShuffle {
	NSInteger currShuffle = [XBMCInterface GetShuffle];
	
	if (self.forceShuffle) {
		self.forceShuffle = NO;		
		if (self.forceShuffleState != currShuffle) {
			shuffleState = self.forceShuffleState;
			[XBMCInterface SetShuffle:shuffleState];
		}
	}
	[self setShuffleButtonState: shuffleState];	
}
- (void)clearData {	
	plotText.text = @"";
	titleLabel.text = @"";
	titleLabelTwo.text = @"";	
	titleLabelThree.text = @"";
	timeLabel.text = @"";
	remainingLabel.text = @"";
}
- (void)clearMainImage {
	[coverImage setImage:[UIImage imageNamed:@"MusicNowPlayingXBMC.png"]];
}
- (void)clearVideoImage {
	[tvImage setImage:nil];
}
- (void)refreshNowPlaying {
	NowPlayingData *nowPlayingData = [XBMCInterface GetCurrentlyPlaying ];
	NSLog(@"Playing %d", nowPlayingData.playing);
	if (nowPlayingData.playing == YES || nowPlayingData.paused == YES) {
		if ( ![nowPlayingData.filename isEqualToString: currentFilename] || nowPlayingData.trackchanged) {
			trackChanged = YES;
			[self clearData];
		}	
		
		if (nowPlayingData.playing == YES) {
			[ self playingButtonState: PLAYING];
		} else {
			[ self playingButtonState: PAUSED];
		}
		
		timeLabel.text      = nowPlayingData.time;
		remainingLabel.text = nowPlayingData.duration;
		
		if (!isFingerDown) {
			[ trackingSlider setValue: nowPlayingData.percentagePlayed animated: NO];
		}
		
		// Only refresh the tracking information on track change, as it should generally not change.
		if (trackChanged) {
			[NSThread detachNewThreadSelector:@selector(_refreshTrackingThread) toTarget:self withObject: nil];
		}

		NSLog(@"Now Playing Type %d", nowPlayingData.type);
		if (nowPlayingData.type == TYPE_MUSIC) {
			titleLabel.text = nowPlayingData.artistTitle;
			titleLabelTwo.text = [nowPlayingData mediaTitle];
			titleLabelThree.text = nowPlayingData.albumTitle;
			if (trackChanged == YES) {
				[self clearVideoImage];
				currentFilename = [nowPlayingData.filename copy];
				trackChanged = NO;
				[ playlistViewController setNowPlayingData: nowPlayingData ]; 
				[ playlistViewController loadData ];
				[NSThread detachNewThreadSelector:@selector(getCoverImage:) toTarget:self withObject:nowPlayingData];
			}			
		} else if (nowPlayingData.type == TYPE_MOVIE) {
			//plotText.text     = data.plot;
			titleLabel.text      = [nowPlayingData mediaTitle];
			titleLabelTwo.text   = nowPlayingData.genre;
			titleLabelThree.text = nowPlayingData.director;

			if (trackChanged == YES) {
				[self clearVideoImage];
				//[self clearMainImage];
				currentFilename = [nowPlayingData.filename copy];
				trackChanged = NO;
				[NSThread detachNewThreadSelector:@selector(getCoverImage:) toTarget:self withObject:nowPlayingData];
			}					
		} else if (nowPlayingData.type == TYPE_VIDEO) {
			//plotText.text     = data.plot;
			titleLabel.text     = nowPlayingData.showTitle;
			titleLabelTwo.text  = [nowPlayingData mediaTitle];
			if (nowPlayingData.season != nil && nowPlayingData.episode != nil) { 
				titleLabelThree.text = [NSString stringWithFormat:@"Season %@ Episode %@", 
										nowPlayingData.season, nowPlayingData.episode];
			}
			if (trackChanged == YES) {
				//[self clearMainImage];
				currentFilename = [nowPlayingData.filename copy];
				trackChanged = NO;
				[NSThread detachNewThreadSelector:@selector(getCoverImage:) toTarget:self withObject:nowPlayingData];
				[NSThread detachNewThreadSelector:@selector(getShowImage:) toTarget:self withObject:nowPlayingData];
			}				
		}
	} else {
		[self clearVideoImage];
		[self clearMainImage];
		[self clearData];
   	    [ self playingButtonState: PAUSED];	
	}		

	return;	
}

- (void)getShowImage:(NowPlayingData*)data {
    NSAutoreleasePool   *autoreleasepool = [[NSAutoreleasePool alloc] init];	
	
	
	NSString *where =  [NSString stringWithFormat:@"c00 = \"%@\"", data.showTitle];
	NSArray *shows     = [XBMCInterface GetTVShowsByWhereClause: where];
	TVShowData *tv;
	if ([shows count] > 0) {
		tv   = [shows objectAtIndex:0];
	}
	if (tv) {
		//[tv setThumbnailFromPath];
		[tv fetchThumbnailMaxRes:320];
		if (tv.thumbnail_image != nil) {
			CGImageRef imgRef = tv.thumbnail_image.CGImage;
			CGFloat width = CGImageGetWidth(imgRef);
			CGFloat height = CGImageGetHeight(imgRef);		
			if ((height / width) < 0.20) {			
				[tvImage setImage:tv.thumbnail_image];
			}
		} else {
			[tvImage setImage:nil];
		}
	}
	[autoreleasepool release];	
}
- (void)getCoverImage:(NowPlayingData*)data {
    NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];	
	[data fetchThumbnail];
	if (data.image != nil) {
		[coverImage setImage:data.image];
	} else {
		[coverImage setImage:[UIImage imageNamed:@"MusicNowPlayingXBMC.png"]];		
	}
	if ([playlistView superview]) {
		[flipImageContainerView setImage: coverImage.image];
	}
	[autoreleasepool release];
}

- (void)playingButtonState:(NSInteger)state {
	if (state == PLAYING) {
		playButton.hidden = true; 
		pauseButton.hidden = false;
	} else {
		playButton.hidden = false;
		pauseButton.hidden = true;
	}
}

- (void)refreshVolume {
	NSInteger volume = [XBMCInterface GetVolume ];
	if (!isFingerDown) {
		[volumeSlider setValue: volume animated: YES] ;
	}
}
	
- (IBAction)play:(id)sender {
	[ self playingButtonState: PLAYING ];
	[XBMCInterface pause];		
}
- (IBAction)pause:(id)sender {
	[ self playingButtonState: PAUSED ];
	[XBMCInterface pause];	
}
- (IBAction)fingerDown:(id)sender {
	isFingerDown = YES;
}
- (IBAction)fingerUp:(id)sender {
	isFingerDown = NO;
}
- (IBAction)prevSong:(id)sender {
	// Unpause
	if (pauseButton.hidden == false) {
		[XBMCInterface pause];
	}	
	[XBMCInterface playPrev];
}
- (IBAction)nextSong:(id)sender {
	// Unpause
	if (pauseButton.hidden == false) {
		[XBMCInterface pause];
	}
	[XBMCInterface playNext];
}
- (IBAction)changeVolume:(id)sender {	
	[XBMCInterface SetVolume: volumeSlider.value];
}
- (IBAction)changePosition:(id)sender {	
	[XBMCInterface SeekPercentage: trackingSlider.value];
}

- (IBAction)toggleTracking:(id)sender {
	trackingView.hidden = !trackingView.hidden;
}
- (IBAction)showAlbumInfo:(id)sender {
	[self flipAction: sender];
}

- (void)flipAction:(id)sender
{
	UIViewAnimationTransition animation  = [nowPlayingContentView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft;
	UIImage *image;
	if ([nowPlayingContentView superview]) {
		image = coverImage.image;		
	} else {
		image = [UIImage imageNamed:@"plbutton.png"];	
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	
	[UIView setAnimationTransition:(animation)
						   forView:flipContainerView cache:YES];
	if ([playlistView superview])
	{
		[playlistView removeFromSuperview];
		[flipContainerView addSubview:nowPlayingContentView];	
	}
	else
	{
		[flipContainerView addSubview:playlistView];	
		[nowPlayingContentView removeFromSuperview];
	}
	
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];	
	[UIView setAnimationTransition:animation
						   forView:flipImageContainerView cache:YES];	
	[flipImageContainerView setImage: image];
	[UIView commitAnimations];
}

- (IBAction)showMediaInfo:(id)sender {
	NowPlayingData *data = [XBMCInterface GetCurrentlyPlaying ];
	mediaInfoViewController.dataType = data.type;
	if (data.url) {
		mediaInfoViewController.filename = data.url;
	} else {
		mediaInfoViewController.filename = data.filename;
	}
	
	[[self navigationController] presentModalViewController:mediaInfoNavController animated:YES];
	NSLog(@"Showing media info");
	
}
- (IBAction)hideMediaInfo:(id)sender {
	[[self navigationController] dismissModalViewControllerAnimated:YES];
}

- (void)setShuffleButtonState:(NSInteger)shuffle {
	UIImage *image;
	if (shuffle == SHUFFLE_STATE_ON) {
		image =  [UIImage imageNamed:@"NPAShuffleOn.png"];				
	} else {
		image =  [UIImage imageNamed:@"NPAShuffle.png"];
	}
	[shuffleButton setBackgroundImage: image forState:UIControlStateNormal];
	[shuffleButton setBackgroundImage: image forState:UIControlStateSelected];
	[shuffleButton setBackgroundImage: image forState:UIControlStateHighlighted];	
}

- (void)setRepeatButtonState:(NSInteger)repeat {
	UIImage *image;
	if (repeat == REPEAT_STATE_OFF) {
		image =  [UIImage imageNamed:@"NPARepeat.png"];				
	} else if (repeat == REPEAT_STATE_ON) {
		image =  [UIImage imageNamed:@"NPARepeatOn.png"];
	} else if (repeat == REPEAT_STATE_ONE) {
		image =  [UIImage imageNamed:@"NPARepeatOne.png"];		
	}
	[repeatButton setBackgroundImage: image forState:UIControlStateNormal];
	[repeatButton setBackgroundImage: image forState:UIControlStateSelected];
	[repeatButton setBackgroundImage: image forState:UIControlStateHighlighted];	
}
 
- (void)SetXBMCShuffle {
	NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];	
	[XBMCInterface SetShuffle:shuffleState];
	[autoreleasepool release];
}
- (void)SetXBMCRepeat {
	NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];	
	if (repeatState == REPEAT_STATE_OFF) {
		[XBMCInterface SetRepeatOff];
	} else if (repeatState == REPEAT_STATE_ON) {
		[XBMCInterface SetRepeatOn];		
	} else if (repeatState == REPEAT_STATE_ONE) {
		[XBMCInterface SetRepeatOne];		
	}
	[autoreleasepool release];
}
- (IBAction)toggleShuffle:(id)sender {
	shuffleState = (shuffleState == SHUFFLE_STATE_ON) ? (SHUFFLE_STATE_OFF) : (SHUFFLE_STATE_ON);  
	[self setShuffleButtonState:shuffleState];	
	[NSThread detachNewThreadSelector:@selector(SetXBMCShuffle) toTarget:self withObject:nil];	

}
- (IBAction)toggleRepeat:(id)sender {
	if (repeatState == REPEAT_STATE_OFF) {
		repeatState = REPEAT_STATE_ON;	
	} else if (repeatState == REPEAT_STATE_ON) {
		repeatState = REPEAT_STATE_ONE;			
	} else {
		repeatState = REPEAT_STATE_OFF;			
	}
	[NSThread detachNewThreadSelector:@selector(SetXBMCRepeat) toTarget:self withObject:nil];			
	[self setRepeatButtonState:repeatState];
}


- (void)dealloc {
	[self.timer invalidate];
	[currentFilename release];
	[playlistViewController release];
	[playlistView release];
	[super dealloc];
}

@end
