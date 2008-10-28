//
//  AlbumData.h
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBMCSettings.h";
#import "ViewData.h";
@interface AlbumData : ViewData {
	NSString *artistId;
	NSString *artistTitle;
}
- initWithDictionary:(NSDictionary *)dict ;
- (void)fetchThumbnail ;
@property (nonatomic, retain) NSString *artistId;
@property (nonatomic, retain) NSString *artistTitle;
@end
