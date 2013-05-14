// Copyright (c) 2013 Simon Fell
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

#import "CreateContactController.h"
#import "Email.h"
#import "zkSforce.h"

@interface CreateContactController  ()
@property (retain, nonatomic) NSString *recordId;
@property (retain, nonatomic) ZKSforceClient *sforce;
@end

@implementation CreateContactController

@synthesize contactFirstName=firstName, contactLastName=lastName, contactEmail=email, recordId, sforce;

-(id)init {
    self = [super init];
    [NSBundle loadNibNamed:[self nibName] owner:self];
    return self;
}

-(void)dealloc {
    [firstName release];
    [lastName release];
    [email release];
    [window release];
    [recordId release];
    [sforce release];
    [super dealloc];
}

-(NSString *)nibName {
    return @"CreateContact";
}

-(IBAction)cancel:(id)sender {
    [NSApp endSheet:window returnCode:1];
}

- (NSString *)makeNotNull:(NSString *)s {
    return (s == nil || [s length] == 0) ? @" " : s;
}

-(NSString *)typeOfSObject {
    return @"Contact";
}

-(void)populateSObject:(ZKSObject *)n {
	[n setFieldValue:[self makeNotNull:[self contactFirstName]] field:@"FirstName"];
	[n setFieldValue:[self makeNotNull:[self contactLastName]]  field:@"LastName"];
	[n setFieldValue:[self makeNotNull:[self contactEmail]]     field:@"Email"];
}

-(IBAction)create:(id)sender {
	ZKSObject *n = [ZKSObject withType:[self typeOfSObject]];
    [self populateSObject:n];
                    
	ZKSaveResult *sr = [[sforce create:[NSArray arrayWithObject:n]] objectAtIndex:0];
	if ([sr success]) {
        self.recordId = [sr id];
        [NSApp endSheet:window returnCode:0];
	} else {
		NSAlert * a = [NSAlert alertWithMessageText:@"Create Failed" defaultButton:@"OK" alternateButton:nil otherButton:nil
                          informativeTextWithFormat:[NSString stringWithFormat:@"%@ : %@", [sr statusCode], [sr message]]];
		[a runModal];
	}
}

-(void)setFieldsFromEmail:(Email *)msg {
	NSString *name = [msg nameOfInterest];
	NSRange rng = [name rangeOfString:@" "];
	if (rng.location == NSNotFound) {
		[self setContactFirstName:nil];
		[self setContactLastName:name];
	} else {
		[self setContactFirstName:[name substringToIndex:rng.location]];
		[self setContactLastName:[name substringFromIndex:rng.location + rng.length]];
	}
	[self setContactEmail:[msg addrOfInterest]];
}

-(void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    NSArray *blocks = (NSArray *)contextInfo;
    void (^cb)(NSString *) = [blocks objectAtIndex:0];
    void (^can)() = [blocks objectAtIndex:1];
    if (returnCode == 0)
        cb(self.recordId);
    else
        can();
    
    [sheet orderOut:self];
    [cb release];
    [can release];
    [blocks release];
    self.sforce = nil;
}

-(void)showSheetFromEmail:(Email *)emailMsg
                 inWindow:(NSWindow *)containerWindow
                   client:(ZKSforceClient *)sforceClient
                  created:(void (^)(NSString *))createdBlock
                 canceled:(void (^)())canceledBlock {

    self.sforce = sforceClient;
    NSArray *ctx = [[NSArray arrayWithObjects:[createdBlock copy], [canceledBlock copy], nil] retain];
    [self setFieldsFromEmail:emailMsg];
    [NSApp beginSheet:window modalForWindow:containerWindow modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:ctx];
}

@end
