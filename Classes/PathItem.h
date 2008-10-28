//
//  PathItem.h
//  xbmcremote
//
//  Created by David Fumberger on 13/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PATH_TYPE_GENRE    1
#define PATH_TYPE_ARTIST   2
#define PATH_TYPE_ALBUM    3
#define PATH_TYPE_SONG     4
#define PATH_TYPE_TOP100   5


#define PATH_TYPE_TVSHOW   2
#define PATH_TYPE_SEASON   3
#define PATH_TYPE_EPISODE  4
@interface PathItem : NSObject {
	NSInteger type;
	NSString *value;
}
@property (nonatomic, retain) NSString *value;
@property (nonatomic, getter=type) NSInteger type;

@end
