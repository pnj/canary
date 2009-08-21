//
//  ORSTwitterEngine+SavedSearches.m
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 19/08/2009.
//  Copyright 2008-2009 Ocean Road Software, Nick Toumpelis.
//
//  Version 0.7.1
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy 
//  of this software and associated documentation files (the "Software"), to 
//  deal in the Software without restriction, including without limitation the 
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
//  sell copies of the Software, and to permit persons to whom the Software is 
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in 
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
//  IN THE SOFTWARE.

#import "ORSTwitterEngine+SavedSearches.h"

@implementation ORSTwitterEngine ( SavedSearchesMethods )

- (NSArray *) savedSearches {
	NSString *path = @"saved_searches.xml";
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path 
								synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"saved_searches"]) {
		return [self savedSearchesFromData:data];
	} else {
		return NULL;
	}
}

- (NSXMLNode *) savedSearch:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"saved_searches/show/"];
	[path appendString:identifier];
	[path appendString:@".xml"];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"GET" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"saved_search"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) createSavedSearchFor:(NSString *)queryStr {
	NSMutableString *path = [NSMutableString
		stringWithString:@"saved_searches/create.xml?query="];
	NSString *query = [queryStr 
		stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	query = [query stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	query = [query stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	[path appendString:query];
	
	if (synchronously) {
		NSXMLNode *node = [self nodeFromData:[self 
			executeUnencodedRequestOfType:@"POST" atPath:path 
				synchronously:synchronously]];
		if ([[node name] isEqualToString:@"saved_search"]) {
			return node;
		} else {
			return NULL;
		}
	} else {
		[self executeUnencodedRequestOfType:@"POST" 
									 atPath:path 
							  synchronously:synchronously];
		return NULL;
	}
}

- (NSXMLNode *) destroySavedSearch:(NSString *)identifier {
	NSMutableString *path = [NSMutableString
		stringWithString:@"saved_searches/destroy/"];
	[path appendString:identifier];
	[path appendString:@".xml"];
	
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"DELETE" 
		atPath:path synchronously:synchronously]];
	if ([[node name] isEqualToString:@"saved_search"]) {
		return node;
	} else {
		return NULL;
	}
}

@end
