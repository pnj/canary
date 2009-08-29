//
//  ORSCanaryController.m
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
#include <math.h>

@implementation ORSCanaryController

@synthesize visibleUserID, preferences,
			previousTimeline, authenticator, twitterEngine, urlShortener, 
			updateDispatcher, cacheManager, aboutWindow, statusTextField, 
			statusView, statusBox, dateDifferenceTextField, indicator,
			mainTimelineCollectionView, mainTimelineScrollView, tweetButton,
			newStatusTextField, charsLeftIndicator, sentDMBox, //timelineButton,
			contentView, statusTimelineCollectionViewItem, sentDMTextField,
			sentDMView, receivedDMTextField, betweenUsers, realSelectedRange,
			receivedDMView, receivedDMBox, receivedDMDateDifferenceTextField,
			sentDMDateDifferenceTextField, statusArrayController, defaults, 
			refreshTimer, loginItem, prevUserID, prevPassword, spokenCommands,
			recognizer, firstBackgroundReceivedDMRetrieval, showScreenNames,
			statusBarImageView, statusBarTextField, statusBarButton;

@dynamic statuses, receivedDirectMessages, sentDirectMessages;

static ORSCanaryController *sharedCanaryController = nil;

// sharedController
+ (ORSCanaryController *) sharedController {
    @synchronized(self) {
        if (sharedCanaryController == nil) {
            [[self alloc] init];
        }
    }
    return sharedCanaryController;
}

// allocWithZone
+ (id) allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedCanaryController == nil) {
			return [super allocWithZone:zone];
        }
    }
	return sharedCanaryController;
}

// copyWihtZone
- (id) copyWithZone:(NSZone *)zone {
	return self;
}

// Initialize
+ (void) initialize {
	ORSFilterTransformer *filterTransformer;
	filterTransformer = [[ORSFilterTransformer alloc] init];
	[NSValueTransformer setValueTransformer:filterTransformer
									forName:@"FilterTransformer"];
	
	ORSFilterArrayTransformer *filterArrayTransformer;
	filterArrayTransformer = [[ORSFilterArrayTransformer alloc] init];
	[NSValueTransformer setValueTransformer:filterArrayTransformer
									forName:@"FilterArrayTransformer"];
	
	ORSScreenNameToBooleanTransformer *screenNameToBoolTransformer;
	screenNameToBoolTransformer = [[ORSScreenNameToBooleanTransformer alloc] init];
	[NSValueTransformer setValueTransformer:screenNameToBoolTransformer
									forName:@"ScreenNameToBoolTransformer"];
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *appDefaults = [NSMutableDictionary dictionary];
	[appDefaults setObject:[NSNumber numberWithFloat:0.0]
					forKey:@"CanaryWindowX"];
	[appDefaults setObject:[NSNumber numberWithFloat:0.0]
					forKey:@"CanaryWindowY"];
	[appDefaults setObject:[NSNumber numberWithFloat:339.0]
					forKey:@"CanaryWindowWidth"];
	[appDefaults setObject:[NSNumber numberWithFloat:530.0]
					forKey:@"CanaryWindowHeight"];
	[appDefaults setObject:@"Every minute" forKey:@"CanaryRefreshPeriod"];
	[appDefaults setObject:@"80" forKey:@"CanaryMaxShownUpdates"];
	[appDefaults setObject:@"Cli.gs" forKey:@"CanarySelectedURLShortener"];
	[appDefaults setObject:[NSNumber numberWithBool:YES]
					forKey:@"CanaryWillShortenPastedURLs"];
	[appDefaults setObject:[NSNumber numberWithBool:NO]
									forKey:@"CanaryWillRetrieveAllUpdates"];
	[appDefaults setObject:[NSNumber numberWithBool:YES]
					forKey:@"CanaryFirstTimeUser"];
	[appDefaults setObject:[NSNumber numberWithBool:YES]
					forKey:@"CanaryShowScreenNames"];
	[appDefaults setObject:[NSArray array]
					forKey:@"CanaryFilters"];
	[appDefaults setObject:[NSNumber numberWithBool:YES]
					forKey:@"CanaryUseAutocomplete"];
	[defaults registerDefaults:appDefaults];
}

// Init
- (id) init {
	Class canaryControllerClass = [self class];
	@synchronized(canaryControllerClass) {
		if (sharedCanaryController == nil) {
			if (self = [super init]) {
				sharedCanaryController = self;
				[GrowlApplicationBridge setGrowlDelegate:self];
				connectionErrorShown = NO;
		
				defaults = [NSUserDefaults standardUserDefaults];
				authenticator = [[ORSCredentialsManager alloc] init];
				cacheManager = [[ORSTimelineCacheManager alloc] init];
		
				// NotificationCenter stuff -- need to determine a way to find
				// which method to call
				NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
				[nc addObserver:self
					   selector:@selector(setStatusesAsynchronously:)
						   name:@"OTEStatusesDidFinishLoading"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(setUsersAsynchronously:)
						   name:@"OTEUsersDidFinishLoading"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(setDMsAsynchronously:)
						   name:@"OTEDMsDidFinishLoading"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(addSentStatusAsynchronously:)
						   name:@"OTEStatusDidFinishLoading"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(addSentDMsAsynchronously:)
						   name:@"OTEDMDidFinishSending"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(showConnectionFailure:)
						   name:@"OTEConnectionFailure"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(showReceivedResponse:)
						   name:@"OTEReceivedResponse"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(textDidEndEditing:)
						   name:@"NSTextDidEndEditingNotification"
						 object:nil];
				[nc addObserver:self
					   selector:@selector(printTwitPicURL:)
						   name:@"OTEReceivedTwitPicResponse"
						 object:nil];
		
				spokenCommands = [NSArray 
					arrayWithObjects:@"Tweet", @"Home", @"Refresh", nil];
		
				previousTimeline = @"";
				
				[self updateMaxNoOfShownUpdates];
		
				if ([defaults stringForKey:@"CanaryCurrentUserID"]) {
					NSString *sessionUserID = 
						[defaults stringForKey:@"CanaryCurrentUserID"];
					NSString *sessionPassword = NULL;
					if ([authenticator hasPasswordForUser:sessionUserID]) {
						sessionPassword = [authenticator 
										   passwordForUser:sessionUserID];
						twitterEngine = [[ORSTwitterEngine alloc] 
							initSynchronously:NO
								withUserID:sessionUserID 
									andPassword:sessionPassword];
						[self setVisibleUserID:[NSString 
								stringWithFormat:@"  %@",
									twitterEngine.sessionUserID]];
					} else {
						twitterEngine = [[ORSTwitterEngine alloc] 
							initSynchronously:NO 
								withUserID:sessionUserID 
									andPassword:NULL];
					}
				} else {
					loginItem = nil;
					twitterEngine = [[ORSTwitterEngine alloc] 
						initSynchronously:NO 
							withUserID:NULL 
								andPassword:NULL];
					[self setVisibleUserID:@"  Click here to login"];
				}
				[self updateSelectedURLShortener];
		
				updateDispatcher = [[ORSUpdateDispatcher alloc] 
										initWithEngine:twitterEngine];
		
				if ([preferences willRetrieveAllUpdates]) {
					cacheManager.firstFollowingCall = NO;
					cacheManager.lastFollowingStatusID = 
						[preferences statusIDSinceLastExecution];
				}
		
				firstBackgroundReceivedDMRetrieval = YES;
				firstFollowingTimelineRun = YES;
		
				NSString *lastExecutionID = [preferences 
								receivedDMIDSinceLastExecution];
				cacheManager.lastReceivedMessageID = lastExecutionID;
		
				betweenUsers = NO;
				
				previousUpdateText = @"";
				
				activeSegment = -1;
			}
		}
		preferences = [[ORSCanaryPreferences alloc] 
					   initWithEngine:twitterEngine
					   cacheManager:cacheManager];
	}
	return sharedCanaryController;
}

// Awake From Nib
- (void) awakeFromNib {
	if ([defaults floatForKey:@"CanaryWindowX"]) {
		NSRect newFrame = NSMakeRect([defaults floatForKey:@"CanaryWindowX"],
							[defaults floatForKey:@"CanaryWindowY"],
							[defaults floatForKey:@"CanaryWindowWidth"],
							[defaults floatForKey:@"CanaryWindowHeight"]);
		[[self window] setFrame:newFrame display:YES];
	}
	
	ORSDateDifferenceFormatter *dateDiffFormatter = 
					[[ORSDateDifferenceFormatter alloc] init];
	
	[[dateDifferenceTextField cell] setFormatter:dateDiffFormatter];
	[[receivedDMDateDifferenceTextField cell] setFormatter:dateDiffFormatter];
	[[sentDMDateDifferenceTextField cell] setFormatter:dateDiffFormatter];
	
	if ([defaults boolForKey:@"CanaryShowScreenNames"]) {
		[switchNamesMenuItem setTitle:@"Switch to Usernames"];
		[self changeToScreenNames];
		showScreenNames = YES;
		[viewOptionsNamesControl setSelectedSegment:1];
		namesSelectedSegment = 1;
	} else {
		[switchNamesMenuItem setTitle:@"Switch to Screen Names"];
		[self changeToUsernames];
		showScreenNames = NO;
		[viewOptionsNamesControl setSelectedSegment:0];
		namesSelectedSegment = 0;
	}
	
	NSMenuItem *instaFilterMenuItem = [[NSMenuItem alloc] init];
	[instaFilterMenuItem setTitle:@"InstaFilter"];
	[instaFilterMenuItem setView:instaFilterBox];
	[viewMenu insertItem:instaFilterMenuItem atIndex:5];
	[viewMenu insertItem:[NSMenuItem separatorItem] atIndex:6];
	[[NSApp mainMenu] setSubmenu:availableFiltersMenu
						 forItem:filterMenuItem];
	
	NSArray *placeholders = [NSArray arrayWithObjects:@"compose a haiku »", 
		@"vent some steam »", @"compile a eulogy »", 
		@"scribble your pithy words »", @"scrawl an incantation »", 
		@"write a polemic »", @"write stuff »", @"formulate an opinion »", 
		@"drop a line »", @"register your sentiment »",
		@"stay in touch with your fans »", @"compose a song »", 
		@"put forward a theory »", @"share an interesting link »", 
		@"speculate »", nil];
	srandom([NSDate timeIntervalSinceReferenceDate]);
	NSInteger rNumb = random() % 15;
	[[newStatusTextField cell] setPlaceholderString:[placeholders 
													 objectAtIndex:rNumb]];
	NSLog(@"%i", rNumb);
}

