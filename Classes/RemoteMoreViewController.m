//
//  RemoteMoreViewController.m
//  xbmcremote
//
//  Created by David Fumberger on 30/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "RemoteMoreViewController.h"
#import "Key.h";
#import "InterfaceManager.h";
static NSString *kCellIdentifier = @"RemoteMoreCell";

@implementation RemoteMoreViewController

- (void)awakeFromNib
{	
	XBMCInterface = [InterfaceManager getSharedInterface];
	
	NSMutableArray *machineCommands   = [[NSMutableArray alloc] init];
	NSMutableArray *playCommands      = [[NSMutableArray alloc] init];
	NSMutableArray *displayCommands   = [[NSMutableArray alloc] init];
	NSMutableArray *transportCommands = [[NSMutableArray alloc] init];
	NSMutableArray *pictureCommands   = [[NSMutableArray alloc] init];
	NSMutableArray *databaseCommands   = [[NSMutableArray alloc] init];
	sectionList = [[NSMutableArray alloc] init];
	[sectionList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						NSLocalizedString(@"Play", @""), @"title",
						playCommands, @"items",
						nil]];
	[sectionList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							NSLocalizedString(@"Transport", @""), @"title",
							transportCommands, @"items",
							nil]];	
	[sectionList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							NSLocalizedString(@"Video", @""), @"title",
							displayCommands, @"items",
							nil]];	
	[sectionList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							NSLocalizedString(@"Picture", @""), @"title",
							pictureCommands, @"items",
							nil]];		
	[sectionList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							NSLocalizedString(@"Machine", @""), @"title",
							machineCommands, @"items",
							nil]];
	[sectionList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							NSLocalizedString(@"Library", @""), @"title",
							databaseCommands, @"items",
							nil]];
	[pictureCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							 NSLocalizedString(@"Zoom In", @""), @"title",
							 [NSString stringWithFormat: @"%d", ACTION_ZOOM_IN], @"key",
							 nil]];	
	[pictureCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								NSLocalizedString(@"Zoom Out", @""), @"title",
								[NSString stringWithFormat: @"%d", ACTION_ZOOM_OUT], @"key",
								nil]];	
	[pictureCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								NSLocalizedString(@"Rotate", @""), @"title",
								[NSString stringWithFormat: @"%d", ACTION_ROTATE_PICTURE], @"key",
								nil]];	
	
	
	[playCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Play DVD", @""), @"title",
						 @"PlayDVD", @"command",
						 nil]];	
	
	[playCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Party Mode Video", @""), @"title",
						 @"PartyModeVideo", @"command",
						 nil]];	
	[playCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Party Mode Music", @""), @"title",
						 @"PartyModeMusic", @"command",
						 nil]];		

	/*
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Seek 25%", @""), @"title",
						 @"Seek25", @"command",
						 nil]];	
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Seek 50%", @""), @"title",
						 @"Seek50", @"command",
						 nil]];		
	[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Seek 75%", @""), @"title",
						 @"Seek75", @"command",
						 nil]];			*/
	[machineCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								NSLocalizedString(@"Eject Tray", @""), @"title",
								@"EjectTray", @"command",
								nil]];		
	[machineCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Restart XBMC", @""), @"title",
						 @"RestartXBMC", @"command",
						 nil]];		
	[machineCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Restart Machine", @""), @"title",
						 @"RestartMachine", @"command",
						 nil]];		
	[machineCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Shutdown Machine", @""), @"title",
						 @"Shutdown", @"command",
						 nil]];		
	[displayCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Show Subtitles", @""), @"title",
						 [NSString stringWithFormat: @"%d", ACTION_SHOW_SUBTITLES], @"key",
						 nil]];			
	[displayCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Change Aspect", @""), @"title",
						 [NSString stringWithFormat: @"%d", ACTION_ASPECT_RATIO], @"key",
						 nil]];		
	[displayCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 NSLocalizedString(@"Change Resolution", @""), @"title",
						 [NSString stringWithFormat: @"%d", ACTION_CHANGE_RESOLUTION], @"key",
						 nil]];	
	[displayCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								NSLocalizedString(@"Change Theme",@""), @"title",
								@"Change Theme", @"command",
								nil]];		
	

	[transportCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								  NSLocalizedString(@"Rewind", @""), @"title",
								  [NSString stringWithFormat: @"%d", ACTION_PLAYER_REWIND], @"key",
								  nil]];	
	[transportCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								  NSLocalizedString(@"Normal Play Speed", @""), @"title",
								  @"PlaySpeedOne", @"command",
								  nil]];	
	
	[transportCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								  NSLocalizedString(@"Forward", @""), @"title",
								  [NSString stringWithFormat: @"%d", ACTION_PLAYER_FORWARD], @"key",
								  nil]];
	[transportCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								  NSLocalizedString(@"Step Back", @""), @"title",
								  [NSString stringWithFormat: @"%d", ACTION_STEP_BACK], @"key",
								  nil]];
	[transportCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								NSLocalizedString(@"Step Forward", @""), @"title",
								[NSString stringWithFormat: @"%d", ACTION_STEP_FORWARD], @"key",
								nil]];	
	[transportCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								  NSLocalizedString(@"Big Step Back", @""), @"title",
								  [NSString stringWithFormat: @"%d", ACTION_STEP_BACK], @"key",
								  nil]];		
	[transportCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								  NSLocalizedString(@"Big Step Forward", @""), @"title",
								  [NSString stringWithFormat: @"%d", ACTION_STEP_FORWARD], @"key",
								  nil]];
	
	[databaseCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								  NSLocalizedString(@"Update Video Library", @""), @"title",
								  @"UpdateVideoLibrary", @"command",
								  nil]];	
	[databaseCommands addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								 NSLocalizedString(@"Update Music Library", @""), @"title",
								 @"UpdateMusicLibrary", @"command",
								 nil]];	

	[playCommands release];
	[machineCommands release];
	[displayCommands release];
	[pictureCommands release];
	[transportCommands release];
	[databaseCommands release];
}	
- (void)viewDidLoad {

}

