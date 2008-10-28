//
//  PodcastViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 19/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "PodcastViewController.h";
#import "AlbumsViewController.h";
@implementation PodcastViewController

- (void)setupView {
	[super setupView];
	cellIdentifier = @"PodcastCellView";
	actionCellText = @"All Artists";
}

- (void)doneLoad {
	[super doneLoad];
	
	//cellIdentifier = @"PodcastViewCell";
}
- (void)loadData {
	NSString *podcastID = [XBMCInterface GetPodcastGenreId];	
	if (podcastID) {
		NSLog(@"Podcast id [%@]", podcastID);
		PathItem *pathItem = [[PathItem alloc] init];
		pathItem.value =podcastID;
		pathItem.type = PATH_TYPE_GENRE;
		[musicPath addItem:pathItem];		
		NSLog(@"Count %d", [musicPath.items count]);
		displayData = [[XBMCInterface GetArtistsForMusicPath:musicPath] retain];
		[pathItem release];
	}
	NSLog(@"Number of podcast artists %d", [displayData count]);		
}


- (void)selectedDataCell:(ViewData*)data {
	AlbumsViewController *targetController = [[AlbumsViewController alloc] init];
	PathItem *pathItem = [[PathItem alloc] init];
	pathItem.type = PATH_TYPE_ARTIST;
	if (data == nil) {
		targetController.title = @"Albums";		
	} else {		
		targetController.title = data.title;
		pathItem.value = data.identifier;		
	}
	
	// Create new music path from this one and add new item
	MusicPath *newMusicPath = [MusicPath pathFromPath: musicPath];
	[newMusicPath addItem:pathItem];
	[targetController setMusicPath: newMusicPath];
	[[self navigationController] pushViewController:targetController animated:YES ];
	[targetController release];
	[pathItem release];
	[newMusicPath release];	
}

@end
