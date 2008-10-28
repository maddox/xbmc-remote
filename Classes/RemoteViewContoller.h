//
//  RemoveViewContoller.h
//  xbmcremote
//
//  Created by David Fumberger on 17/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteMoreViewController.h";
#import "RemoteTouchView.h";
#import "GUIStatus.h";
#import "RemoteInterface.h";
#import "XBMCSettings.h";
@interface RemoteViewContoller : UIViewController {
	RemoteInterface *XBMCInterface;
	GUIStatus *guiStatus;
	NSInteger guiMode;
	IBOutlet UIViewController *moreViewController;
	IBOutlet UISlider *volumeSlider;
	IBOutlet UIImageView *pointer;
	NSTimer *timer;
	
	IBOutlet UIView *remoteGestureView;
	IBOutlet UIView *remoteButtonView;
	IBOutlet UIView *remoteContainerView;
	
	BOOL refreshing;
	BOOL isFingerDown;
	
	XBMCSettings *xbmcSettings;
}	

- (IBAction)fingerDown:(id)sender;
- (IBAction)fingerUp:(id)sender;
- (IBAction)actionSwitchView:(id)sender;
- (IBAction)actionUp:(id)sender;
- (IBAction)actionDown:(id)sender;
- (IBAction)actionLeft:(id)sender;
- (IBAction)actionRight:(id)sender;
- (IBAction)actionEnter:(id)sender;
- (IBAction)actionBack:(id)sender;
- (IBAction)actionPlay:(id)sender;
- (IBAction)actionPause:(id)sender;
- (IBAction)actionStop:(id)sender;
- (IBAction)actionBackTwo:(id)sender;
- (IBAction)actionBack:(id)sender;
- (IBAction)actionNext:(id)sender;
- (IBAction)actionPrev:(id)sender;
- (IBAction)actionStop:(id)sender;
- (IBAction)actionGui:(id)sender;
- (IBAction)actionMenu:(id)sender;
- (IBAction)actionChangeVolume:(id)sender;

- (IBAction)closeMenu:(id)sender;
@end
