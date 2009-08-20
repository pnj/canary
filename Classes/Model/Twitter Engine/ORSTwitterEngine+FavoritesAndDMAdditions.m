//
//  ORSTwitterEngine+FavoritesAndDMAdditions.m
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

#import "ORSTwitterEngine+FavoritesAndDMAdditions.h"

@implementation ORSTwitterEngine ( FavoritesAndDMAdditions )

// returns a list of the 20 most recent DMs sent to the current user since a 
// date
- (NSArray *) getReceivedDMsSince:(NSString *)date {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages.xml?since="];
	[path appendString:date];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	[path appendString:@"&count=200"];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self getAllDMsFromData:data];
	} else {
		return NULL;
	}
}

// returns the 20 next most recent DMs sent to the current user (page-based)
- (NSArray *) getReceivedDMsAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages.xml?page="];
	[path appendString:page]; 
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self getAllDMsFromData:data];
	} else {
		return NULL;
	}
}

// returns a list of the 20 most recent DMs sent by the current user since a
// date
- (NSArray *) getSentDMsSince:(NSString *)date {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"direct_messages/sent.xml?since="];
	[path appendString:date];
	[path appendString:@"&count=200"];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self getAllDMsFromData:data];
	} else {
		return NULL;
	}
}

// returns the 20 next most recent DMs sent by the current user (page-based)
- (NSArray *) getSentDMsAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString 
			stringWithString:@"direct_messages/sent.xml?page="];
	[path appendString:page]; 
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self getAllDMsFromData:data];
	} else {
		return NULL;
	}
}

// sends a new DM to the specified user
- (BOOL) newDM:(NSString *)message toUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages/new.xml?user="];
	[path appendString:userID];
	[path appendString:@"&text="];
	NSString *messageText = [message 
		stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	messageText = [messageText stringByReplacingOccurrencesOfString:@"&" 
															withString:@"%26"];
	messageText = [messageText stringByReplacingOccurrencesOfString:@"+"		
														 withString:@"%2B"];
	[path appendString:messageText];
	NSXMLNode *node = [self getNodeFromData:[self 
		executeUnencodedRequestOfType:@"POST" 
				atPath:path synchronously:synchronously]];
	if ([[node name] isEqualToString:@"direct_message"]) {
		return YES;
	} else {
		return NO;
	}
}

// destroy a specified DM
- (BOOL) destroyDM:(NSString *)messageID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages/destroy/"];
	[path appendString:messageID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"POST" atPath:path synchronously:synchronously]];
	if ([[node name] isEqualToString:@"direct_message"]) {
		return YES;
	} else {
		return NO;
	}
}

@end
