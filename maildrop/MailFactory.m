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

#import "MailFactory.h"
#import "Email.h"
#import "Attachment.h"

@implementation MailFactory

static NSString *mailBundleId = @"com.apple.mail";

-(NSString *)bundleId {
    return mailBundleId;
}

-(MailApplication *)app {
    return (MailApplication *)[self application];
}

-(MailMessageViewer *)topmostView:(MailApplication *)app {
    NSArray *windows = [app windows];
    if ([windows count] == 0) return nil;
    MailWindow *w = [windows objectAtIndex:0];
    NSUInteger wid = [w id];
    for (MailMessageViewer *v in [app messageViewers]) {
        if ([[v window] id] == wid)
             return v;
    }
    return nil;
}

-(NSUInteger)countOfSelectedEmails {
    MailApplication *app = [self app];
    return [[[self topmostView:app] selectedMessages] count];
}

/** return YES if the mailbox "mb" is within the tree starting at 'root' */
-(BOOL)is:(MailMailbox *)mb inMailboxTree:(MailMailbox *)root {
    if ([[mb get] isEqualTo:[root get]]) return YES;
    for (MailMailbox *child in [root mailboxes]) {
        if ([self is:mb inMailboxTree:child])
            return YES;
    }
    return NO;
}

-(Attachment *)createAttachment:(MailMailAttachment *)src {
    Attachment *res = [[[Attachment alloc] init] autorelease];
    res.mimeType = src.MIMEType;
    res.name = src.name;
    [src saveIn:[res file] as:MailSaveableFileFormatNativeFormat];
    return res;
}

-(void)addAttachmentsTo:(Email *)res from:(MailMessage *)msg {
    for (MailMailAttachment *a in [msg mailAttachments]) {
        [res insertInAttachments:[self createAttachment:a]];
    }
}

-(Email *)createEmail:(MailMessage *)msg app:(MailApplication *)app includeAttachments:(BOOL)incAttachments {
    Email *res = [[[Email alloc] init] autorelease];
    res.subject = msg.subject;
    res.body = [msg.content get];
    res.fromAddr = [app extractAddressFrom:msg.sender];
    res.fromName = [app extractNameFrom:msg.sender];
    SBElementArray *recips = msg.toRecipients;
    if ([recips count] > 0) {
        MailRecipient *r = [recips objectAtIndex:0];
        res.toName = [r name];
        res.toAddr = [r address];
    }
    res.date = msg.dateReceived;
    res.isASentEmail = [self is:msg.mailbox inMailboxTree:[app sentMailbox]];
    if (incAttachments) {
        [self addAttachmentsTo:res from:msg];
    }
    return res;
}

-(NSArray *)selectedEmailsWithAttachments:(BOOL)includeAttachments {
    MailApplication *app = [self app];
    NSMutableArray *results = [NSMutableArray array];
    MailMessageViewer *viewer = [self topmostView:app];
    for (MailMessage *msg in [viewer selectedMessages]) {
        [results addObject:[self createEmail:msg app:app includeAttachments:includeAttachments]];
    }
    return results;
}

@end
