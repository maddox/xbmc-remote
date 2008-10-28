//
//  NPAlbumViewController.m
//  NavTest
//
//  Created by David Fumberger on 8/08/08.
//  Copyright 2008 collect3. All rights reserved.
//
#import "InterfaceManager.h";
#import "RemoteInterface.h";
#import "NPAlbumViewController.h"
#import "SongData.h";

@implementation NPAlbumViewController
@synthesize nowPlayingData;
@synthesize tableData;
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	//NSLog(@"NPAlumbViewController");
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	}
	return self;
}
*/

- (void)viewDidLoad {
//	[ self loadData ];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}
- (void)loadData {
	XBMCInterface = [InterfaceManager getSharedInterface];
	NSLog(@"loadData ----- ");
	//self.tableData = [XBMCInterface GetSongsForAlbumName:albumName artistName:artistName];
	self.tableData = [XBMCInterface GetSongsForAlbumName:nowPlayingData.albumTitle artistName: nowPlayingData.artistTitle];
	NSLog(@"Number of songs %d", [self.tableData count]);	
	[self.tableView reloadData];
	NSLog(@"Done reload");
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return 1;
	if (self.tableData == nil) {
		return 0;
	} else {
		return self.tableData.count;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyIdentifier = @"NPAlbumViewCell";	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
	}
	SongData* data = [self.tableData objectAtIndex:indexPath.row];
	cell.text = data.title;
	cell.textColor = [UIColor whiteColor];
	return cell;	
}

// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SongData* songData = [self.tableData objectAtIndex:indexPath.row];
	RemoteInterface *xbmcInterface = [InterfaceManager getSharedInterface];
	[xbmcInterface clearPlayList: [xbmcInterface getMusicPlaylist ]];
	[xbmcInterface setCurrentPlayList: [xbmcInterface getMusicPlaylist ]];
	[xbmcInterface queueAlbumId: songData.albumId shuffle:NO];
	[xbmcInterface playFile: [songData fullFileName]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

// decide what kind of accesory view (to the far right) we will use
//- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//	return UITableViewCellAccessoryDisclosureIndicator;
//}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}*/


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[tableData release];
	[nowPlayingData release];
	[super dealloc];
}



@end
