//
//  GUIStatus.h
//  xbmcremote
//
//  Created by David Fumberger on 5/09/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GUIStatus : NSObject {
	NSString *activeWindowName;
	NSString *videoPath;	
	NSString *musicPath;		
}
@property (nonatomic, retain) NSString *activeWindowName;
@property (nonatomic, retain) NSString *videoPath;
@property (nonatomic, retain) NSString *musicPath;
@end
