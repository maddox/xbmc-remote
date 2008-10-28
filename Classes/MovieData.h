//
//  MovieData.h
//  xbmcremote
//
//  Created by David Fumberger on 17/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewData.h";

@interface MovieData : ViewData {
		NSString *tagline;
		NSString *genre;	
}
@property (nonatomic, retain) NSString *tagline;
@property (nonatomic, retain) NSString *genre;
@end
