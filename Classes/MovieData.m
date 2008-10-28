//
//  MovieData.m
//  xbmcremote
//
//  Created by David Fumberger on 17/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "MovieData.h"


@implementation MovieData
@synthesize tagline;
@synthesize genre;
- (UIImage*)defaultImage {
	return [UIImage imageNamed:@"AIconVideo.png"];	
}
- (NSString*)fullFileName {
	NSString *fullFileName = [ NSString stringWithFormat: @"%@%@", self.path, self.file ];	
	return fullFileName;
}
-(void)dealloc {
	[genre release];	
	[tagline release];
	[super dealloc];
}
@end
