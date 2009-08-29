//
//  ORSTimelineCacheManager.h
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

enum {
	ORSFollowingTimelineCacheType = 1,
	ORSArchiveTimelineCacheType = 2,
	ORSPublicTimelineCacheType = 3,
	ORSMentionsTimelineCacheType = 4,
	ORSFavoritesTimelineCacheType = 5,
	ORSReceivedMessagesTimelineCacheType = 6,
	ORSSentMessagesTimelineCacheType = 7
};
typedef NSUInteger ORSTimelineCacheTypes;

@interface ORSTimelineCacheManager : NSObject {

	// Intermediate caches
	NSMutableArray *followingStatusCache, *mentionsStatusCache, 
		*publicStatusCache, *archiveStatusCache, *receivedMessagesCache,
		*sentMessagesCache, *favoritesStatusCache;
	BOOL firstFollowingCall, firstMentionsCall, firstPublicCall, 
		firstArchiveCall, firstReceivedMessagesCall, firstSentMessagesCall,
		firstFavoriteCall;
	NSString *lastFollowingStatusID, *lastMentionStatusID, *lastPublicStatusID,
		*lastArchiveStatusID, *lastReceivedMessageID, *lastSentMessageID, 
		*lastFavoriteStatusID;
	
}

- (void) resetAllCaches;
- (NSMutableArray *) setStatusesForTimelineCache:(NSUInteger)timelineCacheType
					withNotification:(NSNotification *)note;

@property(copy) NSMutableArray *followingStatusCache, *mentionsStatusCache,
	*publicStatusCache, *archiveStatusCache, *receivedMessagesCache,
	*sentMessagesCache, *favoritesStatusCache;
@property() BOOL firstFollowingCall, firstMentionsCall, firstPublicCall,
	firstArchiveCall, firstReceivedMessagesCall, 
	firstSentMessagesCall, firstFavoriteCall;
@property(copy) NSString *lastFollowingStatusID, *lastMentionStatusID,
	*lastPublicStatusID, *lastArchiveStatusID, *lastReceivedMessageID, 
	*lastSentMessageID, *lastFavoriteStatusID;

@end
