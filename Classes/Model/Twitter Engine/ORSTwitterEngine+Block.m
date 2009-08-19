//
//  ORSTwitterEngine+Block.h
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

#import "ORSTwitterEngine+Block.h"

@implementation ORSTwitterEngine ( BlockMethods )

// Change these two.
// blocks the user with the specified id
- (BOOL) blockUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"blocks/create/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// unblocks the user with the specified id
- (BOOL) unblockUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"blocks/destroy/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path 
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

- (BOOL) blocksUserWithID:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"blocks/exists.xml?user_id="];
	[path appendString:identifier];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"GET"
																atPath:path 
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

- (BOOL) blocksUserWithScreenName:(NSString *)screenName {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"blocks/exists.xml?screen_name="];
	[path appendString:screenName];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"GET"
																atPath:path 
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

- (NSArray *) blockedUsers {
	NSString *path = @"blocks/blocking.xml";
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path 
								synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

- (NSArray *) blockedIDs {
	NSString *path = @"blocks/blocking/ids.xml";
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path 
								synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"ids"]) {
		return [self IDsFromData:data];
	} else {
		return NULL;
	}
}

@end
