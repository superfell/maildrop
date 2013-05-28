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

#import "Email.h"
#import "ZKSforceClient.h"
#import "ZKSObject.h"
#import "zkDescribeGlobalSObject.h"
#import "SObjectPermsWrapper.h"
#import "AppDelegate.h"
#import "Attachment.h"
#import "ButtonBarController.h"
#import "Constants.h"
#import "ZKDescribeSObject_additions.h"

typedef enum GrowlNotification {
	EmailAdded,
	CaseCreated
} GrowlNotification;

@interface Email (private)
- (void)growl:(GrowlNotification)type;
@end

@implementation Email

@synthesize fromName, fromAddr, toName, toAddr, subject, body, date, isASentEmail, salesforceId;

- (id)init {
	self = [super init];
	attachments = [[NSMutableArray alloc] init];
 	return self;
}

- (void)dealloc {
	[attachments release];
	[fromAddr release];
	[fromName release];
	[toAddr release];
	[toName release];
	[subject release];
	[body release];
	[date release];
	[salesforceId release];
	[super dealloc];
}

- (NSString *)addrOfInterest {
	return isASentEmail ? toAddr : fromAddr;
}

- (NSString *)nameOfInterest {
	return isASentEmail ? toName : fromName;
}

- (NSString *)escapeForSoql:(NSString *)src {
	NSMutableString *s = [NSMutableString stringWithString:src];
	[s replaceOccurrencesOfString:@"'" withString:@"\\'" options:NSLiteralSearch range:NSMakeRange(0, [s length])];
	return s;
}

- (void)openInSalesforce:(NSString *)sfId sobject:(NSString *)sobject sforce:(ZKSforceClient *)sforce {
	NSMutableString *detail = [NSMutableString stringWithString:[[sforce describeSObject:sobject] urlDetail]];
	[detail replaceOccurrencesOfString:@"{ID}" withString:sfId options:NSLiteralSearch range:NSMakeRange(0, [detail length])];
	NSURL *detailUrl = [NSURL URLWithString:detail];
	NSURL *baseUiUrl = [NSURL URLWithString:@"/" relativeToURL:detailUrl];		
	NSURL *frontdoor = [NSURL URLWithString:[NSString stringWithFormat:@"/secur/frontdoor.jsp?sid=%@&retURL=%@", [[[NSApp delegate] sforce] sessionId], [detailUrl path]] relativeToURL:baseUiUrl];
	[[NSWorkspace sharedWorkspace] openURL:frontdoor];
}

-(BOOL)checkSObjectType:(NSString *)sobjectType hasAccess:(ZKSforceClient *)sforce {
	if (sforce == nil) return NO;
	ZKDescribeGlobalSObject *desc = [sforce describeGlobalFor:sobjectType];
	if ([desc createable]) return YES;
			
	NSString *endUserType = desc != nil ? [desc labelPlural] : [NSString stringWithFormat:@"%@s", sobjectType];
	NSAlert * a = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"No Access to create %@", endUserType] defaultButton:@"OK" alternateButton:nil otherButton:nil 
						informativeTextWithFormat:@"Your login does not have the create %@ access, please contact your Salesforce.com administrator", endUserType];
	[a runModal];
	return NO;
}

-(void)saveAttachmentsUsingClient:(ZKSforceClient *)sforce numTotal:(int)totalAttachments  {
	if ([attachments count] == 0) return;
	if (![self checkSObjectType:@"Attachment" hasAccess:sforce]) return;
	AppDelegate *app = (AppDelegate *)[NSApp delegate];
	int progress = 1;
	for (Attachment *a in attachments) {
		if (![a shouldUpload]) continue;
		[[app buttonBarController] showProgressOf:progress max:totalAttachments + 1 withText:[NSString stringWithFormat:@"Attachment %d %@", progress, [a name]]]; 
		ZKSaveResult *sr = [[sforce create:[NSArray arrayWithObject:[a makeSObject]]] objectAtIndex:0];
		if (![sr success]) {
			// TODO
			NSLog(@"%@ %@", [sr statusCode], [sr message]);
		} else {
			[a setSalesforceId:[sr id]];
		}
		progress++;
	}
	[[app buttonBarController] hideProgress];
}

