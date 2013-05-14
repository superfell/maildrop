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

#import <Cocoa/Cocoa.h>
#import "WhatSearchDataSource.h"
#import "ActivityBuilder.h"

@class ZKSforceClient;
@class Email;
@class ZKSObject;
@class SObjectWhoWhat;
@class PendingTaskWhoWhat;

@interface CreateActivityController : NSObject<ActivityBuilderDelegate> {
	IBOutlet NSArrayController	*whoSearchController;
	IBOutlet NSTableView		*whatSearchResults;
	IBOutlet NSWindow			*window;
	IBOutlet NSWindow			*createContactWindow;
	IBOutlet NSWindow			*createLeadWindow;
	IBOutlet NSWindow			*whatSearchConfigWindow;
	
	NSTextField					*whatNoResults;
	
	ZKSforceClient			*sforce;
	NSArray					*whatObjectTypes;
	NSString				*closedTaskStatus;
	NSArray					*taskStatus;
	NSArray					*leadStatus;
	NSString				*defaultLeadStatus;
	NSArray					*whoSearchResults;
	WhatSearchDataSource	*whatResultsTableSource;

	SObjectWhoWhat			*selectedWho;
	SObjectWhoWhat			*selectedWhat;
	PendingTaskWhoWhat		*pendingTaskWhoWhat;
    ActivityBuilder         *activityBuilder;
	
	NSString 				*whoSearchText;
	NSString				*whatSearchText;
	Email					*email;
	NSString				*taskId;
	
	NSString				*contactFirstName;
	NSString				*contactLastName;
	NSString				*contactEmail;
	NSString				*contactCompany;
	NSString				*contactLeadStatus;
	BOOL					createContactAllowed;
	BOOL					createLeadAllowed;
	BOOL					storeTaskStatusDefault;
}

- (NSString *)createActivity:(Email *)email sforce:(ZKSforceClient *)sforce;
- (NSArray *)whatObjectTypes;
- (NSArray *)whoSearchResults;
- (NSArray *)leadStatus;
- (NSArray *)taskStatus;
- (NSString *)defaultLeadStatus;

@property (readonly) BOOL hasStatusField;
@property (retain) NSString *whatSearchText;
@property (retain) NSString *whoSearchText;
@property (retain) NSString *contactFirstName;
@property (retain) NSString *contactLastName;
@property (retain) NSString *contactEmail;
@property (retain) NSString *contactCompany;
@property (retain) NSString *contactLeadStatus;
@property (retain) NSString *emailSubject;
@property (retain) NSString *closedTaskStatus;
@property (assign) BOOL storeTaskStatusDefault;
@property (retain) Email *email;

- (NSArray *)whatObjectTypeDescribes;
- (NSArray *)selectedWhoWhats;

@property (assign) BOOL createContactAllowed;
@property (assign) BOOL createLeadAllowed;

- (BOOL)canSearchWho;
- (NSString *)whoSearchToolTip;

- (IBAction)cancel:(id)sender;
- (IBAction)create:(id)sender;
- (IBAction)searchWho:(id)sender;
- (IBAction)searchWhat:(id)sender;
- (IBAction)showCreateContact:(id)sender;
- (IBAction)cancelCreateContact:(id)sender;
- (IBAction)createContact:(id)sender;
- (IBAction)showCreateLead:(id)sender;
- (IBAction)cancelCreateLead:(id)sender;
- (IBAction)createLead:(id)sender;

- (IBAction)configureWhatSearchColumns:(id)sender;
- (IBAction)closeWhatConfig:(id)sender;

@end
