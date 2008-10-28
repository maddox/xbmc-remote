//
//  SongData.h
//  NavTest
//
//  Created by David Fumberger on 8/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewData.h";

@interface SongData : ViewData {
	NSString *track;
	NSString *duration;
	NSString *albumId;
	NSString *albumTitle;	
	NSString *artistTitle;	
}
- initWithDictionary:(NSDictionary *)dict ;
@property (nonatomic, copy) NSString *track;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *albumId;
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, copy) NSString *artistTitle;
@end
