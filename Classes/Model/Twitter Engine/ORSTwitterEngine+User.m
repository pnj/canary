//
//  ORSTwitterEngine+User.m
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

#import "ORSTwitterEngine+User.h"

@implementation ORSTwitterEngine ( UserMethods )

// returns extended information for a given user
- (NSXMLNode *) userWithID:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"users/show.xml?user_id="];
	[path appendString:identifier];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"GET" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

// returns extended information for user with a given email
- (NSXMLNode *) userWithScreenName:(NSString *)screenName {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"users/show.xml?screen_name="];
	[path appendString:screenName];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"GET" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}


// returns the current user's friends
- (NSArray *) friends {
	NSString *path = @"statuses/friends.xml";
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the specified user's friends
- (NSArray *) friendsOfUserWithID:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/friends.xml?user_id="];
	[path appendString:identifier];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the current user's next 100 friends
- (NSArray *) friendsAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/friends.xml?page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// unofficial? unsupported?
// returns the current user's friends since the given date
- (NSArray *) friendsSinceDate:(NSString *)date {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/friends.xml?since="];
	[path appendString:date];
	[path appendString:@"&count=200"];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the specified user's next 100 friends
- (NSArray *) friendsOfUserWithID:(NSString *)identifier
						   atPage:(NSString *)page {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"statuses/friends.xml?user_id="];
	[path appendString:identifier];
	[path appendString:@"&page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// unofficial? unsupported?
// get the specified user's friends since the given date
- (NSArray *) friendsOfUserWithID:(NSString *)identifier
						sinceDate:(NSString *)date {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/friends.xml?user_id="];
	[path appendString:identifier];
	[path appendString:@"&since="];
	[path appendString:date];
	[path appendString:@"&count=200"];
	NSData *data = [self executeRequestOfType:@"GET" 
			atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}


// returns the current user's followers
- (NSArray *) followers {
	NSString *path = @"statuses/followers.xml";
	NSData *data = [self executeRequestOfType:@"GET" 
			atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) { 
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the specified user's followers
- (NSArray *) followersOfUserWithID:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/followers.xml?user_id="];
	[path appendString:identifier];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the current user's next 100 followers
- (NSArray *) followersAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString
							 stringWithString:@"statuses/followers.xml?page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}

// returns the specified user's next 100 followers
- (NSArray *) followersOfUserWithID:(NSString *)identifier 
							 atPage:(NSString *)page {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/followers.xml?user_id="];
	[path appendString:identifier];
	[path appendString:@"&page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
					atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}


// unsupported? unofficial?
// returns a list of the users currently featured on the site
- (NSArray *) getFeatured {
	NSString *path = @"statuses/featured.xml";
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"users"]) {
		return [self usersFromData:data];
	} else {
		return NULL;
	}
}


// support for more variations and screen_name

@end
