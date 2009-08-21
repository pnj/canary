//
//  ORSTwitterEngine+Favorite.m
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

#import "ORSTwitterEngine+Favorite.h"

@implementation ORSTwitterEngine ( FavoritesMethods )

// gets the favorites for the current user
- (NSArray *) favorites {
	NSString *path = @"favorites.xml";
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET" 
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self nodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self statusesFromData:data];
		} else {
			return NULL;
		}
	} else {
		[self executeRequestOfType:@"GET" 
							atPath:path synchronously:synchronously];
		return NULL;
	}
}

// unofficial - gets the favorites for the current user since the given ID
- (NSArray *) favoritesSinceStatus:(NSString *)identifier {
	NSString *path = [NSString 
		stringWithFormat:@"favorites.xml?since_id=%@&count=200", identifier];
	if (synchronously) {
		NSData *data = [self executeRequestOfType:@"GET"
										   atPath:path 
									synchronously:synchronously];
		NSXMLNode *node = [self nodeFromData:data];
		if ([[node name] isEqualToString:@"statuses"]) {
			return [self statusesFromData:data];
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

// gets the favorites for the specified user
- (NSArray *) favoritesForUser:(NSString *)user {
	NSMutableString *path = [NSMutableString stringWithString:@"favorites/"];
	[path appendString:user];
	[path appendString:@".xml"];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path 
								 synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"statuses"]) {
		return [self statusesFromData:data];
	} else {
		return NULL;
	}
}

// gets the next 20 most recent favorites for the current user
- (NSArray *) favoritesAtPage:(NSString *)page {
	NSMutableString *path = 
		[NSMutableString stringWithString:@"favorites.xml?page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"statuses"]) {
		return [self statusesFromData:data];
	} else {
		return NULL;
	}
}

// gets the next 20 most recent favorites for the specified user
- (NSArray *) favoritesForUser:(NSString *)user 
						atPage:(NSString *)page {
	NSMutableString *path = [NSMutableString stringWithString:@"favorites/"];
	[path appendString:user];
	[path appendString:@".xml?page="];
	[path appendString:page];
	NSData *data = [self executeRequestOfType:@"GET" 
									   atPath:path 
								synchronously:synchronously];
	NSXMLNode *node = [self nodeFromData:data];
	if ([[node name] isEqualToString:@"statuses"]) {
		return [self statusesFromData:data];
	} else {
		return NULL;
	}
}

// creates a favorite status
- (NSXMLNode *) favoriteStatus:(NSString *)identifier {
	NSMutableString *path = [NSMutableString
		stringWithString:@"favorites/create/"];
	[path appendString:identifier];
	[path appendString:@".xml"];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
											 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"status"]) {
		return node;
	} else {
		return NULL;
	}
}

// creates a favorite status with no data
- (void) blindFavoriteStatus:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"favorites/create/"];
	[path appendString:identifier];
	[path appendString:@".xml"];
	[self simpleExecuteRequestOfType:@"POST" 
							  atPath:path
					   synchronously:synchronously];
}

// unfavorites the specified status
- (NSXMLNode *) unfavoriteStatus:(NSString *)identifier {
	NSMutableString *path = [NSMutableString
		stringWithString:@"favorites/destroy/"];
	[path appendString:identifier];
	[path appendString:@".xml"];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"DELETE" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"status"]) {
		return node;
	} else {
		return NULL;
	}
}

@end