// Delegate: calls all the necessary methods when the app starts
- (void) applicationDidFinishLaunching:(NSNotification *)aNotification {
	if (![defaults objectForKey:@"CanaryFirstTimeUser"] ||
		[[defaults objectForKey:@"CanaryFirstTimeUser"] isEqualToNumber:[NSNumber numberWithBool:YES]] || ![twitterEngine sessionUserID]) {
		[self showNewUserWindow];
		[defaults setObject:[NSNumber numberWithBool:NO]
					 forKey:@"CanaryFirstTimeUser"];
	}
	[timelineSegControl setSelectedSegment:0];
	[self changeSegmentedControlTimeline:timelineSegControl];
}

// Delegate: closes the application when the window is closed
- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *) 
sender {
	return [defaults boolForKey:@"CanaryWillExitOnWindowClose"];
}

// Action: allows the user to send an update to Twitter
- (IBAction) sendUpdate:sender {
	if ([twitterEngine sessionUserID]) {
		// Counter readjustment
		[charsLeftIndicator setIntValue:0];
		[charsLeftIndicator setMaxValue:140];
		[charsLeftIndicator setCriticalValue:140];
		[charsLeftIndicator setWarningValue:125];
		
		// Commands
		if ([newStatusTextField.stringValue hasPrefix:@"%f "]) {
			[self createFriendshipWithUser:
				[newStatusTextField.stringValue substringFromIndex:3]];
		} else if ([newStatusTextField.stringValue hasPrefix:@"%l "]) {
			[self destroyFriendshipWithUser:
				[newStatusTextField.stringValue substringFromIndex:3]];
		} else if ([newStatusTextField.stringValue hasPrefix:@"%b "]) {
			[self showUserBlockAlertSheet:
				[newStatusTextField.stringValue substringFromIndex:3]];
		} else if ([newStatusTextField.stringValue hasPrefix:@"%u "]) {
			[self unblockUserWithScreenName:
				[newStatusTextField.stringValue substringFromIndex:3]];
		} else {
			previousUpdateText = [[newStatusTextField stringValue] copy];
			[updateDispatcher addMessage:[newStatusTextField stringValue]];
		}
		newStatusTextField.stringValue = @"";
		[self updateNewStatusTextField];
		[self showAnimatedStatusBarMessage:@"Sending data to Twitter..."];
	}
}

- (IBAction) retypePreviousUpdate:sender {
	[self insertStringTokenInNewStatusTextField:previousUpdateText];
}

// Action: allows the user to change the active timeline
- (IBAction) changeSegmentedControlTimeline:sender {
	NSSegmentedControl *timelineControl = (NSSegmentedControl *)sender;
	if (timelineControl.selectedSegment == activeSegment) {
		return;
	}
	if (showScreenNames) {
		[self changeToScreenNames];
	} else {
		[self changeToUsernames];
	}
	
	if (timelineControl.selectedSegment == 0) {
		if ([cacheManager.followingStatusCache count] > 0) {
			self.statuses = cacheManager.followingStatusCache;
		}
		[self getFriendsTimeline];
		[self.window setTitle:@"Canary: Friends"];
	} else if (timelineControl.selectedSegment == 1) {
		if ([cacheManager.mentionsStatusCache count] > 0) {
			self.statuses = cacheManager.mentionsStatusCache;
		}
		[self getMentions];
		[self.window setTitle:@"Canary: Mentions"];
	} else if (timelineControl.selectedSegment == 2) {
		if ([[cacheManager receivedMessagesCache] count] > 0) {
			self.receivedDirectMessages = cacheManager.receivedMessagesCache;
		}
		[self getReceivedMessages];
		[self.window setTitle:@"Canary: Messages"];
		[self hideStatusBar];
	} else if (timelineControl.selectedSegment == 3) {
		if ([cacheManager.favoritesStatusCache count] > 0) {
			self.statuses = cacheManager.favoritesStatusCache;
		}
		[self getFavorites];
		[self.window setTitle:@"Canary: Favorites"];
	}
	[self updateTimer];
}

- (IBAction) friendsTimelineMenuItemClicked:sender {
	[timelineSegControl setSelectedSegment:0];
	[self changeSegmentedControlTimeline:timelineSegControl];
}

- (IBAction) mentionsTimelineMenuItemClicked:sender {
	[timelineSegControl setSelectedSegment:1];
	[self changeSegmentedControlTimeline:timelineSegControl];
}

- (IBAction) messagesTimelineMenuItemClicked:sender {
	[timelineSegControl setSelectedSegment:2];
	[self changeSegmentedControlTimeline:timelineSegControl];
}

- (IBAction) favoritesTimelineMenuItemClicked:sender {
	[timelineSegControl setSelectedSegment:3];
	[self changeSegmentedControlTimeline:timelineSegControl];
}

// Scrolls timeline to the top
- (void) scrollToTop {
    NSPoint newScrollOrigin;
	NSScrollView *scrollView = mainTimelineScrollView;

    if ([scrollView.documentView isFlipped]) {
        newScrollOrigin = NSMakePoint(0.0,0.0);
    } else {
        newScrollOrigin = NSMakePoint(0.0,
			NSMaxY([scrollView.documentView frame]) - NSHeight(scrollView.contentView.bounds));
    }
    [scrollView.documentView scrollPoint:newScrollOrigin];
}

// Updates the current timer (according to the user's settings)
- (void) updateTimer {
	float refreshPeriod = [preferences timelineRefreshPeriod];
	[refreshTimer invalidate];
	refreshTimer = nil;
	if (![backgroundReceivedDMTimer isValid])
		[self setupReceivedDMTimer];
	if (refreshPeriod > -1.0) {
		if (timelineSegControl.selectedSegment == 0) {
			refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshPeriod 
				target:self selector:@selector(getFriendsTimeline) userInfo:nil 
														   repeats:YES];
		} else if (timelineSegControl.selectedSegment == 1) { 
			refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshPeriod
					target:self selector:@selector(getMentions) userInfo:nil 
														   repeats:YES];
		} else if (timelineSegControl.selectedSegment == 3) {
			refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshPeriod
				target:self selector:@selector(getFavorites) userInfo:nil 
														   repeats:YES];
		} else if (timelineSegControl.selectedSegment == 2) {
			refreshTimer = [NSTimer scheduledTimerWithTimeInterval:refreshPeriod
				target:self selector:@selector(getReceivedMessages) userInfo:nil 
														   repeats:YES];
		}
	}
}

// Sets up the timer for background tracking of direct messages
- (void) setupReceivedDMTimer {
	[backgroundReceivedDMTimer invalidate];
	backgroundReceivedDMTimer = nil;
	backgroundReceivedDMTimer = [NSTimer scheduledTimerWithTimeInterval:300.0
		target:self selector:@selector(getReceivedMessages) 
								userInfo:nil repeats:YES];
	[self performSelector:@selector(getReceivedMessages)
			   withObject:nil
			   afterDelay:3.0];
}

// Updates the maximum number of shown updates (according to the user's 
// settings)
- (void) updateMaxNoOfShownUpdates {
	int maxNoOfShownUpdates = [preferences maxShownUpdates];
	[mainTimelineCollectionView setMaxNumberOfRows:maxNoOfShownUpdates];
}

// Updates the selected URL shortener (according to the user's settings)
- (void) updateSelectedURLShortener {
	urlShortener = [ORSShortenerFactory getShortener:[preferences
													  selectedURLShortener]];
}

