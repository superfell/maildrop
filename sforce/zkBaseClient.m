// Copyright (c) 2006-2008 Simon Fell
//
// Permission is hereby granted, free of charge, to any person obtaining a 
// copy of this software and associated documentation files (the "Software"), 
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, 
// and/or sell copies of the Software, and to permit persons to whom the 
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included 
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
// THE SOFTWARE.
//

#import "zkBaseClient.h"
#import "zkSoapException.h"

@implementation ZKBaseClient

- (void)dealloc {
	[endpointUrl release];
	[super dealloc];
}

- (NSXMLNode *)sendRequest:(NSString *)payload {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:endpointUrl]];
	[request setHTTPMethod:@"POST"];
	[request addValue:@"text/xml; charset=UTF-8" forHTTPHeaderField:@"content-type"];	
	[request addValue:@"\"\"" forHTTPHeaderField:@"SOAPAction"];
	
	NSData *data = [payload dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:data];
	
	NSHTTPURLResponse *resp = nil;
	NSError *err = nil;
	// todo, support request compression
	// todo, support response compression
	NSData *respPayload = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
	NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithData:respPayload options:NSXMLNodeOptionsNone error:&err] autorelease];
	if (err != NULL) {
		@throw [NSException exceptionWithName:@"Xml error" reason:@"Unable to parse XML returned by server" userInfo:nil];
	}
	if (500 == [resp statusCode]) {
		NSXMLNode * nFaultCode = [[doc nodesForXPath:@"/soapenv:Envelope/soapenv:Body/soapenv:Fault/faultcode" error:&err] objectAtIndex:0];
		NSXMLNode * nFaultMsg  = [[doc nodesForXPath:@"/soapenv:Envelope/soapenv:Body/soapenv:Fault/faultstring" error:&err] objectAtIndex:0];
		ZKSoapException *exception = [ZKSoapException exceptionWithFaultCode:[nFaultCode stringValue] faultString:[nFaultMsg stringValue]];
		@throw exception;				
	}	
	NSXMLNode *body = [[doc nodesForXPath:@"/soapenv:Envelope/soapenv:Body" error:&err] objectAtIndex:0];
	return [[body children] objectAtIndex:0];
}

@end
