//
//  Crc32.h
//  xbmcremote
//
//  Created by David Fumberger on 16/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Crc32 : NSObject {
	int m_crc;
}
- (void) Compute:(const void*)buffer count:(unsigned int) count;
- (void) Compute:(unsigned char) value;
- (int)ComputeString:(NSString*)string;
- (int)ComputeStringLower:(NSString*)string;
@end
