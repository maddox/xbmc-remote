//
//  EpisodesViewController.h
//  xbmcremote
//
//  Created by David Fumberger on 16/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h";
#define SUB_TYPE_SHOW   1
#define SUB_TYPE_SEASON 2
@interface EpisodesViewController : BaseViewController {
	NSString  *seasonName;
	NSInteger subTitleType;
}
@property (nonatomic, retain) NSString *seasonName;
@end
