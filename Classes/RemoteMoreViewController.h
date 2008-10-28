//
//  RemoteMoreViewController.h
//  xbmcremote
//
//  Created by David Fumberger on 30/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteInterface.h";
@interface RemoteMoreViewController :UIViewController <UITableViewDelegate, UITableViewDataSource> { 
	NSMutableArray			*sectionList;
	IBOutlet UITableView	*myTableView;
	RemoteInterface *XBMCInterface;
}

@end
