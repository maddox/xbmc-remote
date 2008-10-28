//
//  SongData.h
//  NavTest
//
//  Created by David Fumberger on 8/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewData.h";

@interface VideoData : ViewData {
	NSString *episode;
	NSString *duration;
	NSString *showName;
	NSString *seasonName;
}
- initWithDictionary:(NSDictionary *)dict ;
- (BOOL)setThumbnailFromPath;
@property (nonatomic, retain) NSString *episode;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSString *showName;
@property (nonatomic, retain) NSString *seasonName;
@end
