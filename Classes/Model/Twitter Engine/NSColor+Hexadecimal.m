// Code found in ADC Technical Q&A QA1576:
// How do I get the hexadecimal value of an NSColor object?

#import "NSColor+Hexadecimal.h"

@implementation NSColor ( NSColorHexadecimalValue )

- (NSString *) hexadecimalValue {
	CGFloat redFloatValue, greenFloatValue, blueFloatValue;
	NSInteger redIntValue, greenIntValue, blueIntValue;
	NSString *redHexValue, *greenHexValue, *blueHexValue;
	
	// Convert the NSColor to the RGB color space before we can
	// access its components
	NSColor *convertedColor = [self 
		colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	if (convertedColor) {
		// Get the red, green, and blue components of the color
		[convertedColor getRed:&redFloatValue 
						 green:&greenFloatValue 
						  blue:&blueFloatValue 
						 alpha:NULL];
		
		// Convert the components to numbers (unsigned decimal integer) 
		// between 0 and 255
		redIntValue = redFloatValue * 255.99999f;
		greenIntValue = greenFloatValue * 255.99999f;
		blueIntValue = blueFloatValue * 255.99999f;
		
		// Convert the numbers to hex strings
		redHexValue = [NSString stringWithFormat:@"%02x", redIntValue];
		greenHexValue = [NSString stringWithFormat:@"%02x", greenIntValue];
		blueHexValue = [NSString stringWithFormat:@"%02x", blueIntValue];
		
		// Concatenate the red, green, and blue components' hex strings 
		// together with a "#"
		return [NSString stringWithFormat:@"#%@%@%@", redHexValue, 
				greenHexValue, blueHexValue];
	}
	return nil;
}

@end
