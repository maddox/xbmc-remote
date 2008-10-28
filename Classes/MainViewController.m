//
//  MainViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 17/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "MainViewController.h"
#import "NavTestAppDelegate.h";

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	//NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
	//[appDelegate showRemote];
	NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (rotateTo == UIInterfaceOrientationPortraitUpsideDown) {
		[appDelegate showRemote];	
	}
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	//NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];	
	rotateTo = toInterfaceOrientation;
	//if (rotateTo == UIInterfaceOrientationPortrait) {
	//	[appDelegate hideRemote];
	//}	

}


/*
- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (rotateTo == UIInterfaceOrientationPortraitUpsideDown) {
		[appDelegate showRemote];	
	} //else if (rotateTo == UIInterfaceOrientationPortrait) {
		//[appDelegate hideRemote];
	//}
}
*/
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
	if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
		//[appDelegate showRemote];
		return YES;
	} else if (interfaceOrientation == UIInterfaceOrientationPortrait) {
		[appDelegate hideRemote];
		return YES;
	} 
	return NO;
} 
- (void)dealloc {
	[super dealloc];
}


@end
