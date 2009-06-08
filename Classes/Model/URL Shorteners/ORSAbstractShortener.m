//
//  ORSAbstractShortener.m
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 27/12/2008.
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

#import "ORSAbstractShortener.h"

@implementation ORSAbstractShortener

// This method returns the generated (shortened) URL that corresponds to the 
// given (original) URL.
- (NSString *) shortURLFromOriginalURL:(NSString *)originalURL {
	return NULL;
}

// This should be used by all concrete classes that implement 
// shortURLFromOriginalURL:. It generates the actual request that is sent to the 
// remote server and returns the shortened URL data. In some cases, the 
// shortener might not actually return the shortened URL, but a whole bunch of 
// XML tags.
- (NSData *) shortURLDataFromRequestURL:(NSString *)requestURL {
	NSURLRequest *request = 
		[NSURLRequest requestWithURL:[NSURL URLWithString:requestURL]
						 cachePolicy:NSURLRequestUseProtocolCachePolicy
					 timeoutInterval:21.0];
	NSURLResponse *response = nil;
	NSError *error = nil;
	return [NSURLConnection sendSynchronousRequest:request 
								 returningResponse:&response 
											 error:&error];
}

// This should be used by all concrete classes that implement 
// shortURLFromOriginalURL: and would like to send POST requests. It generates 
// the actual request that is sent to the remote server and returns the 
// shortened URL data. In some cases, the shortener might not actually return 
// the shortened URL, but a whole bunch of XML tags.
- (NSData *) shortURLDataFromPostRequestURL:(NSString *)requestURL {
	NSMutableURLRequest *request = 
	[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]
							cachePolicy:NSURLRequestUseProtocolCachePolicy
						timeoutInterval:21.0];
	[request setHTTPMethod:@"POST"];
	NSURLResponse *response = nil;
	NSError *error = nil;
	return [NSURLConnection sendSynchronousRequest:request 
								 returningResponse:&response 
											 error:&error];
}

// This should be used by all concrete classes that implement 
// shortURLFromOriginalURL:. It generates the actual request that is sent to the 
// remote server and returns the shortened URL string. In some cases, the 
// shortener might not actually return the shortened URL, but a whole bunch of 
// XML tags.
- (NSString *) shortURLStringFromRequestURL:(NSString *)requestURL {
	return [[NSString alloc] 
			initWithData:[self shortURLDataFromRequestURL:requestURL]
			encoding:NSASCIIStringEncoding];
}

// This should be used by all concrete classes that implement 
// shortURLFromOriginalURL: and would like to send POST requests. It generates 
// the actual request that is sent to the remote server and returns the 
// shortened URL string. In some cases, the shortener might not actually return 
// the shortened URL, but a whole bunch of XML tags.
- (NSString *) shortURLStringFromPostRequestURL:(NSString *)requestURL {
	return [[NSString alloc] 
			initWithData:[self shortURLDataFromPostRequestURL:requestURL]
			encoding:NSASCIIStringEncoding];
}

@end
