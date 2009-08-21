//
//  ORSTwitterEngine+Status.m
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 12/04/2009.
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

#import "ORSTwitterEngine+Status.h"

@implementation ORSTwitterEngine ( StatusMethods )

// returns a single status specified by the given id
- (NSXMLNode *) status:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"statuses/show/"];
	[path appendString:identifier];
	[path appendString:@".xml"];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"GET" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"status"]) {
		return node;
	} else {
		return NULL;
	}
}

// updates the current user's status

- (NSXMLNode *) postStatus:(NSString *)text {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/update.xml?status="];
	NSString *statusText = [text 
		stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	statusText = [statusText stringByReplacingOccurrencesOfString:@"&" 
													   withString:@"%26"];
	statusText = [statusText stringByReplacingOccurrencesOfString:@"+"		
													   withString:@"%2B"];
	[path appendString:statusText];
	[path appendString:@"&source=canary"];
	if (synchronously) {
		NSXMLNode *node = [self nodeFromData:[self 
									executeUnencodedRequestOfType:@"POST" 
												 atPath:path 
												 synchronously:synchronously]];
		if ([[node name] isEqualToString:@"status"]) {
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

- (NSXMLNode *) postStatus:(NSString *)text
				atLatitude:(NSString *)latitude
				 longitude:(NSString *)longitude {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/update.xml?status="];
	NSString *statusText = [text 
		stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	statusText = [statusText stringByReplacingOccurrencesOfString:@"&" 
													   withString:@"%26"];
	statusText = [statusText stringByReplacingOccurrencesOfString:@"+"		
													   withString:@"%2B"];
	[path appendString:statusText];
	[path appendFormat:@"&lat=%@&long=%@&source=canary", latitude, longitude];
	if (synchronously) {
		NSXMLNode *node = [self nodeFromData:[self 
			executeUnencodedRequestOfType:@"POST" 
				atPath:path synchronously:synchronously]];
		if ([[node name] isEqualToString:@"status"]) {
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

- (NSXMLNode *) postStatus:(NSString *)text 
				 inReplyTo:(NSString *)identifier {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/update.xml?status="];
	NSString *statusText = [text 
		stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	statusText = [statusText stringByReplacingOccurrencesOfString:@"&" 
													   withString:@"%26"];
	statusText = [statusText stringByReplacingOccurrencesOfString:@"+"		
													   withString:@"%2B"];
	[path appendString:statusText];
	if (identifier != NULL) {
		[path appendString:@"&in_reply_to_status_id="];
		[path appendString:identifier];
	}
	[path appendString:@"&source=canary"];
	if (synchronously) {
		NSXMLNode *node = [self nodeFromData:[self 
			executeUnencodedRequestOfType:@"POST" 
				atPath:path 
					synchronously:synchronously]];
		if ([[node name] isEqualToString:@"status"]) {
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

- (NSXMLNode *) postStatus:(NSString *)text 
				 inReplyTo:(NSString *)identifier
				atLatitude:(NSString *)latitude
				 longitude:(NSString *)longitude {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/update.xml?status="];
	NSString *statusText = [text 
		stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	statusText = [statusText stringByReplacingOccurrencesOfString:@"&" 
													   withString:@"%26"];
	statusText = [statusText stringByReplacingOccurrencesOfString:@"+"		
													   withString:@"%2B"];
	[path appendString:statusText];
	if (identifier != NULL) {
		[path appendString:@"&in_reply_to_status_id="];
		[path appendString:identifier];
	}
	[path appendFormat:@"&lat=%@&long=%@&source=canary", latitude, longitude];
	if (synchronously) {
		NSXMLNode *node = [self nodeFromData:[self 
			executeUnencodedRequestOfType:@"POST" 
				atPath:path 
					synchronously:synchronously]];
		if ([[node name] isEqualToString:@"status"]) {
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

// destroys the specified status
- (NSXMLNode *) deleteStatus:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"statuses/destroy/"];
	[path appendString:identifier];
	[path appendString:@".xml"];
	NSXMLNode *node = [self nodeFromData:[self 
		executeRequestOfType:@"DELETE" atPath:path 
											 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"status"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) retweetStatus:(NSString *)identifier {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/retweet/"];
	[path appendFormat:@"%@.xml&source=canary", identifier];
	NSXMLNode *node = [self nodeFromData:[self 
		executeRequestOfType:@"POST" atPath:path 
			synchronously:synchronously]];
	if ([[node name] isEqualToString:@"status"]) {
		return node;
	} else {
		return NULL;
	}
}

@end
