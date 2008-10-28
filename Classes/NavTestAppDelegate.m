//
//  NavTestAppDelegate.m
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright collect3 2008. All rights reserved.
//

#import "NavTestAppDelegate.h"
#import "BaseViewController.h";
#import "NowPlayingViewController.h";
#import "XBMCHTTP.h";
#import "NowPlayingData.h";
#import "SettingsViewController.h";
#import "XBMCSettings.h";
#import "XBMCHostData.h";
#import "Crc32.h";
#import "Cache.h";
#import "Utility.h";
#import "InterfaceManager.h";
@implementation NavTestAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize npViewController;

- (id)init {
	if (self = [super init]) {
		
	}
	return self;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self setupInterface];
	
	tabBarController.moreNavigationController.delegate = self;
	navigationController.navigationBarHidden = true;
	[window addSubview:[mainViewController view]];
	[window addSubview:[mainNavigationController view]];
	[window makeKeyAndVisible];
	tabBar.delegate = self;

	Cache *cache = [Cache defaultCache];
	[cache setupDirectories];

}

- (void)setupInterface {
	XBMCHTTP *defaultInterface = [[XBMCHTTP alloc] init];
	InterfaceManager *im = [InterfaceManager sharedInstance];
	im.interface = defaultInterface;
	[defaultInterface release];	
}

- (IBAction)showNowPlayingAction:(id)sender {
	[self showRemote];
	//[self showNowPlaying];
}
- (void)showRemote {
	
	[mainViewController.view addSubview: remoteController.view];
	remoteController.view.frame = CGRectMake(0, 0, remoteController.view.frame.size.width, remoteController.view.frame.size.height);
	[window bringSubviewToFront:mainViewController.view]; 

	[remoteController viewDidAppear:YES];
	remoteController.view.alpha = 0;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	remoteController.view.alpha = 1;
	[UIView commitAnimations];		
}
- (void)hideRemote {
	if (remoteController.view.alpha == 0) {
		return;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];	
	[UIView setAnimationDidStopSelector:@selector(remoteIsHidden)];	
	[UIView setAnimationDuration:1];	
	remoteController.view.alpha = 0;
	[UIView commitAnimations];		
	[remoteController viewDidDisappear:YES];	
		
}
- (void)remoteIsHidden {
	[window sendSubviewToBack:mainViewController.view];
	[remoteController.view removeFromSuperview];
}
- (void)hideNowPlaying {
	[navigationController popViewControllerAnimated:YES];
}
- (void)showSettings {
	//settingsNavigationController.navigationController =  navigationController;
	[navigationController presentModalViewController: settingsNavigationController animated:YES];	
}
- (IBAction)showSettingsAction:(id)sender {
	[self showSettings];
}
- (void)resetAllNavigationControllers {
	NSArray *items = tabBarController.viewControllers;
	for (int i = 0; i < [items count]; i++) {
		UINavigationController *titem = [items objectAtIndex:i];
		if (titem == tabBarController.selectedViewController) {
			NSLog(@"is active %d", i);
			continue;
		}
		[titem popToRootViewControllerAnimated:NO];
		
		NSArray *nitems = titem.viewControllers;
		for (int j = 0; j < [nitems count]; j++) {
		//	BaseViewController *bv = [nitems objectAtIndex:j];
		//	[bv minimiseData];
		}
	}
	[tabBarController.moreNavigationController popToRootViewControllerAnimated:NO];	
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	[self resetAllNavigationControllers];
}

- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (!animated) {
		viewController.navigationItem.leftBarButtonItem = settingsButton;
	}
	if (viewController.navigationItem.rightBarButtonItem == nil) {
		viewController.navigationItem.rightBarButtonItem = nowPlayingButton;
	}
	NSLog(@"Will show");
}
- (void)navigationController:(UINavigationController *)navController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

	//navController.rightBarButtonItem = settingsButton;
}
- (void)showNowPlaying {
	if (npViewController == nil) {
		npViewController = [[NowPlayingViewController alloc] initWithNibName:@"NowPlayingView" bundle:nil ];
	}
	[navigationController pushViewController:npViewController animated:YES];
}
- (void)reloadAllViews {
	NSLog(@"Reloading views");
	NSArray *items = [NSArray arrayWithObjects:artistViewController,
											   albumsViewController,
											   tvshowsViewController,
											   genresViewController,
											   songsViewController,
												moviesViewcontroller, 
												musicSourcesViewController,
											    videoSourcesViewController,
											    playlistViewController
												,nil];
	for (BaseViewController *vc in items) {
		vc.reloadData = YES;
	}
}
- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
}




- (void)dealloc {
	[npViewController release];
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
