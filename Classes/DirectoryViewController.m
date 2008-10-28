//
//  DirectoryViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 20/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "DirectoryViewController.h"
#import "Key.h";
#import "NavTestAppDelegate.h";
#import "BaseCell.h";
#import "FileSystemData.h";
@implementation DirectoryViewController
@synthesize fileSystemData;
@synthesize mask;

- (void)setupView {
	[super setupView];
	cellIdentifier = @"DirectoryCellView";
	actionCellText = @"Queue All Items";
	hasImage = YES;
	rowHeight = 51;
}

- (void)doneLoad {
	[super doneLoad];
}
- (void)loadData {
	if (mask == DIRECTORY_MASK_MUSIC) {
		displayData = [[XBMCInterface GetMediaLocationForMusic:self.fileSystemData.path ] retain];
	} else if (mask == DIRECTORY_MASK_VIDEO) {
		displayData = [[XBMCInterface GetMediaLocationForVideo:self.fileSystemData.path ] retain];				
	} else {
		displayData = [[XBMCInterface GetMediaLocation:self.fileSystemData.path mask: nil] retain];		
	}
	NSLog(@"Number of directories %d", [displayData count]);	
}


- (void)selectedDataCell:(FileSystemData*)data {
	DirectoryViewController *targetController = [[DirectoryViewController alloc] init];
	NSString* playList;
	NSString *maskStr;	
	if (mask == DIRECTORY_MASK_MUSIC) {
		playList = [NSString stringWithFormat: @"%d", PLAYLIST_MUSIC];
		maskStr = @"[music]";
	} else if (mask == DIRECTORY_MASK_VIDEO) {
		playList = [NSString stringWithFormat: @"%d", PLAYLIST_VIDEO];
		maskStr = @"[video]";
	}
	
	if (data == nil || data.file != nil || data.isRar) {
		[XBMCInterface stopPlaying];
		[XBMCInterface clearPlayList: playList ];
		[XBMCInterface setCurrentPlayList: playList ];
		
		if (data == nil) {
			NSArray *paths = [XBMCInterface SplitMultipart:self.fileSystemData.path];
			int c = [paths count];
			for (int i = 0; i < c; i++) {
				[XBMCInterface addToPlayList: [paths objectAtIndex:i] playList: playList mask:maskStr recursive:@"1"];
			}
			[XBMCInterface SetPlaylistSong:0];
		// Work around due to bug in XBMC dealing with RAR's. http://xbmc.org/trac/ticket/4880
		} else if (data.isRar) {
			[XBMCInterface addToPlayList: data.path playList: playList mask:maskStr recursive:@"1"];
			[XBMCInterface SetPlaylistSong:0];
		} else if (data.file != nil) {
			[XBMCInterface addToPlayList: data.file playList: playList mask:maskStr recursive:@"1"];			
			[XBMCInterface playFile:data.file];
		}
		
		// Show now playing
		NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate showNowPlaying];

	} else {
		targetController.fileSystemData = data;
		targetController.mask = mask;
		targetController.title = data.title;
		[[self navigationController] pushViewController: targetController animated: YES];
		[targetController release];
	}
}

- (UITableViewCell*)getDataCell:(UITableView *)tableView data:(ViewData*)data{
	
	BaseCell *cell = (BaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[[BaseCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
		cell.imageWidth = rowHeight - 1;
		cell.imageHeight = rowHeight - 1;
		cell.maxImageSize = 320;
	}
	[cell setData:data showImage: hasImage subTitle: nil];
	return cell;	
}

 
- (void)dealloc {
	[fileSystemData release];
	[super dealloc];
}
@end
