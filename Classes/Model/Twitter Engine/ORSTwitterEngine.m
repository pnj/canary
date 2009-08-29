//
//  ORSTwitterEngine.m
//  Twitter Engine
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




@implementation ORSTwitterEngine

@synthesize dataReceived, synchronously, mainConnection, session;

static ORSTwitterEngine *sharedEngine = nil;

// sharedController
+ (ORSTwitterEngine *) sharedTwitterEngine {
    @synchronized(self) {
        if (sharedEngine == nil) {
            [[self alloc] init];
        }
    }
    return sharedEngine;
}

// allocWithZone
+ (id) allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedEngine == nil) {
			return [super allocWithZone:zone];
        }
    }
	return sharedEngine;
}

// Initialiser for specifying the way the engine operates: synchrously or the
// opposite
- (id) initSynchronously:(BOOL)synchr 
			  withUserID:(NSString *)userID
			 andPassword:(NSString *)password {
	Class engineClass = [self class];
	@synchronized(engineClass) {
		if (sharedEngine == nil) {
			if (self = [super init]) {
				sharedEngine = self;
				session = [[ORSSession alloc] initWithUserID:userID
												 andPassword:password];
				synchronously = synchr;
				sessionQueue = [NSMutableArray arrayWithCapacity:4];
			}
		}
	}
	return sharedEngine;
}

// copyWithZone
- (id) copyWithZone:(NSZone *)zone {
	return self;
}

// Returns the session user id
- (NSString *) sessionUserID {
	return [session userID];
}

// Sets the session user id
- (void) setSessionUserID:(NSString *)theSessionUserID {
	[session setUserID:theSessionUserID];
}

// Returns the session password
- (NSString *) sessionPassword {
	return [session password];
}

// Sets the session password
- (void) setSessionPassword:(NSString *)theSessionPassword {
	[session setPassword:theSessionPassword];
}

// Executes a request
- (NSData *) executeRequestOfType:(NSString *)type
						   atPath:(NSString *)path
					synchronously:(BOOL)synchr {
	ORSSession *tempSession = (ORSSession *)[session copy];
	[sessionQueue addObject:tempSession];
	if ([sessionQueue count] > 4) {
		[sessionQueue removeObjectAtIndex:0];
	}
	return [tempSession executeRequestOfType:type 
									 atPath:path
							  synchronously:synchr];
}

// Executes a request without URL encoding
- (NSData *) executeUnencodedRequestOfType:(NSString *)type
									atPath:(NSString *)path
							 synchronously:(BOOL)synchr{
	ORSSession *tempSession = (ORSSession *)[session copy];
	[sessionQueue addObject:tempSession];
	if ([sessionQueue count] > 4) {
		[sessionQueue removeObjectAtIndex:0];
	}
	return [tempSession executeUnencodedRequestOfType:type 
											   atPath:path
										synchronously:synchr];
}

// Executes a request with no data returned
- (void) simpleExecuteRequestOfType:(NSString *)type
							 atPath:(NSString *)path
					  synchronously:(BOOL)synchr {
	ORSSession *tempSession = (ORSSession *)[session copy];
	[sessionQueue addObject:tempSession];
	if ([sessionQueue count] > 4) {
		[sessionQueue removeObjectAtIndex:0];
	}
	return [tempSession simpleExecuteRequestOfType:type 
								  atPath:path
						   synchronously:synchr];
}

- (NSData *) uploadImageFile:(NSString *)filename
			   toTwitterPath:(NSString *)path
			   synchronously:(BOOL)synchr {
	ORSSession *tempSession = (ORSSession *)[session copy];
	[sessionQueue addObject:tempSession];
	if ([sessionQueue count] > 4) {
		[sessionQueue removeObjectAtIndex:0];
	}
	return [tempSession uploadImageFile:filename 
						  toTwitterPath:path
						  synchronously:synchr];
}

// Returns an XML document from the given data
- (NSXMLDocument *) xmlDocumentFromData:(NSData *)data {
	return [session xmlDocumentFromData:data];
}

// Returns the node from the data received from the connection
- (NSXMLNode *) nodeFromData:(NSData *)data {
	return [session nodeFromData:data];
}

// Returns all the statuses as an array from the data received from the
// connection.
- (NSArray *) statusesFromData:(NSData *)statuses {
	return [session statusesFromData:statuses];
}

// Returns all the users as an array from the data received from the
// connection.
- (NSArray *) usersFromData:(NSData *)data {
	return [session usersFromData:data];
}

// Returns all the saved searches as an array from the data received from the 
// connection.
- (NSArray *) savedSearchesFromData:(NSData *)data {
	return [session savedSearchesFromData:data];
}

- (NSArray *) idsFromData:(NSData *)data {
	return [session idsFromData:data];
}

// Returns all the users as an array from the data received from the
// connection.
- (NSArray *) dmsFromData:(NSData *)directMessages {
	return [session dmsFromData:directMessages];
}

@end
