// Copyright (c) 2011,2013 Simon Fell
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

#import "LionInfoWindowController.h"
#import "Constants.h"

@implementation LionInfoWindowController

@synthesize infoText, buttonLabel;

-(void)dealloc {
	[infoText release];
	[buttonLabel release];
	[super dealloc];
}

-(void)showIfNeeded {
	NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
	BOOL shownPreviously = [ud boolForKey:HAVE_SHOWN_10_72_INFO_WINDOW];
	BOOL showPref = [ud boolForKey:SHOW_LION_MAIL_INFO_PREF];
	BOOL hasAttachments = [ud boolForKey:ATTACHMENTS_ON_EMAIL_PREF] || [ud boolForKey:ATTACHMENTS_ON_CASES_PREF];
	
	if ((shownPreviously) && (!showPref))
		return;
	
	SInt32 minorVer, bugFixVer;
	if ((Gestalt(gestaltSystemVersionMinor, &minorVer) == noErr) &&
		(Gestalt(gestaltSystemVersionBugFix, &bugFixVer) == noErr)) {
		if (minorVer != 0x07) return;
		[ud setBool:TRUE forKey:HAVE_SHOWN_10_72_INFO_WINDOW];
        [NSBundle loadNibNamed:@"LionInfo" owner:self];
        
		// if bugFix < 2 and attachments are on, then show message about upgrading, and button should disable attachments
		if ((bugFixVer < 2) && (hasAttachments)) {
			NSString *lbl = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",
				NSLocalizedString(@"MDUpdateTo1072_Line1", @"Mail attachments broken in 10.7 before 10.7.2"),
				NSLocalizedString(@"MDUpdateTo1072_Line2", @"you should really updrade"),
				NSLocalizedString(@"MDUpdateTo1072_Line3", @"but you can disable attachments for now")];
			self.infoText = lbl;
			self.buttonLabel = NSLocalizedString(@"MDDisableAttachmentsButton", "turn it off");
			buttonShouldEnableAttachments = NO;
			[lionInfoWindow center];
			[lionInfoWindow makeKeyAndOrderFront:self];
		} else if ((bugFixVer >= 2) && (!hasAttachments)) {
			// otherwise if on 10.7.2 or later, and attachments aren't on, inform the user that they can turn them back on.
			self.infoText = NSLocalizedString(@"MDEnableAttachments_Line1", @"you can turn them back on now!");
			self.buttonLabel = NSLocalizedString(@"MDEnableAttachmentsButton", @"turn them on!");
			buttonShouldEnableAttachments = YES;
			[lionInfoWindow center];
			[lionInfoWindow makeKeyAndOrderFront:self];
		}
	}

}

-(void)enableAttachments:(BOOL)enable {
	NSNumber *state = [NSNumber numberWithBool:enable];
	[[NSUserDefaults standardUserDefaults] setObject:state forKey:ATTACHMENTS_ON_EMAIL_PREF];
	[[NSUserDefaults standardUserDefaults] setObject:state forKey:ATTACHMENTS_ON_CASES_PREF];
}

-(IBAction)updateAttachmentSettings:(id)sender {
	[self enableAttachments:buttonShouldEnableAttachments];
	[lionInfoWindow orderOut:self];
}

@end
