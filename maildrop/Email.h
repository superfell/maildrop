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

#import <Cocoa/Cocoa.h>

@class Attachment;

@interface Email : NSObject {
	NSString 	*fromAddr, *toAddr, *body;
	NSString	*fromName, *toName;
	NSString	*subject;
	NSString	*salesforceId;
	NSDate		*date;
	BOOL		isASentEmail;
	NSMutableArray	*attachments;
}

@property (copy) NSString *fromAddr;
@property (copy) NSString *fromName;
@property (copy) NSString *toAddr;
@property (copy) NSString *toName;
@property (copy) NSString *subject;
@property (copy) NSString *body;
@property (copy) NSDate   *date;
@property BOOL	isASentEmail;

@property (copy) NSString *salesforceId;

- (NSArray *)attachments;
- (void)setAttachments:(NSArray *)atts;
- (void)insertInAttachments:(Attachment *)att;
- (void)insertObject:(Attachment *)att inAttachmentsAtIndex:(unsigned int)index;
- (void)removeObjectFromAttachmentsAtIndex:(unsigned int)index;

- (void)createActivity:(NSScriptCommand *)cmd;
- (void)createCase:(NSScriptCommand *)cmd;

// returns the name/email of interest, i.e. the sender in an inbound email, and the recipient in a outbound email.
- (NSString *)addrOfInterest;
- (NSString *)nameOfInterest;

@end
