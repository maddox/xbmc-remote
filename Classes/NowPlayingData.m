//
//  NowPlayingData.m
//  NavTest
//
//  Created by David Fumberger on 6/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "NowPlayingData.h"
#import "ArtistData.h";
#import "InterfaceManager.h";
#import "RemoteInterface.h";
@implementation NowPlayingData
@synthesize type;

@synthesize showTitle;
@synthesize plot;
@synthesize rating;
@synthesize director;
@synthesize writer;
@synthesize season;
@synthesize episode;

@synthesize genre;

@synthesize title;
@synthesize artistTitle;
@synthesize albumTitle;
@synthesize playing;
@synthesize time;
@synthesize duration;
@synthesize track;
@synthesize thumb;
@synthesize percentagePlayed;
@synthesize playStatus;
@synthesize filename;
@synthesize url;
@synthesize image;
@synthesize trackchanged;
@synthesize paused;
- (NSString*)fileComponent {
	if (self.filename) {
		return [self.filename lastPathComponent]; 
	} else {
		return @"Unknown";
	}
}
- (NSString*)mediaTitle {
	if (self.title) {
		return self.title;
	}
	return [self fileComponent];
}

- (void)fetchThumbnail {
	//self.checkedImage = YES;
	RemoteInterface *xbmc = [InterfaceManager getSharedInterface];		
	UIImage *newImage = [xbmc GetThumbnail:self.thumb];	
	if (newImage != nil) {
		self.image = newImage;
	}
}

- (void)dealloc {	
	NSLog(@"NowPlayingData - dealloc");
	[title     release];
	[plot      release];
	[showTitle release];
	[rating    release];
	[director  release];
	[writer    release];
	[season    release];
	[episode   release];
	[artistTitle release];
	[albumTitle  release];
	[genre release];
	[thumb release];
	[time release];
	[duration release];
	[playStatus release];
	[filename release];
	[image release];
	
	[super dealloc];
}
@end
