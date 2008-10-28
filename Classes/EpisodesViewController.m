//
//  RootViewController.m
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright collect3 2008. All rights reserved.
//

#import "EpisodesViewController.h";
#import "VideoData.h";
#import "NavTestAppDelegate.h";
#import "BaseCell.h";

@implementation EpisodesViewController
@synthesize seasonName;
- (void)setupView {
	[super setupView];	
	cellIdentifier = @"EpisodesViewCell";
	actionCellText = @"Shuffle";
	hasImage = TRUE;
	rowHeight = 50;

}

- (void)doneLoad {
	[super doneLoad];
	
}

- (void)loadData {
	displayData = [[XBMCInterface GetEpisodesForVideoPath:videoPath] retain];
	NSLog(@"Number of episodes ", [displayData count]);	

	int count = [videoPath.items count];
	NSArray *items = videoPath.items;
	for (int i = 0; i < count; i++) {
		
		PathItem *path = [items objectAtIndex:i];
		NSLog(@"Path %d %@", path.type, path.value);
		if (path.type == PATH_TYPE_TVSHOW && path.value == nil) {
			NSLog(@"TV Show");
			subTitleType = SUB_TYPE_SHOW;			
			//break;
		} 
		if (path.type == PATH_TYPE_SEASON && path.value == nil) {
			NSLog(@"Season");
			subTitleType = SUB_TYPE_SEASON;
			//break;
		}
	}	
}


- (UITableViewCell*)getDataCell:(UITableView *)callingTableView data:(VideoData*)data{
	
	BaseCell *cell = (BaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[BaseCell alloc] autorelease];
		//float height = rowHeight * 9 / 16;
		cell.imageWidth  = rowHeight * 16 / 9;
		cell.imageHeight = rowHeight;
		[cell initWithFrame:CGRectZero reuseIdentifier:cellIdentifier];
	}
	
	NSString *subdata = nil;
	if (subTitleType == SUB_TYPE_SHOW) {
		subdata = data.showName;
	} else if (subTitleType == SUB_TYPE_SEASON) {
		subdata = [NSString stringWithFormat: @"Season %@", data.seasonName];
	}
	
	NSString *subTitle;
	if (subdata) {
		subTitle = [NSString stringWithFormat:@"Episode %@ - %@", data.episode, subdata];
	} else {
		subTitle = [NSString stringWithFormat:@"Episode %@", data.episode];	
	}
	[cell setData:data showImage: hasImage subTitle: subTitle];
	return cell;	
}


- (void)selectedDataCell:(VideoData*)data {
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
	[XBMCInterface playFile:           [ data fullFileName]];

	if (shuffle) {
		[XBMCInterface SetShuffle:         shuffle];
	}	
	// Show now playing
	NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
	//appDelegate.npViewController.forceShuffle = TRUE;
	//appDelegate.npViewController.forceShuffleState = shuffle;
	[appDelegate showNowPlaying];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[seasonName release];
	[super dealloc];
}


@end

