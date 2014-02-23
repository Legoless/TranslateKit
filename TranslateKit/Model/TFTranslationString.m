//
//  TFTranslationString.m
//  Manager
//
//  Created by Dal Rupnik on 05/02/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "TFTranslationString.h"

@implementation TFTranslationString

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    //
    // Fix if context is string to wrap it in array
    //
    
    NSMutableDictionary* dictionary = [dict mutableCopy];
    
    if ([dictionary[@"context"] isKindOfClass:[NSString class]])
    {
        dictionary[@"context"] = @[ dict[@"context"] ];
    }
    
    return [super initWithDictionary:dictionary error:err];
}

@end
