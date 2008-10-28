//
//  RootViewController.m
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright collect3 2008. All rights reserved.
//

#import "ArtistViewController.h";
#import "AlbumsViewController.h";
#import "NavTestAppDelegate.h"
#import "ArtistData.h";
#import "PathItem.h";
#import "BaseViewController.h";
#import "BaseCell.h";

@implementation ArtistViewController
- (void)setupView {
	[super setupView];	
	sectionTitle   = @"Artists";
	cellIdentifier = @"ArtistViewCell";	
	actionCellText = @"All Albums";
}
- (void)doneLoad {
	[super doneLoad];

	hasImage = NO;
	//sectionViewStyle = SECTION_VIEW_NORMAL;	
}

- (void)loadData {
	displayData = [[XBMCInterface GetArtistsForMusicPath:musicPath] retain];
	NSLog(@"Number of artists %d", [displayData count]);	
}


- (void)selectedActionCell:(NSInteger)index {
	[self selectedDataCell:nil];
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
	[newMusicPath release];	
	[pathItem release];	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


@end

