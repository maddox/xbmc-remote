//
//  TVMediaInfoData.h
//  xbmcremote
//
//  Created by David Fumberger on 21/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MEDIA_FIELD_TEXT 1;
#define MEDIA_FIELD_LONG 2;

@interface MediaInfoData : NSObject {	
	NSString *title;
	NSString *value;
	NSString *fieldtype;
}

@property (nonatomic, retain) NSString *fieldtype;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *value;

@end
