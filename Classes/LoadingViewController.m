//
//  LoadingViewController.m
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "LoadingViewController.h"
@implementation LoadingViewController
@synthesize loadingLabel;

- (void)hideSpinner {
	UIImage *bwimage = [UIImage imageNamed:@"xbmcbw.png"];
	logo.image = bwimage;
	[bwimage release];
	
	[loadingSpinner stopAnimating];	
	loadingSpinner.hidden = true;
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
	NSLog(@"LoadingViewController - dealloc");
	[super dealloc];
}


@end
