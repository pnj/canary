//
//  ORSCanaryStatusView.m
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

#import "ORSCanaryStatusView.h"

@implementation ORSCanaryStatusView

- (BOOL) acceptsFirstMouse:(NSEvent *)theEvent {
	return YES;
}

/*- (NSView *) hitTest:(NSPoint)aPoint {
	NSView *result = [super hitTest:aPoint];
	if (result && !([result isKindOfClass:[NSButton class]] ||
				   ([result isKindOfClass:[NSTextField class]]))) {
		return self;
	} else {
		return result;
	}
}*/

- (void) drawRect:(NSRect)rect {
	/*if ([self selected] && [self isKindOfClass:[ORSCanaryStatusView	class]]) {
		[[NSColor colorWithDeviceRed:.651
							   green:.717
								blue:.919 
							   alpha:1.0] setFill];
		NSRectFill([self bounds]);
	} else {*/
		NSGradient *gradient = [[NSGradient alloc] 
			initWithStartingColor:[NSColor colorWithDeviceRed:0.784 
													  green:0.784 
													   blue:0.784 
													  alpha:1.0]
								endingColor:[NSColor colorWithDeviceRed:0.988 
													   green:0.988 
														blue:0.988 
													   alpha:1.0]];
		[gradient drawInRect:[self bounds] angle:90.0];
	//}
	//[super drawRect:rect];
}

- (void) setSelected:(BOOL)flag {
	m_isSelected = flag;
}

- (BOOL) selected {
	return m_isSelected;
}

@end
