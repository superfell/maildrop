// Copyright (c) 2006-2008 Simon Fell
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
#import "AsItem.h"

@class Attachment;

@interface Email : AsItem {
	NSString 	*fromAddr, *toAddr, *body;
	NSString	*fromName;
	NSString	*subject;
	NSString	*salesforceId;
	NSDate		*date;
	NSMutableArray	*attachments;
}

- (NSString *)fromAddr;
- (void)setFromAddr:(NSString *)aFrom;

- (NSString *)fromName;
- (void)setFromName:(NSString *)aFromName;

- (NSString *)toAddr;
- (void)setToAddr:(NSString *)aTo;

- (NSString *)subject;
- (void)setSubject:(NSString *)aSubject;

- (NSString *)body;
- (void)setBody:(NSString *)aBody;

- (NSDate *)date;
- (void)setDate:(NSDate *)newDate;

- (NSString *)salesforceId;
- (void)setSalesforceId:(NSString *)aSalesforceId;

- (NSArray *)attachments;
- (void)setAttachments:(NSArray *)atts;
- (void)insertInAttachments:(Attachment *)att;
- (void)insertObject:(Attachment *)att inAttachmentsAtIndex:(unsigned int)index;
- (void)removeObjectFromAttachmentsAtIndex:(unsigned int)index;

- (void)createActivity:(NSScriptCommand *)cmd;
- (void)createCase:(NSScriptCommand *)cmd;

@end
