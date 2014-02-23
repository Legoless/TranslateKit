//
//  TFResource.h
//  Manager
//
//  Created by Dal Rupnik on 05/02/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "TFLanguage.h"

@protocol TFResource <NSObject>

@end

@interface TFResource : JSONModel

/*!
 * Basic information
 */
@property (nonatomic, strong) NSString* slug;
@property (nonatomic, strong) NSString* name;

/*!
 * Details
 */
@property (nonatomic, strong) NSString* i18n_type;
@property (nonatomic, strong) NSString* source_language_code;
@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) NSString* priority;
@property (nonatomic, strong) NSString* last_update;
@property (nonatomic) NSInteger wordcount;

@property (nonatomic, strong) NSString* created;
@property (nonatomic, strong) NSString* project_slug;
@property (nonatomic) BOOL accept_translations;
@property (nonatomic) NSInteger total_entities;

@property (nonatomic, strong) NSArray<TFLanguage>* available_languages;




@end
