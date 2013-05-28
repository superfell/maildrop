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

@interface FkSearchController : NSObject {
    NSString        *searchText;
    ZKSforceClient  *sforce;
}

@property (retain) NSString *searchText;
@property (retain) ZKSforceClient *sforce;
@property (readonly) ZKSObject *selected;

-(IBAction)search:(id)sender;
@end

@interface WhoController : FkSearchController {
    IBOutlet NSArrayController	*whoSearchController;
    NSArray                     *searchResults;
}

@property (readonly) BOOL createContactAllowed;
@property (readonly) BOOL createLeadAllowed;
@property (readonly) BOOL canSearch;
@property (readonly) NSString *searchToolTip;
@property (readonly) NSArrayController *whoSearchController; // temp
@property (retain)   NSArray *searchResults;

@end

@interface WhatController : FkSearchController {
}
@end

@interface CreateActivityController : NSObject<ActivityBuilderDelegate> {
    IBOutlet WhoController      *whoController;
    IBOutlet WhatController     *whatController;
    
	IBOutlet NSTableView		*whatSearchResults;
	IBOutlet NSWindow			*window;
	IBOutlet NSWindow			*whatSearchConfigWindow;
	
    IBOutlet NSView             *topContainer;
    IBOutlet NSView             *subjectLabel;
    IBOutlet NSView             *subjectText;
    IBOutlet NSView             *statusLabel;
    IBOutlet NSView             *statusPopup;
    IBOutlet NSView             *statusDefaultCheckbox;
    NSArray                     *subjectOnlyConstraints, *subjectAndStatusConstraints;
    
	NSTextField					*whatNoResults;
	
	ZKSforceClient			*sforce;
	NSArray					*whatObjectTypes;
	NSString				*closedTaskStatus;
	NSArray					*taskStatus;
	WhatSearchDataSource	*whatResultsTableSource;

	SObjectWhoWhat			*selectedWho;
	SObjectWhoWhat			*selectedWhat;
	PendingTaskWhoWhat		*pendingTaskWhoWhat;
    ActivityBuilder         *activityBuilder;
	
	Email					*email;
	NSString				*taskId;
	
	BOOL					storeTaskStatusDefault;
}

- (NSString *)createActivity:(Email *)email sforce:(ZKSforceClient *)sforce;
- (NSArray *)whatObjectTypes;
- (NSArray *)taskStatus;

@property (readonly) BOOL hasStatusField;
@property (retain) NSString *emailSubject;
@property (retain) NSString *closedTaskStatus;
@property (assign) BOOL storeTaskStatusDefault;
@property (retain) Email *email;

- (NSArray *)whatObjectTypeDescribes;
- (NSArray *)selectedWhoWhats;

- (IBAction)cancel:(id)sender;
- (IBAction)create:(id)sender;

- (IBAction)showCreateContact:(id)sender;
- (IBAction)showCreateLead:(id)sender;

- (IBAction)searchWhat:(id)sender;

- (IBAction)configureWhatSearchColumns:(id)sender;
- (IBAction)closeWhatConfig:(id)sender;
- (IBAction)showActivityHelp:(id)sender;

@end
