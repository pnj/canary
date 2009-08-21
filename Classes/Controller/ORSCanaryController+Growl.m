//
//  ORSCanaryController+Growl.m
//  Canary
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

#import "ORSCanaryController+Growl.h"

@implementation ORSCanaryController (Growl)

- (NSString *) userIdentifier:(NSXMLNode *)node {
	if (self.showScreenNames) {
		return node.userName;
	} else {
		return node.userScreenName;
	}
}

- (NSString *) senderIdentifier:(NSXMLNode *)node {
	if (self.showScreenNames) {
		return node.senderName;
	} else {
		return node.senderScreenName;
	}
}

- (NSString *) recipientIdentifier:(NSXMLNode *)node {
	if (self.showScreenNames) {
		return node.recipientName;
	} else {
		return node.recipientScreenName;
	}
}

// Posts notifications that status updates have been received
- (void) postStatusUpdatesReceived:(NSNotification *)note {
	NSMutableArray *newStatuses = [[NSMutableArray alloc] init];
	for (NSXMLNode *node in (NSArray *)note.object) {
		if ([node.ID substringFromIndex:3].intValue > 
				[[preferences statusIDSinceLastExecution] substringFromIndex:3].intValue) {
			[newStatuses addObject:node];
		}
	}
	if (newStatuses.count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Status Updates Received"
			description:[NSString 
				stringWithFormat:@"%i status updates received", 
					((NSArray *)note.object).count]
							   notificationName:@"Status Updates Received"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:@""];
	} else {
		for (NSXMLNode *node in newStatuses) {
			NSMutableDictionary *contextDict = [NSMutableDictionary new];
			[contextDict setObject:@"Friends" forKey:@"Timeline"];
			[contextDict setObject:node.ID forKey:@"ID"];
			NSData *iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
					URLWithString:node.userProfileImageURL]];
			[GrowlApplicationBridge notifyWithTitle:[self userIdentifier:node]
		description:[NSString replaceHTMLEntities:node.text]
								   notificationName:@"Status Updates Received"
										   iconData:iconData
										   priority:1
										   isSticky:NO
									   clickContext:contextDict];
		}
	}
}

// Posts notifications that mentions have been received
- (void) postMentionsReceived:(NSNotification *)note {
	NSMutableArray *newMentions = [[NSMutableArray alloc] init];
	for (NSXMLNode *node in (NSArray *)note.object) {
		if ([node.ID substringFromIndex:3].intValue > 
			[[preferences statusIDSinceLastExecution] substringFromIndex:3].intValue) {
			[newMentions addObject:node];
		}
	}
	if (newMentions.count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Mentions Received"
			description:[NSString stringWithFormat:@"%i mentions received", 
												 ((NSArray *)note.object).count]
							   notificationName:@"Mentions Received"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:@""];
	} else {
		for (NSXMLNode *node in newMentions) {
			NSMutableDictionary *contextDict = [NSMutableDictionary new];
			[contextDict setObject:@"Mentions" forKey:@"Timeline"];
			[contextDict setObject:node.ID forKey:@"ID"];
			NSData *iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
					URLWithString:node.userProfileImageURL]];
			[GrowlApplicationBridge notifyWithTitle:[self userIdentifier:node]
				description:[NSString replaceHTMLEntities:node.text]
								   notificationName:@"Mentions Received"
										   iconData:iconData
										   priority:1
										   isSticky:NO
									   clickContext:contextDict];
		}
	}
}

// Posts notifications that messages have been received
- (void) postDMsReceived:(NSNotification *)note {
	NSMutableArray *newReceivedMessages = [[NSMutableArray alloc] init];
	for (NSXMLNode *node in (NSArray *)note.object) {
		if ([node.ID substringFromIndex:3].intValue > 
			[[preferences receivedDMIDSinceLastExecution] substringFromIndex:3].intValue) {
			[newReceivedMessages addObject:node];
		}
	}
	if (newReceivedMessages.count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Direct Messages Received"
				description:[NSString 
					stringWithFormat:@"%i direct messages received", 
												 ((NSArray *)note.object).count]
							   notificationName:@"Direct Messages Received"
									   iconData:nil
									   priority:1
									   isSticky:YES
								   clickContext:@""];
	} else {
		for (NSXMLNode *node in newReceivedMessages) {
			NSMutableDictionary *contextDict = [NSMutableDictionary new];
			[contextDict setObject:@"Received messages" forKey:@"Timeline"];
			[contextDict setObject:node.ID forKey:@"ID"];
			NSData *iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
					URLWithString:node.senderProfileImageURL]];
			[GrowlApplicationBridge notifyWithTitle:[self senderIdentifier:node]
				description:[NSString replaceHTMLEntities:node.text]
								   notificationName:@"Direct Messages Received"
										   iconData:iconData
										   priority:2
										   isSticky:NO
									   clickContext:contextDict];
		}
	}
}

// Posts notifications that messages with larger id that the given have been
// received
- (void) postDMsReceived:(NSNotification *)note
				 afterID:(NSString *)messageID {
	// This can be optimised
	int count = 0;
	for (NSXMLNode *node in (NSArray *)note.object) {
		if (node.ID.intValue > messageID.intValue) {
			count++;
		}
	}
	
	if (count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Direct Messages Received"
			description:[NSString 
				stringWithFormat:@"%i direct messages received", 
												 ((NSArray *)note.object).count]
							   notificationName:@"Direct Messages Received"
									   iconData:nil
									   priority:1
									   isSticky:YES
								   clickContext:@""];
	} else {
		for (NSXMLNode *node in (NSArray *)note.object) {
			if ([node.ID substringFromIndex:3].intValue > [messageID substringFromIndex:3].intValue) {
				NSMutableDictionary *contextDict = [NSMutableDictionary new];
				[contextDict setObject:@"Received messages" forKey:@"Timeline"];
				[contextDict setObject:node.ID forKey:@"ID"];
				NSData *iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
						URLWithString:node.senderProfileImageURL]];
				[GrowlApplicationBridge notifyWithTitle:[self senderIdentifier:node]
					description:[NSString replaceHTMLEntities:node.text]
									   notificationName:@"Direct Messages Received"
											   iconData:iconData
											   priority:2
											   isSticky:NO
										   clickContext:contextDict];
			}
		}
	}
}

