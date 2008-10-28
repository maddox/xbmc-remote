//
//  RemoteTouchView.h
//  xbmcremote
//
//  Created by David Fumberger on 3/09/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TOUCH_TYPE_X 1
#define TOUCH_TYPE_Y 2

@interface RemoteTouchView : UIImageView {
	NSDate *touchDownDate;	
	NSDate *lastDate;
	CGPoint touchDownPoint;
	CGPoint lastPoint;
	CGPoint firstPoint;
	NSInteger numTouches;
	NSInteger touchMovedCount;
	NSInteger moveAmount;
	NSInteger multiTouchMoveAmount;
	BOOL didStopScroll;
	BOOL scrolling;
	BOOL multiTouch;
	NSTimer *scrollTimer;
	NSInteger scrollDirection;
	float scrollSpeed;
	NSInteger scrollTraveled;
	
	NSInteger lastSpeed;
	NSInteger touchType;
	BOOL touchActive;
	NSInteger ysteps;
	NSInteger xsteps;
	IBOutlet UIImageView *pointer;
	IBOutlet UIViewController *delegate;
	IBOutlet UIImageView *actionImage;
}
@property (nonatomic, retain) NSDate *touchDownDate;
@property (nonatomic, retain) NSDate *lastDate;
@property (nonatomic, retain) UIViewController *delegate;
@end
