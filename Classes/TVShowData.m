//
//  TVShowData.m
//  xbmcremote
//
//  Created by David Fumberger on 16/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "TVShowData.h"

@implementation TVShowData
- initWithDictionary:(NSDictionary *)dict  {
	[super initWithDictionary:dict];
	if ([self.title length] == 0) {
		NSArray *items = [self.path componentsSeparatedByString:@"/"];
		if ([items count] > 1) {
			self.title = [items objectAtIndex: [items count] - 2];
		}
	}
	return self;
}
- (UIImage*)defaultImage {
	return [UIImage imageNamed:@"AIconVideo.png"];	
}
@end
