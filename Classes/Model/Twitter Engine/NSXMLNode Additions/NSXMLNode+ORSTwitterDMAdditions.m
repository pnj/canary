//
//  NSXMLNode+ORSTwitterDMAdditions.m
//  Twitter Engine - NSXMLNode Additions
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

#import "NSXMLNode+ORSTwitterDMAdditions.h"

@implementation NSXMLNode ( ORSTwitterDMAdditions )

// Returns the first XML for a given XPath
- (NSXMLNode *) firstNodeForXPath:(NSString *)xpathString {
	NSError *error = nil;
	NSArray *nodes = [self nodesForXPath:xpathString error:&error];
	NSXMLNode *firstNode = (NSXMLNode *)[nodes objectAtIndex:0];
	return firstNode;
}

// Direct Message Attributes (different from the status attributes)
 
// Returns the ID of the sender
- (NSString *) senderID {
	return [[self firstNodeForXPath:@".//sender_id"] stringValue];
}
 
// Returns the ID of the recipient
- (NSString *) recipientID {
	return [[self firstNodeForXPath:@".//recipient_id"] stringValue];
}
 
// Returns the screen name of the sender
- (NSString *) senderScreenName {
	return [[self firstNodeForXPath:@".//sender_screen_name"] stringValue];
}

// Returns the screen name of the recipient
- (NSString *) recipientScreenName {
	return [[self firstNodeForXPath:@".//recipient_screen_name"] stringValue];
}

// Returns the name of the sender
- (NSString *) senderName {
	return [[self firstNodeForXPath:@".//sender/name"] stringValue];
}

// Returns the location of the sender
- (NSString *) senderLocation {
	return [[self firstNodeForXPath:@".//sender/location"] stringValue];
}

// Returns the description of the sender
- (NSString *) senderDescription {
	return [[self firstNodeForXPath:@".//sender/description"] stringValue];
}
 
// Returns the profile image URL of the sender
- (NSString *) senderProfileImageURL {
	return [[self firstNodeForXPath:@".//sender/profile_image_url"] 
			stringValue];
}

// Returns the URL of the sender
- (NSString *) senderURL {
	return [[self firstNodeForXPath:@".//sender/url"] stringValue];
}

// Returns the protected status of the sender
- (NSString *) senderProtected {
	return [[self firstNodeForXPath:@".//sender/protected"] stringValue];
}

// Returns the followers count of the sender
- (NSString *) senderFollowersCount {
	return [[self firstNodeForXPath:@".//sender/followers_count"] stringValue];
}
 
// Returns the name of the recipient
- (NSString *) recipientName {
	return [[self firstNodeForXPath:@".//recipient/name"] stringValue];
}

// Returns the location of the recipient
- (NSString *) recipientLocation {
	return [[self firstNodeForXPath:@".//recipient/location"] stringValue];
}

// Returns the description of the recipient
- (NSString *) recipientDescription {
	return [[self firstNodeForXPath:@".//recipient/description"] stringValue];
}
 
// Returns the profile image URL of the recipient
- (NSString *) recipientProfileImageURL {
	return [[self firstNodeForXPath:@".//recipient/profile_image_url"] 
			stringValue];
}

// Returns the URL of the recipient
- (NSString *) recipientURL {
	return [[self firstNodeForXPath:@".//recipient/url"] stringValue];
}

// Returns the protected status of the recipient
- (NSString *) recipientProtected {
	return [[self firstNodeForXPath:@".//recipient/protected"] stringValue];
}

// Returns the followers count of the recipient
- (NSString *) recipientFollowersCount {
	return [[self firstNodeForXPath:@".//recipient/followers_count"] stringValue];
}

@end
