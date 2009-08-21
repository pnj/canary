//
//  ORSTwitterEngine+DirectMessage.m
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

#import "ORSTwitterEngine+DirectMessage.h"

@implementation ORSTwitterEngine ( DirectMessageMethods )

// returns a list of the 20 most recent DMs sent to the current user
- (NSArray *) receivedDMs {
	NSString *path = @"direct_messages.xml";
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self nodeFromData:data];
		if ([[node name] isEqualToString:@"direct-messages"]) {
			return [self dmsFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns a list of the 20 most recent DMs sent to the current user since a
// status_id
- (NSArray *) receivedDMsSinceDM:(NSString *)dmID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages.xml?since_id="];
	[path appendString:dmID];
	[path appendString:@"&count=200"];
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self nodeFromData:data];
		if ([[node name] isEqualToString:@"direct-messages"]) {
			return [self dmsFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns a list of the 20 most recent DMs sent to the current user since a 
// date
- (NSArray *) receivedDMsSinceDate:(NSString *)date {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages.xml?since="];
	[path appendString:date];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	[path appendString:@"&count=200"];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self dmsFromData:data];
	} else {
		return NULL;
	}
}

// returns the 20 next most recent DMs sent to the current user (page-based)
- (NSArray *) receivedDMsAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages.xml?page="];
	[path appendString:page]; 
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self dmsFromData:data];
	} else {
		return NULL;
	}
}

// could have a method for max_id

// returns a list of the 20 most recent DMs sent by the current user
- (NSArray *) sentDMs {
	NSString *path = @"/direct_messages/sent.xml";
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self nodeFromData:data];
		if ([[node name] isEqualToString:@"direct-messages"]) {
			return [self dmsFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns a list of the 20 most recent DMs sent by the current user since a
// status_id
- (NSArray *) sentDMsSinceDM:(NSString *)dmID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"direct_messages/sent.xml?since_id="];
	[path appendString:dmID]; 
	[path appendString:@"&count=200"];
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self nodeFromData:data];
		if ([[node name] isEqualToString:@"direct-messages"]) {
			return [self dmsFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path 
					 synchronously:synchronously];
		return NULL;
	}
}

// returns a list of the 20 most recent DMs sent by the current user since a
// date
- (NSArray *) sentDMsSinceDate:(NSString *)date {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"direct_messages/sent.xml?since="];
	[path appendString:date];
	[path appendString:@"&count=200"];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self dmsFromData:data];
	} else {
		return NULL;
	}
}

// returns the 20 next most recent DMs sent by the current user (page-based)
- (NSArray *) sentDMsAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString 
			stringWithString:@"direct_messages/sent.xml?page="];
	[path appendString:page]; 
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"direct-messages"]) {
		return [self dmsFromData:data];
	} else {
		return NULL;
	}
}

// could have a method for max_id

// sends a new DM to the specified user
- (NSXMLNode *) sendDM:(NSString *)message toUserWithID:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"direct_messages/new.xml?user_id="];
	[path appendString:identifier];
	[path appendString:@"&text="];
	NSString *messageText = [message 
		stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	messageText = [messageText stringByReplacingOccurrencesOfString:@"&" 
															withString:@"%26"];
	messageText = [messageText stringByReplacingOccurrencesOfString:@"+"		
														 withString:@"%2B"];
	[path appendString:messageText];
	NSXMLNode *node = [self nodeFromData:[self 
		executeUnencodedRequestOfType:@"POST" 
				atPath:path synchronously:synchronously]];
	if ([[node name] isEqualToString:@"direct_message"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) sendDM:(NSString *)message 
  toUserWithScreenName:(NSString *)screenName {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"direct_messages/new.xml?screen_name="];
	[path appendString:screenName];
	[path appendString:@"&text="];
	NSString *messageText = [message 
							 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	messageText = [messageText stringByReplacingOccurrencesOfString:@"&" 
														 withString:@"%26"];
	messageText = [messageText stringByReplacingOccurrencesOfString:@"+"		
														 withString:@"%2B"];
	[path appendString:messageText];
	NSXMLNode *node = [self nodeFromData:[self 
						executeUnencodedRequestOfType:@"POST" 
								atPath:path synchronously:synchronously]];
	if ([[node name] isEqualToString:@"direct_message"]) {
		return node;
	} else {
		return NULL;
	}
}

// destroy a specified DM
- (NSXMLNode *) deleteDM:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"direct_messages/destroy/"];
	[path appendString:identifier];
	[path appendString:@".xml"];
	NSXMLNode *node = [self nodeFromData:[self 
		executeRequestOfType:@"DELETE" atPath:path synchronously:synchronously]];
	if ([[node name] isEqualToString:@"direct_message"]) {
		return node;
	} else {
		return NULL;
	}
}

@end
