// Copyright (c) 2006 Simon Fell
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


#import "zkSforceClient.h"
#import "zkPartnerEnvelope.h"
#import "zkQueryResult.h"
#import "zkSaveResult.h"
#import "zkSObject.h"
#import "zkSoapException.h"
#import "zkUserInfo.h"
#import "zkDescribeSObject.h"

static const int MAX_SESSION_AGE = 25 * 60; // 25 minutes
static const int SAVE_BATCH_SIZE = 25;

@interface ZKSforceClient (Private)
- (ZKQueryResult *)queryImpl:(NSString *)value operation:(NSString *)op name:(NSString *)elemName;
- (NSArray *)sobjectsImpl:(NSArray *)objects name:(NSString *)elemName;
- (void)checkSession;
- (void)startNewSession;
@end

@implementation ZKSforceClient

- (id)init {
	self = [super init];
	[self setLoginProtocolAndHost:@"https://www.salesforce.com"];
	updateMru = NO;
	cacheDescribes = NO;
	return self;
}

- (void)dealloc {
	[authEndpointUrl release];
	[username release];
	[password release];
	[clientId release];
	[sessionId release];
	[sessionExpiresAt release];
	[userInfo release];
	[describes release];
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	ZKSforceClient *rhs = [[ZKSforceClient alloc] init];
	rhs->authEndpointUrl = [authEndpointUrl copy];
	rhs->endpointUrl = [endpointUrl copy];
	rhs->sessionId = [sessionId copy];
	rhs->username = [username copy];
	rhs->password = [password copy];
	rhs->clientId = [clientId copy];
	rhs->sessionExpiresAt = [sessionExpiresAt copy];
	rhs->userInfo = [userInfo retain];
	[rhs setCacheDescribes:cacheDescribes];
	[rhs setUpdateMru:updateMru];
	return rhs;
}

- (BOOL)updateMru {
	return updateMru;
}

- (void)setUpdateMru:(BOOL)aValue {
	updateMru = aValue;
}

- (BOOL)cacheDescribes {
	return cacheDescribes;
}

- (void)setCacheDescribes:(BOOL)newCacheDescribes {
	if (cacheDescribes == newCacheDescribes) return;
	cacheDescribes = newCacheDescribes;
	[self flushCachedDescribes];
}

- (void)flushCachedDescribes {
	[describes release];
	describes = nil;
	if (cacheDescribes)
		describes = [[NSMutableDictionary alloc] init];
}

- (void)setLoginProtocolAndHost:(NSString *)protocolAndHost {
	[self setLoginProtocolAndHost:protocolAndHost andVersion:11];
}

- (void)setLoginProtocolAndHost:(NSString *)protocolAndHost andVersion:(int)version {
	[authEndpointUrl release];
	authEndpointUrl = [[NSString stringWithFormat:@"%@/services/Soap/u/%d.0", protocolAndHost, version] retain];
}

- (void)login:(NSString *)un password:(NSString *)pwd {
	[userInfo release];
	userInfo = nil;
	[password release];
	[username release];
	username = [un retain];
	password = [pwd retain];
	[self startNewSession];
}

- (void)startNewSession {
	[sessionExpiresAt release];
	sessionExpiresAt = [[NSDate dateWithTimeIntervalSinceNow:MAX_SESSION_AGE] retain];
	[sessionId release];
	[endpointUrl release];
	endpointUrl = [authEndpointUrl copy];

	ZKEnvelope *env = [[ZKPartnerEnvelope alloc] initWithSessionHeader:nil clientId:clientId];
	[env startElement:@"login"];
	[env addElement:@"username" elemValue:username];
	[env addElement:@"password" elemValue:password];
	[env endElement:@"login"];
	[env endElement:@"s:Body"];
	NSString *xml = [env end];
	
	NSError *err = nil;
	NSXMLNode *resp = [self sendRequest:xml];	

	NSXMLNode *serverUrl = [[resp nodesForXPath:@"result/serverUrl" error:&err] objectAtIndex:0];
	[endpointUrl release];
	endpointUrl = [[serverUrl stringValue] copy];

	NSXMLNode *sid = [[resp nodesForXPath:@"result/sessionId" error:&err] objectAtIndex:0];
	sessionId = [[sid stringValue] copy];

	NSXMLNode *ui = [[resp nodesForXPath:@"result/userInfo" error:&err] objectAtIndex:0];
	userInfo = [[ZKUserInfo alloc] initWithXmlElement:(NSXMLElement*)ui];
	[env release];
}

- (BOOL)loggedIn {
	return [sessionId length] > 0;
}

- (void)checkSession {
	if ([sessionExpiresAt timeIntervalSinceNow] < 0)
		[self startNewSession];
}

