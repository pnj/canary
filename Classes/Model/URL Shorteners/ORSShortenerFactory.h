//
//  ORSShortenerFactory.h
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

/*!
 @header ORSShortenerFactory
 @abstract Generates a URL shortener that corresponds to a given type.
 @author Nicholas Toumpelis
 @copyright Nicholas Toumpelis, Ocean Road Software
 @version 0.7.1
 @updated 2008-10-18
 */

#import "ORSShortener.h"
#import "ORSAdjixShortener.h"
#import "ORSBitlyShortener.h"
#import "ORSCligsShortener.h"
#import "ORSIsgdShortener.h"
#import "ORSSnipURLShortener.h"
#import "ORSTinyURLShortener.h"
#import "ORSTrimShortener.h"
#import "ORSUrlborgShortener.h"

/*!
 @enum ORSShortenerTypes
 Contains constants for all available URL shorteners.
 */
enum {
	ORSAdjixShortenerType = 1,
	ORSBitlyShortenerType = 2,
	ORSCligsShortenerType = 3,
	ORSIsgdShortenerType = 4,
	ORSSnipURLShortenerType = 5,
	ORSTinyURLShortenerType = 6,
	ORSTrimShortenerType = 7,
	ORSUrlborgShortenerType = 8
};

/*!
 @typedef ORSShortenerTypes
 Defines the type for constants for all available URL shorteners.
 */
typedef NSUInteger ORSShortenerTypes;

/*!
 @class ORSShortenerFactory
 @group URL Shorteners
 @abstract Generates a URL shortener that corresponds to a given type.
 @author Nicholas Toumpelis
 @version 0.7.1
 @updated 2008-10-18
 */
@interface ORSShortenerFactory : NSObject {

}

/*!
 @method getShortener:
 Returns the URL shortener that corresponds to the given shortener type.
 */
+ (id <ORSShortener>) getShortener:(NSUInteger)shortenerType;

@end