// Sets statuses asynchronously
- (void) setStatusesAsynchronously:(NSNotification *)note {	
	if (connectionErrorShown) {
		[self hideStatusBar];
		connectionErrorShown = NO;
	}
	
	NSPoint oldScrollOrigin = mainTimelineScrollView.contentView.bounds.origin;
	if (timelineSegControl.selectedSegment == 0) {
		[mainTimelineCollectionView unbind:@"content"];
		[mainTimelineCollectionView unbind:@"selectionIndexes"];
		[mainTimelineCollectionView setItemPrototype:NULL];
		[mainTimelineCollectionView bind:@"content"
								toObject:statusArrayController
							 withKeyPath:@"arrangedObjects"
								 options:nil];
		[mainTimelineCollectionView bind:@"selectionIndexes"
								toObject:statusArrayController
							 withKeyPath:@"selectionIndexes"
								 options:nil];
		[mainTimelineCollectionView setItemPrototype:statusTimelineCollectionViewItem];
		if ((firstFollowingTimelineRun) && [preferences willRetrieveAllUpdates]) {
			NSArray *newStatuses = [cacheManager 
				setStatusesForTimelineCache:ORSFollowingTimelineCacheType
									withNotification:note];
			if ([newStatuses count] < 20) {
				cacheManager.firstFollowingCall = YES;
				[self getFriendsTimeline];
			} else {
				self.statuses = newStatuses;
			}
		} else {
			self.statuses = [cacheManager 
				setStatusesForTimelineCache:ORSFollowingTimelineCacheType
										   withNotification:note];
			[self performSelectorInBackground:@selector(postStatusUpdatesReceived:) 
								   withObject:note];
		}
		firstFollowingTimelineRun = NO;
	} else if (timelineSegControl.selectedSegment == 1) {
		self.statuses = [cacheManager 
				setStatusesForTimelineCache:ORSMentionsTimelineCacheType
											withNotification:note];
		[mainTimelineCollectionView unbind:@"content"];
		[mainTimelineCollectionView unbind:@"selectionIndexes"];
		[mainTimelineCollectionView setItemPrototype:NULL];
		[mainTimelineCollectionView bind:@"content"
								toObject:statusArrayController
							 withKeyPath:@"arrangedObjects"
								 options:nil];
		[mainTimelineCollectionView bind:@"selectionIndexes"
								toObject:statusArrayController
							 withKeyPath:@"selectionIndexes"
								 options:nil];
		[mainTimelineCollectionView setItemPrototype:statusTimelineCollectionViewItem];
		[self performSelectorInBackground:@selector(postMentionsReceived:) 
							   withObject:note];		
	} else if (timelineSegControl.selectedSegment == 3) {
		self.statuses = [cacheManager 
			setStatusesForTimelineCache:ORSFavoritesTimelineCacheType 
						   withNotification:note];
		[mainTimelineCollectionView unbind:@"content"];
		[mainTimelineCollectionView unbind:@"selectionIndexes"];
		[mainTimelineCollectionView setItemPrototype:NULL];
		[mainTimelineCollectionView bind:@"content"
								toObject:statusArrayController
							 withKeyPath:@"arrangedObjects"
								 options:nil];
		[mainTimelineCollectionView bind:@"selectionIndexes"
								toObject:statusArrayController
							 withKeyPath:@"selectionIndexes"
								 options:nil];
		[mainTimelineCollectionView setItemPrototype:statusTimelineCollectionViewItem];
	}
	[mainTimelineScrollView.documentView scrollPoint:oldScrollOrigin];
	if (!(timelineSegControl.selectedSegment == activeSegment)) {
		[self scrollToTop];
	}
	activeSegment = timelineSegControl.selectedSegment;
	
	if ([newStatusTextField.stringValue isEqualToString:@"d "]) {
		[newStatusTextField setStringValue:@""];
	}
	[self hideStatusBar];
	[self controlTextDidChange:note];
}

// Sets the users asynchronously
- (void) setUsersAsynchronously:(NSNotification *)note {
	// Not implemented yet
	if (connectionErrorShown) {
		connectionErrorShown = NO;
	}
	NSPoint oldScrollOrigin = mainTimelineScrollView.contentView.bounds.origin;
	[self hideStatusBar];
	[mainTimelineScrollView.documentView scrollPoint:oldScrollOrigin];
}

// Sets the DMs asynchronously
- (void) setDMsAsynchronously:(NSNotification *)note {
	if (connectionErrorShown) {
		[self hideStatusBar];
		connectionErrorShown = NO;
	}
	
	NSPoint oldScrollOrigin;
	if (timelineSegControl.selectedSegment == 2) {
		oldScrollOrigin = mainTimelineScrollView.contentView.bounds.origin;
		self.receivedDirectMessages = [cacheManager 
			setStatusesForTimelineCache:ORSReceivedMessagesTimelineCacheType 
										 withNotification:note];
		[mainTimelineCollectionView unbind:@"content"];
		[mainTimelineCollectionView unbind:@"selectionIndexes"];
		[mainTimelineCollectionView setItemPrototype:NULL];
		[mainTimelineCollectionView bind:@"content"
								toObject:receivedDMsArrayController
							 withKeyPath:@"arrangedObjects"
								 options:nil];
		[mainTimelineCollectionView bind:@"selectionIndexes"
								toObject:receivedDMsArrayController
							 withKeyPath:@"selectionIndexes"
								 options:nil];
		[mainTimelineCollectionView 
			setItemPrototype:receivedDMsCollectionViewItem];
		[self performSelectorInBackground:@selector(postDMsReceived:) 
							   withObject:note];
		[mainTimelineScrollView.documentView scrollPoint:oldScrollOrigin];
		if (!(timelineSegControl.selectedSegment == activeSegment)) {
			[self scrollToTop];
		}
		activeSegment = timelineSegControl.selectedSegment;
		if (newStatusTextField.stringValue.length == 0) {
			[newStatusTextField setStringValue:@"d "];
		}
		[self hideStatusBar];
	} else {
		[self hideStatusBar];
		if (((NSArray *)note.object).count > 0) {
			if (firstBackgroundReceivedDMRetrieval) {
				NSString *lastExecutionID = [preferences 
					receivedDMIDSinceLastExecution];
				NSString *currentExecutionID = [[(NSArray *)note.object
												 objectAtIndex:0] ID];
				if (lastExecutionID.intValue < currentExecutionID.intValue) {
					[self showStatusBarMessage:@"New direct message received"
								withImageNamed:@"email"];
					[statusBarButton setEnabled:YES];
					[cacheManager setStatusesForTimelineCache:
						ORSReceivedMessagesTimelineCacheType 
											 withNotification:note];
					[self performSelector:@selector(postDMsReceived:afterID:) 
							   withObject:note 
							   withObject:lastExecutionID];
					messageDurationTimer = [NSTimer 
						scheduledTimerWithTimeInterval:60 
							target:self selector:@selector(hideStatusBar) 
											userInfo:nil repeats:NO];
				}
				firstBackgroundReceivedDMRetrieval = NO;
			} else {
				NSString *lastExecutionID = [preferences 
											 receivedDMIDSinceLastExecution];
				NSString *currentExecutionID = [[(NSArray *)note.object 
												 objectAtIndex:0] ID];
				if (lastExecutionID.intValue < currentExecutionID.intValue) {
					[self showStatusBarMessage:@"New direct message received"
								withImageNamed:@"email"];
					[statusBarButton setEnabled:YES];
					[cacheManager setStatusesForTimelineCache:
						ORSReceivedMessagesTimelineCacheType 
										 withNotification:note];
					[self performSelectorInBackground:@selector(postDMsReceived:) 
										   withObject:note];
					messageDurationTimer = [NSTimer 
						scheduledTimerWithTimeInterval:60 
							target:self selector:@selector(hideStatusBar) 
											userInfo:nil repeats:NO];
				}
			}
			connectionErrorShown = NO;
		}
	}
	[self controlTextDidChange:note];
}

// Sets the sent status asynchronously
- (void) addSentStatusAsynchronously:(NSNotification *)note {
	[newStatusTextField setStringValue:@""];
	if (connectionErrorShown) {
		[self hideStatusBar];
		connectionErrorShown = NO;
	}
	if (timelineSegControl.selectedSegment == 0) {
		NSPoint oldScrollOrigin = 
			mainTimelineScrollView.contentView.bounds.origin;
		NSMutableArray *cache = [NSMutableArray arrayWithArray:self.statuses];
		[cache insertObject:note.object atIndex:0];
		self.statuses = cache;
		[mainTimelineScrollView.documentView scrollPoint:oldScrollOrigin];
	}
	[self showStatusBarMessage:@"Update sent"
				withImageNamed:@"comment"];
	messageDurationTimer = [NSTimer scheduledTimerWithTimeInterval:60 
		target:self selector:@selector(hideStatusBar) 
			userInfo:nil repeats:NO];
	[self performSelectorInBackground:@selector(postStatusUpdatesSent:) 
						   withObject:note];
	[self controlTextDidChange:nil];
}

// Sets the sent direct messages asynchronously
- (void) addSentDMsAsynchronously:(NSNotification *)note {
	[newStatusTextField setStringValue:@""];
	if (connectionErrorShown) {
		[self hideStatusBar];
		connectionErrorShown = NO;
	}
	[self performSelectorInBackground:@selector(postDMsSent:) withObject:note];
	[self showStatusBarMessage:@"Direct message sent"
				withImageNamed:@"email"];
	messageDurationTimer = [NSTimer 
							scheduledTimerWithTimeInterval:60 
							target:self selector:@selector(hideStatusBar) 
							userInfo:nil repeats:NO];
	[self controlTextDidChange:nil];
}

// Gets the friends timeline
- (void) getFriendsTimeline {
	if (twitterEngine.sessionUserID) {
		[self showAnimatedStatusBarMessage:@"Downloading from Twitter..."];
		if (cacheManager.firstFollowingCall) {
			[twitterEngine friendsTimeline];
		} else {
			[twitterEngine 
			 friendsTimelineSinceStatus:cacheManager.lastFollowingStatusID];
		}
	}
}

// Gets the user timeline
- (void) getUserTimeline {
	if (twitterEngine.sessionUserID) {
		[self showAnimatedStatusBarMessage:@"Downloading from Twitter..."];
		if (cacheManager.firstArchiveCall) {
			[twitterEngine userTimelineForUserWithScreenName:twitterEngine.sessionUserID];
		} else {
			[twitterEngine 
			 userTimelineSinceStatus:cacheManager.lastArchiveStatusID];
		}
	}
}

// Gets the public timeline
- (void) getPublicTimeline {
	if (twitterEngine.sessionUserID) {
		[self showAnimatedStatusBarMessage:@"Downloading from Twitter..."];
		if (cacheManager.firstPublicCall) {
			[twitterEngine publicTimeline];
		} else {
			[twitterEngine 
			 publicTimelineSinceStatus:cacheManager.lastPublicStatusID];
		}
	}
}

// Gets the mentions
- (void) getMentions {
	if (twitterEngine.sessionUserID) {
		[self showAnimatedStatusBarMessage:@"Downloading from Twitter..."];
		if (cacheManager.firstMentionsCall) {
			[twitterEngine mentions];
		} else {
			[twitterEngine 
			 mentionsSinceStatus:cacheManager.lastMentionStatusID];
		}
	}
}

// Gets the favorites
- (void) getFavorites {
	if (twitterEngine.sessionUserID) {
		[self showAnimatedStatusBarMessage:@"Downloading from Twitter..."];
		if (cacheManager.firstFavoriteCall) {
			[twitterEngine favoritesForUser:twitterEngine.sessionUserID];
		} else {
			[twitterEngine 
			 favoritesSinceStatus:cacheManager.lastFavoriteStatusID];
		}
	}
}

