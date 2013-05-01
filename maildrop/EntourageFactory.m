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
#import "EntourageFactory.h"
#import "Email.h"
#import "Attachment.h"

@implementation EntourageFactory

static NSString *enotourageBundleId = @"com.microsoft.Entourage";

-(NSString *)bundleId {
    return enotourageBundleId;
}

-(EntourageApplication *)app {
    return (EntourageApplication *)[self application];
}

-(NSUInteger)countOfSelectedEmails {
    return [[[self app] currentMessages] count];
}

-(Attachment *)makeAttachment:(EntourageAttachment *)src {
    Attachment *r = [[[Attachment alloc] init] autorelease];
    r.name = src.name;
    [src saveIn:[[r file] path]  as:nil];
    return r;
}

-(void)addAttachmentsTo:(Email *)res from:(EntourageMessage *)src {
    for (EntourageAttachment *a in [src attachments])
        [res insertInAttachments:[self makeAttachment:a]];
}

-(Email *)createEmail:(EntourageMessage *)msg includeAttachments:(BOOL)incAttachments {
    Email *res = [[[Email alloc] init] autorelease];
    res.subject = msg.subject;
    res.body = msg.content;
    // because scripting bridge doesn't generate any impls, we can't use [EOM class]
    // as that'll fail in the linker, so we need to dynamically do it at runtime instead
    if ([msg isKindOfClass:NSClassFromString(@"EntourageOutgoingMessage")]) {
        res.date = msg.timeSent;
        res.isASentEmail = YES;
    } else {
        res.date = msg.timeReceived;
        res.isASentEmail = NO;
    }
    res.fromName = msg.sender.displayName;
    res.fromAddr = msg.sender.address;
    if (msg.recipients.count > 0) {
        EntourageRecipient *r = [msg.recipients objectAtIndex:0];
        res.toAddr = r.address.address;
        res.toName = r.address.displayName;
    }
    if (incAttachments)
        [self addAttachmentsTo:res from:msg];
    return res;
}

-(NSArray *)selectedEmailsWithAttachments:(BOOL)includeAttachments {
    NSMutableArray *results = [NSMutableArray array];
    EntourageApplication *app = [self app];
    for (EntourageMessage *msg in [app currentMessages]) {
        [results addObject:[self createEmail:msg includeAttachments:includeAttachments]];
    }
    return results;
}

@end
