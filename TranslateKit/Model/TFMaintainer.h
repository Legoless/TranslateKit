//
//  TFMaintainer.h
//  Manager
//
//  Created by Dal Rupnik on 05/02/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "JSONModel.h"

@protocol TFMaintainer <NSObject>
@end

@interface TFMaintainer : JSONModel

@property (nonatomic, strong) NSString* username;

@end
