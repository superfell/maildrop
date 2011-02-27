// Copyright (c) 2006-2010 Simon Fell
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
#import "zkSforce.h"

@class LoginController;
@class CreateActivityController;
@class WelcomeController;
@class ButtonBarController;
@class Email;
@class Attachment;

@interface AppDelegate : NSObject {
	IBOutlet LoginController			*loginController;
	IBOutlet CreateActivityController	*createAcitivityController;
	IBOutlet WelcomeController			*welcomeController;
	IBOutlet ButtonBarController		*buttonBarController;
	IBOutlet NSWindow					*attachmentsWarningWindow;
	
	NSMutableArray		*emails;
	NSMutableArray		*attachments;
	ZKSforceClient		*sforce;
}

- (NSArray *)emails;
- (void)insertInEmails:(Email *)e;
- (void)insertObject:(Email *)e inEmailsAtIndex:(unsigned int)index;
- (void)removeObjectFromEmailsAtIndex:(unsigned int)index;

- (NSArray *)attachments;
- (void)insertInAttachments:(Attachment *)att;
- (void)insertObject:(Attachment *)att inAttachmentsAtIndex:(unsigned int)index;
- (void)removeObjectFromAttachmentsAtIndex:(unsigned int)index;

- (ZKSforceClient *)sforce;
- (ButtonBarController *)buttonBarController;

- (NSString *)createActivity:(Email *)email;
- (IBAction)showActivityHelp:(id)sender;
- (IBAction)showPreferencesHelp:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)showButtonBar:(id)sender;
- (IBAction)showButtonBarHelp:(id)sender;
- (IBAction)showHelp:(id)sender;
- (IBAction)showTaskRelatedListHelp:(id)sender;

- (void)shouldCheckForAttachmentsRelatedListOnTask;
@end
