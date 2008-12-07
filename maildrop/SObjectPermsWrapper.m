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

#import "SObjectPermsWrapper.h"
#import "ZKDescribeSObject.h"
#import "ZKSObject.h"

@implementation SObjectPermsWrapper

+ (id) withDescribe:(ZKDescribeSObject *)desc forUpdate:(BOOL)isUpdate {
	return [[[SObjectPermsWrapper alloc] initWithDescribe:desc forUpdate:isUpdate] autorelease];
}

- (id) initWithDescribe:(ZKDescribeSObject *)desc forUpdate:(BOOL)isUpdate {
	self = [super init];
	describe = [desc retain];
	isupdate = isUpdate;
	sobject = [[ZKSObject alloc] initWithType:[desc name]];
	return self;
}

- (void)dealloc {
	[describe release];
	[sobject release];
	[super dealloc];
}

- (ZKSObject *)sobject {
	return sobject;
}

- (BOOL)hasAccess:(NSString *)field {
	ZKDescribeField *f = [describe fieldWithName:field];
	return isupdate ? [f updateable] : [f createable];
}

- (BOOL)setFieldValue:(NSString *)val field:(NSString *)field {
	if ([self hasAccess:field]) {
		[sobject setFieldValue:val field:field];
		return YES;
	}
	return NO;
}

- (BOOL)setFieldDateValue:(NSCalendarDate *)val field:(NSString *)field {
	if ([self hasAccess:field]) {
		[sobject setFieldDateValue:val field:field];
		return YES;
	}
	return NO;
}

@end
