//
//  ORSTwitterEngine+Friendship.m
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

#import "ORSTwitterEngine+Friendship.h"

@implementation ORSTwitterEngine ( FriendshipMethods )

// creates friendship with user
- (NSXMLNode *) makeFriendUserWithID:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"friendships/create.xml?user_id="];
	[path appendString:identifier];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"POST"
																atPath:path
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

// creates friendship with user
- (NSXMLNode *) makeFriendUserWithScreenName:(NSString *)screenName {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"friendships/create.xml?screen_name="];
	[path appendString:screenName];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"POST"
																atPath:path
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

// discontinues friendship with user
- (BOOL) destroyFriendshipWithUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"friendships/destroy/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path 
											 // synchronously:YES]];
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// tests if a friendship exists between two users (one way only)
- (BOOL) user:(NSString *)userIDA isFriendWithUser:(NSString *)userIDB {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"friendships/exists.xml?user_a="];
	[path appendString:userIDA];
	[path appendString:@"&user_b="];
	[path appendString:userIDB];
	NSXMLNode *node = [self getNodeFromData:[self executeRequestOfType:@"GET"
																atPath:path 
														 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"friends"] &&
		[[node stringValue] isEqualToString:@"true"]) {
		return YES;
	} else {
		return NO;
	}
}

@end
