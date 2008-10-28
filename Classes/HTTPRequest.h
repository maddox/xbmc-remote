//
//  HTTPRequest.h
//  NavTest
//
//  Created by David Fumberger on 31/07/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HTTPRequest : NSObject {
	NSString *hostname;
	NSString *port_number;
	NSString *path;
	NSString *username;
	NSString *password;
	NSMutableData *request_data;
	NSMutableArray *parameters;
	NSError *reqError;
}

@property (nonatomic, retain) NSString *hostname;
@property (nonatomic, retain) NSString *port_number;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSMutableData *request_data;
@property (nonatomic, retain) NSMutableArray *parameters;
@property (nonatomic, retain) NSError *reqError;
- (NSString*)Get;
- (NSString*)GetURL;

@end
