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

#import "LoginController.h"
#import "ZKSforceClient.h"
#import "../common/ZKLoginController.h"

@implementation LoginController

- (void)dealloc {
	[sforce release];
	[super dealloc];
}

- (NSString *)clientId {
	static NSString *cid;
	if (cid != nil) return cid;
	NSDictionary *plist = [[NSBundle mainBundle] infoDictionary];
	cid = [[NSMutableString stringWithFormat:@"MacMaildrop/%@", [plist objectForKey:@"CFBundleVersion"]] retain];
	return cid;
}

- (void)setSforce:(ZKSforceClient *)sf {
	if (sforce == sf) return;
	[sforce release];
	sforce = [sf retain];
	[sforce setUpdateMru:YES];
	[sforce setCacheDescribes:YES];
}

- (IBAction)showLoginDialog:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
	ZKLoginController *login = [[ZKLoginController alloc] init];
	[login setClientId:[self clientId]];
	ZKSforceClient *sf = [login showModalLoginWindow:sender];
	[self setSforce:sf];
	[login release];
}

- (BOOL)loggedIn {
	return [sforce loggedIn];
}

- (IBAction)openSalesforceInBrowser:(id)sender {
	ZKDescribeSObject *d = [sforce describeSObject:@"Task"];
	NSURL *url = [NSURL URLWithString:[d urlNew]];
	NSURL *baseUiUrl = [NSURL URLWithString:@"/" relativeToURL:url];		
	NSURL *fd = [NSURL URLWithString:[NSString stringWithFormat:@"/secur/frontdoor.jsp?sid=%@", [sforce sessionId]] relativeToURL:baseUiUrl];
	[[NSWorkspace sharedWorkspace] openURL:fd];
}

- (ZKSforceClient *)sforce {
	return sforce;
}

- (void)logout:(id)sender {
	[sforce release];
	sforce = nil;
}

@end
