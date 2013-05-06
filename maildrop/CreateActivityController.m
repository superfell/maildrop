// Copyright (c) 2006-2011 Simon Fell
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

#import "CreateActivityController.h"
#import "Email.h"
#import "ZKSforce.h"
#import "zkDescribeGlobalSObject.h"
#import "ZKDescribeSObject_Additions.h"
#import "SObjectPermsWrapper.h"
#import "Attachment.h"
#import "Constants.h"
#import "WhoWhat.h"
#import "zkSObject.h"
#import "Constants.h"

@interface ZKSObject (AccountNameHelper)
-(NSString *)accountName;
@end

@interface CreateActivityController ()
- (void)saveCheckedWhats;
@property (retain, nonatomic) ZKSforceClient *sforce;
@end

@implementation ZKSObject (AccountNameHelper)

-(NSString *)accountName {
	if ([[self type] isEqualToString:LEAD])
		return [self fieldValue:@"Company"];
	return [[self fieldValue:@"Account"] fieldValue:@"Name"];
}

@end

@implementation CreateActivityController

@synthesize whoSearchText, whatSearchText;
@synthesize contactFirstName, contactLastName;
@synthesize contactEmail, contactCompany, contactLeadStatus;
@synthesize createContactAllowed, createLeadAllowed;
@synthesize email, closedTaskStatus;
@synthesize sforce, storeTaskStatusDefault;

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"emailSubject"])
        return [NSSet setWithObject:@"email"];
    if ([key isEqualToString:@"whoSearchToolTip"])
        return [NSSet setWithObject:@"sforce"];
    return [super keyPathsForValuesAffectingValueForKey:key];
}

- (id)init {
	self = [super init];
	whoSearchResults = [[NSArray array] retain];
	whatObjectTypes = nil;
	return self;
}

- (void)dealloc {
	[sforce release];
	[whatObjectTypes release];
	[whoSearchText release];
	[whatSearchText release];
	[whoSearchResults release];
	[whatResultsTableSource release];
	[selectedWho release];
	[selectedWhat release];
	[pendingTaskWhoWhat release];
	[taskStatus release];
	[closedTaskStatus release];
	[super dealloc];
}

- (IBAction)cancel:(id)sender {
	[NSApp abortModal];
}

- (void)windowWillClose:(NSNotification *)notification {
	[NSApp abortModal];
}

- (BOOL)hasEntity:(NSString *)entity {
	return [sforce describeGlobalFor:entity] != nil;
}

- (ZKSObject *)selectedWho {
	NSArray *sel = [whoSearchController selectedObjects];
	if ([sel count] == 0) return nil;
	return [sel objectAtIndex:0];
}

- (ZKSObject *)selectedWhat {
	int sel = [whatSearchResults selectedRow];
	if (sel < 0) return nil;
	return [[whatResultsTableSource results] objectAtIndex:sel];
}

-(void)updateWhoWhat:(SObjectWhoWhat **)whoWhat from:(ZKSObject *)o {
	if (o == nil) {
		[*whoWhat release];
		*whoWhat = nil;
	} else {
		if (*whoWhat == nil) 
			*whoWhat = [[SObjectWhoWhat alloc] initWithClient:sforce];
		[*whoWhat setSobject:o];
	}
}

-(NSArray *)selectedWhoWhats {
	[self updateWhoWhat:&selectedWho from:[self selectedWho]];
	[self updateWhoWhat:&selectedWhat from:[self selectedWhat]];
	NSMutableArray *s = [NSMutableArray arrayWithCapacity:2];
	if (selectedWho != nil)  [s addObject:selectedWho];
	if (selectedWhat != nil) [s addObject:selectedWhat];
	[s addObject:pendingTaskWhoWhat];
	return s;
}

// there was a selection change in one of the results tables, notifiy that this changes the selectedWhoWhats property
-(void)tableViewSelectionDidChange:(NSNotification *)aNotification {
	[self willChangeValueForKey:@"selectedWhoWhats"];
	[self selectedWhoWhats];
	[self didChangeValueForKey:@"selectedWhoWhats"];
	for (Attachment *a in [email attachments]) {
		if ([a parentWhoWhat] == nil)
			[a setParentWhoWhat:selectedWho != nil ? selectedWho : selectedWhat];
	}
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if (returnCode == NSAlertAlternateReturn) {
		// clicked create, so unset the what, and call create again
		[whatSearchResults deselectAll:self];
		[self create:self];
	}
}

