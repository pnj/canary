//
//  ORSTwitterEngine+Timeline.m
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

@implementation ORSTwitterEngine ( TimelineMethods ) 

// returns the 20 most recent statuses from non-protected users who have set
// a custom user icon
- (NSArray *) publicTimeline {
	NSString *path = @"statuses/public_timeline.xml";
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

// returns the most recent statuses from non-protected users who have set
// a custom user icon since the given id
- (NSArray *) publicTimelineSinceStatus:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/public_timeline.xml?since_id="];
	[path appendString:identifier];
	[path appendString:@"&count=200"];
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

// returns the 20 most recent statuses from the current user and the people
// she follows
- (NSArray *) friendsTimeline {
	NSString *path = @"statuses/friends_timeline.xml";
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

// returns the most recent statuses from the current user and the people she 
// follows since the given status id
- (NSArray *) friendsTimelineSinceStatus:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/friends_timeline.xml?since_id="];
	[path appendString:identifier];
	[path appendString:@"&count=200"];
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

// returns the most recent statuses from the current user and the people she 
// follows since the given date
- (NSArray *) friendsTimelineSinceDate:(NSString *)date {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"statuses/friends_timeline.xml?since="];
	[path appendString:date];
	[path appendString:@"&count=200"];
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

// returns x most recent statuses from the current user and the people she 
// follows
- (NSArray *) friendsTimelineWithCount:(NSString *)count {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"statuses/friends_timeline.xml?count="];
	[path appendString:count];
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

// returns the 20 most recent statuses from the current user and the people she 
// follows for the given page
- (NSArray *) friendsTimelineAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString 
							 stringWithString:@"statuses/friends_timeline.xml?page="];
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

// returns the 20 most recent statuses from the current user
- (NSArray *) userTimeline {
	NSString *path = @"statuses/user_timeline.xml";
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

// returns the 20 most recent statuses from the current user since the given
// status id
- (NSArray *) userTimelineSinceStatus:(NSString *)identifier {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/user_timeline.xml?since_id="];
	[path appendString:identifier];
	[path appendString:@"&count=200"];
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

// returns x most recent statuses from the current user
- (NSArray *) userTimelineWithCount:(NSString *)count {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/user_timeline.xml?count="];
	[path appendString:count];
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

// returns the 20 most recent statuses from the current user since the given
// date
- (NSArray *) userTimelineSinceDate:(NSString *)date {
	NSMutableString *path = [NSMutableString 
			stringWithString:@"statuses/user_timeline.xml?since="];
	[path appendString:date];
	[path appendString:@"&count=200"];
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

// returns the 20 most recent statuses from the current user for the given page
- (NSArray *) userTimelineAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/user_timeline.xml?page="];
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

// returns the 20 most recent statuses from the specified user
- (NSArray *) userTimelineForUserWithScreenName:(NSString *)screenName {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/user_timeline.xml?screen_name="];
	[path appendString:screenName];
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

// returns x most recent statuses from the specified user
- (NSArray *) userTimelineForUserWithScreenName:(NSString *)screenName 
										  count:(NSString *)count {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/user_timeline.xml?screen_name="];
	[path appendString:screenName];
	[path appendString:@"&count="];
	[path appendString:count];
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

// returns the 20 most recent statuses from the specified user since the given
// date
- (NSArray *) userTimelineForUserWithScreenName:(NSString *)screenName 
							  sinceDate:(NSString *)date {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/user_timeline.xml?screen_name="];
	[path appendString:screenName];
	[path appendString:@"&since="];
	[path appendString:date];
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

// returns the 20 most recent statuses from the current user since the given
// status id
- (NSArray *) userTimelineForUserWithScreenName:(NSString *)screenName
									sinceStatus:(NSString *)statusID {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/user_timeline.xml?screen_name="];
	[path appendString:screenName];
	[path appendString:@"&since_id="];
	[path appendString:statusID];
	[path appendString:@"&count=200"];
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

// returns the 20 most recent statuses from the current user for the given page
- (NSArray *) userTimelineForUserWithScreenName:(NSString *)screenName
										 atPage:(NSString *)page {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/user_timeline.xml?screen_name="];
	[path appendString:screenName];
	[path appendString:@"&page="];
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

// maybe add methods with screen name as a parameter

// returns the 20 most recent mentions for the current user
- (NSArray *) mentions {
	NSString *path = @"statuses/mentions.xml";
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

// returns the 20 most recent mentions since the given status ID
- (NSArray *) mentionsSinceStatus:(NSString *)statusID {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/mentions.xml?since_id="];
	[path appendString:statusID];
	[path appendString:@"&count=200"];
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

// returns the 20 most recent mentions for the current user at the given page
- (NSArray *) mentionsAtPage:(NSString *)page {
	NSMutableString *path = [NSMutableString 
		stringWithString:@"statuses/mentions.xml?page="];
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

// returns the 20 most recent mentions since the given date
- (NSArray *) mentionsSinceDate:(NSString *)date {
	NSMutableString *path = [NSMutableString
		stringWithString:@"statuses/mentions.xml?since="];
	[path appendString:date];
	[path appendString:@"&count=200"];
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

@end
