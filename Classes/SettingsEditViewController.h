//
//  SettingsEditView.h
//  NavTest
//
//  Created by David Fumberger on 11/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellTextField.h"
#import "XBMCHostData.h";
#import "XBMCSettings.h";
#import "EditableTableViewCell.h";
@interface SettingsEditViewController : UITableViewController <EditableTableViewCellDelegate>
{
	UITextField *titleTextField;
	UITextField *portTextField;
	UITextField *hostTextField;	
	UITextField *passwordTextField;
	UITextField *pathTextField;
	EditableTableViewCell *pathCell;
	XBMCHostData *hostData;
	XBMCSettings *xbmcSettings;
	//IBOutlet UINavigationController *navigationController;
}
@property (nonatomic, retain) XBMCHostData *hostData;
@property (nonatomic, retain) XBMCSettings *xbmcSettings;
@end
