//
//  Cache.h
//  xbmcremote
//
//  Created by David Fumberger on 31/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CACHE_TYPE_MUSIC 0
#define CACHE_TYPE_VIDEO 1

@interface Cache : NSObject {
	NSFileManager *fm;
	NSString *musicCachePath;
	NSString *videoCachePath;
}
+ (Cache*)defaultCache;
- (void)storeFile:(NSString*)filename data:(NSData*)data type:(NSInteger)type;
- (BOOL)hasFile:(NSString*)filename type:(NSInteger)type;
- (NSData*)getFile:(NSString*)filename type:(NSInteger)type;
@end
