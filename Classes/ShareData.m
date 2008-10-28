//
//  SourceData.m
//  xbmcremote
//
//  Created by David Fumberger on 25/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "ShareData.h"


@implementation ShareData
- (UIImage*)defaultImage {
	return [UIImage imageNamed:@"AIconFolder.png"];	
}
- (BOOL)fetchThumbnail {
	//[self setThumbnailFromPath];
	//return [super fetchThumbnail];
	checkedImage = YES;
	return NO;
}
@end
