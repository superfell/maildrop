// Copyright (c) 2008-2011 Simon Fell
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
#import "ClientApp.h"
#import "Email.h"


static const CGFloat WINDOW_HEIGHT_PROGRESS = 35.0f;

@interface ButtonBarController ()
-(void)setIsFrontMostApp:(BOOL)fm;
-(void)hideProgressWithAnimation:(BOOL)animate;
@end

@implementation ButtonBarController

-(void)awakeFromNib {
    clientApps = [[ClientApp allClients] retain];
	isShowingProgress = YES;
	[self setSelectedClient:[clientApps objectAtIndex:0]];
}

-(void)setFrontAppTimer:(NSTimer *)t {
	if (frontAppTimer == t) return;
	[frontAppTimer invalidate];
	[frontAppTimer autorelease];
	frontAppTimer = [t retain];
}

-(void)dealloc {
	[self setFrontAppTimer:nil];
	[clientApps release];
	[selectedClient release];
	[super dealloc];
}

-(void)showProgressOf:(int)value max:(int)maxValue withText:(NSString *)progressLabel {
	NSRect f = [window frame];
	if (!isShowingProgress) {
		f.origin.y -= WINDOW_HEIGHT_PROGRESS;
		f.size.height += WINDOW_HEIGHT_PROGRESS;
		[window setFrame:f display:YES animate:YES];
		[self setIsFrontMostApp:YES];
		isShowingProgress = YES;
	}
	[progress setUsesThreadedAnimation:YES];
	[progress startAnimation:self];
	[progress setMaxValue:maxValue];
	[progress setDoubleValue:value];
	[progressText setStringValue:progressLabel];
	[progress display];
	[progressText display];
}

-(void)hideProgress {
	[self hideProgressWithAnimation:YES];
}

-(void)hideProgressWithAnimation:(BOOL)animate {
	NSRect f = [window frame];
	if (isShowingProgress) {
		f.size.height -= WINDOW_HEIGHT_PROGRESS;
		f.origin.y += WINDOW_HEIGHT_PROGRESS;
		[window setFrame:f display:YES animate:animate];
		isShowingProgress = NO;
	}
	[progress stopAnimation:self];
}

-(ClientApp *)selectedClient {
	return selectedClient;
}

-(void)setSelectedClient:(ClientApp *)app {
	[selectedClient autorelease];
	selectedClient = [app retain];
	[toggleButton setImage:[app iconImage]];
}

-(IBAction)toggleClient:(id)sender {
	int curIdx = [clientApps indexOfObject:selectedClient];
	int newIdx = (curIdx + 1) % [clientApps count];
	[self setSelectedClient:[clientApps objectAtIndex:newIdx]];
}

// default the mail/entourage selection based on the currently running processes.
-(void)checkProcesses {
	ProcessSerialNumber psn = { kNoProcess, kNoProcess };
	while (noErr == GetNextProcess(&psn)) {
		NSDictionary *d = (NSDictionary *)ProcessInformationCopyDictionary(&psn, kProcessDictionaryIncludeAllInformationMask);
		NSString *bid = [d objectForKey:(NSString*)kCFBundleIdentifierKey];
		[d autorelease];
		for (ClientApp *c in clientApps) {
			if ([bid isEqualToString:[c bundleId]]) {
				[self setSelectedClient:c];
				break;
			}
		}
	}
}

-(void)setIsFrontMostApp:(BOOL)fm {
	if (isFrontMostApp == fm) return;
	isFrontMostApp = fm;
	if ([[NSUserDefaults standardUserDefaults] boolForKey:AUTO_SHOW_HIDE_BUTTONBAR]) {
		if (fm) {
			[window setLevel:NSFloatingWindowLevel];
		} else {
			[window setLevel:NSNormalWindowLevel];
			[window orderBack:self];
		}
	} else {
			[window setLevel:NSNormalWindowLevel];
	}
}

-(void)checkFrontMostApp:(id)sender {
	ProcessSerialNumber psn;
	if (noErr == GetFrontProcess(&psn)) {
		NSDictionary *d = (NSDictionary *)ProcessInformationCopyDictionary(&psn, kProcessDictionaryIncludeAllInformationMask);
		NSString *bid = [d objectForKey:(NSString *)kCFBundleIdentifierKey];
		BOOL fm = NO;
		for (ClientApp *c in clientApps) {
			 if ([bid isEqualToString:[c bundleId]]) {
				[self setSelectedClient:c];
				fm = YES;
			}
		}
		if ([bid isEqualToString:@"com.pocketsoap.maildrop"]) {
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
	[self hideProgressWithAnimation:NO];
	[self checkProcesses];
	isFrontMostApp = YES;
	NSInteger lvl = [[NSUserDefaults standardUserDefaults] boolForKey:AUTO_SHOW_HIDE_BUTTONBAR] ? NSFloatingWindowLevel : NSNormalWindowLevel;
	[window setLevel:lvl];
	[window makeKeyAndOrderFront:self];
	[self setFrontAppTimer:[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkFrontMostApp:) userInfo:nil repeats:YES]];
}

-(void)reportScriptError:(NSString *)operation source:(NSString *)source error:(NSDictionary *)err {
	NSLog(@"error %@ script %@ : %@", operation, source, err);
	int errNum = [[err objectForKey:NSAppleScriptErrorNumber] intValue];
	if (errNum == -128) {
		NSString *brief = [err objectForKey:NSAppleScriptErrorBriefMessage];
		if (brief != nil && [brief rangeOfString:@"cancel"].location != NSNotFound) {
			// script canceled by user, no need to show them the error.
			return;
		}
	}
	NSAlert *a = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"Error %@ apple script", operation] 
	defaultButton:@"Close" alternateButton:nil otherButton:nil informativeTextWithFormat:[NSString stringWithFormat:@"script %@\r\nerror %@", source, err]];
	[a runModal];
}

-(NSArray *)selectedEmailsOrAlert:(NSString *)attachmentPrefName {
    NSUInteger count = [[selectedClient factory] countOfSelectedEmails];
    if (count != 1) {
        NSString *msg = count == 0 ? @"You have not selected an email in your email client" : @"You have %d emails selected";
        NSAlert * a = [NSAlert alertWithMessageText:@"Please select an email" defaultButton:@"Close" alternateButton:nil otherButton:nil informativeTextWithFormat:msg, count];
        [a runModal];
        return nil;
    }
    BOOL loadAttachments = [[NSUserDefaults standardUserDefaults] boolForKey:attachmentPrefName];
    NSArray *emails = [[selectedClient factory] selectedEmailsWithAttachments:loadAttachments];
    return emails;
}

-(IBAction)addEmail:(id)sender {
    NSArray *emails = [self selectedEmailsOrAlert:ATTACHMENTS_ON_EMAIL_PREF];
    if (emails == nil) return;
    [[emails objectAtIndex:0] createActivity:nil];
}

-(IBAction)createCase:(id)sender {
    NSArray *emails = [self selectedEmailsOrAlert:ATTACHMENTS_ON_CASES_PREF];
    if (emails == nil) return;
    [[emails objectAtIndex:0] createCase:nil];
}

@end
