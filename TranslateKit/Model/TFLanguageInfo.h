//
//  TFLanguageInfo.h
//  Manager
//
//  Created by Dal Rupnik on 05/02/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "JSONModel.h"

@interface TFLanguageInfo : JSONModel

/*!
 * Basic information
 */
@property (nonatomic, strong) NSString* language_code;
@property (nonatomic, strong) NSArray* coordinators;
@property (nonatomic, strong) NSArray* translators;
@property (nonatomic, strong) NSArray* reviewers;

/*!
 * Details
 */
@property (nonatomic) NSInteger translated_segments;
@property (nonatomic) NSInteger untranslated_segments;
@property (nonatomic) NSInteger reviewed_segments;
@property (nonatomic) NSInteger total_segments;
@property (nonatomic) NSInteger translated_words;

@end
