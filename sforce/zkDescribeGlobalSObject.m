//
//  zkDescribeGlobalSObjectResult.m
//  AppExplorer
//
//  Created by Simon Fell on 10/2/09.
//  Copyright 2009 Simon Fell. All rights reserved.
//

#import "zkDescribeGlobalSObject.h"


@implementation ZKDescribeGlobalSObject

-(BOOL)activateable {
	return [self boolean:@"activateable"];
}
-(BOOL)createable {
	return [self boolean:@"createable"];
}
-(BOOL)custom {
	return [self boolean:@"custom"];
}
-(BOOL)customSetting {
	return [self boolean:@"customSetting"];
}
-(BOOL)deletable {
	return [self boolean:@"deletable"];
}
-(BOOL)deprecatedAndHidden {
	return [self boolean:@"deprecatedAndHidden"];
}
-(BOOL)layoutable {
	return [self boolean:@"layoutable"];
}
-(BOOL)mergeable {
	return [self boolean:@"mergeable"];
}
-(BOOL)queryable {
	return [self boolean:@"queryable"];
}
-(BOOL)replicateable {
	return [self boolean:@"replicateable"];
}
-(BOOL)retrieveable {
	return [self boolean:@"retrieveable"];
}
-(BOOL)searchable {
	return [self boolean:@"searchable"];
}
-(BOOL)triggerable {
	return [self boolean:@"triggerable"];
}
-(BOOL)undeleteable {
	return [self boolean:@"undeleteable"];
}
-(BOOL)updateable {
	return [self boolean:@"updateable"];
}
-(NSString *)keyPrefix {
	return [self string:@"keyPrefix"];
}
-(NSString *)label {
	return [self string:@"label"];
}
-(NSString *)labelPlural {
	return [self string:@"labelPlural"];
}
-(NSString *)name {
	return [self string:@"name"];
}

@end
