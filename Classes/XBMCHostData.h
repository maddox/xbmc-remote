//
//  XBMCHostData.h
//  NavTest
//
//  Created by David Fumberger on 10/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XBMCHostData : NSObject {
	NSString      *hostname;
	NSString      *port_number;
	NSString	  *title;
	NSString	  *password;
	NSString	  *path;	
	NSInteger	  identifier;
	BOOL		  active;
}
@property (nonatomic, retain) NSString *hostname;
@property (nonatomic, retain) NSString *port_number;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *path;
@property (nonatomic) NSInteger identifier;
@property (nonatomic) BOOL     active;
-(NSString*)dataHash;
-(NSArray*)toArray;
@end
