//
//  NSString+Base64.m
//  Canary
//
//  Created by Νικόλαος Τουμπέλης on 26/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+Base64.h"

@implementation NSString ( Base64 )

- (NSString *) base64Encoding {
    char *inputString = [self UTF8String];
    char *encodedString;
    base64_encode(inputString, strlen(inputString), &encodedString);
    
    return [NSString stringWithUTF8String:encodedString];
}

@end
