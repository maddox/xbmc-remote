//
//  Utility.m
//  NavTest
//
//  Created by David Fumberger on 4/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "Utility.h"


@implementation Utility
+ (void)randomizeArray:(NSMutableArray *)array
{
	// Assume that the random number system has been seeded.
	int i, n = [array count];
	for(i = 0; i < n; i++) {
		// Swap the ith object with one randomly selected from [i,n).
		int destinationIndex = random() % (n - i) + i;
		[array exchangeObjectAtIndex:i withObjectAtIndex:destinationIndex];
	}
}

+ (NSString*)secondsToString:(NSInteger)numSeconds {
	int minutes = numSeconds / 60;
	int seconds = numSeconds % 60;
	return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
+ (NSArray*)fileComponents:(NSString*)fullfile   {
	return [Utility fileComponents:fullfile includeSeperator:YES];
}
+ (NSArray*)fileComponents:(NSString*)fullfile includeSeperator:(BOOL)includeSeperator {
	NSRange range;
	range = [fullfile rangeOfString:@"/"];

	NSString *seperator;
	if (range.location == NSNotFound) {	
		seperator = @"\\";
	} else {
		seperator = @"/";
		
	}
	NSArray *items = [fullfile componentsSeparatedByString:seperator];
	if ([items count] > 1) {
		
		NSString *file = [items objectAtIndex: [items count] - 1];
		NSRange pathrange;
		pathrange.location = 0;
		pathrange.length = [items count] - 1;
		NSArray *pathitems = [items subarrayWithRange: pathrange];
		NSString *path = [pathitems componentsJoinedByString:seperator];
		if (includeSeperator) {
			return [NSArray arrayWithObjects: [NSString stringWithFormat: @"%@%@", path, seperator], file, nil];
		} else {
			return [NSArray arrayWithObjects: [NSString stringWithFormat: @"%@", path], file, nil];
		}
	} else {
		return [NSArray arrayWithObjects:@"", fullfile, nil];
	}
}
@end
