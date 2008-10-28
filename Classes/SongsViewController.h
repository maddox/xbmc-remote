//
//  AlbumSongsViewController.h
//  NavTest
//
//  Created by David Fumberger on 3/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h";
@interface SongsViewController : BaseViewController {
	NSString *albumName;
}

@property (nonatomic, retain) NSString *albumName;

@end