-(int)countOfAttachmentsToUpload {
	int c = 0;
	for (Attachment *a in attachments) 
		if ([a shouldUpload]) c++;
	return c;
}

-(void)setAttachmentsParentId:(NSString *)parentId onlyIfNil:(BOOL)onlyIfNil {
	for (Attachment *a in attachments) {
		if ((!onlyIfNil) || ([a parentId] == nil))
			[a setParentId:parentId];
	}
}

-(void)clearAttachmentUpload {
	for (Attachment *a in attachments)
		[a setShouldUpload:NO];
}

-(void)createActivity:(NSScriptCommand *)cmd {
	AppDelegate *app = (AppDelegate *)[NSApp delegate];
	BOOL addAttachments = [[NSUserDefaults standardUserDefaults] boolForKey:ATTACHMENTS_ON_EMAIL_PREF];
	if (!addAttachments)
		[self clearAttachmentUpload];
	NSString *activityId = [app createActivity:self];
	int num = [self countOfAttachmentsToUpload];
	if (activityId != nil) {
		[self setSalesforceId:activityId];
		[self saveAttachmentsUsingClient:[app sforce] numTotal:num];
		[self growl:EmailAdded];
		if ([[NSUserDefaults standardUserDefaults] boolForKey:SHOW_NEW_EMAIL_PREF])
			[self openInSalesforce:activityId sobject:@"Task" sforce:[app sforce]];
		if (num > 0)
			[app shouldCheckForAttachmentsRelatedListOnTask];
	}
}

- (void)createCase:(NSScriptCommand *)cmd {
	AppDelegate *app = (AppDelegate *)[NSApp delegate];
	ZKSforceClient *sforce = [app sforce];
	if (sforce == nil) return;
	if (![self checkSObjectType:@"Case" hasAccess:sforce]) return;
	BOOL addAttachments = [[NSUserDefaults standardUserDefaults] boolForKey:ATTACHMENTS_ON_CASES_PREF];
	// look for a matching contact
	ZKDescribeSObject *caseDesc = [sforce describeSObject:@"Case"];
	SObjectPermsWrapper *cse = [SObjectPermsWrapper withDescribe:caseDesc forUpdate:NO];
	if (([sforce describeGlobalFor:@"Contact"] != nil) && [[caseDesc fieldWithName:@"ContactId"] createable]) {
		ZKQueryResult *qr = [sforce query:[NSString stringWithFormat:@"select id from contact where email='%@'", [self escapeForSoql:[self addrOfInterest]]]];
		if ([qr size] == 1)
			[cse setFieldValue:[[[qr records] objectAtIndex:0] fieldValue:@"Id"] field:@"ContactId"];
	}
	// populate rest of case data
	[cse setFieldValue:subject 	field:@"Subject"];
	[cse setFieldValue:body    	field:@"Description"];
	[cse setFieldValue:[self nameOfInterest] field:@"SuppliedName"];
	[cse setFieldValue:[self addrOfInterest] field:@"SuppliedEmail"];
	[cse setFieldValue:@"Email" field:@"Origin"];
	int numAttatchments = addAttachments ? [self countOfAttachmentsToUpload] : 0;
	if (numAttatchments > 0)
		[[app buttonBarController] showProgressOf:0 max:1 + numAttatchments withText:[NSString stringWithFormat:@"Creating new %@", [caseDesc label]]];

	ZKSaveResult *sr = [[sforce create:[NSArray arrayWithObject:[cse sobject]]] objectAtIndex:0];
	if ([sr success]) {
		[self setSalesforceId:[sr id]];
		if (addAttachments) {
			[self setAttachmentsParentId:[sr id] onlyIfNil:NO];
			[self saveAttachmentsUsingClient:sforce numTotal:numAttatchments];
		}
		[self growl:CaseCreated];
		if ([[NSUserDefaults standardUserDefaults] boolForKey:SHOW_NEW_CASE_PREF])
			[self openInSalesforce:salesforceId sobject:@"Case" sforce:sforce];
	} else {
		NSAlert * a = [NSAlert alertWithMessageText:[sr message] defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:[sr statusCode]];
		[a runModal];
	}
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ (%@) -> %@ : %@\r%@", fromAddr, fromName, toAddr, subject, body];
}

