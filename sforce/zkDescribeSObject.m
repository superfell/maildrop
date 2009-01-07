// Copyright (c) 2006-2007 Simon Fell
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


#import "zkDescribeSObject.h"
#import "zkDescribeField.h"
#import "zkChildRelationship.h"
#import "zkRecordTypeInfo.h"

@implementation ZKDescribeSObject

-(void)dealloc {
	[fields release];
	[fieldsByName release];
	[childRelationships release];
	[recordTypeInfos release];
	[super dealloc];
}

-(BOOL)activateable {
	return [self boolean:@"activateable"];
}
-(BOOL)createable {
	return [self boolean:@"createable"];
}
-(BOOL)custom {
	return [self boolean:@"custom"];
}
-(BOOL)deletable {
	return [self boolean:@"deletable"];
}
-(BOOL)layoutable {
	return [self boolean:@"layoutable"];
}
-(BOOL)mergeable {
	return [self boolean:@"mergeable"];
}
-(BOOL)queryable {
	return [self boolean:@"queryable"];
}
-(BOOL)replicateable {
	return [self boolean:@"replicateable"];
}
-(BOOL)retrieveable {
	return [self boolean:@"retrieveable"];
}
-(BOOL)searchable {
	return [self boolean:@"searchable"];
}
-(BOOL)triggerable {
	return [self boolean:@"triggerable"];
}
-(BOOL)undeleteable {
	return [self boolean:@"undeleteable"];
}
-(BOOL)updateable {
	return [self boolean:@"updateable"];
}
-(NSString *)keyPrefix {
	return [self string:@"keyPrefix"];
}
-(NSString *)label {
	return [self string:@"label"];
}
-(NSString *)labelPlural {
	return [self string:@"labelPlural"];
}
-(NSString *)name {
	return [self string:@"name"];
}
-(NSString *)urlDetail {
	return [self string:@"urlDetail"];
}
-(NSString *)urlEdit {
	return [self string:@"urlEdit"];
}
-(NSString *)urlNew {
	return [self string:@"urlNew"];
}

-(NSArray *)fields {
	if (fields == nil) {
		NSArray * fn = [node elementsForName:@"fields"];
		NSMutableDictionary *byName = [NSMutableDictionary dictionary];
		NSMutableArray * fs = [NSMutableArray arrayWithCapacity:[fn count]];
		NSXMLNode * fieldNode;
		NSEnumerator *e = [fn objectEnumerator];
		while (fieldNode = [e nextObject]) {
			ZKDescribeField * df = [[ZKDescribeField alloc] initWithXmlElement:(NSXMLElement*)fieldNode];
			[df setSobject:self];
			[fs addObject:df];
			[byName setObject:df forKey:[[df name] lowercaseString]];
			[df release];
		}
		fields = [fs retain];
		fieldsByName = [byName retain];
	}
	return fields;
}

-(ZKDescribeField *)fieldWithName:(NSString *)name {
	if (fieldsByName == nil) 
		[self fields];
	return [fieldsByName objectForKey:[name lowercaseString]];
}

-(NSArray *)childRelationships {
	if (childRelationships == nil) {
		NSArray *crn = [node elementsForName:@"childRelationships"];
		NSMutableArray *crs = [NSMutableArray arrayWithCapacity:[crn count]];
		NSXMLNode * crNode;
		NSEnumerator *e = [crn objectEnumerator];
		while (crNode = [e nextObject]) {
			ZKChildRelationship * cr = [[ZKChildRelationship alloc] initWithXmlElement:(NSXMLElement*)crNode];
			[crs addObject:cr];
			[cr release];
		}
		childRelationships = [crs retain];
	}
	return childRelationships;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"SObject %@ (%@)", [self name], [self label]];
}

-(NSArray *)recordTypeInfos {
	if (recordTypeInfos == nil) {
		NSArray *rti = [node elementsForName:@"recordTypeInfos"];
		NSMutableArray *res = [NSMutableArray arrayWithCapacity:[rti count]];
		NSXMLNode *rnode;
		NSEnumerator *e = [rti objectEnumerator];
		while (rnode = [e nextObject]) {
			ZKRecordTypeInfo *r = [[ZKRecordTypeInfo alloc] initWithXmlElement:(NSXMLElement*)rnode];
			[res addObject:r];
			[r release];
		}
		recordTypeInfos = [res retain];
	}
	return recordTypeInfos;
}

@end
