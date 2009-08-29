//
//  ORSCanaryController.h
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

#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <Quartz/Quartz.h>
#import "ORSShortener.h"
#import "ORSCredentialsManager.h"

#import "ORSCanaryPreferences.h"
#import "ORSShortenerFactory.h"
#import "ORSUpdateDispatcher.h"
#import "ORSDateDifferenceFormatter.h"
#import "NSXMLNode+ORSTwitterStatusAdditions.h"
#import "NSXMLNode+ORSTwitterDMAdditions.h"
#import "ORSCanaryPreferencesController.h"
#import "ORSCanaryAboutController.h"
#import "ORSTimelineCacheManager.h"
#import <Growl/GrowlApplicationBridge.h>
#import "ORSCanaryLoginController.h"
#import "ORSTwitPicDispatcher.h" 
#import "ORSAsyncTwitPicDispatcher.h"
#import "iTunes.h"
#import "ORSFilter.h"
#import "ORSFilterTransformer.h"
#import "ORSFilterArrayTransformer.h"
#import "ORSTwitterEngine+Block.h"
#import "ORSTwitterEngine+Favorite.h"
#import "ORSTwitterEngine+Account.h"
#import "ORSTwitterEngine+Friendship.h"
#import "ORSTwitterEngine+Timeline.h"
#import "ORSScreenNameToBooleanTransformer.h"

@interface ORSCanaryController : NSWindowController < GrowlApplicationBridgeDelegate > {
	// Fundamentals
	ORSCredentialsManager *authenticator;
	ORSTwitterEngine *twitterEngine;
	id <ORSShortener> urlShortener;
	ORSUpdateDispatcher *updateDispatcher;
	ORSTimelineCacheManager *cacheManager;
	ORSCanaryPreferences *preferences;
	// Extra Windows
	IBOutlet NSWindow *aboutWindow;
	IBOutlet NSWindow *newUserWindow;
	// Status View Outlets
	IBOutlet NSButton *statusNameButton;
	IBOutlet NSTextField *statusTextField;
	IBOutlet NSView *statusView;
	IBOutlet NSBox *statusBox;
	IBOutlet NSTextField *dateDifferenceTextField;
	// Main Window Outlets
	IBOutlet NSCollectionView *mainTimelineCollectionView;
	IBOutlet NSScrollView *mainTimelineScrollView;
	IBOutlet NSTextField *newStatusTextField;
	IBOutlet NSButton *tweetButton;
	IBOutlet NSLevelIndicator *charsLeftIndicator;
	IBOutlet NSProgressIndicator *indicator;
	IBOutlet NSView *contentView;
	IBOutlet NSCollectionViewItem *statusTimelineCollectionViewItem;
	IBOutlet NSImageView *statusBarImageView;
	IBOutlet NSTextField *statusBarTextField;
	IBOutlet NSButton *statusBarButton;
	IBOutlet NSMenuItem *switchNamesMenuItem;
	// Received DMs Collection View Item Outlets
	IBOutlet NSCollectionViewItem *receivedDMsCollectionViewItem;
	// Sent DMs Collection View Item Outlets
	IBOutlet NSCollectionViewItem *sentDMsCollectionViewItem;
	// Received DMs View Outlets
	IBOutlet NSButton *receivedDMButton;
	IBOutlet NSTextField *receivedDMTextField;
	IBOutlet NSView *receivedDMView;
	IBOutlet NSBox *receivedDMBox;
	IBOutlet NSTextField *receivedDMDateDifferenceTextField;
	// Sent DMs View Outlets
	IBOutlet NSButton *sentDMButton;
	IBOutlet NSTextField *sentDMTextField;
	IBOutlet NSView *sentDMView;
	IBOutlet NSBox *sentDMBox;
	IBOutlet NSTextField *sentDMDateDifferenceTextField;
	// Array Controllers
	IBOutlet NSArrayController *statusArrayController;
	IBOutlet NSArrayController *receivedDMsArrayController;
	IBOutlet NSArrayController *sentDMsArrayController;
	// View Options
	IBOutlet NSBox *viewOptionsBox;
	IBOutlet NSButton *viewOptionsButton;
	IBOutlet NSSegmentedControl *viewOptionsNamesControl;
	IBOutlet NSMenuItem *filterMenuItem;
	IBOutlet NSMenu *availableFiltersMenu;
	IBOutlet NSSegmentedControl *fontSizeControl;
	int namesSelectedSegment;
	IBOutlet NSPopUpButton *filterPopUpButton;
	IBOutlet NSBox *instaFilterBox;
	IBOutlet NSBox *smallInstaFilterBox;
	IBOutlet NSMenu *viewMenu;
	IBOutlet NSMenu* filterMenu;
	IBOutlet NSSearchField *smallInstaFilterSearchField;
	IBOutlet NSSearchField *largeInstaFilterSearchField;
	IBOutlet NSArrayController *filterArrayController;
	
