//
//  FileSystemData.h
//  xbmcremote
//
//  Created by David Fumberger on 20/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewData.h";
#define FILE_MUSIC 0
#define FILE_VIDEO 1
@interface FileSystemData : ViewData {
	NSInteger filetype;
	BOOL isRar;
}
@property (nonatomic, assign) NSInteger filetype;
@property (nonatomic, assign) BOOL isRar;
@end
