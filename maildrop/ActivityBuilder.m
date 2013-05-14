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

#import "ActivityBuilder.h"
#import "zkSforce.h"
#import "Email.h"
#import "SObjectPermsWrapper.h"
#import "Constants.h"

@interface ActivityBuilder()
@property (assign) id<ActivityBuilderDelegate> delegate;
@end

@implementation ActivityBuilder

@synthesize email, who, what, status, sforce, window, delegate;

-(void)dealloc {
    [email release];
    [who release];
    [what release];
    [status release];
    [sforce release];
    [window release];
    [super dealloc];
}

-(void)build:(id<ActivityBuilderDelegate>)d {
}

- (NSString *)buildDescription {
	if (![[NSUserDefaults standardUserDefaults] boolForKey:ADD_EMAIL_TO_DESC_PREF])
		return [self.email body];
	// otherwise add to/from to the description
	return [NSString stringWithFormat:@"From: %@\r\nTo: %@\r\n\r\n%@", [self.email fromAddr], [self.email toAddr], [self.email body]];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	if (returnCode == NSAlertAlternateReturn) {
		// clicked create, so unset the what, and call create again
        self.what = nil;
        [self build:delegate];
	} else {
        [self.delegate activityBuilderCanceled:self];
    }
}

-(SObjectPermsWrapper *)buildWithType:(NSString *)sobjectType {
	SObjectPermsWrapper *activity = [SObjectPermsWrapper withDescribe:[sforce describeSObject:sobjectType] forUpdate:NO];
	[activity setFieldValue:[NSString stringWithFormat:@"Email: %@", [email subject]] field:@"Subject"];
	[activity setFieldValue:[self buildDescription] field:@"Description"];
    
	[activity setFieldValue:status field:@"Status"];
	[activity setFieldValue:@"Email" field:@"Type"];
	[activity setFieldValue:[who id] field:@"WhoId"];
	if ([[who type] isEqualToString:LEAD] && (what != nil)) {
		NSAlert * a = [NSAlert alertWithMessageText:@"Can not create Email"
                                      defaultButton:@"Cancel Creation"
                                    alternateButton:@"Create without setting \"Related to What\""
                                        otherButton:nil
                          informativeTextWithFormat:@"You can not create an email with a \"Related to What\" value when its \"Related to Who\" is a Lead"];
		[a beginSheetModalForWindow:window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
		return nil;
	}
	[activity setFieldValue:[what id] field:@"WhatId"];
	// check description length
	NSString *desc = [[activity sobject] fieldValue:@"Description"];
	int descMax = [[[activity describe] fieldWithName:@"Description"] length];
	if ([desc length] > descMax) {
		NSAlert *a = [NSAlert alertWithMessageText:@"Email is too long" defaultButton:@"Truncate" alternateButton:@"Cancel" otherButton:nil
                         informativeTextWithFormat:@"Email body is %d characters long, which is longer than max allowed of %d by Salesforce.com, do you want to truncate the email body, or cancel creating it?", [desc length], descMax];
		if (NSAlertDefaultReturn == [a runModal]) {
			[activity setFieldValue:[desc substringToIndex:descMax] field:@"Description"];
        } else {
			[self.delegate activityBuilderCanceled:self];
            return nil;
        }
	}
    
    return activity;
}

-(NSCalendarDate *)emailDate {
    NSDate *date = [email date];
    if (date != nil) {
        NSCalendarDate *d = [date dateWithCalendarFormat:nil timeZone:nil];
        return d;
    }
    return nil;
}

@end

@implementation TaskActivityBuilder

-(void)build:(id<ActivityBuilderDelegate>)d {
    self.delegate = d;
    SObjectPermsWrapper *task = [super buildWithType:@"Task"];
    if (task != nil) {
        [task setFieldDateValue:[self emailDate] field:@"ActivityDate"];
        [self.delegate activityBuilder:self builtActivity:[task sobject]];
    }
}

@end

@implementation EventActivityBuilder

-(void)build:(id<ActivityBuilderDelegate>)d {
    self.delegate = d;
    SObjectPermsWrapper *event = [super buildWithType:@"Event"];
    if (event != nil) {
        [event setFieldValue:@"false" field:@"IsAllDayEvent"];
        [event setFieldDateTimeValue:[self emailDate] field:@"ActivityDateTime"];
        [event setFieldValue:@"1" field:@"DurationInMinutes"];
        [self.delegate activityBuilder:self builtActivity:[event sobject]];
    }
}

@end
