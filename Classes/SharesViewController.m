//
//  SharesViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 21/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "SharesViewController.h"
#import "DirectoryViewController.h";

@implementation SharesViewController

-(void)doneLoad {
	[super doneLoad];
	actionSections = 0;
	rowHeight = 51;	
}

- (void)selectedDataCell:(ViewData*)data {
	DirectoryViewController *targetController = [[DirectoryViewController alloc] init];
	if (data == nil) {
		// Queue all
	} else {
		targetController.fileSystemData = data;
		targetController.mask = directoryMask;
		targetController.title = data.title;
		[[self navigationController] pushViewController: targetController animated: YES];
		[targetController release];
	}
}

@end
