//
//  XBMCHostData.m
//  NavTest
//
//  Created by David Fumberger on 10/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "XBMCHostData.h"

@implementation XBMCHostData
@synthesize hostname;
@synthesize port_number;
@synthesize password;
@synthesize title;
@synthesize identifier;
@synthesize active;
@synthesize path;
- initWithArray:(NSArray*)hostArray {
	self.hostname    = [hostArray objectAtIndex:0];
	self.port_number = [hostArray objectAtIndex:1];	
	self.title       = [hostArray objectAtIndex:2];		
	self.identifier  = [[hostArray objectAtIndex:3] integerValue];
	if ([hostArray count] > 4 && [[hostArray objectAtIndex:4] length] > 0) {
		self.password    = [hostArray objectAtIndex:4];
	}
	if ([hostArray count] > 5 && [[hostArray objectAtIndex:5] length] > 0) {
		self.path       = [hostArray objectAtIndex:5];			
	}
	return self;
}
-(NSString*)dataHash {
	NSString *data = [NSString stringWithFormat: @"%@%@%d%@", self.hostname, self.port_number, self.identifier, self.password, self.path];
	return data;
}
-(NSArray*)toArray {
	NSLog(@"toArray");	
	NSArray *values = [NSArray arrayWithObjects:self.hostname, 
					   self.port_number,
					   self.title, 
					  [NSString stringWithFormat: @"%d", self.identifier],
					  self.password, // Create empty string
					   self.path,  
					   nil];
	NSLog(@"Values");
	return values;
}
-(void)dealloc {
	[hostname release];
	[port_number release];
	[title release];
	[password release];
	[path release];
	[super dealloc];
}
@end
