//
//  NPPlaylistViewController.m
//  NavTest
//
//  Created by David Fumberger on 8/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "NPPlaylistViewController.h"
#import "NPAlbumViewController.h";

@implementation NPPlaylistViewController
@synthesize nowPlayingData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

	
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	
	}
	return self;
}

/*
 Implement loadView if you want to create a view hierarchy programmatically
- (void)loadView {
}
 */

 //If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
	albumViewController = [[NPAlbumViewController alloc] initWithNibName:@"NPAlbumView" bundle:nil];
	[contentView addSubview:albumViewController.view];
}
 
- (void)loadData {
	NSLog(@"NP Playlist View Controller - loadData");
	[albumViewController setNowPlayingData:nowPlayingData];
	[albumViewController loadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[nowPlayingData release];
	[albumViewController release];
	[super dealloc];
}


@end
