//
//  RootViewController.m
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright collect3 2008. All rights reserved.
//

#import "SeasonsViewController.h";
#import "EpisodesViewController.h";

@implementation SeasonsViewController

- (void)setupView {
	[super setupView];	
	cellIdentifier = @"SeasonsViewCell";
	actionCellText = @"All Episodes";
}


- (void)doneLoad {
	[super doneLoad];
}

- (void)loadData {
	displayData = [[XBMCInterface GetSeasonsForVideoPath:videoPath] retain];
	NSLog(@"Number of seasons %d", [displayData count]);	
}


- (void)selectedDataCell:(ViewData*)data {
	EpisodesViewController *targetController = [[EpisodesViewController alloc] init];
	
	PathItem *pathItem = [[PathItem alloc] init];
	pathItem.type = PATH_TYPE_SEASON;
	if (data == nil) {
		targetController.title = @"Episodes";		
	} else {		
		targetController.title = data.title;
		targetController.seasonName = data.title;
		pathItem.value = data.identifier;		
	}
	
	// Create new path from this one and add new item
	VideoPath *newVideoPath = [VideoPath pathFromPath: videoPath];
	[newVideoPath addItem:pathItem];
	[targetController setVideoPath: newVideoPath];

	[[self navigationController] pushViewController:targetController animated:YES ];
	[targetController release];
	[pathItem release];
	[newVideoPath release];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}


@end

