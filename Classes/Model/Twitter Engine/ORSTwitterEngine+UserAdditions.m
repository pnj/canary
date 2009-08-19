//
//  ORSTwitterEngine+UserAdditions.m
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

#import "ORSTwitterEngine+UserAdditions.h"

@implementation ORSTwitterEngine ( UserAdditions )

#pragma mark User methods

// User methods

// returns the current user's friends
- (NSArray *) getFriends {
	NSString *path = @"statuses/friends.xml";
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the specified user's friends
- (NSArray *) getFriendsOfUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"statuses/friends/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the current user's next 100 friends
- (NSArray *) getFriendsAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"statuses/friends.xml?page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the current user's friends without their inline statuses
- (NSArray *) getFriendsLite {
	NSString *path = @"statuses/friends.xml?lite=true";
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the current user's next 100 friends without their inline statuses
- (NSArray *) getFriendsLiteAtPage:(int)page {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/friends.xml?lite=true&page="];
	[path appendString:[NSString stringWithFormat:@"%i", page]];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the current user's friends since the given date
- (NSArray *) getFriendsSince:(NSString *)date {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"statuses/friends.xml?since="];
	[path appendString:date];
	[path appendString:@"&count=200"];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the specified user's next 100 friends
- (NSArray *) getFriendsOfUser:(NSString *)userID
						atPage:(NSString *)page {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"statuses/friends/"];
	[path appendString:userID];
	[path appendString:@".xml?page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// get the specified user's friends without their inline statuses
- (NSArray *) getFriendsLiteOfUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"statuses/friends/"];
	[path appendString:userID];
	[path appendString:@".xml?lite=true"];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// get the specified user's friends since the given date
- (NSArray *) getFriendsOfUser:(NSString *)userID
						 since:(NSString *)date {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"statuses/friends/"];
	[path appendString:userID];
	[path appendString:@".xml?since="];
	[path appendString:date];
	[path appendString:@"&count=200"];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the current user's followers
- (NSArray *) getFollowers {
	NSString *path = @"statuses/followers.xml";
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) { 
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the specified user's followers
- (NSArray *) getFollowersOfUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"statuses/followers/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the current user's next 100 followers
- (NSArray *) getFollowersAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"statuses/followers.xml?page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the current user's followers without their inline statuses
- (NSArray *) getFollowersLite {
	NSString *path = @"statuses/followers.xml?lite=true";
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the specified user's next 100 followers
- (NSArray *) getFollowersOfUser:(NSString *)userID 
						  atPage:(NSString *)page {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"statuses/followers/"];
	[path appendString:userID];
	[path appendString:@".xml?page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the specified user's followers without their inline statuses
- (NSArray *) getFollowersLiteOfUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"statuses/followers/"];
	[path appendString:userID];
	[path appendString:@".xml?lite=true"];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns a list of the users currently featured on the site
- (NSArray *) getFeatured {
	NSString *path = @"statuses/featured.xml";
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self getNodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns extended information for a given user
- (NSXMLNode *) showUser:(NSString *)userID {
	NSMutableString *path = [NSMutableString stringWithString:@"users/show/"];
	[path appendString:userID];
	[path appendString:@".xml"];
	NSXMLNode *node = [self getNodeFromData:[self
		executeRequestOfType:@"GET" atPath:path synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

// returns extended information for user with a given email
- (NSXMLNode *) showUserWithEmail:(NSString *)email {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"users/show.xml?email="];
	[path appendString:email];
	NSXMLNode *node = [self getNodeFromData:[self
		executeRequestOfType:@"GET" atPath:path synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

@end
