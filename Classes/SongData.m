//
//  SongData.m
//  NavTest
//
//  Created by David Fumberger on 8/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "SongData.h"


@implementation SongData

@synthesize track;
@synthesize duration;
@synthesize albumId;
@synthesize artistTitle;
@synthesize albumTitle;

- initWithDictionary:(NSDictionary *)dict  {
	if (self = [super init]) {
		self.title       = [dict objectForKey:@"title"];
		self.identifier  = [dict objectForKey:@"id"];
		self.path        = [dict objectForKey:@"path"];
		self.albumId	 = [dict objectForKey:@"albumId"];		
		self.albumTitle	 = [dict objectForKey:@"albumTitle"];		
		self.artistTitle = [dict objectForKey:@"artistTitle"];
 	}
	return self;
}

- (void)dealloc {
	[track    release];
	[duration release];
	[albumId  release];
	[albumTitle release];
	[artistTitle release];
	[super dealloc];
}
@end