- (ZKUserInfo *)currentUserInfo {
	return userInfo;
}

- (NSString *)serverUrl {
	return endpointUrl;
}

- (NSString *)sessionId {
	[self checkSession];
	return sessionId;
}


- (NSString *)clientId {
	return clientId;
}

- (void)setClientId:(NSString *)aClientId {
	aClientId = [aClientId copy];
	[clientId release];
	clientId = aClientId;
}

- (NSArray *)describeGlobal {
	if(!sessionId) return NULL;
	[self checkSession];
	
	ZKEnvelope * env = [[ZKPartnerEnvelope alloc] initWithSessionHeader:sessionId clientId:clientId];
	[env startElement:@"describeGlobal"];
	[env endElement:@"describeGlobal"];
	[env endElement:@"s:Body"];
	
	NSError * err = NULL;
	NSXMLNode * rr = [self sendRequest:[env end]];
	NSMutableArray *types = [NSMutableArray array]; 
	NSArray * results = [rr nodesForXPath:@"result/types" error:&err];
	NSEnumerator * e = [results objectEnumerator];
	while (rr = [e nextObject]) {
		[types addObject:[rr stringValue]];
	}
	[env release];
	return types;
}

- (ZKDescribeSObject *)describeSObject:(NSString *)sobjectName {
	if (!sessionId) return NULL;
	if (cacheDescribes) {
		ZKDescribeSObject * desc = [describes objectForKey:[sobjectName lowercaseString]];
		if (desc != nil) return desc;
	}
	[self checkSession];
	
	ZKEnvelope * env = [[ZKPartnerEnvelope alloc] initWithSessionHeader:sessionId clientId:clientId];
	[env startElement:@"describeSObject"];
	[env addElement:@"SobjectType" elemValue:sobjectName];
	[env endElement:@"describeSObject"];
	[env endElement:@"s:Body"];
	
	NSError *err = 0;
	NSXMLNode *dr = [self sendRequest:[env end]];
	NSXMLNode *descResult = [[dr nodesForXPath:@"result" error:&err] objectAtIndex:0];
	ZKDescribeSObject *desc = [[[ZKDescribeSObject alloc] initWithXmlElement:(NSXMLElement*)descResult] autorelease];
	[env release];
	if (cacheDescribes) 
		[describes setObject:desc forKey:[sobjectName lowercaseString]];
	return desc;
}

- (NSArray *)search:(NSString *)sosl {
	if (!sessionId) return NULL;
	[self checkSession];
	ZKEnvelope *env = [[ZKPartnerEnvelope alloc] initWithSessionHeader:sessionId clientId:clientId];
	[env startElement:@"search"];
	[env addElement:@"searchString" elemValue:sosl];
	[env endElement:@"search"];
	[env endElement:@"s:Body"];
	
	NSError *err = 0;
	NSXMLNode *sr = [self sendRequest:[env end]];
	NSXMLNode *searchResult = [[sr nodesForXPath:@"result" error:&err] objectAtIndex:0];
	NSArray *records = [searchResult nodesForXPath:@"searchRecords/record" error:&err];
	NSMutableArray *sobjects = [NSMutableArray array];
	NSEnumerator *e = [records objectEnumerator];
	NSXMLNode *soNode;
	while (soNode = [e nextObject]) 
		[sobjects addObject:[ZKSObject fromXmlNode:soNode]];
	[env release];
	return sobjects;	
}

- (NSString *)serverTimestamp {
	if (!sessionId) return NULL;
	[self checkSession];
	ZKEnvelope *env = [[ZKPartnerEnvelope alloc] initWithSessionHeader:sessionId clientId:clientId];
	[env startElement:@"getServerTimestamp"];
	[env endElement:@"getServerTimestamp"];
	[env endElement:@"s:Body"];
	
	NSError *err = 0;
	NSXMLNode *res = [self sendRequest:[env end]];
	NSXMLNode *timestamp = [[res nodesForXPath:@"result" error:&err] objectAtIndex:0];
	[env release];
	return [timestamp stringValue];
}

- (ZKQueryResult *)query:(NSString *) soql {
	return [self queryImpl:soql operation:@"query" name:@"queryString"];
}

- (ZKQueryResult *)queryAll:(NSString *) soql {
	return [self queryImpl:soql operation:@"queryAll" name:@"queryString"];
}

- (ZKQueryResult *)queryMore:(NSString *)queryLocator {
	return [self queryImpl:queryLocator operation:@"queryMore" name:@"queryLocator"];
}

- (NSArray *)create:(NSArray *)objects {
	return [self sobjectsImpl:objects name:@"create"];
}

