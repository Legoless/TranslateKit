//
//  TFLanguage.h
//  Manager
//
//  Created by Dal Rupnik on 05/02/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "JSONModel.h"

@protocol TFLanguage <NSObject>

@end

@interface TFLanguage : JSONModel

@property (nonatomic, strong) NSString* rule_few;
@property (nonatomic, strong) NSString* code_aliases;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* pluralequation;
@property (nonatomic, strong) NSString* rule_zero;
@property (nonatomic, strong) NSString* rule_many;
@property (nonatomic, strong) NSString* rule_two;
@property (nonatomic, strong) NSString* rule_one;
@property (nonatomic, strong) NSString* rule_other;
@property (nonatomic) NSInteger nplurals;
@property (nonatomic, strong) NSString* specialchars;
@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString* name;

@end
