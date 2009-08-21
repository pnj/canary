//
//  ORSTwitterEngine+Notification.m
//  Twitter Engine
//
//  Created by Nicholas Toumpelis on 20/08/2009.
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

#import "ORSTwitterEngine+Notification.h"

@implementation ORSTwitterEngine ( NotificationMethods )

- (NSXMLNode *) followUserWithID:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"notifications/follow.xml?user_id="];
	[path appendString:identifier];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST"
																atPath:path 
												synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) followUserWithScreenName:(NSString *)screenName {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"notifications/follow.xml?screen_name="];
	[path appendString:screenName];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST"
																atPath:path 
												synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) leaveUserWithID:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
			stringWithString:@"notifications/leave.xml?user_id="];
	[path appendString:identifier];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST"
																atPath:path 
												synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) leaveUserWithScreenName:(NSString *)screenName {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"notifications/leave.xml?screen_name="];
	[path appendString:screenName];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST"
																atPath:path 
												synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

@end
