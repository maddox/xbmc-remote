//
//  MusicSharesViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 21/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "MusicSharesViewController.h"
#import "DirectoryViewController.h";

@implementation MusicSharesViewController

- (void)setupView {
	[super setupView];
	cellIdentifier = @"VideoCellView";
	directoryMask = DIRECTORY_MASK_MUSIC;
	actionSections = 0;	
	hasImage = YES;	
}

- (void)loadData {
	displayData = [[XBMCInterface GetSharesForType:@"music"] retain];
	NSLog(@"Number of music shares %d", [displayData count]);	
}

@end
