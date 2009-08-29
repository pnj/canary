//
//  ORSCredentialsManager.h
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

/*!
 @header ORSCredentialsManager
 @abstract Contains methods for managing user credentials in the Keychain
 Manager.
 @author Nicholas Toumpelis
 @copyright Nicholas Toumpelis, Ocean Road Software
 @version 0.7
 @updated 2009-04-12
 */

#import <Security/Security.h>
#include <CoreServices/CoreServices.h>
#include <CoreFoundation/CoreFoundation.h>

#define APP_CNAME "Canary"
#define APP_CNAME_LENGTH 6

/*!
 @class ORSCredentialsManager
 @group Credentials Manager
 @abstract Contains methods for managing user credentials in the Keychain
 Manager.
 @author Nicholas Toumpelis
 @version 0.6
 @updated 2008-10-18
 */
@interface ORSCredentialsManager : NSObject {

@private
	UInt32 passwordLength;
	UInt32 twitterPasswordLength;
	void *passwordData;
	void *twitterPasswordData;
	SecKeychainItemRef loginItem;
	NSString *lastCheckedUsername;
	NSString *lastCheckedTwitterUsername;

}

/*! 
 @method hasPasswordForUser:
 Determines whether the specified user has a password in the keychain. 
 */
- (BOOL) hasPasswordForUser:(NSString *)username;

/*!
 @method passwordForUser:
 Retrieves the password for the specified user. 
 */
- (NSString *) passwordForUser:(NSString *)username;

/*! 
 @method addPassword:forUser:
 Adds a password to the keychain manager for the specified username. 
 */
- (BOOL) addPassword:(NSString *)password
			 forUser:(NSString *)username;

/*!
 @method setPassword:forUser:
 Sets a password in the keychain manager for the specified username. 
 */
- (BOOL) setPassword:(NSString *)password
			 forUser:(NSString *)username;

/*!
 @method hasStoredTwitterPasswordForUser:
 Determines whether the specified user has a twitter password in
 the keychain 
 */
- (BOOL) hasStoredTwitterPasswordForUser:(NSString *)username;

/*!
 @method storedTwitterPasswordForUser:
 Retrieves the current Twitter web password (saved in the keychain).
 */
- (NSString *) storedTwitterPasswordForUser:(NSString *)username;

/*!
 @method fetchedPassword
 Returns the previously retrieved password. 
 */
- (NSString *) fetchedPassword;

/*! 
 @method freeBuffer
 Frees the data buffer. 
 */
- (void) freeBuffer;

@end
