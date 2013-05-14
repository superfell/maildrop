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

#import <Cocoa/Cocoa.h>

@class Email;
@class ZKSforceClient;
@class ZKSObject;

@interface CreateContactController : NSObject {
    IBOutlet    NSWindow *window;
    
    NSString *firstName, *lastName, *email, *recordId;
    ZKSforceClient *sforce;
}

@property (retain) NSString *contactFirstName;
@property (retain) NSString *contactLastName;
@property (retain) NSString *contactEmail;

-(IBAction)cancel:(id)sender;
-(IBAction)create:(id)sender;

-(void)showSheetFromEmail:(Email *)email
                 inWindow:(NSWindow *)window
                   client:(ZKSforceClient *)sforce
                  created:(void (^)(NSString *))createdBlock
                 canceled:(void (^)())canceledBlock;

-(NSString *)typeOfSObject;

// For sub-classes
-(void)setFieldsFromEmail:(Email *)msg;
- (NSString *)makeNotNull:(NSString *)s;
-(void)populateSObject:(ZKSObject *)n;

@end
