//
//  TFTranslationString.h
//  Manager
//
//  Created by Dal Rupnik on 05/02/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "JSONModel.h"

@interface TFTranslationString : JSONModel

@property (nonatomic, strong) NSString* comment;
@property (nonatomic, strong) NSArray* context;
@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) NSString* last_update;
@property (nonatomic, strong) NSString* user;
@property (nonatomic) BOOL pluralized;
@property (nonatomic) NSInteger position;
@property (nonatomic, strong) NSString* source_string;
@property (nonatomic, strong) NSString* translation;
@property (nonatomic) BOOL reviewed;
@property (nonatomic, strong) NSString* occurrences;

@end