	NSString *previousUpdateText; // The text of the last attempted update
	NSArray *statuses;
	NSArray *receivedDirectMessages;
	NSArray *sentDirectMessages;
	NSUserDefaults *defaults;
	
	NSTimer *refreshTimer;
	NSTimer *backgroundReceivedDMTimer;
	NSTimer *messageDurationTimer;
	SecKeychainItemRef loginItem;
	NSString *visibleUserID;
	
	NSString *prevUserID;
	NSString *prevPassword;
	
	NSArray *spokenCommands;
	NSSpeechRecognizer *recognizer;
	NSString *previousTimeline;
	
	BOOL firstBackgroundReceivedDMRetrieval;
	BOOL connectionErrorShown;
	BOOL betweenUsers;
	
	// Selected status update text field
	NSRange realSelectedRange;
	
	BOOL firstFollowingTimelineRun;
	BOOL showScreenNames;
	
	NSInteger activeSegment;
	
	IBOutlet NSSegmentedControl *timelineSegControl;
}

+ (ORSCanaryController *) sharedController;
+ (id) allocWithZone:(NSZone *)zone;
- (id) copyWithZone:(NSZone *)zone;
- (void) applicationDidFinishLaunching:(NSNotification *)aNotification;
- (IBAction) sendUpdate:sender;
- (IBAction) retypePreviousUpdate:sender;
- (IBAction) changeSegmentedControlTimeline:sender;
- (IBAction) friendsTimelineMenuItemClicked:sender;
- (IBAction) mentionsTimelineMenuItemClicked:sender;
- (IBAction) messagesTimelineMenuItemClicked:sender;
- (IBAction) favoritesTimelineMenuItemClicked:sender;
- (void) scrollToTop;
- (void) updateTimer;
- (void) setupReceivedDMTimer;
- (void) updateMaxNoOfShownUpdates;
- (void) updateSelectedURLShortener;
- (void) setStatusesAsynchronously:(NSNotification *)note;
- (void) setUsersAsynchronously:(NSNotification *)note;
- (void) setDMsAsynchronously:(NSNotification *)note;
- (void) addSentStatusAsynchronously:(NSNotification *)note;
- (void) addSentDMsAsynchronously:(NSNotification *)note;
- (void) getFriendsTimeline;
- (void) getUserTimeline;
- (void) getPublicTimeline;
- (void) getMentions;
- (void) getFavorites;
- (void) getReceivedMessages;
- (void) getSentMessages;
- (IBAction) goHome:sender;
- (IBAction) typeUserID:sender;
- (IBAction) dmUserID:sender;
- (IBAction) shortenURL:sender;
- (IBAction) openUserURL:sender; 
- (void) applicationWillTerminate:(NSNotification *)notification;
- (void) retweetStatus:(NSString *)statusText
fromUserWithScreenName:(NSString *)userID;
- (void) updateNewStatusTextField;
- (void) performAutocomplete;
- (IBAction) invokeActionOnUser:sender;
- (void) showUserBlockAlertSheet:(NSString *)userScreenName;
- (void) blockUserAlertDidEnd:(NSAlert *)alert
				   returnCode:(int)returnCode
				  contextInfo:(void *)contextInfo;
- (IBAction) showAboutWindow:sender;
- (IBAction) showPreferencesWindow:sender;
- (IBAction) showLoginWindow:sender;
- (void) showNewUserWindow;
- (IBAction) signupForNewAccountCall:sender;
- (IBAction) loginCall:sender;
- (IBAction) closeCall:sender;
- (IBAction) quitCall:sender;
- (void) didEndNewUserSheet:(NSWindow *)sheet
				 returnCode:(int)returnCode
				contextInfo:(void *)contextInfo;
- (IBAction) sendFeedback:sender;
- (IBAction) changeToReceivedDMs:sender;
- (IBAction) createNewTwitterAccount:sender;
- (IBAction) sendImageToTwitPic:sender;
- (void) executeCallToTwitPicWithFile:(NSString *)filename;
- (void) executeCallToTwitPicWithData:(NSData *)imageData;
- (void) executeAsyncCallToTwitPicWithFile:(NSString *)filename;
- (void) executeAsyncCallToTwitPicWithData:(NSData *)imageData;
- (void) printTwitPicURL:(NSNotification *)note;
- (void) showConnectionFailure:(NSNotification *)note;
- (void) showReceivedResponse:(NSNotification *)note;
- (IBAction) showPictureTaker:sender;
- (void) pictureTakerDidEnd:(IKPictureTaker *)picker
				 returnCode:(NSInteger)code
				contextInfo:(void *)contextInfo;
