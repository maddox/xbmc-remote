//
//  AlbumsViewController.m
//  NavTest
//
//  Created by David Fumberger on 1/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "AlbumsViewController.h"
#import "SongsViewController.h";
#import "NavTestAppDelegate.h"
#import "LoadingViewController.h";
#import "BaseCell.h";
#import "BaseView.h";
#import "AlbumData.h";
#import "MusicPath.h";
#import "PathItem.h";

@implementation AlbumsViewController


- (void)setupView {
	[super setupView];
	hasImage = TRUE;
	rowHeight = 55;
	cellIdentifier = @"AlbumsViewController";	
	actionCellText = @"All Songs";
}

- (void)checkMultipleArtists {
	multipleArtists = NO;
	if ([displayData count] == 0) {
		return;
	}
	AlbumData *first = [displayData objectAtIndex:0];
	NSString *lastArtist = first.artistTitle;
	for ( AlbumData *albumData in displayData ) {
		NSString *currentArtist = albumData.artistTitle;
		if (![lastArtist isEqualToString:currentArtist]) {
				multipleArtists = YES;
				break;
		}
	}
}

- (void)doneLoad {
	[super doneLoad];
	[self checkMultipleArtists];
	if ( [displayData count] > 10) {
		sectionViewStyle = SECTION_VIEW_INDEXED;
	} else {
		sectionViewStyle = SECTION_VIEW_NORMAL;
	}
	
	//hasImage = NO;
	//sectionViewStyle = SECTION_VIEW_NORMAL;	
	//actionSections = 0;
	//cellIdentifier = @"ArtistViewCell";
}

- (void)loadData {
	displayData = [[XBMCInterface GetAlbumsForMusicPath:self.musicPath] retain];
}


- (UITableViewCell*)getDataCell:(UITableView *)callingTableView data:(ViewData*)data{
	AlbumData *albumData = (AlbumData*)data;
	BaseCell *cell = (BaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[BaseCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		cell.imageWidth = rowHeight;
		cell.imageHeight = rowHeight;
	} 

	NSString *subTitle = nil;
	if (multipleArtists == YES) {
		subTitle = albumData.artistTitle;
	}	
	[ cell setData: data showImage: hasImage subTitle: subTitle];
	// Set up the cell
	return cell;	
}
- (void)selectedActionCell:(NSInteger)index {
	[self selectedDataCell:nil];
}
- (void)selectedDataCell:(ViewData*)data {

	SongsViewController *targetController = [[SongsViewController alloc] init];
	
	PathItem *pathItem = [[PathItem alloc] init];
	pathItem.type = PATH_TYPE_ALBUM;
	if (data == nil) {
		targetController.title = @"All Songs";	
	} else {	
		targetController.title = self.title;	
		targetController.albumName = data.title;
		pathItem.value = data.identifier;
	}
	
	//Create new music path from this one and add new item
	MusicPath *newMusicPath = [MusicPath pathFromPath: musicPath];
	[newMusicPath addItem:pathItem];
	[targetController setMusicPath: newMusicPath];
	[[self navigationController] pushViewController:targetController animated:YES ];
	[targetController release];
	[newMusicPath release];
	[pathItem release];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

@end
