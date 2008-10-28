//
//  AlbumData.m
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "AlbumData.h"
#import "Cache.h";
@implementation AlbumData
@synthesize artistId;
@synthesize artistTitle;
+ (void)initialize {
	NSLog(@"Init albumdata");
}
/*
- init {
	if ( self.thumbnail == @"" || [ self.thumbnail isEqualToString:@"NONE"] ) {
		self.checkedImage = YES;
	} else {
		self.checkedImage = NO;
	}	
	return [super init];
}*/
- initWithDictionary:(NSDictionary *)dict  {

	if (self = [super initWithDictionary:dict]) {
		self.maxThumbResolution = 50;
		self.externalImage = NO;
		self.title       = [dict objectForKey:@"title"];
		self.identifier  = [dict objectForKey:@"id"];
		
		//self.thumbnail_path   = [dict objectForKey:@"thumbnail"];
		self.artistId    = [dict objectForKey:@"artistId"];
		self.artistTitle = [dict objectForKey:@"artistTitle"];
	}
	return self;
}
- (void)setThumbnailData { }
- (BOOL)fetchThumbnail {
	//[self setThumbnailFromPath];
	return [super fetchThumbnail];
}
- (void)setThumbnailFromPath {
	return [self setThumbnailFromPathForType: @"Music"];
}
- (UIImage*)defaultImage {
	return [UIImage imageNamed:@"AIconMusic.png"];	
}
- (NSInteger)cacheType {
	return CACHE_TYPE_MUSIC;
}
-(void)dealloc {
	//NSLog(@"Album Data - dealloc");
	[artistId release];
	[artistTitle release];
	[super dealloc];
}
@end
