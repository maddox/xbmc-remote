//
//  RootViewController.m
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright collect3 2008. All rights reserved.
//

#import "GenresViewController.h";
#import "ArtistViewController.h";

@implementation GenresViewController

- (void)setupView {
	[super setupView];	
	cellIdentifier = @"GenreViewCell";
	actionCellText = @"All Artists";
}
- (void)doneLoad {
	[super doneLoad];
}

- (void)loadData {
	displayData = [[XBMCInterface GetGenres] retain];
	NSLog(@"Number of artists %d", [displayData count]);	
}


- (void)selectedDataCell:(ViewData*)data {
	ArtistViewController *targetController = [[ArtistViewController alloc] init];
	
	PathItem *pathItem = [[PathItem alloc] init];
	pathItem.type = PATH_TYPE_GENRE;
	if (data == nil) {
		targetController.title = @"Artists";		
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

