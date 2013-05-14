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

#import "CreateLeadController.h"
#import "zkSforce.h"
#import "ZKDescribeSObject_additions.h"

@implementation CreateLeadController

@synthesize contactCompany=company, contactLeadStatus=status, leadStatuses;

-(void)dealloc {
    [company release];
    [status release];
    [defaultLeadStatus release];
    [leadStatuses release];
    [super dealloc];
}

-(NSString *)nibName {
    return @"CreateLead";
}

-(NSString *)typeOfSObject {
    return @"Lead";
}

-(void)setFieldsFromEmail:(Email *)msg {
    [super setFieldsFromEmail:msg];
    [self setContactCompany:@""];
    self.leadStatuses = nil; // force lead statusus to be recalc'd.
	[self setContactLeadStatus:[self defaultLeadStatus]];
}

-(void)populateSObject:(ZKSObject *)n {
    [super populateSObject:n];
    [n setFieldValue:[self makeNotNull:[self contactCompany]]   field:@"Company"];
    [n setFieldValue:[self makeNotNull:[self contactLeadStatus]] field:@"Status"];
}

-(void)calcLeadStatus {
	if (sforce == nil) return;
	if (leadStatuses == nil) {
        if (![sforce hasEntity:@"LeadStatus"]) return;
        ZKQueryResult *qr = [sforce query:@"select MasterLabel, IsDefault from LeadStatus order by SortOrder"];
        NSMutableArray *ls = [NSMutableArray arrayWithCapacity:[qr size]];
        for (ZKSObject *s in [qr records]) {
            if ([s boolValue:@"IsDefault"])
                defaultLeadStatus = [[s fieldValue:@"MasterLabel"] copy];
            [ls addObject:[s fieldValue:@"MasterLabel"]];
        }
        self.leadStatuses = ls;
	}
}

- (NSString *)defaultLeadStatus {
	if (defaultLeadStatus == nil)
		[self calcLeadStatus];
	return defaultLeadStatus;
}

@end
