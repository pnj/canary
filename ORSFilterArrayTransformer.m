//
//  ORSFilterArrayTransformer.m
//  Filters
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

#import "ORSFilterArrayTransformer.h"

@implementation ORSFilterArrayTransformer

+ (Class) transformedValueClass {
    return [NSArray class];
}

+ (BOOL) allowsReverseTransformation {
    return YES;
}

- (id) transformedValue:(id)value {
	if (value == nil) 
		return nil;
	
	NSArray *initialArray = (NSArray *)value;
	NSMutableArray *finalArray = [NSMutableArray array];
	ORSFilterTransformer *tranny = [[ORSFilterTransformer alloc] init];
	
	for (id filter in initialArray) {
		[finalArray addObject:(NSDictionary *)[tranny reverseTransformedValue:filter]];
	}
	
	return finalArray;
}

- (id) reverseTransformedValue:(id)value {
    if (value == nil) 
		return nil;
	
	NSArray *initialArray = (NSArray *)value;
	NSMutableArray *finalArray = [NSMutableArray array];
	ORSFilterTransformer *tranny = (ORSFilterTransformer *)[NSValueTransformer valueTransformerForName:@"FilterTransformer"];
	
	for (id dictionary in initialArray) {
		[finalArray addObject:(ORSFilter *)[tranny transformedValue:dictionary]];
	}
    
	return finalArray;
}

@end
