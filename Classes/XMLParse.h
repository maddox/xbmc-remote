//
//  XMLParse.h
//  NavTest
//
//  Created by David Fumberger on 31/07/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XMLParse : NSObject {
	NSMutableArray *dataArray;
	NSString *elementName;
	NSMutableString *currentStringValue;
}
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSString *elementName;
- (NSArray*)parseURL:(NSString*)URL;
@end
