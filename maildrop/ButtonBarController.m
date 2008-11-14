// Copyright (c) 2008 Simon Fell
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

#import "ButtonBarController.h"
#import "zkSforce.h"
#import "Constants.h"

NSString *mailBundleId = @"com.apple.mail";
NSString *enotourageBundleId = @"com.microsoft.Entourage";

@implementation ButtonBarController

-(void)setFrontAppTimer:(NSTimer *)t {
	if (frontAppTimer == t) return;
	[frontAppTimer invalidate];
	[frontAppTimer autorelease];
	frontAppTimer = [t retain];
}

-(void)dealloc {
	[self setFrontAppTimer:nil];
	[super dealloc];
}

-(void)setUseEntourage:(BOOL)newState {
	if (usingEntourage == newState) return;
	usingEntourage = newState;
	[toggleButton setImage:[NSImage imageNamed:usingEntourage ? @"entourage" : @"mail_icon"]];
}

-(IBAction)toggleClient:(id)sender {
	[self setUseEntourage:!usingEntourage];
}

-(IBAction)showHelp:(id)sender {	
	[[NSHelpManager sharedHelpManager] openHelpAnchor:@"ButtonBar" inBook:@"Maildrop Help"];
}

// default the mail/entourage selection based on the currently running processes.
-(void)checkProcesses {
	ProcessSerialNumber psn = { kNoProcess, kNoProcess };
	while (noErr == GetNextProcess(&psn)) {
		NSDictionary *d = (NSDictionary *)ProcessInformationCopyDictionary(&psn, kProcessDictionaryIncludeAllInformationMask);
		NSString *bid = [d objectForKey:(NSString*)kCFBundleIdentifierKey];
		[d release];
		if ([bid isEqualToString:mailBundleId]) {
			[self setUseEntourage:NO];
			return;
		}
		if ([bid isEqualToString:enotourageBundleId]) {
			[self setUseEntourage:YES];
			return;
		}
	}
}

-(void)setIsFrontMostApp:(BOOL)fm {
	if (isFrontMostApp == fm) return;
	isFrontMostApp = fm;
	if (fm) {
		[window setLevel:NSFloatingWindowLevel];
	} else {
		[window setLevel:NSNormalWindowLevel];
		[window orderBack:self];
	}
}

-(void)checkFrontMostApp:(id)sender {
	ProcessSerialNumber psn;
	if (noErr == GetFrontProcess(&psn)) {
		NSDictionary *d = (NSDictionary *)ProcessInformationCopyDictionary(&psn, kProcessDictionaryIncludeAllInformationMask);
		NSString *bid = [d objectForKey:(NSString *)kCFBundleIdentifierKey];
		BOOL fm = NO;
		if ([bid isEqualToString:mailBundleId]) {
			[self setUseEntourage:NO];
			fm = YES;
		} else if ([bid isEqualToString:enotourageBundleId]) {
			[self setUseEntourage:YES];
			fm = YES;
		} else if ([bid isEqualToString:@"com.pocketsoap.maildrop"]) {
			fm = YES;
		}
		[self setIsFrontMostApp:fm];
		[d release];
	}
}

-(void)windowWillClose:(NSNotification *)notification {
	[self setFrontAppTimer:nil];
}

-(void)closeWindow:(id)sender {
	[window orderOut:sender];
}

-(void)showWindow:(id)sender {
	[self setUseEntourage:NO];
	[self checkProcesses];
	isFrontMostApp = YES;
	[window setLevel:NSFloatingWindowLevel];
	[window makeKeyAndOrderFront:self];
	[self setFrontAppTimer:[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkFrontMostApp:) userInfo:nil repeats:YES]];
}

-(void)executeAppleScript:(NSString *)resourceName {
	NSString *folder = usingEntourage ? ENTOURAGE_SCRIPTS_FOLDER : MAIL_SCRIPTS_FOLDER;
	NSString *scriptFile = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"scpt" inDirectory:folder];
	NSDictionary *err = nil;
	NSAppleScript *script = [[[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:scriptFile] error:&err] autorelease];
	[script executeAndReturnError:&err];
	
}

-(IBAction)addEmail:(id)sender {
	[self executeAppleScript:ADD_EMAIL_SCRIPT_NAME];
}

-(IBAction)createCase:(id)sender {
	[self executeAppleScript:ADD_CASE_SCRIPT_NAME];
}

@end
