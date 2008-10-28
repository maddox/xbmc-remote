//
//  SettingsViewController.h
//  NavTest
//
//  Created by David Fumberger on 10/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBMCSettings.h";

@interface SettingsViewController : UITableViewController {
	NSMutableArray *tableData;
	NSArray *hostList;
	XBMCSettings *xbmcSettings;
	NSInteger addIndex;
	NSString  *activeHash;
	UIBarButtonItem *doneButton;
}
-(void)setupDisplayList;
@end
