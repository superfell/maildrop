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

NSString *mailBundleId = @"com.apple.mail";
NSString *enotourageBundleId = @"com.microsoft.Entourage";
NSString *outlookBundleId = @"com.microsoft.Outlook";

static const float WINDOW_HEIGHT_NORMAL = 105.0f;
static const float WINDOW_HEIGHT_PROGRESS = 140.0f;

@interface ButtonBarController ()
-(void)setIsFrontMostApp:(BOOL)fm;
@end

@interface ClientApp : NSObject {
	NSImage	 *image;
	NSString *bundleId;
	NSString *folderName;
}

+(id)withBundleId:(NSString *)bid imageName:(NSString *)image folderName:(NSString *)fn;
-(NSImage *)iconImage;
-(NSString *)bundleId;
-(NSString *)folderName;
@end

@implementation ClientApp 
-(id)initWithBundleId:(NSString *)bid imageName:(NSString *)imageName folderName:(NSString *)fn {
	self = [super init];
	bundleId = [bid retain];
	image = [[NSImage imageNamed:imageName] retain];
	folderName = [fn retain];
	return self;
}
-(void)dealloc {
	[bundleId release];
	[image release];
	[folderName release];
	[super dealloc];
}
+(id)withBundleId:(NSString *)bid imageName:(NSString *)image folderName:(NSString *)fn {
	return [[[ClientApp alloc] initWithBundleId:bid imageName:image folderName:fn] autorelease];
}
-(NSString *)bundleId {
	return bundleId;
}
-(NSImage *)iconImage {
	return image;
}
-(NSString *)folderName {
	return folderName;
}
@end

@implementation ButtonBarController

-(void)awakeFromNib {
	ClientApp *mail = [ClientApp withBundleId:mailBundleId		 imageName:@"mail_icon"		folderName:MAIL_SCRIPTS_FOLDER];
	ClientApp *ent  = [ClientApp withBundleId:enotourageBundleId imageName:@"entourage"		folderName:ENTOURAGE_SCRIPTS_FOLDER];
	ClientApp *olk  = [ClientApp withBundleId:outlookBundleId	 imageName:@"outlook_icon"	folderName:OUTLOOK_SCRIPTS_FOLDER];
	clientApps = [[NSArray arrayWithObjects:mail, ent, olk, nil] retain];
	[self setSelectedClient:mail];
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
	if (f.size.height != WINDOW_HEIGHT_PROGRESS) { 
		f.origin.y -= WINDOW_HEIGHT_PROGRESS - WINDOW_HEIGHT_NORMAL;
		f.size.height = WINDOW_HEIGHT_PROGRESS;
		[window setFrame:f display:YES animate:YES];
		[self setIsFrontMostApp:YES];
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
	NSRect f = [window frame];
	if (f.size.height != WINDOW_HEIGHT_NORMAL) {
		f.size.height = WINDOW_HEIGHT_NORMAL;
		f.origin.y += (WINDOW_HEIGHT_PROGRESS - WINDOW_HEIGHT_NORMAL);
		[window setFrame:f display:YES animate:YES];
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
	[self hideProgress];
	[self checkProcesses];
	isFrontMostApp = YES;
	[window setLevel:NSFloatingWindowLevel];
	[window makeKeyAndOrderFront:self];
	[self setFrontAppTimer:[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkFrontMostApp:) userInfo:nil repeats:YES]];
}

-(void)reportScriptError:(NSString *)operation source:(NSString *)source error:(NSDictionary *)err {
	NSLog(@"error %@ script %@ : %@", operation, source, err);
	NSAlert *a = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"Error %@ apple script", operation] 
	defaultButton:@"Close" alternateButton:nil otherButton:nil informativeTextWithFormat:[NSString stringWithFormat:@"script %@\r\nerror %@", source, err]];
	[a runModal];
}

-(void)executeAppleScript:(NSString *)resourceName {
	NSString *scriptFile = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"scpt" inDirectory:[selectedClient folderName]];
	NSLog(@"scriptFile is %@", scriptFile);

	NSDictionary *err = nil;
	NSAppleScript *script = [[[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:scriptFile] error:&err] autorelease];
	// force recompile to fix stupid 10.4 problems
	NSAppleScript *s2 = [[[NSAppleScript alloc] initWithSource:[script source]] autorelease];
	if (![s2 compileAndReturnError:&err]) {
		[self reportScriptError:@"recompiling" source:scriptFile error:err];
	} else {
		script = s2;
	}
	if ([script executeAndReturnError:&err] == nil) {
		[self reportScriptError:@"executing" source:scriptFile error:err];
	}
}

-(IBAction)addEmail:(id)sender {
	[self executeAppleScript:ADD_EMAIL_SCRIPT_NAME];
}

-(IBAction)createCase:(id)sender {
	[self executeAppleScript:ADD_CASE_SCRIPT_NAME];
}

@end
