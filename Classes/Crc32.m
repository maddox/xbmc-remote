//
//  Crc32.m
//  xbmcremote
//
//  Created by David Fumberger on 16/08/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "Crc32.h"


@implementation Crc32


- (void) Compute:(const void*)buffer count:(unsigned int) count
{
	const unsigned char* ptr = (const unsigned char *) buffer;
	count = count * 2;
	while (count--)
	{	
			[self Compute:*ptr++];
	}
}

- (void) Compute:(unsigned char) value
{
	NSString *str = [NSString stringWithFormat:@"%c", value];
	if ([str length] == 0) {
		return;
	}
	//NSLog(@"DO: %c", value);
	m_crc ^= ((unsigned int)value << 24);
	for (int i = 0; i < 8; i++)
	{
		if (m_crc & 0x80000000)
		{
			m_crc = (m_crc << 1) ^ 0x04C11DB7;
		}
		else
		{
			m_crc <<= 1;
		}
	}
}
- (int)ComputeStringLower:(NSString*)string {
	return [self ComputeString:[string lowercaseString]];
}
- (int)ComputeString:(NSString*)string {
	m_crc = 0xFFFFFFFF;
	unichar *buffer = calloc( [ string length ] * 2, sizeof( unichar ) );
	[string getCharacters:buffer];
	[self Compute:buffer count:[string length] ];
	free(buffer);
	return m_crc;
}
@end
