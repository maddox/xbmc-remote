//
//  TouchResponder.m
//  xbmcremote
//
//  Created by David Fumberger on 20/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "TouchTableView.h"
#import "BaseViewController.h";

@implementation TouchTableView
//@synthesize controller;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
	firstpoint = [touch locationInView:self];
	horizontalChange = 0;
	verticalChange = 0;
	if ([[touches allObjects] count] == 1) {
		[super touchesBegan:touches withEvent:event];
	}
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	if ([[[event allTouches] allObjects] count] == 2) {

		NSLog(@"Multi Touch");
	CGPoint location     = [touch locationInView:self];
	horizontalChange += firstpoint.x - location.x;
	verticalChange   += firstpoint.y - location.y;	
	if (verticalChange > 100) {// || verticalChange > 100) {
		NSLog(@"Zoom--");
		horizontalChange = 0;
		verticalChange = 0;
		firstpoint = location;
		if (self.delegate && [self.delegate respondsToSelector:@selector(viewZoomOut)]) {
			[self.delegate viewZoomOut];
		}
	} else if (verticalChange < -100) { // || verticalChange < -50)  {
		NSLog(@"Zoom++"); 		

		horizontalChange = 0;
		verticalChange = 0;
		firstpoint = location;
		if (self.delegate && [self.delegate respondsToSelector:@selector(viewZoomIn)])
		{
			[self.delegate viewZoomIn];
		}		
	}
	CGPoint prevlocation = [touch previousLocationInView:self];
	
	NSLog(@"Touch %f %f / %f %f", location.x, location.y, firstpoint.x , firstpoint.y);
	NSLog(@"Change X %f Y %f", horizontalChange, verticalChange);
	} else {
		[super touchesMoved:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	// We only support single touches, so anyObject retrieves just that touch from touches
	UITouch *touch = [touches anyObject];
	if ([[touches allObjects] count] == 1) {
		[super touchesEnded:touches withEvent:event];
	}
}

- (void)dealloc {
	NSLog(@"TouchTableView - dealloc");
	[super dealloc];
}
@end
