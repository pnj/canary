// Code found in ADC Technical Q&A QA1576:
// How do I get the hexadecimal value of an NSColor object?

#import <Cocoa/Cocoa.h>

@interface NSColor ( NSColorHexadecimalValue )

- (NSString *) hexadecimalValue;

@end
