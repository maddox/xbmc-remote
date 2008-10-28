//
//  Utility.h
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Utility : NSObject {

}
+ (void)randomizeArray:(NSMutableArray *)array;
+ (NSString*)secondsToString:(NSInteger)numSeconds;
+ (NSArray*)fileComponents:(NSString*)fullfile ;
+ (NSArray*)fileComponents:(NSString*)fullfile includeSeperator:(BOOL)includeSeperator;
@end
