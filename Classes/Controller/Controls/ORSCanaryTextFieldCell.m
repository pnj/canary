//
//  ORSCanaryTextFieldCell.m
//  Controls
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

#import "ORSCanaryTextFieldCell.h"

@implementation ORSCanaryTextFieldCell

// Configures the attributed string for the text field cell (for each status)
- (NSAttributedString *) attributedStringValue {
	NSString *initialString = [[[super attributedStringValue] string] 
				stringByReplacingOccurrencesOfString:@"\n"
							   withString:@" "];							   
	NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]
		initWithString:[NSString replaceHTMLEntities:initialString]];
	NSFont *textFont = [NSFont systemFontOfSize:10.2];
	//NSFont *textFont = [NSFont systemFontOfSize:12.2];
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
								textFont, NSFontAttributeName, NULL];
	[attString beginEditing];
	[attString addAttributes:attributes 
					   range:NSMakeRange(0, attString.length)];
	/*if ([attString.string rangeOfString:@":)"].location != NSNotFound) {
		NSRange oldRange = [attString.string rangeOfString:@":)"];
		NSRange newRange = NSMakeRange(oldRange.location, 0);
		[attString replaceCharactersInRange:newRange
					   withAttributedString:[attString emoticonStringWithName:@"Smile"]];
	}*/
	[attString highlightElements];
	[attString endEditing];
	[super setAttributedStringValue:attString];
	return attString;
}

@end