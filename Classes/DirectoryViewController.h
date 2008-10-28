//
//  DirectoryViewController.h
//  xbmcremote
//
//  Created by David Fumberger on 20/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h";
#import "ViewData.h";

#define DIRECTORY_MASK_MUSIC 0
#define DIRECTORY_MASK_VIDEO 1

@interface DirectoryViewController : BaseViewController {
	ViewData *fileSystemData; 
	NSInteger mask;
}
@property (nonatomic, retain) ViewData *fileSystemData;
@property (nonatomic) NSInteger mask;
@end
