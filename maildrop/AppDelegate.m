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

#import "AppDelegate.h"
#import "Email.h"
#import "LoginController.h"
#import "CreateActivityController.h"

@implementation AppDelegate

+ (void)initialize {
	NSMutableDictionary * defaults = [NSMutableDictionary dictionary];
	NSString *prod = [NSString stringWithString:@"https://www.salesforce.com"];
	NSString *test = [NSString stringWithString:@"https://test.salesforce.com"];
	
	NSMutableArray * defaultServers = [NSMutableArray arrayWithObjects:prod, test, nil];
	[defaults setObject:defaultServers forKey:@"servers"];
	[defaults setObject:prod forKey:@"server"];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:@"SUCheckAtStartup"];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:@"showNewCase"];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:@"showNewEmail"];
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
	[emails removeObjectAtIndex:index];
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
	return [createAcitivityController createActivity:email sforce:[self sforce]];
}

-(IBAction)showButtonBar:(id)sender {
	[buttonBarController showWindow:sender];
}

-(IBAction)showLoginHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"Login" inBook:@"Maildrop Help"];
}

- (IBAction)showActivityHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"Activity" inBook:@"Maildrop Help"];
}

- (IBAction)showPreferencesHelp:(id)sender {
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"Preferences" inBook:@"Maildrop Help"];
}

@end
