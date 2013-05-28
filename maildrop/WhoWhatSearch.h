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

@class ZKSforceClient;
@class ZKSObject;
@class WhatSearchDataSource;

@interface FkSearchController : NSObject {
    NSString        *searchText;
    ZKSforceClient  *sforce;
}

@property (retain, nonatomic) NSString *searchText;
@property (retain, nonatomic) ZKSforceClient *sforce;
@property (readonly) ZKSObject *selected;

-(IBAction)search:(id)sender;

@end

@interface WhoController : FkSearchController {
    IBOutlet NSArrayController	*whoSearchController;
    NSArray                     *searchResults;
}

@property (readonly) BOOL createContactAllowed;
@property (readonly) BOOL createLeadAllowed;
@property (readonly) BOOL canSearch;
@property (readonly) NSString *searchToolTip;
@property (readonly) NSArrayController *whoSearchController; // temp
@property (retain)   NSArray *searchResults;

-(void)insertNewRecordOfType:(NSString *)type withId:(NSString *)recordId;

@end

@interface WhatController : FkSearchController {
    IBOutlet NSTableView    *whatSearchResults;
	NSArray					*whatObjectTypes;
    WhatSearchDataSource	*whatResultsTableSource;
}

- (NSArray *)whatObjectTypes;
- (NSArray *)whatObjectTypeDescribes;

- (void)setWhatSearchResultsData:(NSArray *)res;

@end
