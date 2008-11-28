// Copyright (c) 2008 Simon Fell
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

#import "Attachment.h"
#import "Email.h"
#import "zkSObject.h"
#import "NSData-Base64Extensions.h"

@implementation Attachment

-(id)init {
	self = [super init];
	file = [[[NSURL URLWithString:uniqueId relativeToURL:[NSURL fileURLWithPath:NSTemporaryDirectory()]] absoluteURL] retain];
	return self;
}

- (void)dealloc {
	[salesforceId release];
	[name release];
	[mimeType release];
	[file release];
	[super dealloc];
}

-(ZKSObject *)makeSobjectWithParent:(NSString *)parentId {
	ZKSObject *a = [[ZKSObject alloc] initWithType:@"Attachment"];
	[a setFieldValue:parentId field:@"ParentId"];
	[a setFieldValue:name field:@"Name"];
	[a setFieldValue:mimeType field:@"ContentType"];
	NSData *d = [[NSData alloc] initWithContentsOfURL:file];
	[a setFieldValue:[d encodeBase64] field:@"Body"];
	[d release];
	return a;
}

-(void)setName:(NSString *)newName {
	[name autorelease];
	name = [newName retain];
}

-(void)setMimeType:(NSString *)mt {
	[mimeType autorelease];
	mimeType = [mt retain];
}

-(void)setFile:(NSURL *)newFile {
	[file autorelease];
	file = [newFile retain];
}

-(NSString *)uniqueId {
	return uniqueId;
}

-(NSString *)salesforceId {
	return salesforceId;
}

-(NSString *)name {
	return name;
}

-(NSString *)mimeType {
	return mimeType;
}

-(NSURL *)file {
	return file;
}

-(NSString *)description {
	return [NSString stringWithFormat:@"%@ :type %@ url %@ id %@", name, mimeType, file, uniqueId];
}

@end
