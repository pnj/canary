//
//  ORSSession.m
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

#import "ORSSession.h"

@implementation ORSSession

@synthesize userID, password;

// Initialiser
- (id) initWithUserID:(NSString *)newUserID
		  andPassword:(NSString *)newPassword {
	self = [super init];
	if (self != nil) {
		userID = newUserID;
		password = newPassword;
	}
	return self;
	
}

// Copy with zone
- (id) copyWithZone:(NSZone *)zone {
	return [[ORSSession alloc] initWithUserID:userID andPassword:password];
}

// Executes any request both synchronously and asynchronously. For asynchronous
// requests it requires the help of NSURLConnection delegates. For synchronous
// requests the data is returned directly while for asynchronous the 
// setStatuses method in the controller is called upon finishing.
- (NSData *) executeRequestOfType:(NSString *)type
						   atPath:(NSString *)path
					synchronously:(BOOL)synchr {
	@synchronized(self) {
		// Forming the first part of the request URL
		NSMutableString *requestURL = [NSMutableString 
			stringWithFormat:@"https://twitter.com/"];
	
		// Appending the second part of the request URL, the "path"
		[requestURL appendString:path];
		
		// Correcting the encoding
		NSString *encodedRequestURL = [requestURL 
			stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
		// Creating the request
		NSMutableURLRequest *request = [NSMutableURLRequest
			requestWithURL:[NSURL URLWithString:encodedRequestURL]
				cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
										timeoutInterval:48.0];
	
		// Adding some extra values to the request
		[request addValue:@"Canary" forHTTPHeaderField:@"X-Twitter-Client"];
		[request addValue:@"0.7.1" 
	   forHTTPHeaderField:@"X-Twitter-Client-Version"];
		[request addValue:@"http://www.canaryapp.com/" 
	   forHTTPHeaderField:@"X-Twitter-Client-URL"];
		
		// Credentials
		NSString *creds = [NSString stringWithFormat:@"%@:%@", userID, password];
		[request addValue:[NSString stringWithFormat:@"Basic %@", 
			[creds base64Encoding]] forHTTPHeaderField:@"Authorization"];
	
		// Setting the request method (except GET - doesn't need to be specified
		// explicitly)
		if (![type isEqualToString:@"GET"]) {
			[request setHTTPMethod:type];
		}
		
		// Checking whether the request should be synchronous or asynchronous
		if (!synchr) {
			// If asynchronous... setting up the connection
			mainConnection = [[NSURLConnection alloc] initWithRequest:request 
															 delegate:self];
			if (mainConnection) {
				// the data buffer
				dataReceived = [NSMutableData data];
			} else {
			}
			return NULL;
		} else { 
			// If synchronous
			NSURLResponse *response = NULL;
			NSError *error = NULL;
			// the data is returned "immediately"
			NSData *data = [NSURLConnection sendSynchronousRequest:request 
												 returningResponse:&response 
															 error:&error];
			if (data) {
				return data;
			} else {
			}
			return NULL;
		}
	}
	return NULL;
}

// Executes any request without URL encoding
- (NSData *) executeUnencodedRequestOfType:(NSString *)type
									atPath:(NSString *)path
							 synchronously:(BOOL)synchr {
	@synchronized(self) {
		// Forming the first part of the request URL
		NSMutableString *requestURL = [NSMutableString
			stringWithFormat:@"https://twitter.com/"];
		
		// Appending the second part of the request URL, the "path"
		[requestURL appendString:path];
		
		// Creating the request
		NSMutableURLRequest *request = [NSMutableURLRequest
			requestWithURL:[NSURL URLWithString:requestURL]
				cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
										timeoutInterval:48.0];
		
		// Adding some extra values to the request
		[request addValue:@"Canary" forHTTPHeaderField:@"X-Twitter-Client"];
		[request addValue:@"0.7.1" 
	   forHTTPHeaderField:@"X-Twitter-Client-Version"];
		[request addValue:@"http://www.canaryapp.com/" 
	   forHTTPHeaderField:@"X-Twitter-Client-URL"];
		
		// Credentials
		NSString *creds = [NSString stringWithFormat:@"%@:%@", userID, password];
		[request addValue:[NSString stringWithFormat:@"Basic %@", 
			[creds base64Encoding]] forHTTPHeaderField:@"Authorization"];
		
		// Setting the request method (except GET - doesn't need to be specified
		// explicitly)
		if (![type isEqualToString:@"GET"]) {
			[request setHTTPMethod:type];
		}
		
		// Checking whether the request should be synchronous or asynchronous
		if (!synchr) {
			// If asynchronous... setting up the connection
			mainConnection = [[NSURLConnection alloc] initWithRequest:request 
															 delegate:self];
			if (mainConnection) {
				// the data buffer
				dataReceived = [NSMutableData data];
			} else {
			}
			return NULL;
		} else { 
			// If synchronous
			NSURLResponse *response = NULL;
			NSError *error = NULL;
			// the data is returned "immediately"
			NSData *data = [NSURLConnection sendSynchronousRequest:request 
												 returningResponse:&response 
															 error:&error];
			if (data) {
				return data;
			} else {
			}
			return NULL;
		}
	}
	return NULL;
}

// Executes any request both synchronously and asynchronously. Works like above
// but does not return any data. Used in cases where returned data is not a 
// concern.
- (void) simpleExecuteRequestOfType:(NSString *)type
							 atPath:(NSString *)path
					  synchronously:(BOOL)synchr {
	@synchronized(self) {
		// Forming the first part of the request URL
		NSMutableString *requestURL = [NSMutableString
			stringWithFormat:@"https://twitter.com/"];
	
		// Appending the second part of the request URL, the "path"
		[requestURL appendString:path];
		
		// Correcting the encoding
		NSString *encodedRequestURL = [requestURL 
					  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
		// Creating the request
		NSMutableURLRequest *request = [NSMutableURLRequest
			requestWithURL:[NSURL URLWithString:encodedRequestURL]
				cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
					timeoutInterval:48.0];
	
		// Adding some extra values to the request
		[request addValue:@"Canary" forHTTPHeaderField:@"X-Twitter-Client"];
		[request addValue:@"0.7.1" 
	   forHTTPHeaderField:@"X-Twitter-Client-Version"];
		[request addValue:@"http://www.canaryapp.com/" 
	   forHTTPHeaderField:@"X-Twitter-Client-URL"];
		
		// Credentials
		NSString *creds = [NSString stringWithFormat:@"%@:%@", userID, password];
		[request addValue:[NSString stringWithFormat:@"Basic %@", 
			[creds base64Encoding]] forHTTPHeaderField:@"Authorization"];
	
		// Setting the request method (except GET - doesn't need to be specified
		// explicitly)
		if (![type isEqualToString:@"GET"]) {
			[request setHTTPMethod:type];
		}
	
		// Checking whether the request should be synchronous or asynchronous
		if (!synchr) {
			// If asynchronous... setting up the connection
			mainConnection = [[NSURLConnection alloc] initWithRequest:request 
														 delegate:nil];
		} else { 
			return;
		}
	}
}

// Uploads the image data to Twitter
- (NSData *) uploadImageFile:(NSString *)filename
			   toTwitterPath:(NSString *)path 
			   synchronously:(BOOL)synchr{
	@synchronized(self) {
		NSData *imageData = [[NSData alloc] initWithContentsOfFile:filename];
		NSURL *url = [NSURL URLWithString:[NSString 
				stringWithFormat:@"http://twitter.com/%@", path]];
		NSMutableURLRequest *postRequest = [NSMutableURLRequest 
			requestWithURL:url
				cachePolicy:NSURLRequestUseProtocolCachePolicy 
					timeoutInterval:21.0];
		
		[postRequest setHTTPMethod:@"POST"];
		
		NSString *stringBoundary = [NSString 
									stringWithString:@"0xKhTmLbOuNdArY"];
		NSString *contentType = [NSString 
			stringWithFormat:@"multipart/form-data; boundary=%@", 
								 stringBoundary];
		[postRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
		
		// Credentials
		NSString *creds = [NSString stringWithFormat:@"%@:%@", userID, password];
		[postRequest addValue:[NSString stringWithFormat:@"Basic %@", 
				[creds base64Encoding]] forHTTPHeaderField:@"Authorization"];
		
		NSMutableData *postBody = [NSMutableData data];
		[postBody appendData:[[NSString stringWithFormat:@"\r\n\r\n--%@\r\n", 
				stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString:
				@"Content-Disposition: form-data; name=\"source\"\r\n\r\n"] 
							  dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString:@"canary"] 
							  dataUsingEncoding:NSUTF8StringEncoding]];
		
		NSString *mimeType = NULL;
		if ([filename hasSuffix:@".jpeg"] || [filename hasSuffix:@".jpg"] || 
			[filename hasSuffix:@".jpe"]) {
			mimeType = @"image/jpeg";
		} else if ([filename hasSuffix:@".png"]) {
			mimeType = @"image/png";
		} else if ([filename hasSuffix:@".gif"]) {
			mimeType = @"image/gif";
		}	
		
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",
			stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:
			@"Content-Disposition: form-data; name=\"media\"; filename=\"%@\"\r\n", 
							   filename] dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithFormat:
			@"Content-Type: %@\r\n", mimeType] 
							  dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[[NSString stringWithString:
							   @"Content-Transfer-Encoding: binary\r\n\r\n"] 
							  dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:imageData];
		[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",
			stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		[postRequest setHTTPBody:postBody];
		
		// Checking whether the request should be synchronous or asynchronous
		if (!synchr) {
			// If asynchronous... setting up the connection
			mainConnection = [[NSURLConnection alloc] 
				initWithRequest:postRequest delegate:self];
			if (mainConnection) {
				// the data buffer
				dataReceived = [NSMutableData data];
			} else {
			}
			return NULL;
		} else { 
			// If synchronous
			NSURLResponse *response = NULL;
			NSError *error = NULL;
			// the data is returned "immediately"
			NSData *data = [NSURLConnection sendSynchronousRequest:postRequest 
												 returningResponse:&response 
															 error:&error];
			if (data) {
				return data;
			} else {
			}
			return NULL;
		}
	}
	return NULL;
}

// Returns an XML document from the given data
- (NSXMLDocument *) xmlDocumentFromData:(NSData *)data {
	NSError *error = NULL;
	NSString *xml = [[NSString alloc] initWithData:data
										  encoding:NSUTF8StringEncoding];
	
    NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithXMLString:xml
		options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA)
														error:&error];
    if (xmlDocument == NULL) {
		xmlDocument = [[NSXMLDocument alloc] initWithXMLString:xml
			options:NSXMLDocumentTidyXML error:&error];
    }
    if (xmlDocument == NULL)  {
        if (error) {
			// Error handling
		}
        return NULL;
    }
    if (error) {
		// Error handling
	}
	return xmlDocument;
}

