// Copyright (c) 2006-2008,2013 Simon Fell
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

#import "WelcomeController.h"
#import "Constants.h"

@implementation WelcomeController

- (void)awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkShowWelcome:) name:NSApplicationDidFinishLaunchingNotification object:nil];
}

- (float)currentVersion {
	NSDictionary *plist = [[NSBundle mainBundle] infoDictionary];
	NSString * currentVersionString = [plist objectForKey:@"CFBundleVersion"];
	return currentVersionString == nil ? 0.0f : [currentVersionString floatValue];	
}

- (void)checkShowWelcome:(NSNotification *)n {
	float currentVersion = [self currentVersion];
	float lastRegistered = [[NSUserDefaults standardUserDefaults] floatForKey:@"installedVersion"];
	if (currentVersion > lastRegistered) {
        [NSBundle loadNibNamed:@"Welcome" owner:self];
        [window makeKeyAndOrderFront:self];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:[self currentVersion]] forKey:@"installedVersion"];
	}
}

-(IBAction)showHelp:(id)sender {
    [[NSApp delegate] showHelp:sender];
}

@end
