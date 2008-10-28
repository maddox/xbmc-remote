//
//  SettingsEditView.m
//  NavTest
//
//  Created by David Fumberger on 11/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "SettingsEditViewController.h"
#import "CellTextField.h";
#import "EditableTableViewCell.h";
#import "DisplayCell.h";

#define kTextFieldWidth							80.0
#define kTextFieldHeight						15.0

#define kTitleTextRow	    0
#define kPortTextRow        1
#define kHostTextRow        2
#define kPasswordTextRow    3
#define kPathTextRow        4
#define kInfoTextRow        5
#define kOFFSET_FOR_KEYBOARD					150.0
@implementation SettingsEditViewController
@synthesize hostData;
@synthesize xbmcSettings;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UILabel*)createTextFieldLabel:(NSString*)text {
	CGRect frame = CGRectMake(0.0, 0.0,90, kTextFieldHeight);
	UILabel *returnLabel = [[UILabel alloc] initWithFrame:frame];
	returnLabel.font = [UIFont boldSystemFontOfSize:17.0];
 	returnLabel.text = text;
	return returnLabel;
}

- (UITextField *)createTextField:(BOOL)secure
{
	CGRect frame = CGRectMake(0.0, 0.0, kTextFieldWidth, kTextFieldHeight);
	UITextField *returnTextField = [[UITextField alloc] initWithFrame:frame];
    
	//returnTextField.borderStyle = UITextBorderStyleRoundedRect;
	returnTextField.borderStyle = UITextBorderStyleNone;
    returnTextField.textColor = [UIColor blackColor];
	returnTextField.font = [UIFont systemFontOfSize:17.0];
    returnTextField.placeholder = @"";
    returnTextField.backgroundColor = [UIColor whiteColor];
	returnTextField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	
	returnTextField.keyboardType = UIKeyboardTypeDefault;
	returnTextField.returnKeyType = UIReturnKeyDone;
	if (secure) {
		 returnTextField.secureTextEntry = YES;
	}
	returnTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	
	return returnTextField;
}

- (void)SaveData {
    NSLog(@"Saving");
	[hostData setTitle: titleTextField.text];
	[hostData setPort_number: portTextField.text];
	[hostData setHostname: hostTextField.text];
	if (passwordTextField.text) {
		[hostData setPassword: passwordTextField.text];
	} else {
		[hostData setPassword: @""];	
	}
	
	if (pathTextField.text) {
		[hostData setPath: pathTextField.text];
	} else {
		[hostData setPath: @""];		
	}
		
	if (hostData.identifier) {
		[xbmcSettings updateHost:hostData];
	} else {
		[xbmcSettings addHost:hostData];
	}
	NSLog(@"Finished saving");
}

- (void)actionDone {
	[self SaveData];
	[[self navigationController] popViewControllerAnimated:YES];
}
- (void)actionCancel {
	
}
- (UIBarButtonItem*)createDoneButton {
	UIBarButtonItem *returnButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone)];
	return returnButton;
}
- (UIBarButtonItem*)createCancelButton {
	UIBarButtonItem *returnButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel)];
	return returnButton;
}

- (void)viewDidLoad
{
	// create our text fields to be recycled when UITableViewCells are created
	titleTextField     = [self createTextField:0];
	portTextField      = [self createTextField:0];		
	hostTextField      = [self createTextField:0];
	passwordTextField  = [self createTextField:1];
	pathTextField      = [self createTextField:0];	
	if (hostData.identifier) {
		[titleTextField    setText: hostData.title];
		[portTextField     setText: hostData.port_number];
		[hostTextField     setText: hostData.hostname];
			[passwordTextField setText: hostData.password];
			[pathTextField     setText: hostData.path];		
	} else {
		[titleTextField setText: @"XBMC"];
		[portTextField  setText: @"80"];
		[hostTextField  setText: @"192.168.0.1"];	
		[pathTextField  setText: @""];			
	}
	
	UINavigationItem *navigationItem = [self navigationItem];
	navigationItem.rightBarButtonItem = [self createDoneButton];
	navigationItem.backBarButtonItem  = [self createCancelButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 6;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
	//if (cell == nil) {
	UITableViewCell *cell;
	

	
	NSInteger row = [indexPath row];
	UITextField *textfield;
	NSString *label;
	if (row == kTitleTextRow) {
		textfield = titleTextField;
		label     = @"Title";
	} else if (row == kPortTextRow) {
		textfield = portTextField;	
		label     = @"Port";
	} else if (row == kHostTextRow) {
		textfield = hostTextField;
		label     = @"Host/IP";
	} else if (row == kPasswordTextRow) {
		textfield = passwordTextField;
		label     = @"Password";
	} else if (row == kPathTextRow) {
		textfield = pathTextField;
		textfield.font = [UIFont systemFontOfSize:12];
		label     = @"Path";
	} 	
	
	if (row == kInfoTextRow) {
		CGRect frame = CGRectMake(0.0, 0.0, 280, 45);
		DisplayCell *cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"InfoCell"] autorelease];
		//
		//cell.font = [UIFont systemFontOfSize:12];
		//cell.lineBreakMode = UILineBreakModeWordWrap;
		UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
		label.text = @"Path is required if video covers are not displaying. The path will need to point to the 'userdata' folder.";
		label.lineBreakMode = UILineBreakModeWordWrap;
		label.numberOfLines = 2;
		label.font = [UIFont systemFontOfSize:12];
 		[cell setView: label];
		return cell;
	} else {
		CellTextField *cell = [[[CellTextField alloc] initWithFrame:CGRectZero reuseIdentifier:@"TextFieldCell"] autorelease];
		((CellTextField *)cell).delegate = self;	// so we can detect when cell editing starts
		((CellTextField *)cell).view = textfield;
		textfield.leftView = [self createTextFieldLabel: label];
		textfield.leftViewMode = UITextFieldViewModeAlways;		
		if (indexPath.row == kPathTextRow) {
			pathCell = [cell retain];
		}		
		return cell;
	}	
	

}
// Animate the entire view up or down, to prevent the keyboard from covering the author field.
- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    if (movedUp)
	{
        // If moving up, not only decrease the origin but increase the height so the view 
        // covers the entire screen behind the keyboard.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
	else
	{
        // If moving down, not only increase the origin but decrease the height.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    // The keyboard will be shown. If the user is editing the author, adjust the display so that the
    // author field will not be covered by the keyboard.
    if (pathCell.isInlineEditing && self.view.frame.origin.y >= 0)
	{
        [self setViewMovedUp:YES];
    }
	else if (self.view.frame.origin.y < 0)
	{
        [self setViewMovedUp:NO];
    }
}

- (CGFloat)tableView:(UITableView *)callingTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.row == kInfoTextRow) ? 60 : 45;
}

- (void)viewWillAppear:(BOOL)animated
{
    // watch the keyboard so we can adjust the user interface if necessary.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setEditing:NO animated:YES];
	
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}

- (void)dealloc {
	[titleTextField release];
	[portTextField release];
	[hostTextField	 release];
	[passwordTextField release];
	[hostData release];
	[xbmcSettings release];
	[pathCell release];
	[super dealloc];
}


@end