// tell our table how many sections or groups it will have (always 1 in our case)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [sectionList count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[sectionList objectAtIndex: section] objectForKey:@"title"];
}
// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *items =  [[sectionList objectAtIndex: indexPath.section] objectForKey:@"items"];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
	}
	
	cell.text = [[items objectAtIndex:indexPath.row] objectForKey:@"title"];
		
	return cell;
}
- (void) unselectCurrent {
	NSIndexPath *indexPath = [myTableView indexPathForSelectedRow];
	[myTableView deselectRowAtIndexPath: indexPath animated: NO];	
}
- (void)DoCommand:(NSString*)command {
	if ([command isEqualToString:@"PlaySpeedOne"]) {
		[XBMCInterface SetPlaySpeed: 1];
	} else if ([command isEqualToString:@"PlaySpeedTwo"]) {
		[XBMCInterface SetPlaySpeed: 2];		
	} else if ([command isEqualToString:@"PlaySpeedFour"]) {
		[XBMCInterface SetPlaySpeed: 4];		
	} else if ([command isEqualToString:@"Seek25"]) {
		[XBMCInterface SeekPercentage:25];		
	} else if ([command isEqualToString:@"Seek50"]) {
		[XBMCInterface SeekPercentage:50];		
	} else if ([command isEqualToString:@"Seek75"]) {
		[XBMCInterface SeekPercentage:75];		
	} else if ([command isEqualToString:@"RestartXBMC"]) {
		[XBMCInterface RestartApp];		
	} else if ([command isEqualToString:@"RestartMachine"]) {
		[XBMCInterface Restart];		
	} else if ([command isEqualToString:@"Rotate"]) {
		[XBMCInterface Rotate];		
	} else if ([command isEqualToString:@"PartyModeVideo"]) {
		[XBMCInterface PartyModeVideo];		
	} else if ([command isEqualToString:@"PartyModeMusic"]) {
		[XBMCInterface PartyModeMusic];		
	} else if ([command isEqualToString:@"PlayDVD"]) {
		[XBMCInterface PlayDVD];			
	} else if ([command isEqualToString:@"EjectTray"]) {
		[XBMCInterface EjectTray];		
	} else if ([command isEqualToString:@"UpdateVideoLibrary"]) {
		[XBMCInterface UpdateVideoLibrary];		
	} else if ([command isEqualToString:@"UpdateMusicLibrary"]) {
		[XBMCInterface UpdateMusicLibrary];		
	} else if ([command isEqualToString:@"ChangeTheme"]) {
		[XBMCInterface CycleTheme];		
	}
	
	
}
// the table's selection has changed, switch to that item's UIViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *items =  [[sectionList objectAtIndex: indexPath.section] objectForKey:@"items"];
	//UIViewController *targetViewController = [[menuList objectAtIndex: indexPath.row] objectForKey:@"viewController"];
	//[[self navigationController] pushViewController:targetViewController animated:YES];
	NSDictionary *item = [items objectAtIndex: indexPath.row];
	NSString *command =  [item objectForKey:@"command"];
	NSString *action  =  [item objectForKey:@"key"];
	if (command) {
		[self DoCommand: command];
	} else if (action) {
		[XBMCInterface Action:[action integerValue]];
	}
	[self unselectCurrent];
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *items =  [[sectionList objectAtIndex: section] objectForKey:@"items"];
	return [items count];
}

- (void)dealloc
{
	[sectionList release];
	[myTableView release];
	[super dealloc];
}

@end
