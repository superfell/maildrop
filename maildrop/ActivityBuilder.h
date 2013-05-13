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

#import <Foundation/Foundation.h>

@class Email;
@class ZKSObject;
@class ZKSforceClient;
@class ActivityBuilder;

@protocol ActivityBuilderDelegate
-(void)activityBuilder:(ActivityBuilder *)builder builtActivity:(ZKSObject *)activity;
-(void)activityBuilderCanceled:(ActivityBuilder *)builder;
@end

@interface ActivityBuilder : NSObject {
    Email       *email;
    ZKSObject   *who, *what;
    NSString    *status;
    ZKSforceClient  *sforce;
    NSWindow        *window;
    id<ActivityBuilderDelegate> delegate;
}

@property (retain) Email *email;
@property (retain) ZKSObject *who;
@property (retain) ZKSObject *what;
@property (retain) NSString *status;
@property (retain) ZKSforceClient *sforce;
@property (retain) NSWindow *window;

-(void)build:(id<ActivityBuilderDelegate>)delegate;

@end

@interface TaskActivityBuilder : ActivityBuilder
@end

@interface EventActivityBuilder : ActivityBuilder
@end