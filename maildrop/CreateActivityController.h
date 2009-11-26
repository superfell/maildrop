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

#import <Cocoa/Cocoa.h>
#import "WhatSearchDataSource.h"

@class ZKSforceClient;
@class Email;
@class ZKSObject;
@class WhoWhat;

@interface CreateActivityController : NSObject
{
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
	NSArray					*leadStatus;
	NSString				*defaultLeadStatus;
	NSArray					*whoSearchResults;
	WhatSearchDataSource	*whatResultsTableSource;

	WhoWhat					*selectedWho;
	WhoWhat					*selectedWhat;
	
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
}

- (NSString *)createActivity:(Email *)email sforce:(ZKSforceClient *)sforce;
- (NSArray *)whatObjectTypes;
- (NSArray *)whoSearchResults;
- (NSArray *)leadStatus;
- (NSString *)defaultLeadStatus;
- (NSString *)closedTaskStatus;
- (NSString *)whoSearchText;
- (void)setWhoSearchText:(NSString *)aWhoSearchText;
- (NSString *)whatSearchText;
- (void)setWhatSearchText:(NSString *)aWhatSearchText;
- (NSString *)contactFirstName;
- (void)setContactFirstName:(NSString *)aContactFirstName;
- (NSString *)contactLastName;
- (void)setContactLastName:(NSString *)aContactLastName;
- (NSString *)contactEmail;
- (void)setContactEmail:(NSString *)aContactEmail;
- (NSString *)contactCompany;
- (void)setContactCompany:(NSString *)aContactCompany;
- (NSString *)contactLeadStatus;
- (void)setContactLeadStatus:(NSString *)aContactLeadStatus;
- (NSString *)emailSubject;
- (void)setEmailSubject:(NSString *)aEmailSubject;
- (Email *)email;
- (void)setEmail:(Email *)aValue;
- (NSArray *)whatObjectTypeDescribes;
- (NSArray *)selectedWhoWhats;

- (BOOL)createContactAllowed;
- (void)setCreateContactAllowed:(BOOL)newCreateContactAllowed;
- (BOOL)createLeadAllowed;
- (void)setCreateLeadAllowed:(BOOL)newCreateLeadAllowed;

- (BOOL)canSearchWho;

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
