//
//  ORSUrlborgShortener.h
//  URL Shorteners
//
//  Created by Nicholas Toumpelis on 24/02/2009.
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

/*!
 @header ORSUrlborgShortener
 @abstract Represents a urlBorg shortener.
 @author Nicholas Toumpelis
 @copyright Nicholas Toumpelis, Ocean Road Software
 @version 0.7.1
 @updated 2009-02-24
 */

#import "ORSAbstractShortener.h"

/*!
 @class ORSUrlborgShortener
 @group URL Shorteners
 @abstract Represents a urlBorg shortener.
 @author Nicholas Toumpelis
 @version 0.7.1
 @updated 2009-02-24
 */
@interface ORSUrlborgShortener : ORSAbstractShortener {
	
}

/*!
 @method shortURLFromOriginalURL:
 Returns the URL shortener that corresponds to the given shortener type.
 */
- (NSString *) shortURLFromOriginalURL:(NSString *)originalURL;

/*
 @method shortURLFromAuthenticatedURL:
 This method returns the generated (shortened) URL that corresponds to the
 given (original) URL using a specified set of authentication credentials.
 */
- (NSString *) shortURLFromAuthenticatedURL:(NSString *)originalURL;

@end

