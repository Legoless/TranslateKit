//
//  TFProject.h
//  Manager
//
//  Created by Dal Rupnik on 05/02/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "TFOrganization.h"
#import "TFMaintainer.h"
#import "TFResource.h"

@interface TFProject : JSONModel

/*!
 * Basic information
 */
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* source_language_code;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* slug;

/*!
 * Details
 */
@property (nonatomic, strong) NSString* long_description;
@property (nonatomic, strong) NSString* homepage;
@property (nonatomic, strong) NSString* feed;
@property (nonatomic, strong) NSString* created;
@property (nonatomic, strong) NSString* tags;
@property (nonatomic, strong) NSArray* teams;
@property (nonatomic, strong) NSString* last_updated;
@property (nonatomic, strong) NSString* trans_instructions;

@property (nonatomic, strong) NSArray<TFMaintainer>* maintainers;

@property (nonatomic, strong) TFOrganization* organization;
@property (nonatomic) BOOL fill_up_resources;
@property (nonatomic) BOOL auto_join;
@property (nonatomic) BOOL private;

@property (nonatomic, strong) NSString* outsource;

@property (nonatomic, strong) NSArray<TFResource>* resources;

/*!
 * Unverified
 */
@property (nonatomic, strong) NSString* bug_tracker;
@property (nonatomic, strong) NSString* anyone_submit;
@property (nonatomic, strong) NSString* owner;

@end
