//
//  FileSystemData.m
//  xbmcremote
//
//  Created by David Fumberger on 20/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "FileSystemData.h"
#import "Crc32.h";
#import "Cache.h";

@implementation FileSystemData
@synthesize filetype;
@synthesize isRar;
- (void)setThumbnailData {
	if (thumbnail_file == nil) {
		if (filetype == FILE_VIDEO) {
			[super setThumbnailFromPathForType:@"Video"];
		} else {
			[super setThumbnailFromPathForType:@"Music"];
		}
	}
}

- (NSInteger)cacheType {
	if (filetype == FILE_VIDEO) {
		return CACHE_TYPE_VIDEO;
	} else {
		return CACHE_TYPE_MUSIC;
	}
}
- (UIImage*)defaultImage {
	if (self.file) {
		return [UIImage imageNamed:@"AIconFile.png"];	
	} else {
		return [UIImage imageNamed:@"AIconFolder.png"];
	}
}
- (BOOL)fetchThumbnail {
	[self setThumbnailFromPath];
	return [super fetchThumbnail];
}
@end