- (NSString *)buildDescriptionFromEmail:(Email *)e {
	if (![[NSUserDefaults standardUserDefaults] boolForKey:ADD_EMAIL_TO_DESC_PREF])
		return [e body];
	// otherwise add to/from to the description
	return [NSString stringWithFormat:@"From: %@\r\nTo: %@\r\n\r\n%@", [e fromAddr], [e toAddr], [e body]];
}

- (IBAction)create:(id)sender {
    NSString *sobjectType = @"Task";
	SObjectPermsWrapper *activity = [SObjectPermsWrapper withDescribe:[sforce describeSObject:sobjectType] forUpdate:NO];
	[activity setFieldValue:[NSString stringWithFormat:@"Email: %@", [email subject]] field:@"Subject"];
	[activity setFieldValue:[self buildDescriptionFromEmail:email] field:@"Description"];
	NSString *statusVal = [self closedTaskStatus];
	if (self.storeTaskStatusDefault)
		[[NSUserDefaults standardUserDefaults] setObject:statusVal forKey:DEFAULT_TASK_STATUS_PREF];
		
	[activity setFieldValue:statusVal field:@"Status"];
	[activity setFieldValue:@"Email" field:@"Type"];
	NSDate *date = [email date];
	if (date != nil) {
		NSCalendarDate *duedate = [date dateWithCalendarFormat:nil timeZone:nil];
		[activity setFieldDateValue:duedate field:@"ActivityDate"];
	}
	ZKSObject *who = [self selectedWho];
	ZKSObject *what = [self selectedWhat];
	[activity setFieldValue:[who id] field:@"WhoId"];
	if ([[who type] isEqualToString:LEAD] && (what != nil)) {
		NSAlert * a = [NSAlert alertWithMessageText:@"Can not create Email"
								defaultButton:@"Cancel Creation" 
								alternateButton:@"Create without setting \"Related to What\""
								otherButton:nil 
								informativeTextWithFormat:@"You can not create an email with a \"Related to What\" value when its \"Related to Who\" is a Lead"];
		[a beginSheetModalForWindow:window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil]; 
		return;
	}  
	[activity setFieldValue:[[self selectedWhat] id] field:@"WhatId"];
	// check description length
	NSString *desc = [[activity sobject] fieldValue:@"Description"];
	int descMax = [[[activity describe] fieldWithName:@"Description"] length];
	if ([desc length] > descMax) {
		NSAlert *a = [NSAlert alertWithMessageText:@"Email is too long" defaultButton:@"Truncate" alternateButton:@"Cancel" otherButton:nil
			informativeTextWithFormat:@"Email body is %d characters long, which is longer than max allowed of %d by Salesforce.com, do you want to truncate the email body, or cancel creating it?", [desc length], descMax];
		if (NSAlertDefaultReturn == [a runModal])
			[activity setFieldValue:[desc substringToIndex:descMax] field:@"Description"];
		else
			return;	// cancel creation.
	}
	ZKSaveResult *sr = [[sforce create:[NSArray arrayWithObject:[activity sobject]]] objectAtIndex:0];
	if ([sr success]) {
		taskId = [[sr id] copy];
		[pendingTaskWhoWhat setTaskId:[sr id]];
		[NSApp stopModal];
	} else { 
		NSAlert * a = [NSAlert alertWithMessageText:@"Unable to create email" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:[sr message]];
		[a runModal];
	}
}

- (NSString *)escapeSosl:(NSString *)src {
    if (src == nil || [src length] == 0) return src;
	// from docs, these are all reserved
	NSArray *reserved = [NSArray arrayWithObjects:@"\\", @"&", @"|", @"!", @"{", @"}", @"[", @"]", @"^", @"~", @"*:", @":", @"'" ,@"\"", @"+", @"-", nil];
	NSMutableString *s = [NSMutableString stringWithString:src];
	NSString *r;
	NSEnumerator *e = [reserved objectEnumerator];
	while (r = [e nextObject]) 
		[s replaceOccurrencesOfString:r withString:[NSString stringWithFormat:@"\\%@", r] options:NSLiteralSearch range:NSMakeRange(0, [s length])];
	return s;
}

- (void)setWhoSearchResults:(NSArray *)res {
	if (res == whoSearchResults) return;
	[whoSearchResults release];
	whoSearchResults = [res retain];
}

- (BOOL)canSearchWho {
	return [self hasEntity:CONTACT] || [self hasEntity:LEAD];
}

