//
//  ORSCanaryAboutController.m
//  Other Controllers
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

#import "ORSCanaryAboutController.h"

@implementation ORSCanaryAboutController

static ORSCanaryAboutController *sharedAboutController = nil;

+ (ORSCanaryAboutController *)sharedAboutController {
	@synchronized(self) {
		if (sharedAboutController == nil) {
			[[self alloc] initWithWindowNibName:@"About"];
		}
	}
	return sharedAboutController;
}

+ (id) allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedAboutController == nil) {
			sharedAboutController = [super allocWithZone:zone];
			return sharedAboutController;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
} 

- (void) windowWillClose:(NSNotification *)notification {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat:self.window.frame.origin.x
				forKey:@"CanaryAboutWindowX"];
	[defaults setFloat:self.window.frame.origin.y
				forKey:@"CanaryAboutWindowY"];
	[defaults setFloat:self.window.frame.size.width
				forKey:@"CanaryAboutWindowWidth"];
	[defaults setFloat:self.window.frame.size.height
				forKey:@"CanaryAboutWindowHeight"];
}

- (void) awakeFromNib {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults floatForKey:@"CanaryAboutWindowX"]) {
		NSRect newFrame = NSMakeRect(
			[defaults floatForKey:@"CanaryAboutWindowX"],
			[defaults floatForKey:@"CanaryAboutWindowY"],
			[defaults floatForKey:@"CanaryAboutWindowWidth"],
			[defaults floatForKey:@"CanaryAboutWindowHeight"]);
		[[self window] setFrame:newFrame display:YES];
	} else {
		[self.window center];
	}
}

@end
