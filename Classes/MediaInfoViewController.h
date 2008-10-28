//
//  MediaInfoViewController.h
//  xbmcremote
//
//  Created by David Fumberger on 21/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewController.h";
#import "RemoteInterface.h";
#import "NowPlayingData.h";

#define MEDIA_INFO_TYPE_TV     1
#define MEDIA_INFO_TYPE_MOVIE  2

@interface MediaInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	NSInteger dataType;
	NSString *filename;
	
	LoadingViewController* loadingViewController;
	
	RemoteInterface *XBMCInterface;
	XBMCSettings *xbmcSettings;

	NSArray *displayData;	
	NSArray *sectionTitles;
	NSArray *sectionFieldCounts;
}
@property (nonatomic)        NSInteger dataType;
@property (nonatomic, copy)   NSString *filename;
//@property (nonatomic, retain) NSArray *displayData;


@end
