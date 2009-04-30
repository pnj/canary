//
//  ORSCligsShortener.m
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

#import "ORSCligsShortener.h"

@implementation ORSCligsShortener

// This method returns the generated (shortened) URL that corresponds to the 
// given (original) URL.
- (NSString *) shortURLFromOriginalURL:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults boolForKey:@"CligsUseAuthentication"]) {
		return [self shortURLFromAuthenticatedURL:originalURL];
	} else {
		NSString *requestURL = [NSString 
			stringWithFormat:@"http://cli.gs/api/v1/cligs/create?url=%@&appid=canary", 
								originalURL];
		return [super shortURLStringFromRequestURL:requestURL];
	}
}

// This method returns the generated (shortened) URL that corresponds to the
// given (original) URL using a specified set of authentication credentials.
- (NSString *) shortURLFromAuthenticatedURL:(NSString *)originalURL {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *apiKey = [defaults stringForKey:@"CligsAPIKey"];
	NSMutableString *requestURL = [NSMutableString 
		stringWithFormat:@"http://cli.gs/api/v1/cligs/create?url=%@&appid=canary", 
								   originalURL];
	if (apiKey) {
		[requestURL appendFormat:@"&key=%@", apiKey];
	}
	
	return [super shortURLStringFromRequestURL:requestURL];
}

@end
