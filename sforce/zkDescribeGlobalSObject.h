//
//  zkDescribeGlobalSObjectResult.h
//  AppExplorer
//
//  Created by Simon Fell on 10/2/09.
//  Copyright 2009 Simon Fell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "zkXmlDeserializer.h"

/*
            <complexType name="DescribeGlobalSObjectResult">
                <sequence>
                    <element name="activateable"        type="xsd:boolean"/>
                    <element name="createable"          type="xsd:boolean"/>
                    <element name="custom"              type="xsd:boolean"/>
                    <element name="customSetting"       type="xsd:boolean"/>
                    <element name="deletable"           type="xsd:boolean"/>
                    <element name="deprecatedAndHidden" type="xsd:boolean"/>
                    <element name="keyPrefix"           type="xsd:string" nillable="true"/>

                    <element name="label"               type="xsd:string"/>
                    <element name="labelPlural"         type="xsd:string"/>
                    <element name="layoutable"          type="xsd:boolean"/>
					<element name="mergeable"           type="xsd:boolean"/>
                    <element name="name"                type="xsd:string"/>
                    <element name="queryable"           type="xsd:boolean"/>
                    <element name="replicateable"       type="xsd:boolean"/>
                    <element name="retrieveable"        type="xsd:boolean"/>
					<element name="searchable"          type="xsd:boolean"/>

                    <element name="triggerable"         type="xsd:boolean"/>
                    <element name="undeletable"         type="xsd:boolean"/>
                    <element name="updateable"          type="xsd:boolean"/>
                </sequence>
            </complexType>
*/
@interface ZKDescribeGlobalSObject : ZKXmlDeserializer {
}

-(BOOL)activateable;
-(BOOL)createable;
-(BOOL)custom;
-(BOOL)customSetting;
-(BOOL)deletable;
-(BOOL)deprecatedAndHidden;
-(BOOL)layoutable;
-(BOOL)mergeable;
-(BOOL)queryable;
-(BOOL)replicateable;
-(BOOL)retrieveable;
-(BOOL)searchable;
-(BOOL)triggerable;
-(BOOL)undeleteable;
-(BOOL)updateable;

-(NSString *)keyPrefix;
-(NSString *)label;
-(NSString *)labelPlural;
-(NSString *)name;

@end
