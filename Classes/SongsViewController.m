//
//  AlbumSongsViewController.m
//  NavTest
//
//  Created by David Fumberger on 3/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "SongsViewController.h";
#import "NavTestAppDelegate.h"
#import "Utility.h";
#import "LoadingViewController.h";
#import "SongData.h";
#import "BaseCell.h";
@implementation SongsViewController
@synthesize albumName;

/*
- (void)checkNavItem {
	NSString *title = [self navigationItem].title;
	if ([title length] > 10) {
		[self navigationItem].title = @"Long";
	}	
}
*/
- (void)setupView {
	[super setupView];	
	cellIdentifier = @"SongsViewCell";
	actionCellText = @"Shuffle";
}

- (void)doneLoad {
	[super doneLoad];
	sectionViewStyle = SECTION_VIEW_NORMAL;
	if (self.albumName == nil) {
		if ( [displayData count] > 10) {
			sectionViewStyle = SECTION_VIEW_INDEXED;
		}
	} else {
		sectionTitle = self.albumName;
	}
}


- (void)loadData {
	displayData = [[XBMCInterface GetSongsForMusicPath:musicPath] retain];
	NSLog(@"Number of songs %d", [displayData count]);			
}


- (UITableViewCell*)getDataCell:(UITableView *)callingTableView data:(ViewData*)data{
	SongData *songData = (SongData*)data;
	BaseCell *cell = (BaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[BaseCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
	}
	NSString *subTitle = nil;
	if (albumName == nil) {
		subTitle =  songData.artistTitle;
	}
	[cell setData:data showImage: NO subTitle: subTitle];
	return cell;	
}


- (void)selectedActionCell:(NSInteger)index {
	[self selectedDataCell:nil];
}
- (void)selectedDataCell:(ViewData*)data {
	BOOL shuffle = NO;
	
	// Shuffle if needed
	if (data == nil) {
		shuffle = YES;		
		NSInteger index = random() % [displayData count];
		data = [displayData objectAtIndex:index];
	} 
	
	//[XBMCInterface stopPlaying];
	[XBMCInterface clearPlayList:      [XBMCInterface getMusicPlaylist] ];
	[XBMCInterface setCurrentPlayList: [XBMCInterface getMusicPlaylist] ];
	[XBMCInterface queueMusicPath:     musicPath];
	
	SongData *sdata = (SongData*)data;
	[XBMCInterface playFile:[sdata fullFileName]];	
	
	// Queue album
	NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.npViewController.forceShuffle = TRUE;
	appDelegate.npViewController.forceShuffleState = shuffle;	
	[appDelegate showNowPlaying];
	
	//BOOL currshuff = [XBMCInterface GetShuffle];
//[XBMCInterface SetShuffle:         shuffle];	

	if (shuffle) {
		[XBMCInterface SetShuffle:shuffle];
	}			
	//if (currshuff == shuffle) {
		
	//}

	//[XBMCInterface playFile:           [ (SongData*)data fullFileName]];

	//	[XBMCInterface SetShuffle: shuffle delay: 2];	
	//}


			
	// Show now playing

	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[albumName release];
	[super dealloc];
}
@end
