//
//  InterfaceManager.m
//  xbmcremote
//
//  Created by David Fumberger on 19/10/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "InterfaceManager.h"

// This is a singleton class, see below
static InterfaceManager *sharedIMDelegate = nil;

@implementation InterfaceManager
@synthesize interface;
+ (RemoteInterface*)getSharedInterface {
	InterfaceManager *im = [InterfaceManager sharedInstance];
	return im.interface;
}

#pragma mark ---- singleton object methods ----

+ (InterfaceManager *)sharedInstance {
    @synchronized(self) {
        if (sharedIMDelegate == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedIMDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedIMDelegate == nil) {
            sharedIMDelegate = [super allocWithZone:zone];
            return sharedIMDelegate;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


@end
