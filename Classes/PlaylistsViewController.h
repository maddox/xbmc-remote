//
//  PlaylistsViewController.h
//  xbmcremote
//
//  Created by David Fumberger on 21/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h";

@interface PlaylistsViewController : BaseViewController {
	ViewData *fileSystemData; 
}
@property (nonatomic, retain) ViewData *fileSystemData;
@end
