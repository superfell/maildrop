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

@interface WelcomeController ()
-(BOOL)copyScripts;
-(BOOL)stopCopyWithError:(NSError *)err;
@end

@implementation WelcomeController

@synthesize installText=text, installDone=done, installProgress=progress;

- (void)dealloc {
	[text release];
	[super dealloc];
}

- (void)awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkShowWelcome:) name:NSApplicationDidFinishLaunchingNotification object:nil];
}

- (float)currentVersion {
	NSDictionary *plist = [[NSBundle mainBundle] infoDictionary];
	NSString * currentVersionString = [plist objectForKey:@"CFBundleVersion"];
	return currentVersionString == nil ? 0.0f : [currentVersionString floatValue];	
}

- (void)installScripts:(id)sender {
	[window makeKeyAndOrderFront:self];
	[self setInstallText:@"Installing Scripts..."];
	[self setInstallProgress:1];
	[self setInstallDone:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self copyScripts];
    });
}

- (void)checkShowWelcome:(NSNotification *)n {
	float currentVersion = [self currentVersion];
	float lastRegistered = [[NSUserDefaults standardUserDefaults] floatForKey:@"installedVersion"];
	if (currentVersion > lastRegistered) {
        [NSBundle loadNibNamed:@"Welcome" owner:self];
		[self installScripts:self];
	} else {
		[self setInstallText:@""];
		[self setInstallProgress:0];
		[self setInstallDone:YES];
	}
}

-(IBAction)showHelp:(id)sender {
    [[NSApp delegate] showHelp:sender];
}

- (NSArray *)installList {
	NSString *addEmail = [[NSBundle mainBundle] pathForResource:ADD_EMAIL_SCRIPT_NAME ofType:@"scpt"];
	NSString *addCase  = [[NSBundle mainBundle] pathForResource:ADD_CASE_SCRIPT_NAME  ofType:@"scpt"];
	NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *mailScripts = [[library objectAtIndex:0] stringByAppendingPathComponent:@"Scripts/Applications/Mail"];
	NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *entourageScripts = [[docs objectAtIndex:0] stringByAppendingPathComponent:@"Microsoft User Data/Entourage Script Menu Items"];
	
	NSMutableArray *installList = [NSMutableArray array];
	[installList addObject:[NSArray arrayWithObjects:addEmail, mailScripts, nil]];
	[installList addObject:[NSArray arrayWithObjects:addCase,  mailScripts, nil]];
	[installList addObject:[NSArray arrayWithObjects:addEmail, entourageScripts, nil]];
	[installList addObject:[NSArray arrayWithObjects:addCase,  entourageScripts, nil]];
    return installList;
}

- (BOOL)ensureDirectoryExists:(NSString *)dir {
    NSFileManager *fm = [NSFileManager defaultManager];
	if (![fm fileExistsAtPath:dir]) {
        NSError *err = nil;
		if (![[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&err]) {
            return [self stopCopyWithError:err];
        }
	}
    return YES;
}

-(BOOL)stopCopyWithError:(NSError *)err {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSAlert alertWithError:err] runModal];
        [self setInstallText:@"Error installing scripts"];
    });
    return NO;
}

-(BOOL)copyScripts {
    NSArray *installList = [self installList];
    NSFileManager *fm = [NSFileManager defaultManager];
    int p = 1;
    NSError *err = nil;
    for (NSArray *item in installList) {
		NSString *destDir = [item objectAtIndex:1];
		NSString *srcFile = [item objectAtIndex:0];
		NSString *dstFile = [destDir stringByAppendingPathComponent:[srcFile lastPathComponent]];
		if (![self ensureDirectoryExists:destDir])
            return NO;
        if ([fm fileExistsAtPath:dstFile]) {
            if (![fm removeItemAtPath:dstFile error:&err])
                return [self stopCopyWithError:err];
        }
        if (![fm copyItemAtPath:srcFile toPath:dstFile error:&err])
            return [self stopCopyWithError:err];
        p++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setInstallProgress:p];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
		[self setInstallText:@"Finished Installing Scripts"];
		[self setInstallDone:YES];
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:[self currentVersion]] forKey:@"installedVersion"];
	});
    return YES;
}

@end