- (BOOL)growlIsRunning {
    NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
	                @"\
						tell application \"System Events\" \n\
							set isRunning to (count of (every process whose name is \"GrowlHelperApp\")) > 0 \n\
						end tell \n\
						isRunning\n"];

    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
    [scriptObject release];
    if (returnDescriptor != NULL)
    {
        // successful execution
        if (kAENullEvent != [returnDescriptor descriptorType])
        {
			return [returnDescriptor booleanValue];
        }
    }
    else
    {
        // no script result, handle error here
    }
	return NO;
}

- (void)growl:(GrowlNotification)type {
	if (![self growlIsRunning]) return;
    // load the script from a resource by fetching its URL from within our bundle
    NSString* path = [[NSBundle mainBundle] pathForResource:@"maildropGrowl" ofType:@"scpt"];
    if (path != nil) {
        NSURL* url = [NSURL fileURLWithPath:path];
        NSDictionary* errors = [NSDictionary dictionary];
        NSAppleScript* appleScript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errors];
        if (appleScript != nil) {
        	// create the first parameter
            NSAppleEventDescriptor* firstParameter  = [NSAppleEventDescriptor descriptorWithBoolean:type == EmailAdded];
            NSAppleEventDescriptor* secondParameter = [NSAppleEventDescriptor descriptorWithString:[self subject]];

            // create and populate the list of parameters (in our case just two)
            NSAppleEventDescriptor* parameters = [NSAppleEventDescriptor listDescriptor];
            [parameters insertDescriptor:firstParameter atIndex:1];
            [parameters insertDescriptor:secondParameter atIndex:2];

            // create the AppleEvent target
            ProcessSerialNumber psn = {0, kCurrentProcess};
            NSAppleEventDescriptor* target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber bytes:&psn length:sizeof(ProcessSerialNumber)];

            // create an NSAppleEventDescriptor with the script's method name to call,
            // this is used for the script statement: "on show_message(user_message)"
            // Note that the routine name must be in lower case.
            NSAppleEventDescriptor* handler = [NSAppleEventDescriptor descriptorWithString:@"show_message"];

            // create the event for an AppleScript subroutine,
            // set the method name and the list of parameters
            NSAppleEventDescriptor* event =
	                        [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
	                                eventID:kASSubroutineEvent
	                                targetDescriptor:target
	                                returnID:kAutoGenerateReturnID
	                				transactionID:kAnyTransactionID];
	        [event setParamDescriptor:handler forKeyword:keyASSubroutineName];
	        [event setParamDescriptor:parameters forKeyword:keyDirectObject];

	        // call the event in AppleScript
	        [appleScript executeAppleEvent:event error:&errors];
            [appleScript release];
		} else {
	        // report any errors from 'errors'
			NSLog(@"errors: %@",errors);
        }
	}
}

- (NSArray *)attachments {
	return attachments;
}

- (void)setAttachments:(NSArray *)atts {
	[attachments removeAllObjects];
	[attachments addObjectsFromArray:atts];
}

- (void)insertInAttachments:(Attachment *)att {
	[attachments addObject:att];
}

- (void)insertObject:(Attachment *)att inAttachmentsAtIndex:(unsigned int)index {
	[attachments insertObject:att atIndex:index];
}
 
- (void)removeObjectFromAttachmentsAtIndex:(unsigned int)index {
	[attachments removeObjectAtIndex:index];
}

@end