- (NSString *)whoSearchToolTip {
	return [self canSearchWho] ? @"" : @"No access to Leads or Contacts, cannot search/set related to Who field";
}

-(NSString *)whoFieldsForType:(NSString *)type {
	static NSString *WHO_FIELDS = @"Id, Email, Name, FirstName, LastName";
	static NSString *WHO_FIELDS_LEAD = @"Company";
	static NSString *WHO_FIELDS_CONTACT = @"Account.Name";

	if ([type isEqualToString:LEAD])
		return [NSString stringWithFormat:@"%@,%@", WHO_FIELDS, WHO_FIELDS_LEAD];
	if ([self hasEntity:ACCOUNT])
		return [NSString stringWithFormat:@"%@,%@", WHO_FIELDS, WHO_FIELDS_CONTACT];
	return WHO_FIELDS;
}

- (IBAction)searchWho:(id)sender {
	BOOL hasContacts = [self hasEntity:CONTACT];
	BOOL hasLeads =    [self hasEntity:LEAD];
	NSMutableString *sosl = [NSMutableString stringWithFormat:@"FIND {%@} IN ALL FIELDS RETURNING ", [self escapeSosl:[self whoSearchText]]];
	if (hasLeads)
		[sosl appendFormat:@"Lead(%@)", [self whoFieldsForType:LEAD]];
	if (hasContacts)
		[sosl appendFormat:@"%@Contact(%@)", hasLeads ? @", " : @"", [self whoFieldsForType:CONTACT]];
	@try {
		NSArray *res = [sforce search:sosl];
		[self setWhoSearchResults:res];
		if ([res count] == 1)
			[whoSearchController setSelectionIndex:0];
	}
	@catch (ZKSoapException *ex) {
		NSAlert * a = [NSAlert alertWithMessageText:@"Search Failed" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:[ex reason]];
		[a runModal];
	}
}

