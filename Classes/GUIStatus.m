//
//  GUIStatus.m
//  xbmcremote
//
//  Created by David Fumberger on 5/09/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "GUIStatus.h"


@implementation GUIStatus
@synthesize activeWindowName;
@synthesize musicPath;
@synthesize videoPath;
- (void)dealloc {
	[activeWindowName release];
	[musicPath release];
	[videoPath release];
}
@end
