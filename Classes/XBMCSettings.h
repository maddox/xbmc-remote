//
//  XBMCSettings.h
//  NavTest
//
//  Created by David Fumberger on 5/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBMCHostData.h";

@interface XBMCSettings : NSObject {
	NSUserDefaults *defaults;
	BOOL showImages;
	NSInteger remoteType;
	BOOL sync;
}
@property (nonatomic, assign) BOOL showImages;
@property (nonatomic, assign) BOOL sync;
@property (nonatomic, assign) NSInteger remoteType;
- (void)saveSettings;
- (void)addHost:(XBMCHostData*)hostData;
- (void)updateHost:(XBMCHostData*)hostData;
- (void)removeHost:(XBMCHostData*)hostData;
- (NSArray*)getHosts;
- (void)setActive:(XBMCHostData*)hostData ;
- (XBMCHostData*)getActiveHost;
- (NSInteger)getActiveId;
- (void)resetAllSettings;
- (BOOL)hasActiveHost;
@end
