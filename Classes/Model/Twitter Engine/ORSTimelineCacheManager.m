//
//  ORSTimelineCacheManager.m
//  Timeline Cache Controller
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

#import "ORSTimelineCacheManager.h"

@implementation ORSTimelineCacheManager

@synthesize followingStatusCache, mentionsStatusCache, publicStatusCache, 
	archiveStatusCache, receivedMessagesCache, sentMessagesCache,
	firstFollowingCall, firstMentionsCall, firstPublicCall, 
	firstArchiveCall, firstReceivedMessagesCall, firstSentMessagesCall,
	lastFollowingStatusID, lastMentionStatusID, lastPublicStatusID,
	lastArchiveStatusID, lastReceivedMessageID, lastSentMessageID, 
	favoritesStatusCache, firstFavoriteCall, lastFavoriteStatusID;

- (id) init {
	if (self = [super init]) {
		// Following cache
		followingStatusCache = [NSMutableArray array];
		firstFollowingCall = YES;
		lastFollowingStatusID = [NSString string];
		// Mentions cache
		mentionsStatusCache = [NSMutableArray array];
		firstMentionsCall = YES;
		lastMentionStatusID = [NSString string];
		// Public cache
		publicStatusCache = [NSMutableArray array];
		firstPublicCall = YES;
		lastPublicStatusID = [NSString string];
		// Archive cache
		archiveStatusCache = [NSMutableArray array];
		firstArchiveCall = YES;
		lastArchiveStatusID = [NSString string];
		// Received Messages cache
		receivedMessagesCache = [NSMutableArray array];
		firstReceivedMessagesCall = YES;
		lastReceivedMessageID = [NSString string];
		// Sent Messages cache
		sentMessagesCache = [NSMutableArray array];
		firstSentMessagesCall = YES;
		lastSentMessageID = [NSString string];
		// Favorites cache
		favoritesStatusCache = [NSMutableArray array];
		firstFavoriteCall = YES;
		lastFavoriteStatusID = [NSString string];
	}
	return self;
}

- (void) resetAllCaches {
	[favoritesStatusCache removeAllObjects];
	[followingStatusCache removeAllObjects];
	[mentionsStatusCache removeAllObjects];
	[publicStatusCache removeAllObjects];
	[archiveStatusCache removeAllObjects];
	[receivedMessagesCache removeAllObjects];
	[sentMessagesCache removeAllObjects];
	
	firstFavoriteCall = YES;
	firstFollowingCall = YES;
	firstMentionsCall = YES;
	firstPublicCall = YES;
	firstArchiveCall = YES;
	firstReceivedMessagesCall = YES;
	firstSentMessagesCall = YES;
}

- (NSMutableArray *) setStatusesForTimelineCache:(NSUInteger)timelineCacheType 
					withNotification:(NSNotification *)note{
	BOOL *firstCall;
	NSMutableArray *cache;
	NSString **lastStatusID;
	if (timelineCacheType == ORSFollowingTimelineCacheType) {
		firstCall = &firstFollowingCall;
		cache = followingStatusCache;
		lastStatusID = &lastFollowingStatusID;
	} else if (timelineCacheType == ORSArchiveTimelineCacheType) {
		firstCall = &firstArchiveCall;
		cache = archiveStatusCache;
		lastStatusID = &lastArchiveStatusID;
	} else if (timelineCacheType == ORSPublicTimelineCacheType) {
		firstCall = &firstPublicCall;
		cache = publicStatusCache;
		lastStatusID = &lastPublicStatusID;
	} else if (timelineCacheType == ORSMentionsTimelineCacheType) {
		firstCall = &firstMentionsCall;
		cache = mentionsStatusCache;
		lastStatusID = &lastMentionStatusID;
	} else if (timelineCacheType == ORSFavoritesTimelineCacheType) {
		firstCall = &firstFavoriteCall;
		cache = favoritesStatusCache;
		lastStatusID = &lastFavoriteStatusID;
	} else if (timelineCacheType == ORSReceivedMessagesTimelineCacheType) {
		firstCall = &firstReceivedMessagesCall;
		cache = receivedMessagesCache;
		lastStatusID = &lastReceivedMessageID;
	} else if (timelineCacheType == ORSSentMessagesTimelineCacheType) {
		firstCall = &firstSentMessagesCall;
		cache = sentMessagesCache;
		lastStatusID = &lastSentMessageID;
	}
	
	if (*firstCall) {
		[cache setArray:(NSArray *)[note object]];
	} else {
		NSIndexSet *indexSet = [NSIndexSet 
			indexSetWithIndexesInRange:NSMakeRange(0, 
				[(NSArray *)[note object] count])];
		[cache insertObjects:(NSArray *)[note object] atIndexes:indexSet];
	}
	
	NSError *error = NULL;
	if ([cache count] > 0) {
		NSXMLNode *lastNode = (NSXMLNode *)[cache objectAtIndex:0];
		NSArray *lastCreatedAt = [lastNode nodesForXPath:@".//id" error:&error];
		NSXMLNode *lastCreatedAtNode = (NSXMLNode *)[lastCreatedAt 
													 objectAtIndex:0];
		*lastStatusID = [[lastCreatedAtNode stringValue] retain];
		*firstCall = NO;
	}
	return cache;
}

@end
