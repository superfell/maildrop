// Copyright (c) 2013 Simon Fell
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

#import "WhoWhatSearch.h"
#import "zkSforce.h"
#import "Constants.h"
#import "WhatSearchDataSource.h"
#import "ZKDescribeSObject_additions.h"
#import "NSString_sosl.h"

@implementation FkSearchController

@synthesize searchText, sforce;

-(void)dealloc {
    [sforce release];
    [searchText release];
    [super dealloc];
}

-(ZKSObject *)selected {
    return nil;
}

-(IBAction)search:(id)sender {
}

-(void)setSforce:(ZKSforceClient *)c {
    [sforce autorelease];
    sforce = [c retain];
}

@end

@implementation WhoController

@synthesize whoSearchController, searchResults;

+(NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *sforceKeys = [NSSet setWithObjects:@"canSearch", @"searchToolTop", @"createContactAllowed", @"createLeadAllowed", nil];
    if ([sforceKeys containsObject:key])
        return [NSSet setWithObject:@"sforce"];
    return [super keyPathsForValuesAffectingValueForKey:key];
}

-(void)dealloc {
    [searchResults release];
    [super dealloc];
}

-(BOOL)canSearch {
    return [sforce hasEntity:CONTACT] || [sforce hasEntity:LEAD];
}

-(NSString *)searchToolTip {
	return [self canSearch] ? @"" : @"No access to Leads or Contacts, cannot search/set related to Who field";
}

-(ZKSObject *)selected {
    NSArray *sel = [whoSearchController selectedObjects];
	if ([sel count] == 0) return nil;
	return [sel objectAtIndex:0];
}

-(NSString *)whoFieldsForType:(NSString *)type {
	static NSString *WHO_FIELDS = @"Id, Email, Name, FirstName, LastName";
	static NSString *WHO_FIELDS_LEAD = @"Company";
	static NSString *WHO_FIELDS_CONTACT = @"Account.Name";
    
	if ([type isEqualToString:LEAD])
		return [NSString stringWithFormat:@"%@,%@", WHO_FIELDS, WHO_FIELDS_LEAD];
	if ([sforce hasEntity:ACCOUNT])
		return [NSString stringWithFormat:@"%@,%@", WHO_FIELDS, WHO_FIELDS_CONTACT];
	return WHO_FIELDS;
}