// Gets the received messages
- (void) getReceivedMessages {
	if (twitterEngine.sessionUserID) {
		[self showAnimatedStatusBarMessage:@"Downloading from Twitter..."];
		if (cacheManager.firstReceivedMessagesCall) {
			[twitterEngine receivedDMs];
		} else {
			[twitterEngine 
			 receivedDMsSinceDM:cacheManager.lastReceivedMessageID];
		}
	}
}

// Gets the sent messages
- (void) getSentMessages {
	if (twitterEngine.sessionUserID) {
		[self showAnimatedStatusBarMessage:@"Downloading from Twitter..."];
		if (cacheManager.firstSentMessagesCall) {
			[twitterEngine sentDMs];
		} else {
			[twitterEngine sentDMsSinceDM:cacheManager.lastSentMessageID];
		}
	}
}

// Action: opens the user's home page (if they are logged in)
- (IBAction) goHome:sender {
	NSURL *homeURL = [[NSURL alloc] initWithString:@"http://twitter.com/home"];
	[[NSWorkspace sharedWorkspace] openURL:homeURL];
}

// Action: Called when the user wants to autotype the user id to reply to.
- (IBAction) typeUserID:sender {
	NSString *username = [NSString stringWithFormat:@"@%@ ", sender];
	[self insertStringTokenInNewStatusTextField:username];
}

// Action: Called when the user wants to autotype "d" + user id to send 
// message to.
- (IBAction) dmUserID:sender {
	[newStatusTextField setStringValue:@""];
	NSString *username = [NSString stringWithFormat:@"d %@ ", sender];
	[self insertStringTokenInNewStatusTextField:username];
}

// Action: This shortens the given URL using a shortener service.
- (IBAction) shortenURL:sender {
	NSText *editor = newStatusTextField.currentEditor;
	NSRange selectedRange = ((NSTextView *)editor).selectedRange;
	if ([[(NSTextView *)editor 
		  attributedSubstringFromRange:selectedRange].string 
				hasPrefix:@"http://"]) {
		[editor copy:self];
		[editor replaceCharactersInRange:editor.selectedRange 
			withString:[urlShortener shortURLFromOriginalURL:[editor.string 
								substringWithRange:editor.selectedRange]]];
		[self controlTextDidChange:nil];
	}
}

// Action: This is called whenever the user wishes to open a user url.
- (IBAction) openUserURL:sender {
	NSURL *userURL = [[NSURL alloc] initWithString:(NSString *)sender];
	[[NSWorkspace sharedWorkspace] openURL:userURL];
}

// Delegate: This is called whenever the application terminates
- (void) applicationWillTerminate:(NSNotification *)notification {
	[defaults setFloat:self.window.frame.origin.x
				forKey:@"CanaryWindowX"];
	[defaults setFloat:self.window.frame.origin.y
				forKey:@"CanaryWindowY"];
	[defaults setFloat:self.window.frame.size.width
				forKey:@"CanaryWindowWidth"];
	[defaults setFloat:self.window.frame.size.height
				forKey:@"CanaryWindowHeight"];
	[preferences saveLastIDs];
	[twitterEngine endSession];
	
	NSMutableArray *toBeRemoved = [[NSMutableArray alloc] init];
	for (ORSFilter *filter in (NSArray *)[filterArrayController arrangedObjects]) {
		if (filter.active == NO) {
			[toBeRemoved addObject:filter];
		}
	}
	[filterArrayController setSelectedObjects:toBeRemoved];
	[filterArrayController remove:self];
}

// Retweets the given status text from the given userID
- (void) retweetStatus:(NSString *)statusText
fromUserWithScreenName:(NSString *)userID {
	NSString *message = [NSString stringWithFormat:@"%@ (via @%@)", 
						 statusText, userID];
	[self insertStringTokenInNewStatusTextField:message];
}

- (void) retweetStatus:(NSString *)identifier {
	if (twitterEngine.sessionUserID) {
		[twitterEngine retweetStatus:identifier];
		[self showStatusBarMessage:@"Retweet sent" 
					withImageNamed:@"comments"];
		messageDurationTimer = [NSTimer 
								scheduledTimerWithTimeInterval:60 
								target:self selector:@selector(hideStatusBar) 
								userInfo:nil repeats:NO];
	}
}

// Updates the new status text field and other related components when the 
// user types or selects stuff in the text field
- (void) updateNewStatusTextField {
	NSText *fieldEditor = newStatusTextField.currentEditor;
	self.realSelectedRange = fieldEditor.selectedRange;
	
	int charsWritten = newStatusTextField.stringValue.length;
	int maxChars = 140;
	
	[charsLeftIndicator setToolTip:[NSString 
		stringWithFormat:@"Characters written: %i\nCharacters left: %i",
				charsWritten, (((charsWritten / maxChars)+1)*maxChars - charsWritten)]];
	
	if (charsWritten > 0) {
		[tweetButton setEnabled:YES];
	} else {
		[tweetButton setEnabled:NO];
	}
	
	int charsLeft = maxChars - charsWritten;
	[charsLeftIndicator setIntValue:charsWritten];
	
	// Autocomplete
	if ([defaults boolForKey:@"CanaryUseAutocomplete"])
		[self performAutocomplete];
	
	if ([newStatusTextField.stringValue hasPrefix:@"d "] ||
		[newStatusTextField.stringValue hasPrefix:@"D "]) {
		[tweetButton setTitle:@"Message!"];
		[charsLeftIndicator setMaxValue:140];
		[charsLeftIndicator setCriticalValue:140];
		[charsLeftIndicator setWarningValue:125];
		
		NSString *scanString;
		NSScanner *scanner = [NSScanner scannerWithString:[
			newStatusTextField.stringValue substringFromIndex:2]];
		NSCharacterSet *terminalCharacterSet = 
			[NSCharacterSet whitespaceAndNewlineCharacterSet];
		if (![scanner isAtEnd]) {
			[scanner scanUpToCharactersFromSet:terminalCharacterSet
									intoString:&scanString];
			if (scanString) {
				charsWritten = charsWritten - [scanString length] - 3;
			} else {
				charsWritten = charsWritten - 3;
			}
			charsLeft = maxChars - charsWritten;
			[charsLeftIndicator setIntValue:charsWritten];
			
			[charsLeftIndicator setToolTip:[NSString 
				stringWithFormat:@"Characters written: %i\nCharacters left: %i",
					charsWritten, (((charsWritten / maxChars)+1)*maxChars - charsWritten)]];
		}
		
		if (charsLeft < 0)
			[tweetButton setEnabled:NO];
		else {
			if ([tweetButton isEnabled])
				return;
			else
				[tweetButton setEnabled:YES];
		}
	// Commands
	} else if ([newStatusTextField.stringValue hasPrefix:@"%f "]) {
		[tweetButton setTitle:@"Follow"];
	} else if ([newStatusTextField.stringValue hasPrefix:@"%l "]) {
		[tweetButton setTitle:@"Leave"];
	} else if ([newStatusTextField.stringValue hasPrefix:@"%b "]) {
		[tweetButton setTitle:@"Block"];
	} else if ([newStatusTextField.stringValue hasPrefix:@"%u "]) {
		[tweetButton setTitle:@"Unblock"];
	} else {
		[charsLeftIndicator setMaxValue:(maxChars*((charsWritten/maxChars)+1))];
		[charsLeftIndicator setCriticalValue:(maxChars*((charsWritten/maxChars)+1))];
		[charsLeftIndicator setWarningValue:(maxChars*((charsWritten/maxChars)+1))-15];
		if (charsLeft < 0)
			[tweetButton setTitle:[NSString stringWithFormat:@"Twt ×%i", 
								   (charsWritten / maxChars)+1]];
		else {
			if ([[tweetButton title] isEqualToString:@"Tweet!"])
				return;
			else
				[tweetButton setTitle:@"Tweet!"];
		}
	}
}

