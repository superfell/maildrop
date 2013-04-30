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

#import "ClientApp.h"



@implementation ClientApp
-(id)initWithBundleId:(NSString *)bid imageName:(NSString *)imageName folderName:(NSString *)fn {
	self = [super init];
	bundleId = [bid retain];
	image = [[NSImage imageNamed:imageName] retain];
	folderName = [fn retain];
	return self;
}
-(void)dealloc {
	[bundleId release];
	[image release];
	[folderName release];
	[super dealloc];
}
+(id)withBundleId:(NSString *)bid imageName:(NSString *)image folderName:(NSString *)fn {
	return [[[ClientApp alloc] initWithBundleId:bid imageName:image folderName:fn] autorelease];
}
-(NSString *)bundleId {
	return bundleId;
}
-(NSImage *)iconImage {
	return image;
}
-(NSString *)folderName {
	return folderName;
}
@end