- (NSArray *)update:(NSArray *)objects {
	return [self sobjectsImpl:objects name:@"update"];
}

- (NSArray *)sobjectsImpl:(NSArray *)objects name:(NSString *)elemName {
	if(!sessionId) return NULL;
	[self checkSession];
	
	// if more than we can do in one go, break it up.
	if ([objects count] > SAVE_BATCH_SIZE) {
		NSMutableArray *allResults = [NSMutableArray arrayWithCapacity:[objects count]];
		NSRange rng = {0, MIN(SAVE_BATCH_SIZE, [objects count])};
		while (rng.location < [objects count]) {
			[allResults addObjectsFromArray:[self sobjectsImpl:[objects subarrayWithRange:rng] name:elemName]];
			rng.location += rng.length;
			rng.length = MIN(SAVE_BATCH_SIZE, [objects count] - rng.location);
		}
		return allResults;
	}
	ZKEnvelope *env = [[ZKPartnerEnvelope alloc] initWithSessionAndMruHeaders:sessionId mru:updateMru clientId:clientId];
	[env startElement:elemName];
	NSEnumerator *e = [objects objectEnumerator];
	ZKSObject *o;
	while (o = [e nextObject])
		[env addElement:@"sobject" elemValue:o];
	[env endElement:elemName];
	[env endElement:@"s:Body"];

	NSError *err = NULL;
	NSXMLNode *cr = [self sendRequest:[env end]];
	NSArray *resultsArr = [cr nodesForXPath:@"result" error:&err];
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:[resultsArr count]];
	e = [resultsArr objectEnumerator];
	while (cr = [e nextObject]) {
		ZKSaveResult * sr = [[ZKSaveResult alloc] initWithXmlElement:(NSXMLElement*)cr];
		[results addObject:sr];
		[sr release];
	}
	[env release];
	return results;
}

- (NSDictionary *)retrieve:(NSString *)fields sobject:(NSString *)sobjectType ids:(NSArray *)ids {
	if(!sessionId) return NULL;
	[self checkSession];
	
	ZKEnvelope * env = [[ZKPartnerEnvelope alloc] initWithSessionHeader:sessionId clientId:clientId];
	[env startElement:@"retrieve"];
	[env addElement:@"fieldList" elemValue:fields];
	[env addElement:@"sObjectType" elemValue:sobjectType];
	[env addElementArray:@"ids" elemValue:ids];
	[env endElement:@"retrieve"];
	[env endElement:@"s:Body"];
	
	NSError *err = NULL;
	NSXMLNode *rr = [self sendRequest:[env end]];
	NSMutableDictionary *sobjects = [NSMutableDictionary dictionary]; 
	NSArray *results = [rr nodesForXPath:@"result" error:&err];
	NSEnumerator *e = [results objectEnumerator];
	while (rr = [e nextObject]) {
		ZKSObject *o = [[ZKSObject alloc] initFromXmlNode:rr];
		[sobjects setObject:o forKey:[o id]];
		[o release];
	}
	[env release];
	return sobjects;
}

- (NSArray *)delete:(NSArray *)ids {
	if(!sessionId) return NULL;
	[self checkSession];

	ZKEnvelope *env = [[ZKPartnerEnvelope alloc] initWithSessionAndMruHeaders:sessionId mru:updateMru clientId:clientId];
	[env startElement:@"delete"];
	[env addElement:@"ids" elemValue:ids];
	[env endElement:@"delete"];
	[env endElement:@"s:Body"];
	
	NSError *err = NULL;
	NSXMLNode *cr = [self sendRequest:[env end]];
	NSArray *resArr = [cr nodesForXPath:@"result" error:&err];
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:[resArr count]];
	NSEnumerator *e = [resArr objectEnumerator];
	while (cr = [e nextObject]) {
		ZKSaveResult *sr = [[ZKSaveResult alloc] initWithXmlElement:(NSXMLElement*)cr];
		[results addObject:sr];
		[sr release];
	}
	[env release];
	return results;
}

- (ZKQueryResult *)queryImpl:(NSString *)value operation:(NSString *)operation name:(NSString *)elemName {
	if(!sessionId) return NULL;
	[self checkSession];

	ZKEnvelope *env = [[ZKPartnerEnvelope alloc] initWithSessionHeader:sessionId clientId:clientId];
	[env startElement:operation];
	[env addElement:elemName elemValue:value];
	[env endElement:operation];
	[env endElement:@"s:Body"];
	
	NSXMLNode *qr = [self sendRequest:[env end]];
	ZKQueryResult *result = [[ZKQueryResult alloc] initFromXmlNode:[[qr children] objectAtIndex:0]];
	[env release];
	return [result autorelease];
}

@end
