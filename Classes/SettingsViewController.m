//
//  SettingsViewController.m
//  NavTest
//
//  Created by David Fumberger on 10/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsEditViewController.h";
#import "XBMCHostData.h";
#import "NavTestAppDelegate.h";
#import "DisplayCell.h";

#define HOSTS_SECTION       0
#define PERFORMANCE_SECTION 1
#define PLAYBACK_SECTION 2
@implementation SettingsViewController


- (void)viewDidAppear:(BOOL)animated {
    [self setupDisplayList];
	[[self tableView] reloadData];
}

- (NSString*)getActiveHash {
	XBMCHostData *active = [xbmcSettings getActiveHost];
	NSString *data = nil;
	if (active != nil) {	
		data = [active dataHash];
	} else {
		data = @"";
	}
	NSLog(@"Hash %@", data);
	return data;	
}

- (void)actionDone {	
	NSString *currentHash = [self getActiveHash];
	//NSLog(@"actionDone");
	//NSLog(@"Active Hash %@", activeHash);
	//NSLog(@"Current Hash %@", currentHash);	
	if (activeHash == nil || currentHash == nil || ![currentHash isEqualToString:activeHash]) {
		NavTestAppDelegate *appDelegate = (NavTestAppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate reloadAllViews];	
		activeHash = [currentHash retain];
	}
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	//UINavigationController *nav = [modal navigationController];
	//[nav popToRootViewControllerAnimated:YES];
}
- (void)actionEdit {
	
}
- (UIBarButtonItem*)createDoneButton {
	UIBarButtonItem *returnButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone)] autorelease];
	return returnButton;
}
- (UIBarButtonItem*)createEditButton {
	UIBarButtonItem *returnButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit)] autorelease];
	return returnButton;
}

- (UISwitch*)create_UISwitch
{
	CGRect frame = CGRectMake(0.0, 0.0, 94.0, 27.0);
	UISwitch* switchCtl = [[[UISwitch alloc] initWithFrame:frame] autorelease];
	// in case the parent view draws with a custom color or gradient, use a transparent color
	switchCtl.backgroundColor = [UIColor clearColor];
	return switchCtl;
}

- (void)actionShowImagesSwitch:(id)sender {
	UISwitch *s = (UISwitch*)sender;
	[xbmcSettings setShowImages:s.on];
	[xbmcSettings saveSettings];
}
- (void)actionSyncSwitch:(id)sender {
	UISwitch *s = (UISwitch*)sender;
	[xbmcSettings setSync: s.on];
	[xbmcSettings saveSettings];
}

- (void)viewDidLoad {
	NSLog(@"Settings view did load");
	xbmcSettings = [[ XBMCSettings alloc] init];
	activeHash = [[self getActiveHash] retain];
	doneButton = [[self createDoneButton] retain]; 
	[self setupDisplayList];
	[self tableView].allowsSelectionDuringEditing = YES; 
	UINavigationItem *navigationItem = [self navigationItem];
	navigationItem.hidesBackButton = false;
	navigationItem.rightBarButtonItem = self.editButtonItem;;		
	navigationItem.leftBarButtonItem = doneButton; 
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	if (editing) {
		[self navigationItem].leftBarButtonItem = nil;
	} else {
		[self navigationItem].leftBarButtonItem = doneButton;	
	}
	[super setEditing:editing animated:animated];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == HOSTS_SECTION) {
		return tableData.count;
	} else if (section == PERFORMANCE_SECTION) {
		return 1;
	} else if (section == PLAYBACK_SECTION) {
		return 1;
	}
	return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == HOSTS_SECTION) {
		return @"XBMC Hosts";
	} else if (section == PERFORMANCE_SECTION) {
		return @"Performance";
	} else if (section == PLAYBACK_SECTION) {
		return @"Playback";
	}
	return @"";
}

// decide what kind of accesory view (to the far right) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section != HOSTS_SECTION) {
		return UITableViewCellAccessoryNone;
	}
	if (indexPath.row == addIndex) {
		return UITableViewCellAccessoryDisclosureIndicator;
	}
	if (self.editing) {
		return UITableViewCellAccessoryDisclosureIndicator;
	}
	if (tableData != nil) {
		XBMCHostData *hd = [tableData objectAtIndex: indexPath.row];
		if (hd.active) {
			return UITableViewCellAccessoryCheckmark;				
		}
	}
	return UITableViewCellAccessoryNone;

}
- (void)setupDisplayList {
	NSLog(@"Getting hosts");
	tableData     = [[ xbmcSettings getHosts] retain];
	NSLog(@"Got hosts");
	XBMCHostData *hostData = [ XBMCHostData alloc];
	addIndex = [tableData count];
	hostData.title = @"Add Host";
	[tableData addObject: hostData];
	[hostData release];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	[xbmcSettings removeHost: [tableData objectAtIndex: indexPath.row]];
	[self setupDisplayList];
	[[self tableView] reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section)
	{
		case HOSTS_SECTION:
		{
			static NSString *MyIdentifier = @"SettingCell";	
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:MyIdentifier] autorelease];
			}
			XBMCHostData *hostData = [tableData objectAtIndex:indexPath.row];
			cell.text = hostData.title;
			cell.hidesAccessoryWhenEditing = NO;
			cell.editAction = @selector(editSelect);
			return cell;	
			break;
		}
			
		case PERFORMANCE_SECTION:
		{
			UISwitch *switchCtl = [self create_UISwitch];
			static NSString *cellId = @"DisplayCell";	
			DisplayCell *cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellId] autorelease];
			cell.nameLabel.text = @"Cover Images";
			cell.view = switchCtl;
			
			[switchCtl setOn:[xbmcSettings showImages]];
			[switchCtl addTarget:self action:@selector(actionShowImagesSwitch:) forControlEvents:UIControlEventValueChanged];
			[switchCtl release];

			return cell;
			break;
		}
			
		case PLAYBACK_SECTION:
		{
			UISwitch *switchCtl = [self create_UISwitch];
			static NSString *cellId = @"DisplayCell";	
			DisplayCell *cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellId] autorelease];
			cell.nameLabel.text = @"Sync to all hosts";
			cell.view = switchCtl;
			
			[switchCtl setOn:[xbmcSettings sync]];
			[switchCtl addTarget:self action:@selector(actionSyncSwitch:) forControlEvents:UIControlEventValueChanged];
			[switchCtl release];
			
			return cell;
			break;
		}			
	}

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == addIndex) {
		return NO;
	} else {
		return YES;
	}
}


// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	XBMCHostData *hostData = [tableData objectAtIndex:indexPath.row];
	
	if (self.editing || indexPath.row == addIndex) {
		SettingsEditViewController *targetController = [ [SettingsEditViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
		targetController.title =  hostData.title;
		targetController.xbmcSettings = xbmcSettings;
		targetController.hostData = hostData;
		[[self navigationController] pushViewController:targetController animated:YES ];
		[targetController release ];				
	} else {
		// Reset current hash as we always want to refresh when any items are clicked on
		activeHash = nil;
		[xbmcSettings  setActive:hostData];
		[self actionDone];	
	}
}


- (void)dealloc {
	[tableData release];
	[hostList release];
	[xbmcSettings release];
	[activeHash release];
	[doneButton release];	
	[super dealloc];
}
@end
	