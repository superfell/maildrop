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


#import "zkSObject.h"
#import "zkQueryResult.h"

static NSString * NS_URI_XSI = @"http://www.w3.org/2001/XMLSchema-instance";

@implementation ZKSObject

+ (id)withType:(NSString *)type {
	return [[[ZKSObject alloc] initWithType:type] autorelease];
}

+ (id)withTypeAndId:(NSString *)type sfId:(NSString *)sfId {
	ZKSObject *s = [ZKSObject withType:type];
	[s setId:sfId];
	return s;
}

+ (id) fromXmlNode:(NSXMLNode *)node {
	return [[[ZKSObject alloc] initFromXmlNode:node] autorelease];
}

- (id) initWithType:(NSString *)aType {
	self = [super init];	
	type = [aType retain];
	fieldsToNull = [[NSMutableSet alloc] init];
	fields = [[NSMutableDictionary alloc] init];
	return self;
}

- (id) initFromXmlNode:(NSXMLNode *)node {
	self = [super init];
	NSError *err = NULL;
	int i, childCount;
	Id = [[[[node nodesForXPath:@"sf:Id" error:&err] objectAtIndex:0] stringValue] copy];
	type = [[[[node nodesForXPath:@"sf:type" error:&err] objectAtIndex:0] stringValue] copy];
	fields = [[NSMutableDictionary alloc] init];
	fieldsToNull = [[NSMutableSet alloc] init];
	NSArray *children = [node children];
	childCount = [children count];
	// start at 2 to skip Id & Type
	for (i = 2; i < childCount; i++)
	{
		NSXMLElement *f = [children objectAtIndex:i];
		if ([f kind] != NSXMLElementKind) continue;
		NSXMLNode *xsiNil = [f attributeForLocalName:@"nil" URI:NS_URI_XSI];
		id fieldVal;
		if (xsiNil != nil && [[xsiNil stringValue] isEqualToString:@"true"]) 
			fieldVal = [NSNull null];
		else {
			NSXMLNode *xsiType = [f attributeForLocalName:@"type" URI:NS_URI_XSI];
			if (xsiType == nil)
				fieldVal = [f stringValue];
			else if ([[xsiType stringValue] hasSuffix:@"QueryResult"]) 
				fieldVal = [[[ZKQueryResult alloc] initFromXmlNode:f] autorelease];
			else if ([[xsiType stringValue] hasSuffix:@"sObject"])
				fieldVal = [[[ZKSObject alloc] initFromXmlNode:f] autorelease];
			else
				NSLog(@"xsiType is %@", xsiType);
		}
		[fields setObject:fieldVal forKey:[f localName]];
	}
	return self;
}

- (void)dealloc {
	[Id release];
	[type release];
	[fieldsToNull release];
	[fields release];
	[super dealloc];
}

- (id)description {
	return [NSString stringWithFormat:@"%@ %@ fields=%@ toNull=%@", type, Id, fields, fieldsToNull];
}

- (void)setId:(NSString *)theId {
	if (Id == theId) return;
	[Id release];
	Id = [theId retain];
}

- (void)setFieldToNull:(NSString *)field {
	[fieldsToNull addObject:field];
	[fields removeObjectForKey:field];
}

- (void)setFieldValue:(NSString *)value field:(NSString *)field {
	if((value == nil) || ([value length] == 0)) {
		[self setFieldToNull:field];
	} else {
		[fields setObject:value forKey:field];
		[fieldsToNull removeObject:field];
	}
}

- (void)setFieldDateTimeValue:(NSCalendarDate *)value field:(NSString *)field {
	NSMutableString *dt = [NSMutableString stringWithString:[value descriptionWithCalendarFormat:@"%Y-%m-%dT%H:%M:%S.%F%z"]];
	// insert the : in the TZ offset, to make it xsd:dateTime
	[dt insertString:@":" atIndex:[dt length]-2];
	[self setFieldValue:dt field:field];
}

- (void)setFieldDateValue:(NSCalendarDate *)value field:(NSString *)field {
	[self setFieldValue:[value descriptionWithCalendarFormat:@"%Y-%m-%d"] field:field];	
}	

- (id)fieldValue:(NSString *)field {
	id v = [fields objectForKey:field];
	return v == [NSNull null] ? nil : v;
}

- (BOOL)isFieldToNull:(NSString *)field {
	return [fieldsToNull containsObject:field];
}

- (BOOL)boolValue:(NSString *)field {
	return [[self fieldValue:field] isEqualToString:@"true"];
}

- (NSCalendarDate *)dateTimeValue:(NSString *)field {
	// ok, so a little hackish, but does the job
	// note to self, make sure API always returns GMT times ;)
	NSCalendarDate * d = [NSCalendarDate dateWithString:[[self fieldValue:field] stringByAppendingString:@" GMT"] calendarFormat:@"%Y-%m-%dT%H:%M:%S.%FZ %Z"];
	return d;
}

- (NSCalendarDate *)dateValue:(NSString *)field {
	return [NSCalendarDate dateWithString:[self fieldValue:field] calendarFormat:@"%Y-%m-%d"];	
}

- (int)intValue:(NSString *)field {
	return [[self fieldValue:field] intValue];
}

- (double)doubleValue:(NSString *)field {
	return [[self fieldValue:field] doubleValue];
}

- (ZKQueryResult *)queryResultValue:(NSString *)field {
	return [self fieldValue:field];
}

- (NSString *)id {
	return Id;
}

- (NSString *)type {
	return type;
}

- (NSArray *)fieldsToNull {
	return [fieldsToNull allObjects];
}

- (NSDictionary *)fields {
	return fields;
}

@end
