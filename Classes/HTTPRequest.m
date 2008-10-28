//
//  HTTPRequest.m
//  NavTest
//
//  Created by David Fumberger on 31/07/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "HTTPRequest.h"


@implementation HTTPRequest
	@synthesize hostname;
    @synthesize path;
	@synthesize port_number;
	@synthesize request_data;
    @synthesize parameters;
	@synthesize username;
	@synthesize password;
	@synthesize reqError;

- (NSString*)BaseURL {
	NSString *unpw = @"";
	if (self.username && self.password) {
		unpw = [ [NSString stringWithFormat:@"%@:%@@", self.username, self.password]
					  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	NSString *url = [NSString stringWithFormat:@"http://%@%@:%@",
							 unpw, self.hostname , self.port_number];

	return url;
}

- (NSString*)EncodeURL:(NSString*)url {
	NSString *str1 = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *str2 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	NSString *urlString = [str3 stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];	
	return urlString;
}

- (NSString*)ParamsString {
	NSMutableString *str = [NSMutableString string];
	unsigned count = 0;
	while (count < [parameters count]) {
		NSString *pre = [parameters objectAtIndex:count];
		NSString *param = [self EncodeURL: pre];
		
		[str appendString: param];
		if (count % 2 == 0) {
			[str appendString: @"="];
		} else {
			if (count != [parameters count] - 1) {
				[str appendString: @"&"];
			}
		}
//		NSLog(@"Param %@", param);
		count++;
	}
  //  NSLog(@"Param List %@", str);
	return str;
}




- (NSString*)GetURL  {
	NSMutableString *URLString = [NSMutableString string];
	[URLString appendString: [ self BaseURL ]];
	[URLString appendString: path];
	[URLString appendString: @"?" ];	
	NSString *params = [self ParamsString];
	//NSLog(@"%@%@", URLString, params);
	[URLString appendString:  params];

	return URLString;
}

- (NSString*)GetOld {
	NSString *URLString = [self GetURL];
	NSURL *url = [[NSURL alloc] initWithString: URLString];	
	NSString *returndata = [[[NSString alloc] initWithContentsOfURL: url] autorelease];
	[url release];	
	return returndata;
}
- (NSString*)Get {
 	NSString *URLString = [self GetURL];
	reqError = nil;			
	NSURL *url = [NSURL URLWithString:URLString];	
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
										   cachePolicy:  NSURLRequestReloadIgnoringLocalAndRemoteCacheData
										   timeoutInterval:10.0];
	NSData  *rdata = [NSURLConnection
					  sendSynchronousRequest: theRequest
					  returningResponse: nil 
					  error: &reqError];
	NSString *returnStr = [NSString stringWithCString:[rdata bytes] length: [rdata length]];
	return returnStr;
}

//- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse


- (NSString*)GetAsync:(NSString *)URLString {
	
	// create the request
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		request_data=[[NSMutableData data] retain];

	} else {
		// inform the user that the download could not be made
	}	
	
	return @"called get";
}
		
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // this method is called when the server has determined that it
    // has enough information to create the NSURLResponse
	
    // it can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    // receivedData is declared as a method instance elsewhere
   
	[request_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // append the new data to the receivedData
    // receivedData is declared as a method instance elsewhere
    [request_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [request_data release];
	
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[request_data length]);
	
    // release the connection, and the data object
    [connection release];
    [request_data release];
}

- (void)dealloc {
	//NSLog(@"HTTPRequest - dealloc");
	//[reqError release];
	[hostname     release];
	[port_number  release];
	[path         release];
	[username     release];
	[password     release];
	[request_data release];
	[parameters   release]; 
	
	[super dealloc];
}
@end
