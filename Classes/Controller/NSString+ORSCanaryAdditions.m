//
//  NSString+ORSCanaryAdditions.m
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

#import "NSString+ORSCanaryAdditions.h"

@implementation NSString ( ORSCanaryAdditions )

// Detects and replaces HTML Character Entities
+ (NSString *) replaceHTMLEntities:(NSString *)string {
	NSRange range = [string rangeOfString:@"&"];
	if (range.location == NSNotFound)
		return string;
	else {
		range = [string rangeOfString:@"&lt;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&lt;"
													 withString:@"<"];
		range = [string rangeOfString:@"&gt;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&gt;"
													 withString:@">"];
		range = [string rangeOfString:@"&amp;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&amp;"
													 withString:@"&"];
		range = [string rangeOfString:@"&quot;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&quot;"
													 withString:@"\""];
		range = [string rangeOfString:@"&apos;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&apos;"
													 withString:@"\'"];
		range = [string rangeOfString:@"&cent;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&cent;"
													 withString:@"¢"];
		range = [string rangeOfString:@"&pound;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&pound;"
													 withString:@"£"];
		range = [string rangeOfString:@"&yen;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&yen;"
													 withString:@"¥"];
		range = [string rangeOfString:@"&euro;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&euro;"
													 withString:@"€"];
		range = [string rangeOfString:@"&sect;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&sect;"
													 withString:@"§"];
		range = [string rangeOfString:@"&copy;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&copy;"
													 withString:@"©"];
		range = [string rangeOfString:@"&reg;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&reg;"
													 withString:@"®"];
		range = [string rangeOfString:@"&times;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&times;"
													 withString:@"×"];
		range = [string rangeOfString:@"&divide;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&divide;"
													 withString:@"÷"];
		
		range = [string rangeOfString:@"&laquo;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&laquo;"
													withString:@"«"];
		range = [string rangeOfString:@"&not;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&not;"
													withString:@"¬"];
		range = [string rangeOfString:@"&curren;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&curren;"
													withString:@"¤"];
		range = [string rangeOfString:@"&macr;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&macr;"
													withString:@"¯"];
		range = [string rangeOfString:@"&deg;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&deg;"
													withString:@"°"];
		range = [string rangeOfString:@"&plusmn;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&plusmn;"
													withString:@""];
		range = [string rangeOfString:@"&uml;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&uml;"
													withString:@"¨"];
		range = [string rangeOfString:@"&ordf;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&ordf;"
													withString:@"ª"];
		range = [string rangeOfString:@"&sup3;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&sup3;"
													withString:@"³"];
		range = [string rangeOfString:@"&acute;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&acute;"
													withString:@"´"];
		range = [string rangeOfString:@"&micro;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&micro;"
													withString:@"µ"];
		range = [string rangeOfString:@"&para;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&para;"
													withString:@"¶"];
		range = [string rangeOfString:@"&middot;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&middot;"
													withString:@"·"];
		range = [string rangeOfString:@"&cedil;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&cedil;"
													withString:@"¸"];
		range = [string rangeOfString:@"&sup1;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&sup1;"
													withString:@"¹"];
		range = [string rangeOfString:@"&ordm;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&ordm;"
													withString:@"º"];
		range = [string rangeOfString:@"&raquo;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&raquo;"
													withString:@"»"];
		range = [string rangeOfString:@"&frac14;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&frac14;"
													withString:@"¼"];
		range = [string rangeOfString:@"&frac12;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&frac12;"
													withString:@"¹"];
		range = [string rangeOfString:@"&frac34;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&frac34;"
													withString:@"¾"];
		range = [string rangeOfString:@"&iquest;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&iquest;"
													withString:@"¿"];
		range = [string rangeOfString:@"&#8217;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&#8217;"
													withString:@"’"];
		range = [string rangeOfString:@"&iexcl;"];
		if (range.location != NSNotFound)
			return [string stringByReplacingOccurrencesOfString:@"&iexcl;"
													withString:@"¡"];
		
		return string;
	}
}

@end
