//
//  ORSAdjixShortener.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 18/10/2008.
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

#import "ORSAdjixShortener.h"

@implementation ORSAdjixShortener

// This method returns the generated (shortened) URL that corresponds to the 
// given (original) URL.
- (NSString *) shortURLFromOriginalURL:(NSString *)originalURL {
	return [self shortURLFromAuthenticatedURL:originalURL];
}

// This method returns the generated (shortened) URL that corresponds to the
// given (original) URL using a specified set of authentication credentials.
- (NSString *) shortURLFromAuthenticatedURL:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *partnerID = [defaults stringForKey:@"AdjixPartnerID"];
	NSString *partnerEmail = [defaults stringForKey:@"AdjixPartnerEmail"];
	NSString *adType = [defaults stringForKey:@"AdjixAdType"];
	int useIDOrEmail = [defaults integerForKey:@"AdjixUseIDOrEmail"];
	BOOL generateUltraShortURLs = [defaults 
								   boolForKey:@"AdjixGenerateUltraShortURLs"];
	
	NSMutableString *requestURL = [NSMutableString 
		stringWithFormat:@"http://api.adjix.com/shrinkLink?url=%@", 
								   originalURL];
	if (useIDOrEmail == 0) {
		if (partnerID) {
			[requestURL appendFormat:@"&partnerID=%@", partnerID];
		}
	} else {
		if (partnerEmail) {
			[requestURL appendFormat:@"&partnerEmail=%@", partnerEmail];
		}
	}
	
	if (adType) {
		[requestURL appendFormat:@"&at=%@", adType];
	}
	
	if (generateUltraShortURLs) {
		[requestURL appendString:@"&ultraShort=y"];
	}
	
	return [super shortURLStringFromRequestURL:requestURL];
}

@end
