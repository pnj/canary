//
//  ORSPreferences.h
//  Canary
//
//  Created by Νικόλαος Τουμπέλης on 08/06/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ORSTwitterEngine.h"
#import "ORSShortenerFactory.h"
#import "ORSTimelineCacheManager.h"

@interface ORSPreferences : NSObject {
	NSUserDefaults *defaults;
	ORSTwitterEngine *twitterEngine;
	ORSTimelineCacheManager *cacheManager;
}

- (NSString *) receivedDMIDSinceLastExecution;
- (NSString *) statusIDSinceLastExecution;
- (BOOL) willRetrieveAllUpdates;
- (int) selectedURLShortener;
- (NSUInteger) maxShownUpdates;
- (float) timelineRefreshPeriod;
- (void) saveLastIDs;

@property (assign) ORSTwitterEngine *twitterEngine;
@property (assign) NSUserDefaults *defaults;
@property (assign) ORSTimelineCacheManager *cacheManager;

@end
