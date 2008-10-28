//
//  MusicPath.h
//  xbmcremote
//
//  Created by David Fumberger on 13/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathItem.h";

@interface VideoPath : NSObject {
	NSMutableArray *items;
}
@property (nonatomic, retain) NSMutableArray *items;
+ (VideoPath*)pathFromPath:(VideoPath*)path;
- (void)addItem:(PathItem*)item;
- (NSString*)WhereClauseForShow;
- (NSString*)WhereClauseForEpisode;
- (NSString*)WhereClauseForSeason;
- (NSString*)GetPath; 
@end
