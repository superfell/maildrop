// Copyright (c) 2006-2013 Simon Fell
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
#import "CreateContactController.h"
#import "CreateLeadController.h"

@interface ZKSObject (AccountNameHelper)
-(NSString *)accountName;
@end

@interface CreateActivityController ()
- (void)saveCheckedWhats;
@property (retain, nonatomic) ZKSforceClient *sforce;
@property (retain, nonatomic) ActivityBuilder *activityBuilder;
@end

@implementation ZKSObject (AccountNameHelper)

-(NSString *)accountName {
	if ([[self type] isEqualToString:LEAD])
		return [self fieldValue:@"Company"];
	return [[self fieldValue:@"Account"] fieldValue:@"Name"];
}

@end

@implementation CreateActivityController

@synthesize whoSearchText, whatSearchText, activityBuilder;
@synthesize createContactAllowed, createLeadAllowed;
@synthesize email, closedTaskStatus;
@synthesize sforce, storeTaskStatusDefault;

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"emailSubject"])
        return [NSSet setWithObject:@"email"];
    if ([key isEqualToString:@"whoSearchToolTip"])
        return [NSSet setWithObject:@"sforce"];
    if ([key isEqualToString:@"hasStatusField"])
        return [NSSet setWithObject:@"email"];
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
    [activityBuilder release];
	[super dealloc];
}

- (IBAction)cancel:(id)sender {
	[NSApp abortModal];
}

- (void)windowWillClose:(NSNotification *)notification {
	[NSApp abortModal];
}

- (IBAction)showActivityHelp:(id)sender {
    [[NSApp delegate] showActivityHelp:sender];
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

-(void)activityBuilder:(ActivityBuilder *)builder builtActivity:(ZKSObject *)activity {
    ZKSaveResult *sr = [[sforce create:[NSArray arrayWithObject:activity]] objectAtIndex:0];
	if ([sr success]) {
		taskId = [[sr id] copy];
		[pendingTaskWhoWhat setTaskId:[sr id]];
		[NSApp stopModal];
	} else {
		NSAlert * a = [NSAlert alertWithMessageText:@"Unable to create email"
                                      defaultButton:@"OK"
                                    alternateButton:nil
                                        otherButton:nil
                          informativeTextWithFormat:[sr message]];
		[a runModal];
	}
    self.activityBuilder = nil;
}

-(void)activityBuilderCanceled:(ActivityBuilder *)builder {
    self.activityBuilder = nil;
}

-(BOOL)hasStatusField {
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_ACTIVITY_TYPE_PREF];
    return [type isEqualToString:EMAIL_ACTIVITY_TYPE_TASK];
}

- (IBAction)create:(id)sender {
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:EMAIL_ACTIVITY_TYPE_PREF];
    Class builderType = [type isEqualToString:EMAIL_ACTIVITY_TYPE_TASK] ? [TaskActivityBuilder class] : [EventActivityBuilder class];
    ActivityBuilder *builder = [[[builderType alloc] init] autorelease];
    builder.email  = email;
    builder.who  = [self selectedWho];
    builder.what = [self selectedWhat];
    builder.status = [self closedTaskStatus];
    builder.sforce = sforce;
    builder.window = window;

    if (self.storeTaskStatusDefault)
		[[NSUserDefaults standardUserDefaults] setObject:builder.status forKey:DEFAULT_TASK_STATUS_PREF];

    self.activityBuilder = builder;
    [builder build:self];
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
	return [sforce hasEntity:CONTACT] || [sforce hasEntity:LEAD];
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
	if ([sforce hasEntity:ACCOUNT])
		return [NSString stringWithFormat:@"%@,%@", WHO_FIELDS, WHO_FIELDS_CONTACT];
	return WHO_FIELDS;
}

- (IBAction)searchWho:(id)sender {
	BOOL hasContacts = [sforce hasEntity:CONTACT];
	BOOL hasLeads =    [sforce hasEntity:LEAD];
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

- (void)resetState {
	[self setWhoSearchResults:nil];
	[self setWhatSearchResultsData:nil];
	[self setWhatSearchText:@""];
	[self setWhoSearchText:@""];
	[pendingTaskWhoWhat autorelease];
	pendingTaskWhoWhat = [[PendingTaskWhoWhat alloc] init];
}

-(void)createWhoWithController:(CreateContactController *)controller {
    NSString *type = [controller typeOfSObject];
    [controller showSheetFromEmail:self.email inWindow:window client:sforce created:^(NSString *recordId) {
        // query the record back from salesforce.com, pick up the compound name, plus anything else done server side
        
		ZKSObject *n = [[[sforce query:[NSString stringWithFormat:@"select %@ from %@ where id='%@' LIMIT 1",
                                        [self whoFieldsForType:type], type, recordId]] records] objectAtIndex:0];
		// add info to list view,
		NSMutableArray *newList = [NSMutableArray arrayWithArray:[self whoSearchResults]];
		[newList insertObject:n atIndex:0];
		[self setWhoSearchResults:newList];
		[whoSearchController setSelectionIndex:0];
        
    } canceled:^ {
    }];
}

- (IBAction)showCreateContact:(id)sender {
    CreateContactController *c = [[[CreateContactController alloc] init] autorelease];
    [self createWhoWithController:c];
}

- (IBAction)showCreateLead:(id)sender {
    CreateLeadController *c = [[[CreateLeadController alloc] init] autorelease];
    [self createWhoWithController:c];
}

- (NSString *)makeNotNull:(NSString *)s {
	 if (s == nil || [s length] == 0)
		return @" ";
	return s;
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
	if (![sforce hasEntity:sobjectName]) return NO;
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
		[self willChangeValueForKey:@"whatObjectTypeDescribes"];
		[self didChangeValueForKey:@"whatObjectTypeDescribes"];
	}
	self.whatSearchText = email.subject;
	if (email.subject.length > 0) 
		[self searchWhat:sender];
}

-(NSArray *)taskStatus {
	if (taskStatus == nil && [sforce hasEntity:@"TaskStatus"]) {
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

- (void)setSforce:(ZKSforceClient *)sf {
	if (sf == sforce) return;
	[sforce autorelease];
	sforce = [sf retain];
	[whatObjectTypes release];
	whatObjectTypes = nil;
	[taskStatus release];
	taskStatus = nil;
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
