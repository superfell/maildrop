// Copyright (c) 2008,2010,2011 Simon Fell
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

#import "WhoWhat.h"
#import "zkSforceClient.h"
#import "zkDescribeSObject.h"
#import "ZKDescribeSObject_additions.h"

@implementation SObjectWhoWhat

@synthesize sobject;

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    // these 4 Keys all depend on the sobject key.(if sobject changes, these 4 can change as well)
    NSSet *dependentKeys = [NSSet setWithObjects:@"salesforceId", @"name", @"type", @"displayName", nil];
    if ([dependentKeys containsObject:key]) {
        return [NSSet setWithObject:@"sobject"];
    }
    return [super keyPathsForValuesAffectingValueForKey:key];
}

-(id)initWithClient:(ZKSforceClient *)c {
	self = [super init];
	client = [c retain];
	return self;
}

-(void)dealloc {
	[client release];
	[sobject release];
	[super dealloc];
}

-(ZKDescribeSObject *)describe {
	return [sobject describe:client];
}

-(NSString *)salesforceId {
	return [sobject id];
}

-(NSString *)name {
	NSString *tn = [sobject type];
	NSString *nf;
	if ([tn isEqualToString:@"Contact"] || [tn isEqualToString:@"Lead"])
		nf = @"Name";
	else
		nf = [[[[self describe] nameFields] objectAtIndex:0] name];
	return [sobject fieldValue:nf];
}

-(NSString *)type {
	return [[self describe] label];
}

-(NSString *)displayName {
	return [NSString stringWithFormat:@"%@ (%@)", [self name], [self type]];
}

@end

@implementation PendingTaskWhoWhat

-(void)dealloc {
	[taskId release];
	[super dealloc];
}

-(void)setTaskId:(NSString *)tid {
	[taskId autorelease];
	taskId = [tid retain];
}

-(NSString *)salesforceId {
	return taskId;
}

-(NSString *)name {
	return @"This Activity";
}

-(NSString *)type {
	return @"Task";
}

-(NSString *)displayName {
	return [self name];
}

@end