- (void) performAutocomplete {
	NSRange range;
	
	range = [newStatusTextField.stringValue rangeOfString:@"$love "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
			stringByReplacingOccurrencesOfString:@"$love " 
									  withString:@"♥ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$plane "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$plane " 
										  withString:@"✈ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$smile "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$smile " 
										  withString:@"☺ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@":) "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@":) " 
										  withString:@"☺ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@":-) "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@":-) " 
										  withString:@"☺ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$music "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$music " 
										  withString:@"♬ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$boxtick "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$boxtick " 
										  withString:@"☑ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$spade "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$spade " 
										  withString:@"♠ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$phone "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$phone " 
										  withString:@"☎ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$darksmile "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$darksmile " 
										  withString:@"☻ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$song "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$song " 
										  withString:@"♫ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$box "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$box " 
										  withString:@"☒ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$whitespade "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$whitespade " 
										  withString:@"♤ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$carrot "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$carrot " 
										  withString:@"☤ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$sad "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$sad " 
										  withString:@"☹ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@":( "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@":( " 
										  withString:@"☹ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@":-( "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@":-( " 
										  withString:@"☹ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$note "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$note " 
										  withString:@"♪ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$female "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$female " 
										  withString:@"♀ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"star "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"star " 
										  withString:@"✩ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"letter "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"letter " 
										  withString:@"✉ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$pirate "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$pirate " 
										  withString:@"☠ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$tick "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$tick " 
										  withString:@"✔ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$male "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$male " 
										  withString:@"♂ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$darkstar "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$darkstar " 
										  withString:@"★ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$cross "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$cross " 
										  withString:@"✖ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$cook "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$cook " 
										  withString:@"♨ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$cloud "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$cloud " 
										  withString:@"☁ "];
	range = [newStatusTextField.stringValue rangeOfString:@"$peaceout "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$peaceout " 
										  withString:@"✌ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$king "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$king " 
										  withString:@"♛ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$rose "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$rose " 
										  withString:@"❁ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$islam "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$islam " 
										  withString:@"☪ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$umbrella "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$umbrella " 
										  withString:@"☂ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$pen "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$pen " 
										  withString:@"✏ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$bishop "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$bishop " 
										  withString:@"♝ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$flower "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$flower " 
										  withString:@"❀ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$tools "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$tools " 
										  withString:@"☭ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$snowman "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue
							stringByReplacingOccurrencesOfString:@"$snowman " 
										  withString:@"☃ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"-> "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"-> " 
										  withString:@"☛ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$darkknight "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$darkknight " 
										  withString:@"♞ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$darkflower "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$darkflower " 
										  withString:@"✿ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$peace "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$peace " 
										  withString:@"☮ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$sun "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$sun " 
										  withString:@"☼ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"<- "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"<- " 
										  withString:@"☚ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$knight "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$knight " 
										  withString:@"♘ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$ying "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$ying " 
										  withString:@"☯ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"christ "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue									stringByReplacingOccurrencesOfString:@"christ " 
										  withString:@"✝ "];

	range = [newStatusTextField.stringValue rangeOfString:@"$moon "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$moon " 
										  withString:@"☾ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$up "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$up " 
										  withString:@"☝ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$rook "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$rook " 
										  withString:@"♖ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$snow "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$snow " 
										  withString:@"✽ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$comet "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$comet " 
										  withString:@"☄ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$down "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$down " 
										  withString:@"☟ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$pawn "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$pawn " 
										  withString:@"♟ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$prince "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$prince " 
										  withString:@"☥ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$cut "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$cut " 
										  withString:@"✂ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$write "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$write " 
										  withString:@"✍ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$queen "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$queen " 
										  withString:@"♕ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$copy "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$copy " 
										  withString:@"© "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$tm "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$tm " 
										  withString:@"™ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$euro "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$euro " 
										  withString:@"€ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"<< "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"<< " 
										  withString:@"« "];
	
	range = [newStatusTextField.stringValue rangeOfString:@">> "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@">> " 
										  withString:@"» "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$yen "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$yen " 
										  withString:@"¥ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$wheel "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$wheel " 
										  withString:@"✇ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"recycle "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"recycle " 
										  withString:@"♺ "];
	
	range = [newStatusTextField.stringValue rangeOfString:@"$radioactive "];
	if (range.location != NSNotFound)
		newStatusTextField.stringValue = [newStatusTextField.stringValue 
							stringByReplacingOccurrencesOfString:@"$radioactive " 
										  withString:@"☢ "];
}

// Delegate: Changes the green bar and enables/disables the tweet button.
- (void) controlTextDidChange:(NSNotification *)aNotification {
	[self updateNewStatusTextField];
}

// Delegate: Called when the selection range changes in a text view
- (void) textDidEndEditing:(NSNotification *)notification {
	[self updateNewStatusTextField];
}

// Used for enabling/disabling menu items according to the controller state
- (BOOL) validateMenuItem:(NSMenuItem *)item {
	NSText *fieldEditor = [newStatusTextField currentEditor];
	NSRange selectedRange = [(NSTextView *)fieldEditor selectedRange];
    if ([item action] == @selector(shortenURL:)) {
		if ([[[(NSTextView *)fieldEditor 
				attributedSubstringFromRange:selectedRange] string] 
			  hasPrefix:@"http://"]) {
			return YES;
		} else {
			return NO;
		}
	} else if ((item.action == @selector(insertITunesCurrentTrackFull:)) ||
			   (item.action == @selector(insertITunesCurrentTrackName:)) ||
			   (item.action == @selector(insertITunesCurrentTrackAlbum:)) ||
			   (item.action == @selector(insertITunesCurrentTrackArtist:)) ||
			   (item.action == @selector(insertITunesCurrentTrackGenre:)) ||
			   (item.action == @selector(insertITunesCurrentTrackComposer:))) {
		iTunesApplication *iTunes = [SBApplication 
			applicationWithBundleIdentifier:@"com.apple.iTunes"];
		if ([iTunes isRunning]) {
			return YES;
		} else {
			return NO;
		}
	} else if (item.action == @selector(showWindow:)) {
		if ([self.window isVisible]) {
			return NO;
		} else {
			return YES;
		}
	} else if (item.action == @selector(retypePreviousUpdate:)) {
		if ((previousUpdateText != NULL) 
			&& ![previousUpdateText isEqualToString:@""]) {
			return YES;
		} else {
			return NO;
		}
	} else if (item.tag == 115223) {
		return [item isEnabled];
	} else  {
		return YES;
	}
}

// Action: This is called whenever the user performs an action on a status
// or user.
- (IBAction) invokeActionOnUser:sender {
	NSString *userScreenName, *userURL;
	if (timelineSegControl.selectedSegment == 2) {
		userScreenName = [(NSXMLNode *)[sender toolTip] senderScreenName];
		userURL = [(NSXMLNode *)[sender toolTip] senderURL];
	} else {
		userScreenName = [(NSXMLNode *)[sender toolTip] userScreenName];
		userURL = [(NSXMLNode *)[sender toolTip] userURL];
	}
	
	if ([[sender titleOfSelectedItem] isEqualToString:@"Follow"]) {
		[self createFriendshipWithUser:userScreenName];
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Leave"]) {
		[self destroyFriendshipWithUser:userScreenName];
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Block"]) {
		[self showUserBlockAlertSheet:userScreenName];
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Unblock"]) {
		[self unblockUserWithScreenName:userScreenName];
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Reply to"]) {
		[self typeUserID:userScreenName];
	} else if ([[sender titleOfSelectedItem] 
				isEqualToString:@"Message directly"]) {
		[self dmUserID:userScreenName];
	} else if ([[sender titleOfSelectedItem] 
				isEqualToString:@"Favorite this"]) {
		[self favoriteStatus:[(NSXMLNode *)[sender toolTip] ID]];
	} else if ([[sender titleOfSelectedItem] 
				isEqualToString:@"Go to Web page"]) {
		[self openUserURL:userURL];
	} else if ([[sender titleOfSelectedItem] 
				isEqualToString:@"Go to Twitter page"]) {
		[self openUserURL:[NSString stringWithFormat:@"http://twitter.com/%@",
						   userScreenName]];
	} else if ([[sender titleOfSelectedItem] isEqualToString:@"Retweet this"]) {
		[self retweetStatus:[(NSXMLNode *)[sender toolTip] text]
			 fromUserWithScreenName:userScreenName];
		//[self retweetStatus:[(NSXMLNode *)[sender toolTip] ID]];
	}
}

// Shows the user block alert sheet
- (void) showUserBlockAlertSheet:(NSString *)userScreenName {
	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"Block"];
	[alert addButtonWithTitle:@"Cancel"];
	NSString *messageText = [NSString 
		stringWithFormat:@"Do you really want to block user \"%@\"?",
							 userScreenName];
	[alert setMessageText:messageText];
	[alert setInformativeText:@"Blocked users can be unblocked later."];
	[alert setAlertStyle:NSInformationalAlertStyle];
	
	CFRetain(userScreenName);
	
	[alert beginSheetModalForWindow:self.window
					  modalDelegate:self
					 didEndSelector:@selector(
		blockUserAlertDidEnd:returnCode:contextInfo:)
						contextInfo:userScreenName];
}

// Acts upon the result of the user block alert sheet
- (void) blockUserAlertDidEnd:(NSAlert *)alert
					   returnCode:(int)returnCode
					  contextInfo:(void *)contextInfo {
	id contextObject = (id)contextInfo;
	if (returnCode == NSAlertFirstButtonReturn) {
		[self blockUserWithScreenName:(NSString *)contextInfo];
	}
	CFRelease(contextObject);
}

// Action: This is called when the about window needs to be shown.
- (IBAction) showAboutWindow:sender {
	ORSCanaryAboutController *aboutController = [ORSCanaryAboutController 
												 sharedAboutController];
	[aboutController.window makeKeyAndOrderFront:sender];
}

// Action: This is called when the preferences window needs to be shown.
- (IBAction) showPreferencesWindow:sender {
	ORSCanaryPreferencesController *preferencesController = 
		[ORSCanaryPreferencesController sharedPreferencesController];
	[preferencesController.window makeKeyAndOrderFront:sender];
}

// Action: This is called when the login window needs to be shown.
- (IBAction) showLoginWindow:sender {
	prevUserID = twitterEngine.sessionUserID;
	prevPassword = twitterEngine.sessionPassword;
	
	ORSCanaryLoginController *loginController = 
		[[ORSCanaryLoginController alloc] initWithWindowNibName:@"LoginWindow"];
	[NSApp beginSheet:loginController.window
	   modalForWindow:[NSApp mainWindow]
		modalDelegate:loginController
	   didEndSelector:@selector(didEndUserManagerSheet:returnCode:contextInfo:)
		  contextInfo:nil];
	
	[loginController fillPasswordTextField];
}

// This is called when the new user window needs to be shown.
- (void) showNewUserWindow {
	[NSApp beginSheet:newUserWindow
	   modalForWindow:self.window
		modalDelegate:self
	   didEndSelector:@selector(didEndNewUserSheet:returnCode:contextInfo:)
		  contextInfo:nil];
}

// Action: This is called when the "Signup for a new Twitter account" button in
// the new user sheet is clicked
- (IBAction) signupForNewAccountCall:sender {
	[self createNewTwitterAccount:self];
}

// Action: This is called when the "Login" button in the new user sheet is
// clicked
- (IBAction) loginCall:sender {
	[newUserWindow orderOut:sender];
	[NSApp endSheet:newUserWindow 
		 returnCode:1];
}

// Action: This is called when the "Close" button in the new user sheet is
// clicked
- (IBAction) closeCall:sender {
	[newUserWindow orderOut:sender];
	[NSApp endSheet:newUserWindow 
		 returnCode:2];
}

// Action: This is called when the "Quit" button in the new user sheet is
// clicked
- (IBAction) quitCall:sender {
	[newUserWindow orderOut:sender];
	[NSApp endSheet:newUserWindow
		 returnCode:3];
}

// This method is called when the sheet closes
- (void) didEndNewUserSheet:(NSWindow *)sheet
				 returnCode:(int)returnCode
				contextInfo:(void *)contextInfo {
	if (returnCode == 0) {
		return;
	} else if (returnCode == 1) {
		[self showLoginWindow:self];
	} else if (returnCode == 2) {
		return;
	} else if (returnCode == 3) {
		[NSApp terminate:self];
	}
}

// Action: This is called when the user sends feedback
- (IBAction) sendFeedback:sender {
	NSURL *url = [NSURL URLWithString:@"mailto:nicktoumpelis@gmail.com"
		"?subject=Feedback%20for%20Canary"
		"&body=Please%20write%20your%20feedback%20here..."];
	[[NSWorkspace sharedWorkspace] openURL:url];
}

// Action: This is called when the user clicks on the message that new messages
// have been received
- (IBAction) changeToReceivedDMs:sender {
	[self messagesTimelineMenuItemClicked:nil];
}

// Action: This creates a new Twitter account
- (IBAction) createNewTwitterAccount:sender {
	[self openUserURL:@"https://twitter.com/signup"];
}

// This gets called when the main application window is called and the
// user clicks on the dock icon.
- (BOOL) applicationShouldHandleReopen:(NSApplication *)theApplication	
					 hasVisibleWindows:(BOOL)flag {
	[self.window makeKeyAndOrderFront:self];
	return YES;
}


// Front-end error handling

// Shows that there is a connection problem
- (void) showConnectionFailure:(NSNotification *)note {
	[self showStatusBarMessage:@"Connection problem"
				withImageNamed:@"error"];
	messageDurationTimer = [NSTimer 
							scheduledTimerWithTimeInterval:60 
							target:self selector:@selector(hideStatusBar) 
							userInfo:nil repeats:NO];
	connectionErrorShown = YES;
}

// Shows the server response when there is an error
- (void) showReceivedResponse:(NSNotification *)note {
	if (betweenUsers) {
		betweenUsers = NO;
		return;
	}
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)note.object;
	NSInteger statusCode = response.statusCode;
	NSString *msg = @"";
	if (statusCode != 200 && statusCode != 304) {
		if (statusCode == 503) {
			msg = @"Twitter is overloaded";
		} else if (statusCode == 502) {
			msg = @"Twitter is down";
		} else if (statusCode == 500) {
			msg = @"Twitter internal error";
		} else if (statusCode == 404) {
			msg = @"Requested resource not found";
		} else if (statusCode == 403) {
			msg = @"Request not allowed by Twitter";
		} else if (statusCode == 401) {
			msg = @"Authorization required or invalid";
		} else if (statusCode == 400) {
			msg = @"Request invalid or rate exceeded";
		}
		[self showStatusBarMessage:msg
					withImageNamed:@"error"];
		messageDurationTimer = [NSTimer 
								scheduledTimerWithTimeInterval:60 
								target:self selector:@selector(hideStatusBar) 
								userInfo:nil repeats:NO];
		connectionErrorShown = YES;
	}
}


