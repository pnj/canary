//
//  ORSCanaryCollectionView.m
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

#import "ORSCanaryCollectionView.h"

@implementation ORSCanaryCollectionView

- (void) drawRect:(NSRect)rect {
	if ([[self content] count] > 0) {
		[super drawRect:rect];
	} else {
		NSRect bounds = [self bounds];
		[[NSColor controlColor] set];
		[NSBezierPath fillRect:bounds];
		
		NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
		[attributes setObject:[NSFont boldSystemFontOfSize:12] 
					   forKey:NSFontAttributeName];
		[attributes setObject:[NSColor grayColor]
					   forKey:NSForegroundColorAttributeName];
		NSString *string = @"This timeline is empty.";
		NSSize strSize = [string sizeWithAttributes:attributes];
		NSPoint strOrigin;
		strOrigin.x = bounds.origin.x + (bounds.size.width - strSize.width)/2;
		strOrigin.y = bounds.origin.y + (bounds.size.height - strSize.height)/2;
		[string drawAtPoint:strOrigin withAttributes:attributes];
	}
}

- (BOOL) isOpaque {
	return YES;
}

@end
