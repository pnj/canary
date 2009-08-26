//
//  ORSUpdateDispatcher.m
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

#import "ORSUpdateDispatcher.h"

@implementation ORSUpdateDispatcher

- (id) initWithEngine:(ORSTwitterEngine *)engine {
	if (self = [super init]) {
		twitterEngine = engine;
		queueArray = [NSMutableArray new];
	}
	return self;
}

- (void) addMessage:(NSString *)message {	
	@synchronized(self) {
		BOOL directMessage = NO;
		NSScanner *scanner = [NSScanner scannerWithString:message];
		NSString *token = NULL;
		[scanner scanUpToString:@" " intoString:&token];
		if ([token isEqualToString:@"d"] || [token isEqualToString:@"D"]) {
			[scanner scanUpToString:@" " intoString:&token];
			directMessage = YES;
			message = [[scanner string] 
					   substringFromIndex:[scanner scanLocation]+1];
		} else { 
			directMessage = NO;
		}
	
		unsigned int updateLength = [message length];
		NSMutableString *messagePart = NULL;
		NSMutableString *remainingMessage = [NSMutableString 
										stringWithString:message];
		BOOL firstMessage = YES;
	
		if (updateLength > 140) {
			while ([remainingMessage length] > 136) {
				NSRange rangeOfLastWhitespace = [remainingMessage 
					rangeOfString:@" " options:NSBackwardsSearch 
										  range:NSMakeRange(0, 136)];
				NSRange rangeOfMessagePart = NSMakeRange(0, 
											rangeOfLastWhitespace.location+1);
				messagePart = [NSMutableString 
					stringWithString:[remainingMessage 
									  substringWithRange:rangeOfMessagePart]];
				[remainingMessage deleteCharactersInRange:rangeOfMessagePart];
				if (firstMessage) {
					[messagePart appendString:@" »"];
					firstMessage = NO;
				} else {
					[messagePart insertString:@"» " atIndex:0];
					[messagePart appendString:@" »"];
				}
				[queueArray addObject:(NSString *)messagePart];
			}
			[remainingMessage insertString:@"» " atIndex:0];
			[queueArray addObject:(NSString *)remainingMessage];
		} else {
			[queueArray addObject:(NSString *)message];
		}

		if (directMessage) {
			[self initiateDMDispatch:[NSNotification 
				notificationWithName:@"" object:token]];
		} else {
			[self initiateStatusDispatch:nil];
		}
	}
}

- (void) initiateStatusDispatch:(NSNotification *)note {
	@synchronized(self) {
		if ([queueArray count] > 0) {
			[twitterEngine postStatus:[queueArray objectAtIndex:0]
							inReplyTo:nil];
			[queueArray removeObjectAtIndex:0];
			[self performSelector:@selector(initiateStatusDispatch:) 
					   withObject:nil
					   afterDelay:6.0];
		}
	}
}

- (void) initiateDMDispatch:(NSNotification *)note {
	@synchronized(self) {
		if ([queueArray count] > 0) {
			[twitterEngine sendDM:[queueArray objectAtIndex:0]
			 toUserWithScreenName:(NSString *)[note object]];
			[queueArray removeObjectAtIndex:0];
			[self performSelector:@selector(initiateDMDispatch:) 
					   withObject:nil
					   afterDelay:6.0];
		}
	}
}

@end
