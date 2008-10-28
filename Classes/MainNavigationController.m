//
//  MainNavigationController.m
//  xbmcremote
//
//  Created by David Fumberger on 16/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "MainNavigationController.h"
#import "NavTestAppDelegate.h";

@implementation MainNavigationController


- (void)didReceiveMemoryWarning {
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Memory Low" delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
	//[ [self view] addSubview:alert];
	//[alert show];
	[[NSURLCache sharedURLCache] removeAllCachedResponses];			
	NSLog(@"******** MEMORY WARNING ***********");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// We only support single touches, so anyObject retrieves just that touch from touches
	NSArray *allTouches = [touches allObjects];
	NSLog(@"Touches began base view");
	for (int i = 0; i < [allTouches count]; i++) {
		NSLog(@"Touch %d", i);
	}
	
	/*
	 // Only move the placard view if the touch was in the placard view
	 if ([touch view] != placardView) {
	 // In case of a double tap outside the placard view, update the placard's display string
	 if ([touch tapCount] == 2) {
	 [placardView setupNextDisplayString];
	 }
	 return;
	 }
	 // Animate the first touch
	 CGPoint touchPoint = [touch locationInView:self];
	 [self animateFirstTouchAtPoint:touchPoint];
	 */
}

/*
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];	
	if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ||
		toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {

		[appDelegate showRemote];	
	
	} else if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
		
		[appDelegate hideRemote];
	
	}
}
 
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ||
	   interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		return YES;
	} else if (interfaceOrientation == UIInterfaceOrientationPortrait) {
		return YES;
	}
	return NO;
} 
*/
@end
