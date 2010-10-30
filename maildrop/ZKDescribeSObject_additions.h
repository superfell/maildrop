// Copyright (c) 2006-2010 Simon Fell
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
#import "ZKSObject.h"
#import "ZKDescribeSObject.h"
#import "zkSforceClient.h"

@class ZKSforceClient;
@class ZKDescribeGlobalSObject;

@interface ZKSObject (KVCHelper) 
-(id)valueForUndefinedKey:(NSString *)key;
@end

@interface ZKSObject (Describe)
-(ZKDescribeSObject *)describe:(ZKSforceClient *)client;
@end

@interface ZKDescribeSObject (FieldHelpers)
-(NSArray *)nameFields;						// the subset of fields for this sobject that are flagged as 'Name' fields
-(NSArray *)validAdditionalFields;			// the subset of fields that are valid for the additionalDisplayField property
-(ZKDescribeField *)additionalDisplayField;	// extra field that we want to display, set by the user.
-(void)setAdditionalDisplayField:(ZKDescribeField *)f;
@end

@interface ZKDescribeField (BindingHelpers)
-(NSString *)labelAndName;				// foo bar (foobar__c)
@end

@interface ZKSforceClient (Describe)
// looks in the global describe results for the specified entities metadata.
-(ZKDescribeGlobalSObject *)describeGlobalFor:(NSString *)entity;
@end