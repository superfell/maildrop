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

#import <Cocoa/Cocoa.h>
#import "ActivityBuilder.h"

@class ZKSforceClient;
@class Email;
@class ZKSObject;
@class SObjectWhoWhat;
@class PendingTaskWhoWhat;
@class WhoController;
@class WhatController;

@interface CreateActivityController : NSObject<ActivityBuilderDelegate> {
    IBOutlet WhoController      *whoController;
    IBOutlet WhatController     *whatController;

    IBOutlet NSWindow           *whatSearchConfigWindow;
	IBOutlet NSWindow			*window;
    IBOutlet NSView             *topContainer;
    IBOutlet NSView             *subjectLabel;
    IBOutlet NSView             *subjectText;
    IBOutlet NSView             *statusLabel;
    IBOutlet NSView             *statusPopup;
    IBOutlet NSView             *statusDefaultCheckbox;
    NSArray                     *subjectOnlyConstraints, *subjectAndStatusConstraints;
    
	ZKSforceClient			*sforce;
	NSString				*closedTaskStatus;
	NSArray					*taskStatus;

	SObjectWhoWhat			*selectedWho;
	SObjectWhoWhat			*selectedWhat;
	PendingTaskWhoWhat		*pendingTaskWhoWhat;
    ActivityBuilder         *activityBuilder;
	
	Email					*email;
	NSString				*taskId;
	
	BOOL					storeTaskStatusDefault;
}

- (NSString *)createActivity:(Email *)email sforce:(ZKSforceClient *)sforce;
- (NSArray *)taskStatus;

@property (readonly) BOOL hasStatusField;
@property (retain) NSString *emailSubject;
@property (retain) NSString *closedTaskStatus;
@property (assign) BOOL storeTaskStatusDefault;
@property (retain) Email *email;

- (NSArray *)selectedWhoWhats;

- (IBAction)cancel:(id)sender;
- (IBAction)create:(id)sender;

- (IBAction)showCreateContact:(id)sender;
- (IBAction)showCreateLead:(id)sender;

- (IBAction)showActivityHelp:(id)sender;

- (IBAction)configureWhatSearchColumns:(id)sender;
- (IBAction)closeWhatConfig:(id)sender;

@end
