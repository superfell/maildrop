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

#import "AppDelegate.h"
#import "Email.h"
#import "LoginController.h"
#import "CreateActivityController.h"
#import "Constants.h"
#import "ZKDescribeLayoutResult.h"
#import "ZKDescribeLayout.h"
#import "ZKRelatedList.h"

@implementation AppDelegate

+ (void)initialize {
	NSMutableDictionary * defaults = [NSMutableDictionary dictionary];
	NSString *prod = [NSString stringWithString:@"https://www.salesforce.com"];
	NSString *test = [NSString stringWithString:@"https://test.salesforce.com"];
	
	NSMutableArray * defaultServers = [NSMutableArray arrayWithObjects:prod, test, nil];
	[defaults setObject:defaultServers forKey:@"servers"];
	[defaults setObject:prod forKey:@"server"];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:@"SUCheckAtStartup"];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:SHOW_NEW_CASE_PREF];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:SHOW_NEW_EMAIL_PREF];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:ATTACHMENTS_ON_CASES_PREF];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:ATTACHMENTS_ON_EMAIL_PREF];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:ADD_EMAIL_TO_DESC_PREF];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:SHOW_TASK_RELATEDLIST_WARNING_PREF];
	[defaults setObject:@"Subject" forKey:@"additionalField_Case"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (id)init {
	self = [super init];
	emails = [[NSMutableArray alloc] init];
	attachments = [[NSMutableArray alloc] init];
	return self;
}

- (void)dealloc {
	[emails release];
	[attachments release];
	[sforce release];
	[super dealloc];
}

- (ButtonBarController *)buttonBarController {
	return buttonBarController;
}

- (NSArray *)emails {
	return emails;
}

- (void)insertInEmails:(Email *)e {
	[e setContainer:NSApp propertyName:@"emails"];
	[emails addObject:e];
}

- (void)insertObject:(Email *)e inEmailsAtIndex:(unsigned int)index {
	[e setContainer:NSApp propertyName:@"emails"];
	[emails insertObject:e atIndex:index];
}

- (void)removeObjectFromEmailsAtIndex:(unsigned int)index {
	// there's a retain count because any attachments in the email retained their container
	// which is the email, so this doesn't actually free the email.
	// To Work around it, we explicity release the attachments of the email here to break
	// the cycle.
	Email *e = [emails objectAtIndex:index];
	[emails removeObjectAtIndex:index];
	[e setAttachments:nil];
}

- (NSArray *)attachments {
	return attachments;
}

- (void)insertInAttachments:(Attachment *)att {
	[att setContainer:NSApp propertyName:@"attachments"];
	[attachments addObject:att];
}

- (void)insertObject:(Attachment *)att inAttachmentsAtIndex:(unsigned int)index {
	[att setContainer:NSApp propertyName:@"attachments"];
	[attachments insertObject:att atIndex:index];
}

- (void)removeObjectFromAttachmentsAtIndex:(unsigned int)index {
	[attachments removeObjectAtIndex:index];
}

- (BOOL)application:(NSApplication *)sender delegateHandlesKey:(NSString *)key { 
    if ([key isEqualToString: @"emails"]) return YES;
	if ([key isEqualToString:@"attachments"]) return YES; 
    return NO; 
}

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[self showButtonBar:self];
}

- (IBAction)logout:(id)sender {
	[loginController logout:sender];
	[sforce release];
	sforce = nil;
}

// if the user cancels the login dialog, this'll return nil
- (ZKSforceClient *)sforce {
	if (sforce == nil || ![sforce loggedIn]) {
		if (![[loginController sforce] loggedIn])
			[loginController showLoginDialog:self];
		[sforce release];
		sforce = [[loginController sforce] retain];
	}
	return sforce;
}

- (NSString *)createActivity:(Email *)email {
	ZKSforceClient *sf = [self sforce];
	if (sf == nil) return nil;
	return [createAcitivityController createActivity:email sforce:sf];
}

-(IBAction)showButtonBar:(id)sender {
	[buttonBarController showWindow:sender];
}

-(void)showHelpPage:(NSString *)page {
	NSURL *baseUrl = [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ZkHelpBaseUrl"]];
	if (page != nil)
		baseUrl = [NSURL URLWithString:page relativeToURL:baseUrl];
	[[NSWorkspace sharedWorkspace] openURL:baseUrl];
}

- (void)checkForAttachmentsRelatedList {
	ZKDescribeLayoutResult *layoutRes = [[self sforce] describeLayout:@"Task" recordTypeIds:nil];
	for (ZKDescribeLayout *layout in [layoutRes layouts]) {
		for (ZKRelatedList *rl in [layout relatedLists]) {
			if ([[rl sobject] caseInsensitiveCompare:@"attachment"] == NSOrderedSame) {
				return;// found a layout with the Attachments related list.
			}
		}
	}
	[NSApp activateIgnoringOtherApps:YES];
	[attachmentsWarningWindow makeKeyAndOrderFront:self];
}

- (void)shouldCheckForAttachmentsRelatedListOnTask {
	if (![[NSUserDefaults standardUserDefaults] boolForKey:SHOW_TASK_RELATEDLIST_WARNING_PREF]) return;
	[self performSelectorOnMainThread:@selector(checkForAttachmentsRelatedList) withObject:nil waitUntilDone:NO];
}

-(IBAction)showHelp:(id)sender {
	[self showHelpPage:nil];
}

-(IBAction)showLoginHelp:(id)sender {
	[self showHelpPage:@"pages/login.html"];
}

- (IBAction)showActivityHelp:(id)sender {
	[self showHelpPage:@"pages/activity.html"];
}

- (IBAction)showPreferencesHelp:(id)sender {
	[self showHelpPage:@"pages/preferences.html"];
}

-(IBAction)showButtonBarHelp:(id)sender {	
	[self showHelpPage:@"pages/buttonbar.html"];
}

-(IBAction)showTaskRelatedListHelp:(id)sender {
	[self showHelpPage:@"pages/attachments.html"];
}

@end
