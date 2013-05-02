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


#import "WhatSearchDataSource.h"
#import "ZKDescribeSObject_additions.h"
#import "ZKSforce.h"

@implementation WhatSearchDataSource

- (void)dealloc {
	[results release];
	[sforce release];
	[super dealloc];
}

- (ZKSforceClient *)sforce {
	return sforce;
}

- (void)setSforce:(ZKSforceClient *)aValue {
	ZKSforceClient *oldSforce = sforce;
	sforce = [aValue retain];
	[oldSforce release];
}

- (NSArray *)results {
	return results;
}

- (void)setResults:(NSArray *)newResults {
	if (results == newResults) return;
	[results release];
	results = [newResults retain]; 
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)v {
	return [results count];
}

- (NSString *)nameValueForRow:(ZKSObject *)row {
	ZKDescribeSObject *d = [sforce describeSObject:[row type]];
	NSArray *nameFields = [d nameFields];
	if ([nameFields count] == 1) 
		return [row fieldValue:[[nameFields objectAtIndex:0] name]];
	NSMutableString *n = [NSMutableString string];
	ZKDescribeField *f;
	BOOL isFirst = YES;
	NSEnumerator *e = [nameFields objectEnumerator];
	while (f = [e nextObject]) {
		[n appendFormat:@"%@%@", isFirst ? @"" : @" ", [row fieldValue:[f name]]];
		isFirst = NO;
	}
	return n;
}

-(NSString *)additionalValue:(ZKSObject *)row {
	ZKDescribeSObject *d = [sforce describeSObject:[row type]];
	ZKDescribeField *f = [d additionalDisplayField];
	if (f == nil) return @"";
	return [row fieldValue:[f name]];
}

- (id)tableView:(NSTableView *)view objectValueForTableColumn:(NSTableColumn *)tc row:(NSInteger)rowIdx {
	ZKSObject *r = [results objectAtIndex:rowIdx];
	NSString *ident = [tc identifier];
	if ([ident isEqualToString:@"type"]) {
		return [[sforce describeGlobalFor:[r type]] label];
	} else if ([ident isEqualToString:@"name"]) {
		return [self nameValueForRow:r];
	} else if ([ident isEqualToString:@"id"]) {
		return [r id];
	} else if ([ident isEqualToString:@"additional"]) {
		return [self additionalValue:r];
	}
	return @"";
}

@end
