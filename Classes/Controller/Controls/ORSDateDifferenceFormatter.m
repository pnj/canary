//
//  ORSDateDifferenceFormatter.m
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

#import "ORSDateDifferenceFormatter.h"

@implementation ORSDateDifferenceFormatter

- (NSString *) stringForObjectValue:(id)anObject {
	// Get time difference
	int currentDateAsSeconds = (int) [NSDate timeIntervalSinceReferenceDate];
	int statusDateAsSeconds = (int)[(NSString *)anObject doubleValue];
	int seconds = currentDateAsSeconds - statusDateAsSeconds;
	
	// Check whether it's years away
	int yearInSecs = 12 * 4 * 7 * 24 * 60 * 60;
	int years = seconds / yearInSecs;
	if (years > 0) {
		if (years > 1) {
			return @"> a year";
		} else {
			return @"a year";
		}
	}
	
	// check whether it's months away
	int monthInSecs = 4 * 7 * 24 * 60 * 60;
	int months = seconds / monthInSecs;
	int secsAfterMonths = seconds % monthInSecs;
	if (secsAfterMonths > 2 * 7 * 24 * 60 * 60) {
		months++;
	}
	if (months > 0) {
		if (months > 1) {
			return [NSString stringWithFormat:@"%i months", months];
		} else {
			return @"a month";
		}
	}
	
	// check whether it's weeks away
	int weekInSecs = 7 * 24 * 60 * 60;
	int weeks = seconds / weekInSecs;
	int secsAfterWeeks = seconds % weekInSecs;
	if (secsAfterWeeks > 4 * 24 * 60 * 60) {
		weeks++;
	}
	if (weeks > 0) {
		if (weeks > 1) {
			return [NSString stringWithFormat:@"%i weeks", weeks];
		} else {
			return @"a week";
		}
	}
	
	// check whether it's days away
	int dayInSecs = 24 * 60 * 60;
	int days = seconds / dayInSecs;
	int secsAfterDays = seconds % dayInSecs;
	if (secsAfterDays > 12 * 60 * 60) {
		days++;
	}
	if (days > 0) {
		if (days > 1) {
			return [NSString stringWithFormat:@"%i days", days];
		} else {
			return @"a day";
		}
	}
	
	// check whether it's hours away
	int hourInSecs = 60 * 60;
	int hours = seconds / hourInSecs;
	int secsAfterHours = seconds % hourInSecs;
	if (secsAfterHours > 30 * 60) {
		hours++;
	}
	if (hours > 0) {
		if (hours > 1) {
			return [NSString stringWithFormat:@"%i hrs", hours];
		} else {
			return @"an hr";
		}
	}
	
	// check whether it's minutes away
	int minuteInSecs = 60;
	int minutes = seconds / minuteInSecs;
	if (minutes > 0) {
		if (minutes > 1) {
			return [NSString stringWithFormat:@"%i mins", minutes];
		} else {
			return @"a min";
		}
	}
	
	// if not any of the above, it's seconds away
	if (seconds > 1) {
		return [NSString stringWithFormat:@"%i secs", seconds];
	} else if (seconds == 1) {
		return @"a sec";
	} else {
		return @"< a sec";
	}
}

- (BOOL) getObjectValue:(id *)anObject 
			  forString:(NSString *)string
	   errorDescription:(NSString **)error {
	return YES;
}

- (NSAttributedString *) attributedStringForObjectValue:(id)anObject
						withDefaultAttributes:(NSDictionary *)attributes {

	return [[NSAttributedString alloc] 
			initWithString:[self stringForObjectValue:anObject] 
			attributes:attributes];
}

@end
