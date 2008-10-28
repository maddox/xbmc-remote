//
//  XBMCSettings.m
//  NavTest
//
//  Created by David Fumberger on 5/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "XBMCSettings.h"
#import "XBMCHostData.h";

#define KEY_HOST_LIST   0
#define KEY_HOST_ACTIVE 1
#define KEY_ID_SEQ      2
#define KEY_SHOW_IMAGES 3
#define KEY_SYNC        4



@implementation XBMCSettings

@synthesize showImages;
@synthesize sync;
@synthesize remoteType;
- (void) init {
	defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *hostList = [defaults objectForKey:@"XBMCHostList"];
	if (hostList == nil) {
		hostList = [NSMutableArray array];
		[defaults setObject: hostList forKey:@"XBMCHostList"];
		[defaults setBool:  YES forKey: @"XBMCShowImages"];
		[defaults setBool:  NO  forKey: @"XBMCSync"];		
		[defaults setInteger:0 forKey:@"XBMCRemoteType"];				
	}  
	showImages = [defaults boolForKey: @"XBMCShowImages"];
	sync       = [defaults boolForKey: @"XBMCSync"];	
	remoteType = [defaults integerForKey:@"XBMCRemoteType"];
	[super init];
}
- (void)saveSettings {
	[defaults setBool: showImages forKey: @"XBMCShowImages"];
	[defaults setBool: sync forKey: @"XBMCSync"];	
	[defaults setInteger: remoteType forKey: @"XBMCRemoteType"];		
}
- (void)resetAllSettings {
	[defaults removeObjectForKey:@"XBMCHostList"];
	[defaults removeObjectForKey:@"XBMCHostActive"];
	[defaults removeObjectForKey:@"XBMCIDSeq"];
}
- (void)addHost:(XBMCHostData*)hostData {
	NSMutableArray *hostList = [NSMutableArray arrayWithArray: [defaults objectForKey:@"XBMCHostList"]];
	NSInteger idseq          = [defaults integerForKey:@"XBMCIDSeq"];
	if (!idseq) {
		idseq = 1;
	} else {
		idseq++;
	}
	[hostData setIdentifier: idseq];
	[hostList addObject: [hostData toArray]];	
	[defaults setInteger: idseq forKey:@"XBMCHostActive"];
	[defaults setInteger: idseq forKey:@"XBMCIDSeq"];
	[defaults setObject: hostList forKey:@"XBMCHostList"];	
}
- (void)setActive:(XBMCHostData*)hostData {
	[defaults setInteger: hostData.identifier forKey:@"XBMCHostActive"];
}
- (NSInteger)getActiveId  {
	NSInteger activeIdentifier = [defaults integerForKey:@"XBMCHostActive"];
	return activeIdentifier;
}
- (void)removeHost:(XBMCHostData*)hostData {
	NSArray *hostList = [defaults objectForKey:@"XBMCHostList"];
	NSMutableArray *newHostList = [NSMutableArray array]; 
	NSEnumerator *enumerator = [hostList objectEnumerator];
	
	NSArray *host;
	NSInteger activeIdentifier = [defaults integerForKey:@"XBMCHostActive"];
	NSInteger newActiveIdentifier;
	BOOL setNewActiveIdentifier = NO;
	while (host = [enumerator nextObject]) {
		XBMCHostData *currHostData = [[XBMCHostData alloc] initWithArray:host];	
		if ( currHostData.identifier != hostData.identifier) {
			newActiveIdentifier = currHostData.identifier;
			[newHostList addObject:[currHostData toArray]];
		} else {
			if (currHostData.identifier == activeIdentifier) {
				setNewActiveIdentifier = YES;
			}
		}
		[currHostData release];
	}

	if (setNewActiveIdentifier) {
		if (newActiveIdentifier) {
			[defaults setInteger:newActiveIdentifier forKey:@"XBMCHostActive"];
		} else {
			[defaults removeObjectForKey:@"XBMCHostActive"];
		}
	}
		
	[defaults setObject: newHostList forKey:@"XBMCHostList"];	
}
- (void)updateHost:(XBMCHostData*)hostData {
	NSArray *hostList = [defaults objectForKey:@"XBMCHostList"];
	NSMutableArray *newHostList = [NSMutableArray array]; 
	NSEnumerator *enumerator = [hostList objectEnumerator];
	
	NSArray *host;
	while (host = [enumerator nextObject]) {
		XBMCHostData *currHostData = [[XBMCHostData alloc] initWithArray:host];	
		if ( currHostData.identifier == hostData.identifier) {
			[newHostList addObject:[hostData toArray]];
		} else {
			[newHostList addObject:host];
		}
		[currHostData release];
	}
	
	[defaults setObject: newHostList forKey:@"XBMCHostList"];
}
- (NSArray*)getHosts {
	NSArray *hostList = [defaults objectForKey:@"XBMCHostList"];	
	NSInteger activeIdentifier = [defaults integerForKey:@"XBMCHostActive"];
	NSMutableArray *hostArray = [NSMutableArray array ];
	NSArray *host;
	int count = [hostList count];
	for (int i = 0; i < count; i++) {
		host = [hostList objectAtIndex:i];
		XBMCHostData *hostdata = [[XBMCHostData alloc] initWithArray: host];
		if ( hostdata.identifier == activeIdentifier){
			hostdata.active = YES;
		}
		[hostArray addObject: hostdata];
		[hostdata release];
	}
	return hostArray;
}
- (BOOL)hasActiveHost {
	NSInteger activeIdentifier = [defaults integerForKey:@"XBMCHostActive"];
	if (activeIdentifier) {	
		return YES;
	}	
	return NO;
}
- (XBMCHostData*)getActiveHost {
	NSInteger activeIdentifier = [defaults integerForKey:@"XBMCHostActive"];
	if (!activeIdentifier) {	
		return nil;
	}
	NSArray *hosts = [self getHosts];
	XBMCHostData *host;
	int count = [hosts count];
	while (count--) {
		host = [hosts objectAtIndex:count];
		if ( host.identifier == activeIdentifier ) {
			return host;
		}
	}
	
	return nil;	
}
-(void)dealloc {
	//NSLog(@"XBMCSettings - dealloc");
	[super dealloc];
}
@end