// Posts a notification that a status update has been sent
- (void) postStatusUpdatesSent:(NSNotification *)note {
	//if (((NSArray *)note.object).count > 10) {
	if ([[note.object class] isEqualTo:[NSArray class]]) {
		if (((NSArray *)note.object).count > 10) {
			[GrowlApplicationBridge notifyWithTitle:@"Status Updates Sent"
										description:[NSString stringWithFormat:@"%i status updates sent", 
													 ((NSArray *)note.object).count]
								   notificationName:@"Status Updates Sent"
										   iconData:nil
										   priority:1
										   isSticky:NO
									   clickContext:@""];
		} else {
			for (NSXMLNode *node in (NSArray *)note.object) {
				NSMutableDictionary *contextDict = [NSMutableDictionary new];
				[contextDict setObject:@"Friends" forKey:@"Timeline"];
				[contextDict setObject:node.ID forKey:@"ID"];
				NSData *iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
																		  URLWithString:node.userProfileImageURL]];
				[GrowlApplicationBridge notifyWithTitle:[self userIdentifier:node]
											description:[NSString replaceHTMLEntities:node.text]
									   notificationName:@"Status Updates Sent"
											   iconData:iconData
											   priority:0
											   isSticky:NO
										   clickContext:contextDict];
			}
		}
	} else {
		NSXMLNode *node = (NSXMLNode *)note.object;
		NSMutableDictionary *contextDict = [NSMutableDictionary new];
		[contextDict setObject:@"Friends" forKey:@"Timeline"];
		[contextDict setObject:node.ID forKey:@"ID"];
		NSData *iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
																  URLWithString:node.userProfileImageURL]];
		[GrowlApplicationBridge notifyWithTitle:[self userIdentifier:node]
									description:[NSString replaceHTMLEntities:node.text]
							   notificationName:@"Status Updates Sent"
									   iconData:iconData
									   priority:0
									   isSticky:NO
								   clickContext:contextDict];
	}
	
}

// Posts a notification that a message has been sent
- (void) postDMsSent:(NSNotification *)note {
	if (((NSArray *)note.object).count > 10) {
		[GrowlApplicationBridge notifyWithTitle:@"Direct Messages Sent"
			description:[NSString stringWithFormat:@"%i direct messages sent", 
												 ((NSArray *)note.object).count]
							   notificationName:@"Direct Messages Sent"
									   iconData:nil
									   priority:1
									   isSticky:NO
								   clickContext:@""];
	} else {
		for (NSXMLNode *node in (NSArray *)note.object) {
			NSMutableDictionary *contextDict = [NSMutableDictionary new];
			[contextDict setObject:@"Sent messages" forKey:@"Timeline"];
			[contextDict setObject:node.ID forKey:@"ID"];
			NSData *iconData = [[NSData alloc] initWithContentsOfURL:[NSURL 
				URLWithString:node.recipientProfileImageURL]];
			[GrowlApplicationBridge notifyWithTitle:[self 
											recipientIdentifier:node]
				description:[NSString replaceHTMLEntities:node.text]
								   notificationName:@"Direct Messages Sent"
										   iconData:iconData
										   priority:0
										   isSticky:NO
									   clickContext:contextDict];
		}
	}
}

- (void) growlNotificationWasClicked:(id)clickContext {
	NSDictionary *contextDict = (NSDictionary *)clickContext;
	NSString *statusID = [contextDict objectForKey:@"ID"];
	NSString *timeline = [contextDict objectForKey:@"Timeline"];
	if (![statusID isEqualToString:@""]) {
		if ([timeline isEqualToString:@"Friends"] || 
			[timeline isEqualToString:@"Mentions"]) {
			for (NSXMLNode *node in [statusArrayController arrangedObjects]) {
				if ([node.ID isEqualToString:statusID]) {
					[statusArrayController setSelectedObjects:[NSArray 
										arrayWithObject:node]];
					break;
				}
			}
		} else if ([timeline isEqualToString:@"Received messages"]) {
			/*if (![timelineButton.titleOfSelectedItem 
				  isEqualToString:@"Received messages"]) {
				[self changeToReceivedDMs:self];
			}*/
			if (!(timelineSegControl.selectedSegment == 2)) {
				[self changeToReceivedDMs:self];
			}
			for (NSXMLNode *node in [receivedDMsArrayController 
									 arrangedObjects]) {
				if ([node.ID isEqualToString:statusID]) {
					[receivedDMsArrayController setSelectedObjects:[NSArray 
						arrayWithObject:node]];
					break;
				}
			}
		} else {
			for (NSXMLNode *node in [sentDMsArrayController arrangedObjects]) {
				if ([node.ID isEqualToString:statusID]) {
					[sentDMsArrayController setSelectedObjects:[NSArray 
						arrayWithObject:node]];
					break;
				}
			}
		}
	}
	[self showWindow:nil];
	[self.window makeKeyAndOrderFront:self.window];
}

@end