// TwitPic functionality

// Action: shows the picture taker to the user
- (IBAction) showPictureTaker:sender {
	IKPictureTaker *pictureTaker = [IKPictureTaker pictureTaker];
	[pictureTaker setValue:[NSNumber numberWithBool:NO]
					forKey:IKPictureTakerShowEffectsKey];
	[pictureTaker setValue:[NSNumber numberWithBool:YES]
					forKey:IKPictureTakerAllowsEditingKey];
	[pictureTaker setValue:[NSNumber numberWithBool:YES]
					forKey:IKPictureTakerAllowsVideoCaptureKey];
	[pictureTaker beginPictureTakerSheetForWindow:self.window
									 withDelegate:self
								   didEndSelector:@selector(
										pictureTakerDidEnd:returnCode:contextInfo:)
									  contextInfo:nil];
}

// This gets called when the picture taker has an output image
- (void) pictureTakerDidEnd:(IKPictureTaker *)picker
				 returnCode:(NSInteger)code
				contextInfo:(void *)contextInfo {
	if (code == NSOKButton) { 
		NSImage *image = [picker outputImage];
		NSData *dataTiffRep = [image TIFFRepresentation];
		NSBitmapImageRep *bitmapRep = [NSBitmapImageRep 
									   imageRepWithData:dataTiffRep];
		NSData *jpegData = [bitmapRep representationUsingType:NSJPEGFileType
												   properties:nil];
		[self executeAsyncCallToTwitPicWithData:jpegData];
	}
}

// Action: This sends an image to TwitPic
- (IBAction) sendImageToTwitPic:sender {
	NSArray *acceptableFileTypes = [NSArray arrayWithObjects:@"jpg", @"jpeg", 
									@"png", @"gif", @"jpe", nil];
	NSOpenPanel *oPanel = [NSOpenPanel openPanel];
	[oPanel setAllowsMultipleSelection:NO];
	int result = [oPanel runModalForDirectory:NSHomeDirectory() 
										 file:nil
										types:acceptableFileTypes];
	if (result == NSOKButton) {
		[self executeAsyncCallToTwitPicWithFile:[oPanel filename]];
	}
}

// This method executes the call to TwitPic and adds the resulting url in the
// text field
- (void) executeCallToTwitPicWithFile:(NSString *)filename {
	NSData *imageData = [[NSData alloc] initWithContentsOfFile:filename];
	ORSTwitPicDispatcher *twitPicDispatcher = [[ORSTwitPicDispatcher alloc]
											   init];
	NSString *twitPicURLString = [twitPicDispatcher uploadData:imageData
												  withUsername:twitterEngine.sessionUserID
													  password:twitterEngine.sessionPassword
													  filename:filename];
	[self insertStringTokenInNewStatusTextField:twitPicURLString];
	[self showStatusBarMessage:@"Picture has been sent to TwitPic"
				withImageNamed:@"picture_link"];
	messageDurationTimer = [NSTimer 
							scheduledTimerWithTimeInterval:60 
							target:self selector:@selector(hideStatusBar) 
							userInfo:nil repeats:NO];
}

// This method executes the call to twitpic and adds the resulting url in the
// text field
- (void) executeCallToTwitPicWithData:(NSData *)imageData {
	ORSTwitPicDispatcher *twitPicDispatcher = [[ORSTwitPicDispatcher alloc]
											   init];
	NSString *twitPicURLString = [twitPicDispatcher uploadData:imageData
									withUsername:twitterEngine.sessionUserID
							password:twitterEngine.sessionPassword
										filename:@"user_selection.jpeg"];
	[self insertStringTokenInNewStatusTextField:twitPicURLString];
	[self showStatusBarMessage:@"Picture has been sent to TwitPic"
				withImageNamed:@"picture_link"];
	messageDurationTimer = [NSTimer 
							scheduledTimerWithTimeInterval:60 
							target:self selector:@selector(hideStatusBar) 
							userInfo:nil repeats:NO];
}

// This method executes the call to twitpic asynchronously and sends the given
// file
- (void) executeAsyncCallToTwitPicWithFile:(NSString *)filename {
	[self showAnimatedStatusBarMessage:@"Sending picture to TwitPic..."];
	NSData *imageData = [[NSData alloc] initWithContentsOfFile:filename];
	ORSAsyncTwitPicDispatcher *asyncTwitPicDispatcher = 
		[[ORSAsyncTwitPicDispatcher alloc] init];
	[asyncTwitPicDispatcher uploadData:imageData
						  withUsername:twitterEngine.sessionUserID
							  password:twitterEngine.sessionPassword
							  filename:filename];
}

// This method executes the call to twitpic asynchronously and sends the given
// data
- (void) executeAsyncCallToTwitPicWithData:(NSData *)imageData {
	[self showAnimatedStatusBarMessage:@"Sending picture to TwitPic..."];
	ORSAsyncTwitPicDispatcher *asyncTwitPicDispatcher = 
		[[ORSAsyncTwitPicDispatcher alloc] init];
	[asyncTwitPicDispatcher uploadData:imageData
						  withUsername:twitterEngine.sessionUserID
							  password:twitterEngine.sessionPassword
							  filename:@"user_selection.jpeg"];
}

// Prints the TwitPic URL in the status text box (called asynchronously)
- (void) printTwitPicURL:(NSNotification *)note {
	NSString *twitPicURLString = (NSString *)[note object];
	[self insertStringTokenInNewStatusTextField:twitPicURLString];
	[self showStatusBarMessage:@"Picture has been sent to TwitPic"
				withImageNamed:@"picture_link"];
	messageDurationTimer = [NSTimer 
							scheduledTimerWithTimeInterval:60 
							target:self selector:@selector(hideStatusBar) 
							userInfo:nil repeats:NO];
}


// iTunes functionality methods

// This inserts the current iTunes full track info in the text field
- (IBAction) insertITunesCurrentTrackFull:sender {
	iTunesApplication *iTunes = [SBApplication 
		applicationWithBundleIdentifier:@"com.apple.iTunes"];
	if ([iTunes isRunning]) {
		NSString *track = iTunes.currentTrack.name;
		NSString *album = iTunes.currentTrack.album;
		NSString *artist = iTunes.currentTrack.artist;
		NSString *fullName = [NSString stringWithFormat:@"♬ %@ - %@: %@",
			artist, album, track];
		[self insertStringTokenInNewStatusTextField:fullName];
	}
}

// This inserts the current iTunes track in the text field
- (IBAction) insertITunesCurrentTrackName:sender {
	iTunesApplication *iTunes = [SBApplication 
		applicationWithBundleIdentifier:@"com.apple.iTunes"];
	if ([iTunes isRunning]) {
		NSString *trackName = [NSString stringWithFormat:@"♬ %@", iTunes.currentTrack.name];
		[self insertStringTokenInNewStatusTextField:trackName];
	}
}
		
