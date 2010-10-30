// Copyright (c) 2006-2010 Simon Fell
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

#import "ZKDescribeSObject_additions.h"
#import "zkSforceClient.h"

@implementation ZKSObject (KVCHelper)

- (id)valueForUndefinedKey:(NSString *)key {
	id v = [fields objectForKey:key];
	if (v != nil) {
		return v == [NSNull null] ? nil : v;
	}
	return [super valueForUndefinedKey:key];
}

-(ZKDescribeSObject *)describe:(ZKSforceClient *)client {
	return [client describeSObject:[self type]];
}

@end

@implementation ZKDescribeSObject (FieldHelpers)

- (NSArray *)nameFields {
	NSMutableArray *names = [NSMutableArray arrayWithCapacity:2];
	ZKDescribeField *f;
	NSEnumerator *e = [[self fields] objectEnumerator];
	while (f = [e nextObject]) {
		if([f nameField])
			[names addObject:f];
	}
	return names;
}

// As we already include the name fields in the search, we need to filter those out of the options
-(NSArray *)validAdditionalFields {
	NSArray *allFields = [self fields];
	NSMutableArray *fs = [NSMutableArray arrayWithCapacity:[allFields count]];
	NSEnumerator *e = [allFields objectEnumerator];
	ZKDescribeField *f;
	while (f = [e nextObject]) {
		if (![f nameField])
			[fs addObject:f];
	}
	return fs;
}

-(NSString *)additionalFieldDefaultsKeyName {
	return [NSString stringWithFormat:@"additionalField_%@", [self name]];
}

-(ZKDescribeField *)additionalDisplayField {
	NSString *fn = [[NSUserDefaults standardUserDefaults] objectForKey:[self additionalFieldDefaultsKeyName]];
	if (fn == nil) return nil;
	return [self fieldWithName:fn];
}

-(void)setAdditionalDisplayField:(ZKDescribeField *)f {
	[[NSUserDefaults standardUserDefaults] setObject:[f name] forKey:[self additionalFieldDefaultsKeyName]];
}

@end

@implementation ZKDescribeField (BindingHelpers)

-(NSString *)labelAndName {
	return [NSString stringWithFormat:@"%@ (%@)", [self label], [self name]];
}

@end

@implementation ZKSforceClient (Describe)

-(ZKDescribeGlobalSObject *)describeGlobalFor:(NSString *)entity {
	for (ZKDescribeGlobalSObject *d in [self describeGlobal]) {
		if ([entity caseInsensitiveCompare:[d name]] == NSOrderedSame)
			return [[d retain] autorelease];
	}
	return nil;
}

@end