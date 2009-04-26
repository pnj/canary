//
//  ORSAbstractShortener.h
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

/*!
 @header ORSAbstractShortener
 @abstract Abstract superclass used for defining URL shorteners. All shorteners
 should be subclasses of this.
 @author Nicholas Toumpelis
 @copyright Nicholas Toumpelis, Ocean Road Software
 @version 0.7.1
 @updated 2008-12-27
 */

#import <Cocoa/Cocoa.h>
#import "ORSShortener.h"

/*!
 @class ORSAbstractShortener
 @group URL Shorteners
 @abstract Abstract superclass used for defining URL shorteners. All shorteners
 should be subclasses of this.
 @author Nicholas Toumpelis
 @version 0.7.1
 @updated 2008-12-27
 */
@interface ORSAbstractShortener : NSObject <ORSShortener> {

}

/*!
 @method getShortener:
 Returns the URL shortener that corresponds to the given shortener type. This
 method is abstract and if not overloaded (by a concrete URL shortener) returns
 NULL.
 */
- (NSString *) generateURLFrom:(NSString *)originalURL;

/*!
 @method generateURLFromRequestURL:
 This should be used by all concrete classes that implement generateURLFrom:. It
 generates the actual request that is sent to the remote server.
 */
- (NSString *) generateURLFromRequestURL:(NSString *)requestURL;

/*!
 @method generateURLFromPostRequestURL:
 This should be used by all concrete classes that implement generateURLFrom: and 
 would like to send POST requests. It generates the actual request that is sent 
 to the remote server.
 */
- (NSString *) generateURLFromPostRequestURL:(NSString *)requestURL;

@end
