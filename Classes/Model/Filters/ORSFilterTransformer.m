//
//  ORSFilterTransformer.m
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

#import "ORSFilterTransformer.h"

@implementation ORSFilterTransformer

+ (Class) transformedValueClass {
    return [NSDictionary class];
}

+ (BOOL) allowsReverseTransformation {
    return YES;
}

- (id) transformedValue:(id)value {
	if (value == nil) 
		return nil;
	
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	ORSFilter *filterValue = (ORSFilter *)value;
	
	if ([value respondsToSelector:@selector(active)]) {
		[dictionary setObject:[NSNumber numberWithBool:filterValue.active]
					   forKey:@"ORSCanaryFilterActive"];
	} else {
        [NSException raise: NSInternalInconsistencyException
                    format: @"Value (%@) does not respond to -active.",
			[value class]];
	}
	
	if ([value respondsToSelector:@selector(filterName)]) {
		[dictionary setObject:filterValue.filterName
					   forKey:@"ORSCanaryFilterName"];
	} else {
        [NSException raise: NSInternalInconsistencyException
                    format: @"Value (%@) does not respond to -filterName.",
			[value class]];
    }
	
	if ([value respondsToSelector:@selector(predicate)]) {
		[dictionary setObject:[filterValue.predicate predicateFormat]
					   forKey:@"ORSCanaryFilterPredicate"];
	} else {
        [NSException raise: NSInternalInconsistencyException
                    format: @"Value (%@) does not respond to -predicate.",
			[value class]];
    }
	
	return dictionary;
}

- (id) reverseTransformedValue:(id)value {
    if (value == nil) 
		return nil;
	
	NSDictionary *dictionary = (NSDictionary *)value;
	ORSFilter *filter = [[ORSFilter alloc] init];
	
	if ([value respondsToSelector:@selector(objectForKey:)]) {
		filter.active = [(NSNumber *)[dictionary objectForKey:@"ORSCanaryFilterActive"] boolValue];
	} else {
        [NSException raise: NSInternalInconsistencyException
                    format: @"Value (%@) does not respond to -objectForKey:.",
		 [value class]];
    }
	
	if ([value respondsToSelector:@selector(objectForKey:)]) {
		filter.filterName = [dictionary 
							   objectForKey:@"ORSCanaryFilterName"];
	}
	
	if ([value respondsToSelector:@selector(objectForKey:)]) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:[dictionary 
			objectForKey:@"ORSCanaryFilterPredicate"]];
		filter.predicate = predicate;
	}
	
	return filter;
}

@end
