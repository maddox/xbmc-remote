//
//  RemoteTouchView.m
//  xbmcremote
//
//  Created by David Fumberger on 3/09/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RemoteTouchView.h"
#define DIRECTION_LEFT  0
#define DIRECTION_RIGHT 1
#define DIRECTION_UP    2
#define DIRECTION_DOWN  3

@implementation RemoteTouchView
@synthesize delegate;
@synthesize touchDownDate;
@synthesize lastDate;
- (void)sendDirection:(NSInteger)direction multiTouch:(BOOL)multiTouch {
	UIImage *imageAction;
	if (multiTouch) {
		switch (direction) {
			case DIRECTION_LEFT:
				[self.delegate controlSecondaryBack];
				imageAction = [UIImage imageNamed:@"remote-alt-left.png"];
				break;
			case DIRECTION_RIGHT:
				[self.delegate controlSecondaryRight];
				imageAction = [UIImage imageNamed:@"remote-alt-right.png"];
				break;
			case DIRECTION_UP:
				[self.delegate controlSecondaryUp];
				imageAction = [UIImage imageNamed:@"remote-alt-up.png"];
				break;
			case DIRECTION_DOWN:
				[self.delegate controlSecondaryDown];
				imageAction = [UIImage imageNamed:@"remote-alt-down.png"];				
				break;
		}			
	} else {
		switch (direction) {
			case DIRECTION_LEFT:
				[self.delegate controlMovedLeft];
				imageAction = [UIImage imageNamed:@"remote-left.png"];				
				break;
			case DIRECTION_RIGHT:
				[self.delegate controlMovedRight];
				imageAction = [UIImage imageNamed:@"remote-right.png"];				
				break;
			case DIRECTION_UP:
				[self.delegate controlMovedUp];
				imageAction = [UIImage imageNamed:@"remote-up.png"];				
				break;
			case DIRECTION_DOWN:
				[self.delegate controlMovedDown];
				imageAction = [UIImage imageNamed:@"remote-down.png"];				
				break;
		}
	}
	
	actionImage.image = imageAction;
	actionImage.alpha = 1;
	[UIView beginAnimations:@"imageAction" context:nil];
	[UIView setAnimationDuration:0.5];
	actionImage.alpha = 0;
	[UIView commitAnimations];
	
}
- (NSInteger)directionBetweenLocation:(CGPoint)location locationtwo:(CGPoint)locationtwo multiTouch:(BOOL)multiTouch {
	NSInteger xdiff = location.x - locationtwo.x ;
	NSInteger ydiff = location.y - locationtwo.y;
	
	// Respect the largest diff
	if (abs(xdiff) > abs(ydiff) )  {
		ydiff = 0;
	} else {
		xdiff = 0;
	}
	
	NSInteger direction = -1;

	NSInteger ma = (multiTouch) ? (multiTouchMoveAmount) : (moveAmount);
	
	if (abs(ydiff) >= ma) {
		if (ydiff < 0) 
			 { direction = DIRECTION_DOWN;  }
		else { direction = DIRECTION_UP;    }
	} else if (abs(xdiff) >= ma) {
		if (xdiff > 0) 
			 { direction = DIRECTION_LEFT;  }
		else { direction = DIRECTION_RIGHT; } 
	}
	return direction;
}
- (CGPoint)getPoint:(NSSet*)touches {
	if ([touches count] == 1) {
		UITouch *touch       = [touches anyObject];
		return [touch locationInView:self];
	}
	int x = 0; int y = 0;
	int count = [touches count];
	NSArray *objects = [touches allObjects];
	for (int i = 0; i < count; i++) {
		UITouch *touch = [objects objectAtIndex:i];
		CGPoint location = [touch locationInView: self];
		x += location.x; y += location.y;
	}
	x /= count;
	y /= count;
	return CGPointMake(x, y);
}
- (BOOL)stopScroll {
	if (scrolling) {
		[scrollTimer invalidate];
		scrollTimer = nil;
		scrolling = NO;
		return TRUE;
	}
	return FALSE;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {


	NSLog(@"Multi touch %i", multiTouch);
	didStopScroll = [self stopScroll];
	touchDownPoint = [self getPoint: touches];
	self.touchDownDate  = [NSDate date];
	self.lastDate  = [NSDate date];	
	lastPoint      = touchDownPoint;
	
	moveAmount			 = 40;
	multiTouchMoveAmount = 80;
	
	if ([touches count] < 2) {
		multiTouch = NO;
	}
	touchMovedCount = 0;
	NSLog(@"Touch Began %i Num Touches %i ", [touches count], numTouches);
	[self showPointer: touchDownPoint];
}
- (void)showPointer:(CGPoint)location {
	pointer.center = location;
	[UIView beginAnimations:@"pointer" context:nil];
	[UIView setAnimationDuration:0.5];
	pointer.alpha = 1;
	pointer.transform = CGAffineTransformMakeScale(10, 10);
	[UIView commitAnimations];
}
- (void)movePointer:(CGPoint)location {
	[UIView beginAnimations:@"pointerpos" context:nil];
	[UIView setAnimationDuration:0.5];
	pointer.center = CGPointMake(location.x, location.y + 50) ;	
	[UIView commitAnimations];

}
- (void)hidePointer {
	[UIView beginAnimations:@"pointer" context:nil];
	[UIView setAnimationDuration:0.5];
	pointer.alpha = 0;
	pointer.transform = CGAffineTransformMakeScale(1, 1);
	[UIView commitAnimations];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch       = [touches anyObject];
	CGPoint location     = [self getPoint: touches];
	[self movePointer: location];
	
	// Set multitouch sticky until touches begin again
	if ([touches count] > 1 && !multiTouch) {
		multiTouch = YES;
	}
	
	// Use this counter to only register the move until there have been 2 moves, just to make the multi touch a bit more solid.
	touchMovedCount++;
	
	NSLog(@"Touches Moved %i Num Touches %i Multi %i", [touches count] , numTouches, multiTouch);	
	
	
	NSInteger direction = [self directionBetweenLocation: lastPoint locationtwo: location multiTouch: multiTouch];
	if (direction >= 0 && touchMovedCount > 1) {
		lastPoint = location;
		[self sendDirection:direction multiTouch: multiTouch];
	}
	
	// If we haven't moved for quarter of a second then reset the inital points for the scroll checking.
	NSTimeInterval time = fabs([lastDate timeIntervalSinceNow]);
	if (time > 0.25) {
		touchDownPoint = location;
		self.lastDate = [NSDate date];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch       = [touches anyObject];
	CGPoint location     = [self getPoint: touches];
	NSInteger direction  = [self directionBetweenLocation: touchDownPoint locationtwo: location multiTouch: multiTouch];
	NSInteger distance   = 0;
	
	
	if (direction == DIRECTION_UP || direction == DIRECTION_DOWN) {
		distance = abs(location.y - touchDownPoint.y);
	} else if (direction == DIRECTION_LEFT || direction == DIRECTION_RIGHT) {
		distance = abs(location.x - touchDownPoint.x);		
	}
	
	NSTimeInterval time = fabs([lastDate timeIntervalSinceNow]);
	NSLog(@"Time %f Distance %i Direction %i", time, distance, direction);
	
	// If we've moved further than one 'move' in under quarter of a second then start scrolling.
	if (distance > moveAmount && time < 0.25 && !multiTouch) {
		if (direction == DIRECTION_UP || direction == DIRECTION_DOWN) {
			scrollSpeed     = (distance / time) * 1;
			scrolling       = YES;
			scrollDirection = direction; 
			scrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target: self selector: @selector(triggerScroll) userInfo:nil repeats:YES];		
			NSLog(@"Speed %f", scrollSpeed);
		}
	}
	
	NSTimeInterval totaltime = fabs([touchDownDate timeIntervalSinceNow]);	
	if (distance < moveAmount && totaltime <= 1 && !didStopScroll && !multiTouch) {
		NSLog(@"Enter");
		NSInteger taps = [touch tapCount];
		if (taps == 1 && totaltime > 0.10) {
			[self.delegate controlEnter];
		} else if (taps == 2) {
			[self.delegate controlSecondaryEnter];
		} else if (taps == 3) {
			[self.delegate controlThirdEnter];
		}
		
	}

	NSLog(@"Touches Ended %i Num Touches %i", [touches count] , numTouches);	
	[self hidePointer];
	[super touchesEnded:touches withEvent:event];
}

- (void)triggerScroll {
	scrollTraveled += (scrollSpeed / moveAmount);
	if (scrollTraveled >= moveAmount) {
		int send = (scrollTraveled / moveAmount);
		while(send--) {
			[self sendDirection:scrollDirection multiTouch: NO];
		}
		scrollTraveled = 0;
	}
	float curve = .9738;
	scrollSpeed *= curve;
	if (scrollSpeed <= moveAmount) {
		[self stopScroll];	
		return;
	}
}

- (void)dealloc {
	[self stopScroll];
	NSLog(@"TouchTableView - dealloc");
	[super dealloc];
}
@end



@end
