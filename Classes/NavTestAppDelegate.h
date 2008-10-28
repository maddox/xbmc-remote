//
//  NavTestAppDelegate.h
//  NavTest
//
//  Created by David Fumberger on 30/07/08.
//  Copyright collect3 2008. All rights reserved.
//

//#import <UIKit/UIKit.h>
//#import "XBMCSettings.h"
//#import "XBMCHTTP.h"
#import "NowPlayingViewController.h"
#import "BaseViewController.h"

@interface NavTestAppDelegate : NSObject <UIApplicationDelegate, UITabBarDelegate> {
	
	IBOutlet UIWindow *window;
	
	IBOutlet UIViewController *mainViewController;
	IBOutlet UINavigationController *navigationController;
	
	IBOutlet UINavigationController *mainNavigationController;
	
	IBOutlet UINavigationController *settingsNavigationController;
	IBOutlet UIView *nowPlayingButtonView;
	NowPlayingViewController *npViewController;
	
	IBOutlet UIViewController *artistNavigationController;
	IBOutlet UIViewController *albumNavigationController;

	IBOutlet UITabBarController *tabBarController;
	IBOutlet UITabBar *tabBar;
	IBOutlet UIViewController *remoteController;
	
	IBOutlet UIBarButtonItem *settingsButton;
	IBOutlet UIBarButtonItem *nowPlayingButton;	
	
	IBOutlet BaseViewController *artistViewController;	
	IBOutlet BaseViewController *albumsViewController;	
	IBOutlet BaseViewController *songsViewController;
	IBOutlet BaseViewController *tvshowsViewController;
	IBOutlet BaseViewController *moviesViewcontroller;
	IBOutlet BaseViewController *genresViewController;
	IBOutlet BaseViewController *videoSourcesViewController;	
	IBOutlet BaseViewController *musicSourcesViewController;	
	IBOutlet BaseViewController *playlistViewController;		
}
- (void)showRemote;
- (void)hideRemote;
- (void)showNowPlaying;
- (IBAction)showNowPlayingAction:(id)sender;
- (IBAction)showSettingsAction:(id)sender;
- (void)hideNowPlaying;
- (void)reloadAllViews;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, assign) NowPlayingViewController *npViewController;
//@property (nonatomic, retain) XBMCHTTP *XBMCInterface;
@end

