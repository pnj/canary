//
//  ORSCredentialsManager.m
//  Credentials Manager
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

#import "ORSCredentialsManager.h"

@implementation ORSCredentialsManager

// Determines whether the specified user has a password in the keychain.
- (BOOL) hasPasswordForUser:(NSString *)username {
	passwordData = nil;
	OSStatus result;
	@synchronized(self) {
		result = SecKeychainFindGenericPassword(NULL, APP_CNAME_LENGTH,
			APP_CNAME, 
			[username lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
			[username cStringUsingEncoding:NSASCIIStringEncoding], 
			&passwordLength, &passwordData, &loginItem);
	}
	lastCheckedUsername = username;
	if (result == 0) {
		return YES;
	} else {
		return NO;
	}
}

// Retrieves the password for the specified user.
- (NSString *) passwordForUser:(NSString *)username {
	if (![username isEqualToString:lastCheckedUsername]) {
		passwordData = nil;
		@synchronized(self) {
			SecKeychainFindGenericPassword(NULL, APP_CNAME_LENGTH, APP_CNAME, 
				[username lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
				[username cStringUsingEncoding:NSASCIIStringEncoding], 
					&passwordLength, &passwordData, &loginItem);
		}
	}
	return [[NSString alloc] initWithBytes:passwordData 
									length:passwordLength
								  encoding:NSASCIIStringEncoding];
}

// Adds a password to the keychain manager for the specified username.
- (BOOL) addPassword:(NSString *)password
			 forUser:(NSString *)username {
	OSStatus result;
	@synchronized(self) {
		result = SecKeychainAddGenericPassword(NULL, APP_CNAME_LENGTH, 
			APP_CNAME, 
			[username lengthOfBytesUsingEncoding:NSASCIIStringEncoding], 
			[username cStringUsingEncoding:NSASCIIStringEncoding], 
			[password lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
			[password cStringUsingEncoding:NSASCIIStringEncoding], &loginItem);
	}
	if (result == 0) {
		return YES;
	} else {
		return NO;
	}
}

// Sets a password in the keychain manager for the specified username.
- (BOOL) setPassword:(NSString *)password
			 forUser:(NSString *)username {
	[self hasPasswordForUser:username]; // gets loginItem
	OSStatus result;
	@synchronized(self) {
		result = SecKeychainItemModifyAttributesAndData(loginItem, 
			NULL, [password lengthOfBytesUsingEncoding:NSASCIIStringEncoding], 
			[password cStringUsingEncoding:NSASCIIStringEncoding]);
	}
	if (result == 0) {
		return YES;
	} else {
		return NO;
	}
}

// Determines whether the specified user has a twitter password in
// the keychain
- (BOOL) hasStoredTwitterPasswordForUser:(NSString *)username {
	twitterPasswordData = nil;
	OSStatus result;
	@synchronized(self) {
		result = SecKeychainFindInternetPassword(NULL, 11, 
			"twitter.com", 0, NULL, 
			[username lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
			[username cStringUsingEncoding:NSASCIIStringEncoding], 1, "/", 0,
			kSecProtocolTypeHTTPS, kSecAuthenticationTypeDefault, 
			&twitterPasswordLength, &twitterPasswordData, NULL);
	}
	lastCheckedTwitterUsername = username;
	if (result == 0) {
		return YES;
	} else {
		return NO;
	}
}

// Retrieves the current Twitter web password (saved in the keychain).
- (NSString *) storedTwitterPasswordForUser:(NSString *)username {
	if (![username isEqualToString:lastCheckedTwitterUsername]) {
		twitterPasswordData = nil;
		@synchronized(self) {
			SecKeychainFindInternetPassword(NULL, 11, "twitter.com", 0, NULL,
				[username lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
				[username cStringUsingEncoding:NSASCIIStringEncoding], 1, "/", 
				0, kSecProtocolTypeHTTPS, kSecAuthenticationTypeDefault, 
				&twitterPasswordLength, &twitterPasswordData, NULL);
		}
	}
	return [[NSString alloc] initWithBytes:twitterPasswordData 
									length:twitterPasswordLength
								  encoding:NSASCIIStringEncoding];
}

// Returns the previously retrieved password. 
- (NSString *) fetchedPassword {
	return [[NSString alloc] initWithBytes:passwordData 
									length:passwordLength
								  encoding:NSASCIIStringEncoding];
}

// Frees the data buffer. 
- (void) freeBuffer {
	@synchronized(self) {
		SecKeychainItemFreeContent(NULL, passwordData);
		SecKeychainItemFreeContent(NULL, twitterPasswordData);
	}
}

@end
