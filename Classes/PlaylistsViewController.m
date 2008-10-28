//
//  PlaylistsViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 21/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "PlaylistsViewController.h"
#import "NavTestAppDelegate.h";

@implementation PlaylistsViewController
@synthesize fileSystemData;

-(void)doneLoad {
	[super doneLoad];
	actionSections = 0;
}

- (void)loadData {
	if (self.fileSystemData == nil) {
		displayData = [[XBMCInterface GetDirectory:@"userdata/playlists/"] retain];
	} else {
		displayData = [[XBMCInterface GetDirectory:self.fileSystemData.path] retain];
	}
	NSLog(@"Number of directories %d", [displayData count]);	
}

- (void)selectedDataCell:(ViewData*)data {
	PlaylistsViewController *targetController = [[PlaylistsViewController alloc] init];
	if (data.file != nil) {
		[XBMCInterface stopPlaying];
		[XBMCInterface playFile: [data fullFileName]];
		// Show now playing
		NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate showNowPlaying];
	} else if (data.path != nil) {
		targetController.fileSystemData = data;
		[[self navigationController] pushViewController: targetController animated: YES];
		[targetController release];
	} 
}

@end
