//
//  XMLParse.m
//  NavTest
//
//  Created by David Fumberger on 31/07/08.
//  Copyright 2008 collect3. All rights reserved.
//

#import "XMLParse.h"


@implementation XMLParse

@synthesize dataArray;
@synthesize elementName;

- (NSArray*)parseURL:(NSString*)URL {
	BOOL success;
	dataArray = nil;
	NSURL *xmlURL = [NSURL URLWithString:URL];
	//if (addressParser) // addressParser is an NSXMLParser instance variable
        //[addressParser release];
    NSXMLParser *addressParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    [addressParser setDelegate:self];
    [addressParser setShouldResolveExternalEntities:NO];
    success = [addressParser parse]; // return value not used	
	[addressParser release];
	return self.dataArray;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)element
										namespaceURI:(NSString *)namespaceURI 
										qualifiedName:(NSString *)qName 
										attributes:(NSDictionary *)attributeDict {
	
	if ( [element isEqualToString:self.elementName] ) {
		if (!dataArray) 
			dataArray = [[NSMutableArray alloc] init];
		return;
	}	
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentStringValue) {
        // currentStringValue is an NSMutableString instance variable
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
	//NSLog(@"Found [%@]", string);
    [currentStringValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)element namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ( [element isEqualToString:self.elementName] ) {
		//NSString *normalised = [ currentStringValue stringByReplacingOccurrencesOfString: @"\n" withString: @"" ];
		if (currentStringValue == nil) {
			currentStringValue = @"";
		}
		[ dataArray addObject:currentStringValue];
		//NSLog(@"<%@>%@</%@>", self.elementName, currentStringValue, self.elementName);
		[ currentStringValue release ];
		currentStringValue = nil;
		return;
	}
}

- (void)dealloc {
	[currentStringValue release];
	[dataArray release];
	[super dealloc];
}
@end
