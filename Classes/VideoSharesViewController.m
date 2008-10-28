//
//  VideoSharesViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 20/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "VideoSharesViewController.h"
#import "DirectoryViewController.h";

@implementation VideoSharesViewController

- (void)setupView {
	[super setupView];
	cellIdentifier = @"VideoCellView";
	directoryMask = DIRECTORY_MASK_VIDEO;
	actionSections = 0;
	hasImage = YES;
}

- (void)loadData {
	displayData = [[XBMCInterface GetSharesForType:@"video"] retain];
	NSLog(@"Number of video shares %d", [displayData count]);	
}

@end
