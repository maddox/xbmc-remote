//
//  SongData.m
//  NavTest
//
//  Created by David Fumberger on 8/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "VideoData.h"
#import "Crc32.h";

@implementation VideoData
@synthesize episode;
@synthesize duration;
@synthesize seasonName;
@synthesize showName;
- initWithDictionary:(NSDictionary *)dict  {
	self.title       = [dict objectForKey:@"title"];
	self.identifier  = [dict objectForKey:@"id"];
	self.path        = [dict objectForKey:@"path"];
	self.file        = [dict objectForKey:@"file"];	
		
	self.episode        = [dict objectForKey:@"episode"];			
	self.seasonName  = [dict objectForKey:@"seasonName"];
	self.showName    = [dict objectForKey:@"showName"];			
	self.checkedImage = NO;
	
	return [self init];
}

/*- (void)setThumbnailFromFullFile {
	//NSLog(@"Set Thumbnail From Full Path ---- %@", [self fullFileName] );
	Crc32 *crc32 = [[Crc32 alloc] init];
	int crc = [crc32 ComputeStringLower:[ self fullFileName] ];
	//NSLog(@"Computed CRC");
	NSString *thumb = [NSString stringWithFormat:@"%08x", crc];
	NSString *thumbpath = @"userdata/Thumbnails/Video";
	char fc = [thumb characterAtIndex:0];
	NSString *full = [NSString stringWithFormat:@"%@/%c/%@.tbn", thumbpath, fc, thumb]; 
	self.thumbnail = full;
	//NSLog(@"thumb from path : %@", full);		
}*/
- (void)setThumbnailData {
	if (thumbnail_file == nil) {
		[self setThumbnailFromFullFileForType: @"Video"];
	}
}
- (UIImage*)defaultImage {
	return [UIImage imageNamed:@"AIconVideoWide.png"];	
}
- (void)dealloc {
	[seasonName release];
	[showName release];
	[episode    release];
	[duration release];
	[super dealloc];
}
@end
