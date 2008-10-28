//
//  InterfaceManager.h
//  xbmcremote
//
//  Created by David Fumberger on 19/10/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteInterface.h";

@interface InterfaceManager : NSObject {
	RemoteInterface *interface;
}
@property (nonatomic, retain) RemoteInterface *interface;
+ (InterfaceManager*)sharedInstance;
+ (RemoteInterface*)getSharedInterface;
@end
