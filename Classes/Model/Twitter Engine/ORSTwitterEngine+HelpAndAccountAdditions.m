//
//  ORSTwitterEngine+HelpAndAccountAdditions.m
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

#import "ORSTwitterEngine+HelpAndAccountAdditions.h"

@implementation ORSTwitterEngine ( HelpAndAccountAdditions )

#pragma mark Account methods

// Account methods

// specifies the user's location in their profile
- (BOOL) specifyLocation:(NSString *)location {
	NSMutableString *path = [NSMutableString
		stringWithString:@"account/update_location.xml?location="];
	[path appendString:location];
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"GET" atPath:path
				 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// updates the delivery device
- (BOOL) updateDeliveryDeviceWith:(NSString *)device {
	NSMutableString *path = [NSMutableString
		stringWithString:@"account/update_delivery_device.xml?device="];
	[path appendString:device];
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"POST" atPath:path
				 synchronously:synchronously]];
	if ([[node name] isEqualToString:@"user"]) {
		return YES;
	} else {
		return NO;
	}
}

// gets the rate limit status
- (NSXMLNode *) getRateLimitStatus {
	NSString *path = @"account/rate_limit_status.xml";
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"GET" atPath:path
			synchronously:synchronously]];
	if (![[[node childAtIndex:0] name] isEqualToString:@"error"]) {
		return node;
	} else {
		return NULL;
	}
}


#pragma mark Help methods

// gets Twitter downtime schedule
- (NSXMLNode *) getDowntimeSchedule {
	NSString *path = @"help/downtime_schedule.xml";
	NSXMLNode *node = [self getNodeFromData:[self 
		executeRequestOfType:@"GET" atPath:path synchronously:synchronously]];
	if (![[[node childAtIndex:0] name] isEqualToString:@"error"]) {
		return node;
	} else {
		return NULL;
	}
}

@end