- (BOOL) applicationShouldHandleReopen:(NSApplication *)theApplication	
					 hasVisibleWindows:(BOOL)flag;
- (IBAction) insertITunesCurrentTrackFull:sender;
- (IBAction) insertITunesCurrentTrackName:sender;
- (IBAction) insertITunesCurrentTrackAlbum:sender;
- (IBAction) insertITunesCurrentTrackArtist:sender;
- (IBAction) insertITunesCurrentTrackGenre:sender;
- (IBAction) insertITunesCurrentTrackComposer:sender;
- (void) insertStringTokenInNewStatusTextField:(NSString *)stringToken;
- (IBAction) switchBetweenUserNames:sender;
- (void) changeToUsernames;
- (void) changeToScreenNames;
- (void) populateWithStatuses;
- (void) populateWithReceivedDMs;
- (void) populateWithSentDMs;
- (IBAction) switchViewOptions:sender;
- (IBAction) followMacsphere:sender;
- (IBAction) visitCanaryWebsite:sender;
- (IBAction) visitCanaryRepo:sender;
- (IBAction) switchFontSize:sender;
- (void) changeToSmallFont;
- (void) changeToLargeFont;
- (IBAction) performInstaFiltering:sender;

- (IBAction) listen:sender;
- (void) speechRecognizer:(NSSpeechRecognizer *)sender
	  didRecognizeCommand:(id)aCommand;

// Friendship methods
- (void) createFriendshipWithUser:(NSString *)userID;
- (void) destroyFriendshipWithUser:(NSString *)userID;

// Block methods
- (void) blockUserWithScreenName:(NSString *)userID;
- (void) unblockUserWithScreenName:(NSString *)userID;

// Favorite methods
- (void) favoriteStatus:(NSString *)statusID;

// Status bar methods
- (void) showStatusBarMessage:(NSString *)message
			   withImageNamed:(NSString *)imageName;
- (void) showAnimatedStatusBarMessage:(NSString *)message;
- (void) hideStatusBar;

- (IBAction) paste:sender;

- (void) setStatuses:(NSArray *)theStatuses;
- (NSArray *) statuses;
- (void) setReceivedDirectMessages:(NSArray *)receivedDMs;
- (NSArray *) receivedDirectMessages;
- (void) setSentDirectMessages:(NSArray *)sentDMs;
- (NSArray *) sentDirectMessages;

@property (copy) NSArray *statuses;
@property (copy) NSArray *receivedDirectMessages;
@property (assign) NSArray *sentDirectMessages;
@property (assign) NSString *visibleUserID;
@property (assign) NSString *previousTimeline;

@property (assign) ORSCredentialsManager *authenticator;
@property (assign) ORSTwitterEngine *twitterEngine;
@property (assign) ORSCanaryPreferences *preferences;
@property (assign) id <ORSShortener> urlShortener;
@property (assign) ORSUpdateDispatcher *updateDispatcher;
@property (assign) ORSTimelineCacheManager *cacheManager;
@property (assign) NSWindow *aboutWindow;
@property (assign) NSTextField *statusTextField;
@property (assign) NSView *statusView;
@property (assign) NSBox *statusBox;
@property (assign) NSTextField *dateDifferenceTextField;
@property (assign) NSCollectionView *mainTimelineCollectionView;
@property (assign) NSScrollView *mainTimelineScrollView;
@property (assign) NSTextField *newStatusTextField;
@property (assign) NSButton *tweetButton;
@property (assign) NSLevelIndicator *charsLeftIndicator;
@property (assign) NSProgressIndicator *indicator;
@property (assign) NSView *contentView;
@property (assign) NSCollectionViewItem *statusTimelineCollectionViewItem;
@property (assign) NSTextField *receivedDMTextField;
@property (assign) NSView *receivedDMView;
@property (assign) NSBox *receivedDMBox;
@property (assign) NSTextField *receivedDMDateDifferenceTextField;
@property (assign) NSTextField *sentDMTextField;
@property (assign) NSView *sentDMView;
@property (assign) NSBox *sentDMBox;
@property (assign) NSTextField *sentDMDateDifferenceTextField;
@property (assign) NSArrayController *statusArrayController;
@property (assign) NSUserDefaults *defaults;
@property (assign) NSTimer *refreshTimer;
@property SecKeychainItemRef loginItem;
@property (assign) NSString *prevUserID;
@property (assign) NSString *prevPassword;
@property (assign) NSArray *spokenCommands;
@property (assign) NSSpeechRecognizer *recognizer;
@property () BOOL firstBackgroundReceivedDMRetrieval;
@property () BOOL betweenUsers;
@property () NSRange realSelectedRange;
@property () BOOL showScreenNames;
@property (assign) NSTextField *statusBarTextField;
@property (assign) NSImageView *statusBarImageView;
@property (assign) NSButton *statusBarButton;

@end
