//
//  Cache.m
//  xbmcremote
//
//  Created by David Fumberger on 31/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "Cache.h"
static Cache *sharedCache;

@implementation Cache

+ (Cache*)defaultCache {
	if (sharedCache == nil) {
		sharedCache = [Cache new];
		
	}
	return sharedCache;
}
- init {
	fm = [NSFileManager defaultManager];
	return [super init];
}
- (void)createDir:(NSString*)dir {
	BOOL isDir;
	//if ([fm fileExistsAtPath:dir isDirectory:&isDir] && isDir) {	
		NSLog(@"Cache: Creating dir [%@]", dir);
		[fm createDirectoryAtPath:dir attributes:nil];	
	//} else {
	//	NSLog(@"Cache: Directory [%@] already exists", dir);
	//}
}

- (BOOL)hasFile:(NSString*)filename type:(NSInteger)type {
	NSString *path = ((type == CACHE_TYPE_VIDEO) ? (videoCachePath) : (musicCachePath));	
	NSString *fullpath = [NSString stringWithFormat:@"%@/%@", path, filename];
	BOOL isDir;
	if ([fm fileExistsAtPath:fullpath isDirectory:&isDir]) {		
		return true;
	} else {
		return false;
	}
}
- (NSData*)getFile:(NSString*)filename type:(NSInteger)type {
	NSString *path = ((type == CACHE_TYPE_VIDEO) ? (videoCachePath) : (musicCachePath));	
	NSString *fullpath = [NSString stringWithFormat:@"%@/%@", path, filename];
	return [fm contentsAtPath:fullpath];
}
- (void)storeFile:(NSString*)filename data:(NSData*)data type:(NSInteger)type {
	NSString *thepath = ((type == CACHE_TYPE_VIDEO) ? (videoCachePath) : (musicCachePath));
	NSString *fullpath = [NSString stringWithFormat:@"%@/%@", thepath, filename];
	NSLog(@"Cache: Store file [%@]", fullpath);
	[fm createFileAtPath:fullpath contents:data attributes:nil];
}
- (void)setupDirectories {
	NSLog(@"Cache: Setting up directories"); 
	NSArray *items = NSSearchPathForDirectoriesInDomains(  NSCachesDirectory, NSAllDomainsMask,TRUE);
	NSString *rootDir = [items objectAtIndex:0];
	NSLog(@"Cache: Root Cache Dir [%@]", rootDir);
	
	[self createDir:rootDir];
	videoCachePath = [[NSString stringWithFormat:@"%@/%@", rootDir, @"Video"] copy];
	[self createDir:videoCachePath];
	musicCachePath = [[NSString stringWithFormat:@"%@/%@", rootDir, @"Music"] copy];
	[self createDir:musicCachePath];	
}	


@end
