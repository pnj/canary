//
//  ORSTwitterEngine+Account.m
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

#import "ORSTwitterEngine+Account.h"

@implementation ORSTwitterEngine ( AccountMethods )

// verifies the user credentials
- (BOOL) verifyCredentials {
	NSString *path = @"account/verify_credentials.xml";
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"GET" 
																atPath:path 
														 synchronously:YES]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// gets the rate limit status
- (NSXMLNode *) rateLimitStatus {
	NSString *path = @"account/rate_limit_status.xml";
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"GET" 
																atPath:path
											 synchronously:synchronously]];
	//if (![[[node childAtIndex:0] name] isEqualToString:@"error"]) {
	if ([[node name] isEqualToString:@"hash"]) {
		return node;
	} else {
		return NULL;
	}
}

// ends the session of the authenticating user
- (BOOL) endSession {
	NSString *path = @"account/end_session.xml";
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path 
											 synchronously:synchronously]];
	if (node) {
		return YES;
	} else {
		return NO;
	}
}

// updates the delivery device
- (NSXMLNode *) deliverUpdatesToDevice:(NSString *)device {
	NSMutableString *path = [NSMutableString
		stringWithString:@"account/update_delivery_device.xml?device="];
	[path appendString:device];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
											 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) setProfileBackgroundColor:(NSColor *)newColor {
	NSMutableString *path = [NSMutableString stringWithString:
		@"account/update_profile_colors.xml?profile_background_color="];
	[path appendString:[newColor hexadecimalValue]];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) setProfileTextColor:(NSColor *)newColor {
	NSMutableString *path = [NSMutableString stringWithString:
		@"account/update_profile_colors.xml?profile_text_color="];
	[path appendString:[newColor hexadecimalValue]];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) setProfileLinkColor:(NSColor *)newColor {
	NSMutableString *path = [NSMutableString stringWithString:
		@"account/update_profile_colors.xml?profile_link_color="];
	[path appendString:[newColor hexadecimalValue]];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) setProfileSidebarFillColor:(NSColor *)newColor {
	NSMutableString *path = [NSMutableString stringWithString:
		@"account/update_profile_colors.xml?profile_sidebar_fill_color="];
	[path appendString:[newColor hexadecimalValue]];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) setProfileSidebarBorderColor:(NSColor *)newColor {
	NSMutableString *path = [NSMutableString stringWithString:
		@"account/update_profile_colors.xml?profile_sidebar_border_color="];
	[path appendString:[newColor hexadecimalValue]];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) setProfileImage:(NSString *)filename {
	NSMutableString *path = [NSMutableString stringWithString:
		@"account/update_profile_image.xml"];
	NSXMLNode *node = [self nodeFromData:[self uploadImageFile:filename 
													toTwitterPath:path
													synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) setProfileBackgroundImage:(NSString *)filename {
	NSMutableString *path = [NSMutableString stringWithString:
							 @"account/update_profile_background_image.xml"];
	NSXMLNode *node = [self nodeFromData:[self uploadImageFile:filename 
													toTwitterPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) setName:(NSString *)name {
	NSMutableString *path = [NSMutableString stringWithString:
		@"account/update_profile.xml?name="];
	[path appendString:name];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) setEmail:(NSString *)email {
	NSMutableString *path = [NSMutableString stringWithString:
		@"account/update_profile.xml?email="];
	[path appendString:email];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) setURL:(NSString *)URL {
	NSMutableString *path = [NSMutableString stringWithString:
		@"account/update_profile.xml?url="];
	[path appendString:URL];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
													synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

// specifies the user's location in their profile
- (NSXMLNode *) setLocation:(NSString *)location {
	NSMutableString *path = [NSMutableString
		stringWithString:@"account/update_profile.xml?location="];
	[path appendString:location];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
											 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

- (NSXMLNode *) setDescription:(NSString *)description {
	NSMutableString *path = [NSMutableString
		stringWithString:@"account/update_profile.xml?description="];
	[path appendString:description];
	NSXMLNode *node = [self nodeFromData:[self executeRequestOfType:@"POST" 
																atPath:path
												synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return node;
	} else {
		return NULL;
	}
}

@end
