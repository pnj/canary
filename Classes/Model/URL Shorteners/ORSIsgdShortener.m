//
//  ORSIsgdShortener.m
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

#import "ORSIsgdShortener.h"

@implementation ORSIsgdShortener

// This method returns the generated (shortened) URL that corresponds to the 
// given (original) URL.
- (NSString *) generateURLFrom:(NSString *)originalURL {
	NSString *requestURL = [NSString 
		stringWithFormat:@"http://is.gd/api.php?longurl=%@", originalURL];
	/*NSURLRequest *request = [NSURLRequest 
		requestWithURL:[NSURL URLWithString:requestURL]
			cachePolicy:NSURLRequestUseProtocolCachePolicy
				 timeoutInterval:21.0];
	NSURLResponse *response = nil;
	NSError *error = nil;
	return [[NSString alloc] initWithData:[NSURLConnection 
		sendSynchronousRequest:request returningResponse:&response error:&error]
								 encoding:NSASCIIStringEncoding];*/
	return [super generateURLFromRequestURL:requestURL];
}

@end
