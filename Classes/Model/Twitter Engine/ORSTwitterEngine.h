//
//  ORSTwitterEngine.h
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

#import <Cocoa/Cocoa.h>
#import "ORSSession.h"

#define DEVICE_NONE		@"none"
#define DEVICE_IM		@"im"
#define DEVICE_SMS		@"sms"

@interface ORSTwitterEngine : NSObject {

@private
	ORSSession *session;
	NSMutableData *dataReceived;
	BOOL synchronously;
	NSURLConnection *mainConnection;
	NSMutableArray *sessionQueue;
}

+ (ORSTwitterEngine *) sharedTwitterEngine;
+ (id) allocWithZone:(NSZone *)zone;
- (id) initSynchronously:(BOOL)synchr 
			  withUserID:(NSString *)userID
			 andPassword:(NSString *)password;
- (NSString *) sessionUserID;
- (void) setSessionUserID:(NSString *)theSessionUserID;
- (NSString *) sessionPassword;
- (void) setSessionPassword:(NSString *)theSessionPassword;
- (NSData *) executeRequestOfType:(NSString *)type
						   atPath:(NSString *)path
					synchronously:(BOOL)synchr;
- (NSData *) executeUnencodedRequestOfType:(NSString *)type
									atPath:(NSString *)path
							 synchronously:(BOOL)synchr;
- (void) simpleExecuteRequestOfType:(NSString *)type
							 atPath:(NSString *)path
					  synchronously:(BOOL)synchr;
- (NSData *) uploadImageFile:(NSString *)filename
			   toTwitterPath:(NSString *)path
			   synchronously:(BOOL)synchr;
- (NSXMLDocument *) getXMLDocumentFromData:(NSData *)data;
- (NSXMLNode *) getNodeFromData:(NSData *)userData;
- (NSArray *) getAllStatusesFromData:(NSData *)statuses;
- (NSArray *) usersFromData:(NSData *)data;
- (NSArray *) savedSearchesFromData:(NSData *)data;
- (NSArray *) IDsFromData:(NSData *)data;
- (NSArray *) getAllDMsFromData:(NSData *)directMessages;

// Status methods
- (NSArray *) getPublicTimeline;
- (NSArray *) getPublicTimelineSinceStatus:(NSString *)statusID;
- (NSArray *) getFriendsTimeline;
- (NSArray *) getFriendsTimelineSinceStatus:(NSString *)statusID;
- (NSArray *) getUserTimeline;
- (NSArray *) getUserTimelineForUser:(NSString *)userID;
- (NSArray *) getUserTimelineSinceStatus:(NSString *)statusID;
- (NSXMLNode *) sendUpdate:(NSString *)text inReplyTo:(NSString *)statusID;
- (NSArray *) getReplies;
- (NSArray *) getRepliesSinceStatus:(NSString *)statusID;

// Direct Message methods
- (NSArray *) getReceivedDMs;
- (NSArray *) getReceivedDMsSinceDM:(NSString *)dmID;
- (NSArray *) getSentDMs;
- (NSArray *) getSentDMsSinceDM:(NSString *)dmID;

// Friendship methods
- (BOOL) createFriendshipWithUser:(NSString *)userID;
- (BOOL) destroyFriendshipWithUser:(NSString *)userID;
- (BOOL) user:(NSString *)userIDA isFriendWithUser:(NSString *)userIDB;

- (NSXMLNode *) getDowntimeSchedule;

@property (copy) NSMutableData *dataReceived;
@property BOOL synchronously;
@property (copy) NSURLConnection *mainConnection;
@property (retain) ORSSession *session;

@end