- (NSString *)buildWhatSosl {
	NSMutableString *sosl = [NSMutableString stringWithFormat:@"FIND {%@*} IN ALL FIELDS RETURNING", [self escapeSosl:[self whatSearchText]]];
	BOOL first = YES;
    for (NSMutableDictionary *sobject in [self whatObjectTypes]) {
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

- (void)setWhatSearchResultsData:(NSArray *)res {
	if (whatResultsTableSource == nil) {
		whatResultsTableSource = [[WhatSearchDataSource alloc] init];
		[whatSearchResults setDataSource:whatResultsTableSource];
	}
	[whatResultsTableSource setSforce:sforce];
	[whatResultsTableSource setResults:res];
	[whatSearchResults reloadData];
}

- (IBAction)searchWhat:(id)sender {
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

- (NSArray *)whoSearchResults {
	return whoSearchResults;
}

- (NSString *)emailSubject {
	return [email subject];
}

- (void)setEmailSubject:(NSString *)aEmailSubject {
	[email setSubject:aEmailSubject];
}

- (void)setCurrentPropertiesFromEmail {
	NSString *name = [email nameOfInterest];
	NSRange rng = [name rangeOfString:@" "];
	if (rng.location == NSNotFound) {
		[self setContactFirstName:nil];
		[self setContactLastName:name];
	} else {
		[self setContactFirstName:[name substringToIndex:rng.location]];
		[self setContactLastName:[name substringFromIndex:rng.location + rng.length]];
	}
	[self setContactEmail:[email addrOfInterest]];
	[self setContactCompany:@""];
	if ([self createLeadAllowed])
		[self setContactLeadStatus:[self defaultLeadStatus]];
	else
		[self setContactLeadStatus:@""];
}

- (void)resetState {
	[self setWhoSearchResults:nil];
	[self setWhatSearchResultsData:nil];
	[self setWhatSearchText:@""];
	[self setWhoSearchText:@""];
	[pendingTaskWhoWhat autorelease];
	pendingTaskWhoWhat = [[PendingTaskWhoWhat alloc] init];
}

- (IBAction)showCreateContact:(id)sender {
	[self setCurrentPropertiesFromEmail];
	[NSApp beginSheet:createContactWindow modalForWindow:window modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)cancelCreateContact:(id)sender {
	[NSApp endSheet:createContactWindow];
	[createContactWindow orderOut:sender];
}

- (IBAction)showCreateLead:(id)sender {
	[self setCurrentPropertiesFromEmail];
	[NSApp beginSheet:createLeadWindow modalForWindow:window modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)cancelCreateLead:(id)sender {
	[NSApp endSheet:createLeadWindow];
	[createLeadWindow orderOut:sender];
}

- (NSString *)makeNotNull:(NSString *)s {
	 if (s == nil || [s length] == 0)
		return @" ";
	return s;
}

- (void)createNewSObjectItem:(BOOL)isLead window:(NSWindow *)sheetWindow {
	ZKSObject *n = [ZKSObject withType:isLead ? LEAD : CONTACT];
	[n setFieldValue:[self makeNotNull:[self contactFirstName]] field:@"FirstName"];
	[n setFieldValue:[self makeNotNull:[self contactLastName]]  field:@"LastName"];
	[n setFieldValue:[self makeNotNull:[self contactEmail]]     field:@"Email"];
	if (isLead) {
		[n setFieldValue:[self makeNotNull:[self contactCompany]]   field:@"Company"];
		[n setFieldValue:[self makeNotNull:[self contactLeadStatus]] field:@"Status"];
	}
	ZKSaveResult *sr = [[sforce create:[NSArray arrayWithObject:n]] objectAtIndex:0];
	if ([sr success]) {
		[NSApp endSheet:sheetWindow];
		[sheetWindow orderOut:self];
		// query the record back from salesforce.com, pick up the compound name, plus anything else done server side
		n = [[[sforce query:[NSString stringWithFormat:@"select %@ from %@ where id='%@' LIMIT 1", [self whoFieldsForType:[n type]], [n type], [sr id]]] records] objectAtIndex:0];
		// add info to list view, 
		NSMutableArray *newList = [NSMutableArray arrayWithArray:[self whoSearchResults]];
		[newList insertObject:n atIndex:0];
		[self setWhoSearchResults:newList];
		[whoSearchController setSelectionIndex:0];
	} else {
		NSAlert * a = [NSAlert alertWithMessageText:@"Create Failed" defaultButton:@"OK" alternateButton:nil otherButton:nil 
							   informativeTextWithFormat:[NSString stringWithFormat:@"%@ : %@", [sr statusCode], [sr message]]];
		[a runModal];
	}
}

- (IBAction)createContact:(id)sender {
	[self createNewSObjectItem:NO window:createContactWindow];
}

- (IBAction)createLead:(id)sender {
	[self createNewSObjectItem:YES window:createLeadWindow];
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

- (NSNumber *)shouldWhatObjectBeChecked:(ZKDescribeSObject *)sobject {
	NSArray * defaultWhats = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedWhats"];
	bool checked = NO;
	if (defaultWhats == nil) 
		checked = ![sobject custom];
	else 
		checked = [defaultWhats containsObject:[sobject name]];
	return [NSNumber numberWithBool:checked];
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
	NSArray *t = [self whatObjectTypeDescribes];
	NSMutableArray * types = [NSMutableArray array];
	NSEnumerator *e = [t objectEnumerator];
	ZKDescribeSObject *type;
	while (type = [e nextObject]) {
		NSMutableDictionary *t = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self shouldWhatObjectBeChecked:type], @"checked", [type labelPlural], @"sobjectLabel", [type name], @"type", nil];
		[types addObject:t];
	}
	whatObjectTypes = [types retain];
	return whatObjectTypes;
}

- (IBAction)configureWhatSearchColumns:(id)sender {
	[NSApp beginSheet:whatSearchConfigWindow modalForWindow:window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)closeWhatConfig:(id)sender {
	[NSApp endSheet:whatSearchConfigWindow];
	[whatSearchConfigWindow orderOut:sender];
}

- (BOOL)isCreateableObjectType:(NSString *)sobjectName {
	if (![self hasEntity:sobjectName]) return NO;
	return [[sforce describeSObject:sobjectName] createable];
}

- (void)initWhats:(id)sender {
	[self willChangeValueForKey:@"canSearchWho"];
	[self didChangeValueForKey:@"canSearchWho"];
	if (whatObjectTypes == nil) {
		[self willChangeValueForKey:@"whatObjectTypes"];
		[whatObjectTypes release];
		whatObjectTypes = nil;
		[self didChangeValueForKey:@"whatObjectTypes"];
		[self willChangeValueForKey:@"leadStatus"];
		[leadStatus release];
		leadStatus = nil;
		[self didChangeValueForKey:@"leadStatus"];
		[self willChangeValueForKey:@"whatObjectTypeDescribes"];
		[self didChangeValueForKey:@"whatObjectTypeDescribes"];
	}
	self.whatSearchText = email.subject;
	if (email.subject.length > 0) 
		[self searchWhat:sender];
}

-(NSArray *)taskStatus {
	if (taskStatus == nil && [self hasEntity:@"TaskStatus"]) {
		ZKQueryResult *qr = [sforce query:@"select MasterLabel,IsClosed from TaskStatus order by sortOrder"];
		taskStatus = [[qr records] retain];
	}
	return taskStatus;
}

-(NSString *)defaultTaskStatus {
	NSArray *s = [self taskStatus];
	NSEnumerator *re = [s reverseObjectEnumerator];
	ZKSObject *r;
	NSString *sysDefault = nil;
	NSString *userDefault = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULT_TASK_STATUS_PREF];
	BOOL sawUserDefault = NO;
	while (r = [re nextObject]) {
		// default is the last status with a IsClosed=true.
		if ((sysDefault == nil) && [r boolValue:@"IsClosed"])
			sysDefault = [r fieldValue:@"MasterLabel"];
		// double check that the users default still exists.
		if ((!sawUserDefault) && [[r fieldValue:@"MasterLabel"] isEqualToString:userDefault])
			sawUserDefault = YES;
	}
	return sawUserDefault ? userDefault : sysDefault;
}

- (NSArray *)leadStatus {
	if (leadStatus != nil) return leadStatus;
	if (sforce == nil) return nil;
	if (![self hasEntity:@"LeadStatus"]) return nil;
	ZKQueryResult *qr = [sforce query:@"select MasterLabel, IsDefault from LeadStatus order by SortOrder"];
	NSMutableArray *ls = [NSMutableArray arrayWithCapacity:[qr size]];
	ZKSObject *s;
	NSEnumerator *e = [[qr records] objectEnumerator];
	while (s = [e nextObject]) {
		if ([s boolValue:@"IsDefault"])
			defaultLeadStatus = [[s fieldValue:@"MasterLabel"] copy];
		[ls addObject:[s fieldValue:@"MasterLabel"]];
	}
	leadStatus = [ls retain];
	return leadStatus;
}

- (NSString *)defaultLeadStatus {
	if (defaultLeadStatus == nil)
		[self leadStatus];
	return defaultLeadStatus;
}

- (void)setSforce:(ZKSforceClient *)sf {
	if (sf == sforce) return;
	[sforce autorelease];
	sforce = [sf retain];
	[whatObjectTypes release];
	whatObjectTypes = nil;
	[leadStatus release];
	leadStatus = nil;
	[taskStatus release];
	taskStatus = nil;
	[defaultLeadStatus release];
	defaultLeadStatus = nil;
	[selectedWho release];
	selectedWho = nil;
	[selectedWhat release];
	selectedWhat = nil;
	[self willChangeValueForKey:@"taskStatus"];
	[self didChangeValueForKey:@"taskStatus"];
	[self willChangeValueForKey:@"selectedWhoWhats"];
	[self didChangeValueForKey:@"selectedWhoWhats"];
	[self setCreateContactAllowed:[self isCreateableObjectType:CONTACT]];
	[self setCreateLeadAllowed:[self isCreateableObjectType:LEAD]];	
}

- (NSString *)createActivity:(Email *)theEmail sforce:(ZKSforceClient *)sf {
	[self resetState];
	[self setSforce:sf];
	[self setEmail:theEmail];
	[self setWhoSearchText:[email addrOfInterest]];
	[self setClosedTaskStatus:[self defaultTaskStatus]];
	self.storeTaskStatusDefault = NO;
	[NSApp activateIgnoringOtherApps:YES];
	if ([self canSearchWho]) {
		NSTimer *t = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(searchWho:) userInfo:nil repeats:NO];
		[[NSRunLoop currentRunLoop] addTimer:t forMode:NSModalPanelRunLoopMode];
	}
	NSTimer *t = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(initWhats:) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:t forMode:NSModalPanelRunLoopMode];
	[NSApp runModalForWindow:window];
	[window orderOut:self];
	// todo
	[self setEmail:nil];
	NSString *sfId = [taskId autorelease];
	taskId = nil;
	return sfId;
}

static const float MIN_PANE_SIZE = 70.0f;

- (CGFloat)splitView:(NSSplitView *)sender constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)offset {
	return proposedMin + (offset == 1 ? MIN_PANE_SIZE : MIN_PANE_SIZE *2);
}

- (CGFloat)splitView:(NSSplitView *)sender constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)offset {
	return proposedMax - (offset == 1 ? MIN_PANE_SIZE : MIN_PANE_SIZE *2);
}

@end