// This inserts the current iTunes album in the text field
- (IBAction) insertITunesCurrentTrackAlbum:sender {
	iTunesApplication *iTunes = [SBApplication 
		applicationWithBundleIdentifier:@"com.apple.iTunes"];
	if ([iTunes isRunning]) {
		NSString *albumName = [NSString stringWithFormat:@"♬ %@", 
			iTunes.currentTrack.album];
		[self insertStringTokenInNewStatusTextField:albumName];
	}
}

// This inserts the current iTunes artist in the text field
- (IBAction) insertITunesCurrentTrackArtist:sender {
	iTunesApplication *iTunes = [SBApplication 
		applicationWithBundleIdentifier:@"com.apple.iTunes"];
	if ([iTunes isRunning]) {
		NSString *artistName = [NSString stringWithFormat:@"♬ %@", 
			iTunes.currentTrack.artist];
		[self insertStringTokenInNewStatusTextField:artistName];
	}
}

// This inserts the current iTunes genre in the text field
- (IBAction) insertITunesCurrentTrackGenre:sender {
	iTunesApplication *iTunes = [SBApplication 
		applicationWithBundleIdentifier:@"com.apple.iTunes"];
	if ([iTunes isRunning]) {
		NSString *genre = [NSString stringWithFormat:@"♬ %@", 
									 iTunes.currentTrack.genre];
		[self insertStringTokenInNewStatusTextField:genre];
	}
}

// This inserts the current iTunes composer in the text field
- (IBAction) insertITunesCurrentTrackComposer:sender {
	iTunesApplication *iTunes = [SBApplication 
		applicationWithBundleIdentifier:@"com.apple.iTunes"];
	if ([iTunes isRunning]) {
		NSString *composer = [NSString stringWithFormat:@"♬ %@", 
						   iTunes.currentTrack.composer];
		[self insertStringTokenInNewStatusTextField:composer];
	}
}


// Inserts the string to the new status text field
- (void) insertStringTokenInNewStatusTextField:(NSString *)stringToken {
	NSTextView *fieldEditor = (NSTextView *)[self.window fieldEditor:YES 
											 forObject:newStatusTextField];
	[self.window makeFirstResponder:newStatusTextField];
	[self.window makeFirstResponder:fieldEditor];
	
	NSString *token = [NSString stringWithFormat:@"%@", stringToken];
	
	[fieldEditor setSelectedRange:self.realSelectedRange];
	[fieldEditor insertText:token];
	
	[fieldEditor setNeedsDisplay:YES];
	[fieldEditor didChangeText];
}


// View options related methods

// Action: Switches between the usernames and the screen names of the senders
- (IBAction) switchBetweenUserNames:sender {
	if ([sender class] == [NSMenuItem class]) {
		if ([[(NSMenuItem *)sender title] isEqualToString:@"Switch to Usernames"]) {
			[self changeToUsernames];
			[defaults setObject:[NSNumber numberWithBool:NO]
						 forKey:@"CanaryShowScreenNames"];
			[(NSMenuItem *)sender setTitle:@"Switch to Screen Names"];
			[viewOptionsNamesControl setSelectedSegment:0];
		} else {
			[self changeToScreenNames];
			[defaults setObject:[NSNumber numberWithBool:YES]
						 forKey:@"CanaryShowScreenNames"];
			[(NSMenuItem *)sender setTitle:@"Switch to Usernames"];
			[viewOptionsNamesControl setSelectedSegment:1];
		}
	} else {
		if (namesSelectedSegment != [viewOptionsNamesControl selectedSegment]) {
			if ([viewOptionsNamesControl selectedSegment] == 0) {
				[self changeToUsernames];
				[defaults setObject:[NSNumber numberWithBool:NO]
							 forKey:@"CanaryShowScreenNames"];
				[switchNamesMenuItem setTitle:@"Switch to Screen Names"];
			} else {
				[self changeToScreenNames];
				[defaults setObject:[NSNumber numberWithBool:YES]
							 forKey:@"CanaryShowScreenNames"];
				[switchNamesMenuItem setTitle:@"Switch to Usernames"];
			}
			namesSelectedSegment = [viewOptionsNamesControl selectedSegment];
		} else {
			return;
		}
	}
	if (timelineSegControl.selectedSegment == 2) {
		[mainTimelineCollectionView setContent:NULL];
		[mainTimelineCollectionView setNeedsDisplay:YES];
		[mainTimelineCollectionView displayIfNeededIgnoringOpacity];
		[self performSelector:@selector(populateWithReceivedDMs)
				   withObject:nil
				   afterDelay:0.5];
	} else {
		[mainTimelineCollectionView setContent:NULL];
		[mainTimelineCollectionView setNeedsDisplay:YES];
		[mainTimelineCollectionView displayIfNeededIgnoringOpacity];
		[self performSelector:@selector(populateWithStatuses)
				   withObject:nil
				   afterDelay:0.5];
	}
}

// Changes the binding of the main timeline collection to usernames
- (void) changeToUsernames {
	if (timelineSegControl.selectedSegment == 2) {
		[receivedDMButton bind:@"title"
				toObject:receivedDMsCollectionViewItem
			 withKeyPath:@"representedObject.senderScreenName"
				 options:nil];
		[receivedDMButton bind:@"toolTip"
				toObject:receivedDMsCollectionViewItem
			 withKeyPath:@"representedObject.senderName"
				 options:nil];
	} else {
		[statusNameButton bind:@"title"
				toObject:statusTimelineCollectionViewItem
			 withKeyPath:@"representedObject.userScreenName"
				 options:nil];
		[statusNameButton bind:@"toolTip"
				toObject:statusTimelineCollectionViewItem
			 withKeyPath:@"representedObject.userName"
				 options:nil];
	}
	showScreenNames = NO;
}

// Changes the binding of the main timeline collection to screen names
- (void) changeToScreenNames {
	if (timelineSegControl.selectedSegment == 2) {
		[receivedDMButton bind:@"title"
				toObject:receivedDMsCollectionViewItem
			 withKeyPath:@"representedObject.senderName"
				 options:nil];
		[receivedDMButton bind:@"toolTip"
				toObject:receivedDMsCollectionViewItem
			 withKeyPath:@"representedObject.senderScreenName"
				 options:nil];
	} else {
		[statusNameButton bind:@"title"
				toObject:statusTimelineCollectionViewItem
			 withKeyPath:@"representedObject.userName"
				 options:nil];
		[statusNameButton bind:@"toolTip"
				toObject:statusTimelineCollectionViewItem
			 withKeyPath:@"representedObject.userScreenName"
				 options:nil];
	}
	showScreenNames = YES;
}

// Repopulates the main timeline
- (void) populateWithStatuses {
	[mainTimelineCollectionView setContent:self.statuses];
	[mainTimelineCollectionView setNeedsDisplay:YES];
	[mainTimelineCollectionView	displayIfNeededIgnoringOpacity];
}

- (void) populateWithReceivedDMs {
	[mainTimelineCollectionView setContent:self.receivedDirectMessages];
	[mainTimelineCollectionView setNeedsDisplay:YES];
	[mainTimelineCollectionView	displayIfNeededIgnoringOpacity];
}

- (void) populateWithSentDMs {
	[mainTimelineCollectionView setContent:self.sentDirectMessages];
	[mainTimelineCollectionView setNeedsDisplay:YES];
	[mainTimelineCollectionView	displayIfNeededIgnoringOpacity];
}

// Action: Shows/hides the view options banner
- (IBAction) switchViewOptions:sender {
	if ([viewOptionsButton state] == NSOnState) {
		float width = mainTimelineScrollView.frame.size.width;
		float height = mainTimelineScrollView.frame.size.height - 25.0;
		NSSize newSize = NSMakeSize(width, height);
		[[mainTimelineScrollView animator] setFrameSize:newSize];
		[[viewOptionsBox animator] setHidden:NO];
	} else {
		float width = mainTimelineScrollView.frame.size.width;
		float height = mainTimelineScrollView.frame.size.height + 25.0;
		NSSize newSize = NSMakeSize(width, height);
		[[mainTimelineScrollView animator] setFrameSize:newSize];
		[viewOptionsBox setHidden:YES];
	}
}

// Action: Follows user macsphere
- (IBAction) followMacsphere:sender {
	[self createFriendshipWithUser:@"macsphere"];	
}

// Action: Visit Canary website
- (IBAction) visitCanaryWebsite:sender {
	[self openUserURL:@"http://www.canaryapp.com"];
}

// Action: Visit Canary Repository on GitHub
- (IBAction) visitCanaryRepo:sender {
	[self openUserURL:@"http://github.com/macsphere/canary"];
}

- (IBAction) switchFontSize:sender {
	if ([fontSizeControl selectedSegment] == 0) {
		[self changeToSmallFont];
	} else {
		[self changeToLargeFont];
	}
}

- (void) changeToSmallFont {
	[statusTimelineCollectionViewItem setView:nil];
	[mainTimelineCollectionView setContent:NULL];
	[mainTimelineCollectionView setNeedsDisplay:YES];
	[mainTimelineCollectionView displayIfNeededIgnoringOpacity];
	[statusTextField setFont:[NSFont systemFontOfSize:10.0]];
	[statusTimelineCollectionViewItem setView:statusView];
	[self performSelector:@selector(populate)
			   withObject:nil
			   afterDelay:0.5];
}

- (void) changeToLargeFont {
	[statusTimelineCollectionViewItem setView:nil];
	[mainTimelineCollectionView setContent:NULL];
	[mainTimelineCollectionView setNeedsDisplay:YES];
	[mainTimelineCollectionView displayIfNeededIgnoringOpacity];
	[statusTextField setFont:[NSFont systemFontOfSize:12.0]];
	[statusTimelineCollectionViewItem setView:statusView];
	[self performSelector:@selector(populate)
			   withObject:nil
			   afterDelay:0.5];
}

