//
//  MusicPath.m
//  xbmcremote
//
//  Created by David Fumberger on 13/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "VideoPath.h"
#import "PathItem.h";

@implementation VideoPath
@synthesize items;
- (void)addItem:(PathItem*)item {
	[items addObject:item];
}	
+ (VideoPath*)pathFromPath:(VideoPath*)path {
	VideoPath *newVideoPath = [VideoPath alloc];
	newVideoPath.items = [NSMutableArray arrayWithArray:path.items];
	return newVideoPath;
}


- (NSString*)WhereClauseForSeason {
	NSMutableString *whereClause = [NSMutableString stringWithString:@" 1 = 1 "];
	for ( PathItem* item in items) {
		NSInteger itemType = item.type;
		NSString *itemValue = item.value;
		if ( itemValue == nil) { continue; }
		if (itemType == PATH_TYPE_TVSHOW) {
			[whereClause appendString:
			 [NSString stringWithFormat:@" and idEpisode in (select idEpisode from tvshowlinkepisode where idShow = %@) ", itemValue]
			 ];
		} 
	}
	NSLog(@"WhereClauseForSeason [%@]", whereClause);
	return whereClause;
}
- (NSString*)WhereClauseForEpisode {
	NSMutableString *whereClause = [NSMutableString stringWithString:@" 1 = 1 "];
	for ( PathItem*item in items) {
		NSInteger itemType = item.type;
		NSString *itemValue = item.value;
		if ( itemValue == nil) { continue; }
		if (itemType == PATH_TYPE_TVSHOW) {
			[whereClause appendString:
			 [NSString stringWithFormat:@" and tvshow.idShow = %@ ", itemValue]
			 ];
		}else if (itemType == PATH_TYPE_SEASON) {
			[whereClause appendString:
			 [NSString stringWithFormat:@" and episode.c12 = %@ ", itemValue]
			 ];
		} 
	}
	NSLog(@"WhereClauseForEpisode [%@]", whereClause);
	return whereClause;
}
-(NSString*)GetPath {
	NSMutableString *path = [NSMutableString stringWithString:@"videodb://2/"];
	NSEnumerator *enumerator = [items objectEnumerator];
	PathItem *item;
	NSString *lastNullPath = nil;
	int count = 0;
	while (item = [enumerator nextObject]) {
		NSInteger itemType = item.type;
		NSString *itemValue = item.value;
		if (count == 0) {
			[path appendString: [NSString stringWithFormat:@"%d/", itemType ]];		
		}
		if ( itemValue == nil) { 
			if (!lastNullPath) {
				lastNullPath = [NSString stringWithString: path];
			}
			itemValue = @"-1"; 
		} else { 
			lastNullPath = nil;
		}
		[path appendString: [NSString stringWithFormat:@"%@/", itemValue]];
		
		count++;
	}
	if (lastNullPath) {
		return lastNullPath;
	} else {
		return path;
	}
}

-(void)dealloc {
	NSLog(@"VideoPath - dealloc");	
	[items release];
	[super dealloc];
}
@end
