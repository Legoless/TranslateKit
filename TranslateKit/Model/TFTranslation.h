//
//  TFTranslation.h
//  Manager
//
//  Created by Dal Rupnik on 05/02/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "JSONModel.h"

/*!
 * A specific translation, only supporting "application/json" mimetype for now
 */
@interface TFTranslation : JSONModel

@property (nonatomic, strong) NSDictionary* content;
@property (nonatomic, strong) NSString* mimetype;

@end