-(IBAction)search:(id)sender {
	BOOL hasContacts = [sforce hasEntity:CONTACT];
	BOOL hasLeads =    [sforce hasEntity:LEAD];
	NSMutableString *sosl = [NSMutableString stringWithFormat:@"FIND {%@} IN ALL FIELDS RETURNING ", [searchText escapedForSosl]];
	if (hasLeads)
		[sosl appendFormat:@"Lead(%@)", [self whoFieldsForType:LEAD]];
	if (hasContacts)
		[sosl appendFormat:@"%@Contact(%@)", hasLeads ? @", " : @"", [self whoFieldsForType:CONTACT]];
	@try {
		NSArray *res = [sforce search:sosl];
        [self setSearchResults:res];
		if ([res count] == 1)
			[whoSearchController setSelectionIndex:0];
	}
	@catch (ZKSoapException *ex) {
		NSAlert * a = [NSAlert alertWithMessageText:@"Search Failed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:[ex reason]];
		[a runModal];
	}
}

-(void)insertNewRecordOfType:(NSString *)type withId:(NSString *)recordId {
    // query the record back from salesforce.com, pick up the compound name, plus anything else done server side
    ZKSObject *n = [[[sforce query:[NSString stringWithFormat:@"select %@ from %@ where id='%@' LIMIT 1",
                                    [self whoFieldsForType:type], type, recordId]] records] objectAtIndex:0];
    // add info to list view,
    NSMutableArray *newList = [NSMutableArray arrayWithArray:[self searchResults]];
    [newList insertObject:n atIndex:0];
    [self setSearchResults:newList];
    [whoSearchController setSelectionIndex:0];
}

-(BOOL)createContactAllowed {
    return [sforce canCreateEntity:CONTACT];
    
}

-(BOOL)createLeadAllowed {
    return [sforce canCreateEntity:LEAD];
}

@end

@implementation WhatController

+(NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *sforceKeys = [NSSet setWithObjects:@"whatObjectTypes", @"whatObjectTypeDescribes", nil];
    if ([sforceKeys containsObject:key])
        return [NSSet setWithObject:@"sforce"];
    return [super keyPathsForValuesAffectingValueForKey:key];
}

-(void)dealloc {
    [whatObjectTypes release];
    [whatResultsTableSource release];
    [super dealloc];
}

-(ZKSObject *)selected {
    int sel = [whatSearchResults selectedRow];
    if (sel < 0) return nil;
    return [[whatResultsTableSource results] objectAtIndex:sel];
}

- (NSString *)buildWhatSosl {
	NSMutableString *sosl = [NSMutableString stringWithFormat:@"FIND {%@*} IN ALL FIELDS RETURNING", [searchText escapedForSosl]];
	BOOL first = YES;
    for (NSDictionary *sobject in [self whatObjectTypes]) {
		if (![[sobject objectForKey:@"checked"] boolValue]) continue;
		ZKDescribeSObject *desc = [sforce describeSObject:[sobject objectForKey:@"type"]];
		[sosl appendFormat:@"%@ %@(Id", first ? @"" : @",", [desc name]];
		ZKDescribeField *f;
		NSEnumerator *fe = [[desc nameFields] objectEnumerator];
		while (f = [fe nextObject])
			[sosl appendFormat:@", %@", [f name]];
		f = [desc additionalDisplayField];
		if (f != nil)
			[sosl appendFormat:@", %@", [f name]];
		[sosl appendFormat:@")"];
		first = NO;
	}
    // If we didn't find any checked types, first will still be true, and we should return nil to skip the search
	return first ? nil : sosl;
}

- (NSNumber *)shouldWhatObjectBeChecked:(ZKDescribeSObject *)sobject {
	NSArray * defaultWhats = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedWhats"];
	bool checked = NO;
	if (defaultWhats == nil)
		checked = ![sobject custom];
	else
		checked = [defaultWhats containsObject:[sobject name]];
	return [NSNumber numberWithBool:checked];
}

-(void)setSforce:(ZKSforceClient *)c {
    [super setSforce:c];
    [whatObjectTypes autorelease];
    whatObjectTypes = nil;
}

- (NSArray *)whatObjectTypeDescribes {
	ZKDescribeSObject *desc = [sforce describeSObject:@"Task"];
	NSMutableArray *types = [NSMutableArray array];
	NSEnumerator *e = [[[desc fieldWithName:@"WhatId"] referenceTo] objectEnumerator];
	NSString *type;
	while (type = [e nextObject]) {
		// for sosl, you can't search products or solutions with everything else
		// they have to be done on there own, so for now, we'll just exclude them
		// from the list all together.
		if ([type isEqualToString:@"Product2"] || [type isEqualToString:@"Solution"]) continue;
		ZKDescribeSObject * rd = [sforce describeSObject:type];
		[types addObject:rd];
	}
	return types;
}

- (NSArray *)whatObjectTypes {
	if (whatObjectTypes != nil) return whatObjectTypes;
	NSMutableArray * types = [NSMutableArray array];
    for (ZKDescribeSObject *type in [self whatObjectTypeDescribes]) {
		NSMutableDictionary *t = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  [self shouldWhatObjectBeChecked:type], @"checked",
                                  [type labelPlural],                    @"sobjectLabel",
                                  [type name],                           @"type",
                                  nil];
		[types addObject:t];
	}
	whatObjectTypes = [types retain];
	return whatObjectTypes;
    return types;
}

- (void)setWhatSearchResultsData:(NSArray *)res {
	if (whatResultsTableSource == nil) {
		whatResultsTableSource = [[WhatSearchDataSource alloc] init];
		[whatSearchResults setDataSource:whatResultsTableSource];
	}
	[whatResultsTableSource setSforce:sforce];
	[whatResultsTableSource setResults:res];
	[whatSearchResults reloadData];
}

- (void)saveCheckedWhats {
	NSMutableArray *whats = [NSMutableArray array];
	NSDictionary *r;
	NSEnumerator *e = [[self whatObjectTypes] objectEnumerator];
	while (r = [e nextObject]) {
		if ([[r objectForKey:@"checked"] boolValue])
			[whats addObject:[r objectForKey:@"type"]];
	}
	[[NSUserDefaults standardUserDefaults] setObject:whats forKey:@"selectedWhats"];
}

-(IBAction)search:(id)sender {
    [self saveCheckedWhats];
    NSString *sosl = [self buildWhatSosl];
    if (sosl == nil) return;
    @try {
        NSArray *res = [sforce search:sosl];
        [self setWhatSearchResultsData:res];
        if ([res count] == 1)
            [whatSearchResults selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    }
    @catch (ZKSoapException *ex) {
        NSAlert * a = [NSAlert alertWithMessageText:@"Search Failed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:[ex reason]];
        [a runModal];
    }
}

@end


