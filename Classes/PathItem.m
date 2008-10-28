//
//  PathItem.m
//  xbmcremote
//
//  Created by David Fumberger on 13/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "PathItem.h"


@implementation PathItem
@synthesize type;
@synthesize value;
-(void)dealloc {
	[value release];
	[super dealloc];
}
@end