// Action: Performs the instant filtering
- (IBAction) performInstaFiltering:sender {
	if (![((NSSearchField *)sender).stringValue isEqualToString:@""]) {
		ORSFilter *instaFilter = [[ORSFilter alloc] init];
		instaFilter.filterName = ((NSSearchField *)sender).stringValue;
		instaFilter.active = NO;
		instaFilter.predicate = [NSPredicate 
			predicateWithFormat:@"(text contains[cd] %@) OR \
								 (userScreenName contains[cd] %@) OR \
								 (userDescription contains[cd] %@) OR \
								 (userLocation contains[cd] %@) OR \
								 (source contains[cd] %@) OR \
								 (inReplyToScreenName contains[cd] %@)", 
								 ((NSSearchField *)sender).stringValue,
								 ((NSSearchField *)sender).stringValue,
								 ((NSSearchField *)sender).stringValue,
								 ((NSSearchField *)sender).stringValue,
								 ((NSSearchField *)sender).stringValue,
								 ((NSSearchField *)sender).stringValue];
		if ([[filterArrayController selectedObjects] count] > 0) {
			if ([(ORSFilter *)[[filterArrayController selectedObjects]	
							   objectAtIndex:0] active] == NO) {
				[filterArrayController removeSelectedObjects:[filterArrayController selectedObjects]];
				[filterArrayController insertObject:instaFilter 
							  atArrangedObjectIndex:0];
				[filterArrayController setSelectionIndex:0];
			}
		} else {
			[filterArrayController insertObject:instaFilter 
						  atArrangedObjectIndex:0];
			[filterArrayController setSelectionIndex:0];
		}
	} else {
		if ([[filterArrayController selectedObjects] count] > 0) {
			if ([(ORSFilter *)[[filterArrayController selectedObjects]	
						   objectAtIndex:0] active] == NO) {
				[filterArrayController removeSelectedObjects:
					[filterArrayController selectedObjects]];
			}
		}
	}
	if (sender == smallInstaFilterSearchField) {
		[largeInstaFilterSearchField setStringValue:((NSSearchField *)sender).stringValue];
	} else {
		[smallInstaFilterSearchField setStringValue:((NSSearchField *)sender).stringValue];
	}
}


// Speech-related methods

// Action: This is called 
- (IBAction) listen:sender {
	if ([sender state] == NSOffState) {
		// Speech recognition
		recognizer = [[NSSpeechRecognizer alloc] init];
		[recognizer setCommands:spokenCommands];
		[recognizer setDelegate:self];
		[recognizer startListening];
		[sender setState:NSOnState];
	} else {
		[recognizer stopListening];
		[recognizer release];
		recognizer = NULL;
		[sender setState:NSOffState];
	}
}

// Delegate: acts upon the recognition of certain commands
- (void) speechRecognizer:(NSSpeechRecognizer *)sender
	  didRecognizeCommand:(id)command {
	if ([(NSString *)command isEqualToString:@"Tweet"]) {
		[self sendUpdate:sender];
		return;
	}
	if ([(NSString *)command isEqualToString:@"Home"]) {
		[self goHome:sender];
		return;
	}
	if ([(NSString *)command isEqualToString:@"Refresh"]) {
		//[self changeTimeline:sender];
		[self changeSegmentedControlTimeline:sender];
		return;
	}
}


// Friendship methods

// Add user with given ID from friends list (following)
- (void) createFriendshipWithUser:(NSString *)userID {
	if (twitterEngine.sessionUserID) {
		[twitterEngine befriendUserWithScreenName:userID];
		NSString *msg = [NSString stringWithFormat:@"Following %@",
						 userID];
		[self showStatusBarMessage:msg
					withImageNamed:@"user_add"];
		messageDurationTimer = [NSTimer 
								scheduledTimerWithTimeInterval:60 
								target:self selector:@selector(hideStatusBar) 
								userInfo:nil repeats:NO];
	}
}

// Remove user with given ID from friends list (following)
- (void) destroyFriendshipWithUser:(NSString *)userID {
	if (twitterEngine.sessionUserID) {
		[twitterEngine unfriendUserWithScreenName:userID];
		NSString *msg = [NSString stringWithFormat:@"No longer following %@",
						 userID];
		[self showStatusBarMessage:msg
					withImageNamed:@"user_delete"];
		messageDurationTimer = [NSTimer 
								scheduledTimerWithTimeInterval:60 
								target:self selector:@selector(hideStatusBar) 
								userInfo:nil repeats:NO];
	}
}


// Block methods

// Block the user owning the status
- (void) blockUserWithScreenName:(NSString *)userID { 
	if (twitterEngine.sessionUserID) {
		[twitterEngine blockUser:userID];
		NSString *msg = [NSString stringWithFormat:@"%@ has been blocked",
			userID];
		[self showStatusBarMessage:msg
					withImageNamed:@"user_red"];
		messageDurationTimer = [NSTimer 
								scheduledTimerWithTimeInterval:60 
								target:self selector:@selector(hideStatusBar) 
								userInfo:nil repeats:NO];
	}
}

// Unblock the user owning the status
- (void) unblockUserWithScreenName:(NSString *)userID {
	if (twitterEngine.sessionUserID) {
		[twitterEngine unblockUser:userID];
		NSString *msg = [NSString stringWithFormat:@"%@ has been unblocked",
			userID];
		[self showStatusBarMessage:msg withImageNamed:@"user_green"];
		messageDurationTimer = [NSTimer 
								scheduledTimerWithTimeInterval:60 
								target:self selector:@selector(hideStatusBar) 
								userInfo:nil repeats:NO];
	}
}


// Favorite methods

// Favorite the selected status
- (void) favoriteStatus:(NSString *)statusID {
	if (twitterEngine.sessionUserID) {
		[twitterEngine blindFavoriteStatus:statusID];
		[self showStatusBarMessage:@"A new favorite has been added" 
					withImageNamed:@"fave_star"];
		messageDurationTimer = [NSTimer 
								scheduledTimerWithTimeInterval:60 
								target:self selector:@selector(hideStatusBar) 
								userInfo:nil repeats:NO];
	}
}


// STATUS BAR METHODS

- (void) showStatusBarMessage:(NSString *)message
			   withImageNamed:(NSString *)imageName {
	[indicator stopAnimation:self];
	[statusBarTextField setStringValue:message];
	[statusBarImageView setImage:[NSImage imageNamed:imageName]];
	[statusBarTextField setHidden:NO];
	[statusBarImageView setHidden:NO];
	[statusBarButton setEnabled:NO];
	[statusBarButton setHidden:YES];
}

- (void) showAnimatedStatusBarMessage:(NSString *)message {
	[statusBarImageView setHidden:YES];
	[indicator startAnimation:self];
	[statusBarTextField setStringValue:message];
	[statusBarTextField setHidden:NO];
	[statusBarButton setEnabled:NO];
	[statusBarButton setHidden:YES];
}

- (void) hideStatusBar {
	[indicator stopAnimation:self];
	[statusBarTextField setHidden:YES];
	[statusBarImageView setHidden:YES];
	[statusBarButton setEnabled:NO];
	[statusBarButton setHidden:YES];
}


// ACTIONS

// Action: paste
- (IBAction) paste:sender {
	if ([self.window isKeyWindow]) {
		NSPasteboard *generalPasteboard = [NSPasteboard generalPasteboard];
		NSString *originalString = [generalPasteboard 
									stringForType:NSStringPboardType];
		if (originalString != nil) {
			if ([originalString hasPrefix:@"http://"] ||
					[originalString hasPrefix:@"https://"]) {
				if ([(NSNumber *)[defaults 
						objectForKey:@"CanaryWillShortenPastedURLs"] 
							boolValue] == YES) {
					NSString *shortenedURL = [[ORSCanaryController 
						sharedController].urlShortener 
											  shortURLFromOriginalURL:originalString];
					[self insertStringTokenInNewStatusTextField:shortenedURL];
				} else {
					[self insertStringTokenInNewStatusTextField:originalString];
				}
			} else {
				[self insertStringTokenInNewStatusTextField:originalString];
			}
		}
		
	} else {
		[NSApp sendAction:@selector(paste:) to:nil from:self];
	}
}


// ACCESSOR METHODS

// Access methods for the status timeline array
- (void) setStatuses:(NSArray *)theStatuses {
	if (theStatuses.count > [preferences maxShownUpdates]) {
		NSMutableArray *mutableStatuses = [NSMutableArray 
										   arrayWithArray:theStatuses];
		unsigned int count = mutableStatuses.count;
		for (unsigned int i = [preferences maxShownUpdates]; i < count; i++) {
			[mutableStatuses removeObjectAtIndex:[preferences maxShownUpdates]];
		}
		statuses = mutableStatuses;
	} else {
		statuses = theStatuses;
	}
}

- (NSArray *) statuses {
	return statuses;
}

// Access methods for the received direct messages array
- (void) setReceivedDirectMessages:(NSArray *)receivedDMs {
	if (receivedDMs.count > [preferences maxShownUpdates]) {
		NSMutableArray *mutableReceivedDMs = [NSMutableArray 
										   arrayWithArray:receivedDMs];
		unsigned int count = mutableReceivedDMs.count;
		for (unsigned int i = [preferences maxShownUpdates]; i < count; i++) {
			[mutableReceivedDMs removeObjectAtIndex:i];
		}
		receivedDirectMessages = mutableReceivedDMs;
	} else {
		receivedDirectMessages = receivedDMs;
	}
}

- (NSArray *) receivedDirectMessages {
	return receivedDirectMessages;
}

- (void) setSentDirectMessages:(NSArray *)sentDMs {
	if (sentDMs.count > [preferences maxShownUpdates]) {
		NSMutableArray *mutableSentDMs = [NSMutableArray 
											  arrayWithArray:sentDMs];
		unsigned int count = mutableSentDMs.count;
		for (unsigned int i = [preferences maxShownUpdates]; i < count; i++) {
			[mutableSentDMs removeObjectAtIndex:i];
		}
		sentDirectMessages = mutableSentDMs;
	} else {
		sentDirectMessages = sentDMs;
	}
}

- (NSArray *) sentDirectMessages {
	return sentDirectMessages;
}

@end
