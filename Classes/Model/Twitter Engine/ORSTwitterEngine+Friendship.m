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
- (NSXMLNode *) befriendUserWithID:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"friendships/create.xml?user_id="];
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

// creates friendship with user
- (NSXMLNode *) befriendUserWithScreenName:(NSString *)screenName {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"friendships/create.xml?screen_name="];
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

// discontinues friendship with user
- (NSXMLNode *) unfriendUserWithID:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"friendships/destroy.xml?user_id="];
	[path appendString:identifier];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"DELETE" 
																atPath:path 
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) unfriendUserWithScreenName:(NSString *)screenName {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"friendships/destroy.xml?screen_name="];
	[path appendString:screenName];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"DELETE" 
																atPath:path 
														 synchronously:NO]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

// tests if a friendship exists between two users (one way only)
- (BOOL) user:(NSString *)userA isFriendWithUser:(NSString *)userB {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"friendships/exists.xml?user_a="];
	[path appendString:userA];
	[path appendString:@"&user_b="];
	[path appendString:userB];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"GET"
																atPath:path 
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"friends"] &&
		[[node stringValue] isEqualToString:@"true"]) {
		return YES;
	} else {
		return NO;
	}
}

// returns detailed information about the relationship between two users
- (NSXMLNode *) friendshipBetweenUserWithID:(NSString *)identifierA
								  andUserWithID:(NSString *)identifierB {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"friendships/show.xml?source_id="];
	[path appendString:identifierA];
	[path appendString:@"&target_id="];
	[path appendString:identifierB];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"GET"
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"relationship"]) {
		return node;
	} else {
		return NULL;
	}
}

// returns detailed information about the relationship between two users
- (NSXMLNode *) friendshipOfAuthdUserToUserWithID:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
						stringWithString:@"friendships/show.xml?target_id="];
	[path appendString:identifier];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"GET"
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"relationship"]) {
		return node;
	} else {
		return NULL;
	}
}

// potentially you could have a couple of methods with screen names

@end
