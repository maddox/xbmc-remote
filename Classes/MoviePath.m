//
//  MoviePath.m
//  xbmcremote
//
//  Created by David Fumberger on 17/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "MoviePath.h"
#import "PathItem.h";

@implementation MoviePath
@synthesize items;
- (void)addItem:(PathItem*)pathItem {
	if ([self.items count] == 0) {
		self.items = [NSMutableArray arrayWithObjects:pathItem, nil];
	} else {
		[self.items addObject:pathItem];
	}
}	
+ (MoviePath*)pathFromPath:(MoviePath*)path {
	MoviePath *newVideoPath = [MoviePath alloc];
	newVideoPath.items = [NSMutableArray arrayWithArray:path.items];
	return newVideoPath;
}

- (NSString*)WhereClauseForMovie {
	NSMutableString *whereClause = [NSMutableString stringWithString:@" 1 = 1 "];
	for ( PathItem*item in self.items) {
		NSInteger itemType = item.type;
		NSString *itemValue = item.value;
		if ( itemValue == nil) { continue; }
		/*if (itemType == PATH_TYPE_TVSHOW) {
			[whereClause appendString:
			 [NSString stringWithFormat:@" and idEpisode in (select idEpisode from tvshowlinkepisode where idShow = %@) ", itemValue]
			 ];
		}else if (itemType == PATH_TYPE_SEASON) {
			[whereClause appendString:
			 [NSString stringWithFormat:@" and c12 = %@ ", itemValue]
			 ];
		} */
	}
	NSLog(@"WhereClauseForMovie [%@]", whereClause);
	return whereClause;
}

-(void)dealloc {
	[items release];
	[super dealloc];
}
@end
