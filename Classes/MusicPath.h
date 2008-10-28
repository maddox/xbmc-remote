//
//  MusicPath.h
//  xbmcremote
//
//  Created by David Fumberger on 13/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PathItem.h";

@interface MusicPath : NSObject {
	NSMutableArray *items;
}
@property (nonatomic, retain) NSMutableArray *items;
+ (MusicPath*)pathFromPath:(MusicPath*)path;
- (void)addItem:(PathItem*)item;
- (NSString*)WhereClauseForArtist;
- (NSString*)WhereClauseForAlbum;
- (NSString*)WhereClauseForSong;
- (NSString*)GetPath; 
@end
