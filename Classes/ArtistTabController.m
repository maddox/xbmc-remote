//
//  ArtistTabController.m
//  NavTest
//
//  Created by David Fumberger on 2/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "ArtistTabController.h"
#import "RootViewController.h"

@implementation ArtistTabController
- (void)viewDidLoad {
[self.view addSubview:navigationController.view];
	//UITableViewController *targetController = [[RootViewController alloc] init];
	//[navigationController setView:targetController.view ];	
}
@end
