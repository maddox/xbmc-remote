//
//  RootViewController.m
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright collect3 2008. All rights reserved.
//

#import "MoviesViewController.h";
//#import "SeasonsViewController.h";
#import "BaseCell.h";
//#import "MoviePath.h";
#import "MovieData.h";
#import "NavTestAppDelegate.h";
@implementation MoviesViewController

- (void)setupView {
	[super setupView];	
	cellIdentifier = @"MovieViewCell";
	actionCellText = @"Shuffle";
	hasImage = YES;	
	if ([xbmcSettings showImages]) {
		rowHeight = 160;
	}

}

- (void)doneZoom {
	if (zoomLevel == 1) {
		rowHeight = 120;
	} else if (zoomLevel == 2) {
		rowHeight = 160;
	} else if (zoomLevel == 3) {
		rowHeight = 200;
	} else if (zoomLevel == 4) {
		rowHeight = 280;
	}
}
- (void)doneLoad {
	[super doneLoad];

	if ( [displayData count] > 25) {
		sectionViewStyle = SECTION_VIEW_INDEXED;
	} else {
		sectionViewStyle = SECTION_VIEW_NORMAL;
	}
}

- (void)loadData {
	displayData = [[XBMCInterface GetMovies] retain];
	NSLog(@"Number of movies %d", [displayData count]);	
}

- (UITableViewCell*)getDataCell:(UITableView *)callingTableView data:(MovieData*)data{
	
	BaseCell *cell = (BaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[BaseCell alloc] autorelease];
		cell.imageHeight = (rowHeight - 1);
		cell.imageWidth  = (rowHeight - 1) * 3 / 4;
		[cell initWithFrame:CGRectZero reuseIdentifier:cellIdentifier];
	}
	cell.imageHeight = (rowHeight - 1);
	cell.imageWidth =  (rowHeight - 1) * 3 / 4;	
	[cell setData:data showImage: hasImage subTitle: data.genre];
	return cell;	
}


- (void)selectedDataCell:(ViewData*)data {
	BOOL shuffle = NO;

	// Shuffle if needed
	if (data == nil) {
		shuffle = YES;		
		NSInteger index = random() % [displayData count];
		data = [displayData objectAtIndex:index];
	} 
	// Queue album
	[XBMCInterface stopPlaying];
	[XBMCInterface clearPlayList:      [XBMCInterface getVideoPlaylist] ];
	[XBMCInterface setCurrentPlayList: [XBMCInterface getVideoPlaylist] ];
	[XBMCInterface queueVideoPath:     videoPath];
	[XBMCInterface SetShuffle:         shuffle];
	[XBMCInterface playFile:           [ (MovieData*)data fullFileName]];
	
	// Show now playing
	NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate showNowPlaying];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


@end

