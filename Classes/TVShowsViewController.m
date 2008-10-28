//
//  RootViewController.m
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright collect3 2008. All rights reserved.
//

#import "TVShowsViewController.h";
#import "SeasonsViewController.h";
#import "TVCell.h";
#import "VideoPath.h";
#import "BaseCell.h";

@implementation TVShowsViewController
- (void)setupView {
	[super setupView];	
	cellIdentifier = @"TVShowViewCell";
	actionCellText = @"All Shows";
	hasImage       = YES;	
	rowHeight      = 60;
}

- (void)doneLoad {
	[super doneLoad];

	if ( [displayData count] > 30) {
		sectionViewStyle = SECTION_VIEW_INDEXED;
	} else {
		sectionViewStyle = SECTION_VIEW_NORMAL;
	}
	
}

- (void)loadData {
	displayData = [[XBMCInterface GetTVShows] retain];
	NSLog(@"Number of shows %d", [displayData count]);	
	if (self.videoPath == nil) {
		PathItem *path = [PathItem alloc];
		path.type = PATH_TYPE_TVSHOW;
		path.value = @"2";
		[self.videoPath addItem: path];
		[path release];
	}
}

- (UITableViewCell*)getDataCell:(UITableView *)callingTableView data:(ViewData*)data{
	
	BaseCell *cell = (BaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[BaseCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
	}
	cell.imageHeight = rowHeight;
	cell.imageWidth = rowHeight * 3/4;
	cell.maxImageSize = 321;
	[cell setData:data showImage: hasImage subTitle: nil];
	return cell;	
}


- (void)selectedDataCell:(ViewData*)data {

	SeasonsViewController *targetController = [[SeasonsViewController alloc] init];
	
	PathItem *pathItem = [[PathItem alloc] init];
	pathItem.type = PATH_TYPE_TVSHOW;
	if (data == nil) {
		targetController.title = @"Seasons";		
	} else {		
		targetController.title = data.title;
		pathItem.value = data.identifier;		
	}
	
	// Create new path from this one and add new item
	VideoPath *newVideoPath = [VideoPath pathFromPath: videoPath];
	[newVideoPath addItem:pathItem];
	[targetController setVideoPath: newVideoPath];
	
	[[self navigationController] pushViewController:targetController animated:YES ];
	[targetController release];
	[newVideoPath release];
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

