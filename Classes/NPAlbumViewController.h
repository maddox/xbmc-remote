//
//  NPAlbumViewController.h
//  NavTest
//
//  Created by David Fumberger on 8/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NowPlayingData.h";
#import "RemoteInterface.h";
@interface NPAlbumViewController : UITableViewController {
	RemoteInterface *XBMCInterface;
	NowPlayingData *nowPlayingData;
	NSArray *tableData;
}
- (void)loadData;
@property (nonatomic, retain) NowPlayingData *nowPlayingData;
@property (nonatomic, retain) NSArray *tableData;
@end