// Returns the node from the data received from the connection
- (NSXMLNode *) nodeFromData:(NSData *)data {
	NSXMLDocument *xmlDocument = [self xmlDocumentFromData:data];
	return [xmlDocument rootElement];
}

// Returns all the statuses as an array from the data received from the
// connection.
- (NSArray *) statusesFromData:(NSData *)statuses {
	NSError *error = nil;
	NSXMLNode *root = [self nodeFromData:statuses];
	return [root nodesForXPath:@".//status" error:&error];
}

// Returns all the users as an array from the data received from the
// connection.
- (NSArray *) usersFromData:(NSData *)data {
	NSError *error = nil;
	NSXMLNode *root = [self nodeFromData:data];
	return [root nodesForXPath:@".//user" error:&error];
}

// Returns all the saved searches as an array from the data received from the
// connectiom.
- (NSArray *) savedSearchesFromData:(NSData *)data {
	NSError *error = nil;
	NSXMLNode *root = [self nodeFromData:data];
	return [root nodesForXPath:@".//saved_search" error:&error];
}

- (NSArray *) idsFromData:(NSData *)data {
	NSError *error = nil;
	NSXMLNode *root = [self nodeFromData:data];
	return [root nodesForXPath:@".//id" error:&error];
}

// Returns all the users as an array from the data received from the
// connection.
- (NSArray *) dmsFromData:(NSData *)directMessages {
	NSError *error = NULL;
	NSXMLNode *root = [self nodeFromData:directMessages];
	return [root nodesForXPath:@".//direct_message" error:&error];
}


