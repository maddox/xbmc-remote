//
//  MusicPath.m
//  xbmcremote
//
//  Created by David Fumberger on 13/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "MusicPath.h"
#import "PathItem.h";

@implementation MusicPath
@synthesize items;

- (void)addItem:(PathItem*)pathItem {
	if ([self.items count] == 0) {
		self.items = [NSMutableArray arrayWithObjects:pathItem, nil];
	} else {
		[self.items addObject:pathItem];
	}
}	


+ (MusicPath*)pathFromPath:(MusicPath*)path {
	MusicPath *newMusicPath = [[MusicPath alloc] init];
	newMusicPath.items = [NSMutableArray arrayWithArray:path.items];
	return newMusicPath;
}
- (NSString*)WhereClauseForArtist {
	NSMutableString *whereClause = [NSMutableString stringWithString:@"1 = 1"];
	NSEnumerator *enumerator = [self.items objectEnumerator];
	PathItem *item;

	while (item = [enumerator nextObject]) {
		NSInteger itemType = item.type;
		NSString *itemValue = item.value;
		if (itemValue == nil) { NSLog(@"Nil value"); continue; }
		if (itemType == PATH_TYPE_GENRE) {
				[whereClause appendString:
					[NSString stringWithFormat:@" and (artist.idArtist IN (select song.idArtist from song where song.idGenre=%@) or artist.idArtist IN (select song.idArtist from song join exgenresong on song.idSong=exgenresong.idSong where exgenresong.idGenre=%@)) ", 
					 itemValue, itemValue]
				];
		} 
	}
	//NSLog(@"WhereClauseForArtist [%@]", whereClause);	
	return whereClause;
}

- (NSString*)WhereClauseForAlbum {

	NSMutableString *whereClause = [NSMutableString stringWithString:@"1 = 1"];
	NSLog(@"WhereClauseForAlbum items [%d]", [items count]);
	NSEnumerator *enumerator = [items objectEnumerator];
	PathItem *item;
		
	while (item = [enumerator nextObject]) {
		NSInteger itemType = item.type;
		NSString *itemValue = item.value;
		if ( itemValue == nil) { continue; }
		if (itemType == PATH_TYPE_ARTIST) {
			[whereClause appendString:
			 [NSString stringWithFormat:@" and idArtist = %@ ", itemValue]
			];
		} else if (itemType == PATH_TYPE_GENRE) {
			[whereClause appendString:
			 [NSString stringWithFormat:@" and idGenre = %@ ", itemValue]
			];
		}
	}
	//NSLog(@"WhereClauseForAlbum [%@]", whereClause);
	return whereClause;
}
- (NSString*)WhereClauseForSong {
	
	NSMutableString *whereClause = [NSMutableString stringWithString:@"1 = 1"];
	NSLog(@"WhereClauseForSong items [%d]", [items count]);
	NSEnumerator *enumerator = [items objectEnumerator];
	PathItem *item;
	
	while (item = [enumerator nextObject]) {
		NSInteger itemType = item.type;
		NSString *itemValue = item.value;
		if ( itemValue == nil) { continue; }
		if (itemType == PATH_TYPE_ARTIST) {
			[whereClause appendString:
			 [NSString stringWithFormat:@" and idArtist = %@ ", itemValue]
			 ];
		}else if (itemType == PATH_TYPE_ALBUM) {
			[whereClause appendString:
			 [NSString stringWithFormat:@" and idAlbum = %@ ", itemValue]
			 ];
		} else if (itemType == PATH_TYPE_GENRE) {
			[whereClause appendString:
			 [NSString stringWithFormat:@" and idGenre = %@ ", itemValue]
			 ];
		}
	}
	//NSLog(@"WhereClauseForSong [%@]", whereClause);
	return whereClause;
}
-(NSString*)GetPath {
	NSMutableString *path = [NSMutableString stringWithString:@"musicdb://"];
	NSEnumerator *enumerator = [items objectEnumerator];
	PathItem *item;
	int count = 0;
	while (item = [enumerator nextObject]) {
		NSInteger itemType = item.type;
		NSString *itemValue = item.value;
		if (count == 0) {
			[path appendString: [NSString stringWithFormat:@"%d/", itemType ]];		
		}
		if ( itemValue == nil) { itemValue = @"-1"; }
		[path appendString: [NSString stringWithFormat:@"%@/", itemValue]];
		count++;
	}
    return path;
}
-(void)dealloc {
	NSLog(@"MusicPath - dealloc");
	[items release];
	[super dealloc];
}
@end