#pragma mark NSURLConnection delegates for async conn

// NSURLConnection delegates for asynchronous connections

// is called when the server requests (additional) authentication.
- (void) connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	@synchronized(self) {
		if ([challenge previousFailureCount] == 0) {
			NSURLCredential *newCredential = [NSURLCredential 
											  credentialWithUser:userID 
											  password:password
					persistence:NSURLCredentialPersistenceNone];
			[[challenge sender] useCredential:newCredential
				forAuthenticationChallenge:challenge];
		} else {
			[[challenge sender] cancelAuthenticationChallenge:challenge];
		}
	}
}

// is called when the connection receives a response from the server.
- (void) connection:(NSURLConnection *)connection 
					didReceiveResponse:(NSURLResponse *)response {
	@synchronized(self) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"OTEReceivedResponse"
						  object:response];
		[dataReceived setLength:0];
	}
}

// is called when the connection receives some data from the server.
- (void) connection:(NSURLConnection *)connection 
		didReceiveData:(NSData *)dataReceivedArg {
	@synchronized(self) {
		[dataReceived appendData:dataReceivedArg];
	}
}

// is called when the connection faces some kind of error.
- (void) connection:(NSURLConnection *)connection
				didFailWithError:(NSError *)connectionError {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"OTEConnectionFailure"
					  object:connectionError];
}

// is called when the data received from the server finishes.
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	@synchronized(self) {
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		NSXMLNode *node = [self nodeFromData:dataReceived];
		if ([[node name] isEqualToString:@"statuses"]) {
			[nc postNotificationName:@"OTEStatusesDidFinishLoading"
							object:[self statusesFromData:dataReceived]];
		} else if ([[node name] isEqualToString:@"users"]) {
			[nc postNotificationName:@"OTEUsersDidFinishLoading"
						  object:[self usersFromData:dataReceived]];
		} else if ([[node name] isEqualToString:@"direct-messages"] || 
				   [[node name] isEqualToString:@"nilclasses"]) {
			[nc postNotificationName:@"OTEDMsDidFinishLoading"
							  object:[self dmsFromData:dataReceived]];
		} else if ([[node name] isEqualToString:@"direct_message"])  {
			NSError *error = NULL;
			[nc postNotificationName:@"OTEDMDidFinishSending"
						  object:[node nodesForXPath:@".//recipientScreenName" 
											   error:&error]];
		} else if ([[node name] isEqualToString:@"status"]) {
			[nc postNotificationName:@"OTEStatusDidFinishLoading"
							object:node];
		} else if ([[node name] isEqualToString:@"hash"]) {
			NSError *error = NULL;
			[nc postNotificationName:@"OTEErrorMsgDidFinishLoading"
							  object:[node nodesForXPath:@".//error" 
												   error:&error]];
		}
	}
}

@end
