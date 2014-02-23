//
//  Transifex.m
//  Manager
//
//  Created by Dal Rupnik on 05/02/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "Transifex.h"
#import "TFManager.h"

#define TRANSIFEX_DEFAULT_URL @"http://www.transifex.com/api/2/"

@interface Transifex ()

@property (nonatomic, readwrite) NSString* username;
@property (nonatomic, readwrite) NSString* password;
@property (nonatomic, readwrite) NSURL* url;

/*!
 * Tells us if setup with username method was called, as we do not allow multiple setups or usage without setup.
 */
@property (nonatomic, getter = isSetuped) BOOL setuped;

@property (nonatomic, strong) TFManager* manager;

@end

@implementation Transifex

/*!
 * No direct access to init
 */
- (id)init
{
    return nil;
}

- (TFManager *)manager
{
    if (!self.isSetuped)
    {
        @throw [NSException exceptionWithName:@"Internal inconsistency" reason:@"Call setup object before using any calls." userInfo:nil];
    }
    
    return _manager;
}

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    
    if (self)
    {
        self.url = [url copy];
    }
    
    return self;
}

- (void)setupWithUsername:(NSString *)username password:(NSString *)password
{
    if (self.isSetuped)
    {
        @throw [NSException exceptionWithName:@"Internal inconsistency" reason:@"Username and password is already set, use new instance." userInfo:nil];
    }
    
    if (![username length])
    {
        @throw [NSException exceptionWithName:@"Internal inconsistency" reason:@"Username must be set." userInfo:nil];
    }
    
    if (![password length])
    {
        @throw [NSException exceptionWithName:@"Internal inconsistency" reason:@"Password must be set." userInfo:nil];
    }
    
    self.setuped = YES;
    
    self.manager = [[TFManager alloc] initWithBaseURL:self.url];
    
    self.username = [username copy];
    self.password = [password copy];
    
    //
    // Apply username and password
    //
    
    if (!self.manager.requestSerializer)
    {
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    [self.manager.requestSerializer clearAuthorizationHeader];
    [self.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.username password:self.password];
    
    
}

+ (Transifex *)defaultClient
{
    static Transifex* defaultClient;
    
    @synchronized(self)
    {
        if (!defaultClient)
        {
            defaultClient = [[Transifex alloc] initWithURL:[NSURL URLWithString:TRANSIFEX_DEFAULT_URL]];
        }
        
        return defaultClient;
    }
}

- (void)projects:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self.manager GET:@"projects?details" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //
        // Convert response object to array
        //
        
        NSMutableArray* projects = [NSMutableArray array];
        
        for (NSDictionary* dictionary in responseObject)
        {
            NSError* err;
            
            TFProject* project = [[TFProject alloc] initWithDictionary:dictionary error:&err];
            
            //
            // Doing fullproof - check for error
            //
            
            if (err)
            {
                if (error)
                {
                    error(err);
                }
                
                return;
            }
            
            [projects addObject:project];
        }
        
        if (success)
        {
            success([projects copy]);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)projectWithSlug:(NSString *)slug success:(void (^)(TFProject *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"project/%@?details", slug] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError* err;
        
        TFProject* project = [[TFProject alloc] initWithDictionary:responseObject error:&err];
        
        if (err)
        {
            if (error)
            {
                error(err);
            }
            
            return;
        }
        
        if (success)
        {
            success(project);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)resourcesForProject:(TFProject *)project success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self resourcesForProjectSlug:project.slug success:success error:error];
}

- (void)resourcesForProjectSlug:(NSString *)project success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"project/%@/resources", project] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray* resources = [NSMutableArray array];
        
        for (NSDictionary* dictionary in responseObject)
        {
            NSError* err;
            
            TFResource* resource = [[TFResource alloc] initWithDictionary:dictionary error:&err];
            
            if (err)
            {
                if (error)
                {
                    error(err);
                }
                
                return;
            }
            
            [resources addObject:resource];
        }

        if (success)
        {
            success(resources);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)resourceForResourceSlug:(NSString *)resource withProject:(TFProject *)project success:(void (^)(TFResource *))success error:(void (^)(NSError *))error
{
    [self resourceForResourceSlug:resource withProjectSlug:project.slug success:success error:error];
}

- (void)resourceForResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(TFResource *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"project/%@/resource/%@?details", project, resource] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError* err;

        TFResource* resource = [[TFResource alloc] initWithDictionary:responseObject error:&err];

        if (err)
        {
            if (error)
            {
                error(err);
            }

            return;
        }

        if (success)
        {
            success(resource);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)resourceContentForResource:(TFResource *)resource success:(void (^)(TFTranslation *))success error:(void (^)(NSError *))error
{
    [self resourceContentForResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)resourceContentForResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(TFTranslation *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"project/%@/resource/%@/content", project, resource] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError* err;

        TFTranslation* translation = [[TFTranslation alloc] initWithDictionary:responseObject error:&err];

        if (err)
        {
            if (error)
            {
                error(err);
            }

            return;
        }

        if (success)
        {
            success(translation);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)resourceUpdateSourceContent:(TFTranslation *)translation forResourceSlug:(TFResource *)resource success:(void (^)())success error:(void (^)(NSError *))error
{
    [self resourceUpdateSourceContent:translation withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)resourceUpdateSourceContent:(TFTranslation *)translation withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)())success error:(void (^)(NSError *))error
{
    [self.manager PUT:[NSString stringWithFormat:@"project/%@/resource/%@/content", project, resource] parameters:[translation toDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (success)
        {
            success();
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)languagesForProject:(TFProject *)project success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self languagesForProjectSlug:project.slug success:success error:error];
}

- (void)languagesForProjectSlug:(NSString *)project success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"project/%@/languages", project] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray* languages = [NSMutableArray array];

        for (NSDictionary* dictionary in responseObject)
        {
            NSError* err;

            TFLanguageInfo* language = [[TFLanguageInfo alloc] initWithDictionary:dictionary error:&err];

            if (err)
            {
                if (error)
                {
                    error(err);
                }

                return;
            }

            [languages addObject:language];
        }

        if (success)
        {
            success(languages);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)languageForLanguageCode:(NSString *)languageCode forProject:(TFProject *)project success:(void (^)(TFLanguageInfo *))success error:(void (^)(NSError *))error
{
    [self languageForLanguageCode:languageCode withProjectSlug:project.slug success:success error:error];
}

- (void)languageForLanguageCode:(NSString *)languageCode withProjectSlug:(NSString *)project success:(void (^)(TFLanguageInfo *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"project/%@/language/%@", project, languageCode] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError* err;

        TFLanguageInfo* language = [[TFLanguageInfo alloc] initWithDictionary:responseObject error:&err];

        if (err)
        {
            if (error)
            {
                error(err);
            }

            return;
        }

        if (success)
        {
            success(language);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)languages:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"languages"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray* languages = [NSMutableArray array];

        for (NSDictionary* dictionary in responseObject)
        {
            NSError* err;

            TFLanguage* language = [[TFLanguage alloc] initWithDictionary:dictionary error:&err];

            if (err)
            {
                if (error)
                {
                    error(err);
                }

                return;
            }

            [languages addObject:language];
        }

        if (success)
        {
            success(languages);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)languageForLanguageInfo:(TFLanguageInfo *)language success:(void (^)(TFLanguage *))success error:(void (^)(NSError *))error
{
    [self languageForLanguageCode:language.language_code success:success error:error];
}

- (void)languageForLanguageCode:(NSString *)languageCode success:(void (^)(TFLanguage *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"language/%@", languageCode] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError* err;

        TFLanguage* language = [[TFLanguage alloc] initWithDictionary:responseObject error:&err];

        if (err)
        {
            if (error)
            {
                error(err);
            }

            return;
        }

        if (success)
        {
            success(language);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)translationForLanguageInfo:(TFLanguageInfo *)language forResource:(TFResource *)resource success:(void (^)(TFTranslation *))success error:(void (^)(NSError *))error
{
    [self translationForLanguageCode:language.language_code withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationForLanguage:(TFLanguage *)language forResource:(TFResource *)resource success:(void (^)(TFTranslation *))success error:(void (^)(NSError *))error
{
    [self translationForLanguageCode:language.code withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationForLanguageCode:(NSString *)languageCode forResource:(TFResource *)resource success:(void (^)(TFTranslation *))success error:(void (^)(NSError *))error
{
    [self translationForLanguageCode:languageCode withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationForLanguageCode:(NSString *)languageCode withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(TFTranslation *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"project/%@/resource/%@/translation/%@", project, resource, languageCode] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSError* err;

        TFTranslation* translation = [[TFTranslation alloc] initWithDictionary:responseObject error:&err];

        if (err)
        {
            if (error)
            {
                error(err);
            }

            return;
        }

        if (success)
        {
            success(translation);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)translationUpdateContent:(TFTranslation *)translation forLanguageInfo:(TFLanguageInfo *)language forResource:(TFResource *)resource success:(void (^)())success error:(void (^)(NSError *))error
{
    [self translationUpdateContent:translation forLanguageCode:language.language_code withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationUpdateContent:(TFTranslation *)translation forLanguage:(TFLanguage *)language forResource:(TFResource *)resource success:(void (^)())success error:(void (^)(NSError *))error
{
    [self translationUpdateContent:translation forLanguageCode:language.code withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationUpdateContent:(TFTranslation *)translation forLanguageCode:(NSString *)languageCode forResource:(TFResource *)resource success:(void (^)())success error:(void (^)(NSError *))error
{
    [self translationUpdateContent:translation forLanguageCode:languageCode withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationUpdateContent:(TFTranslation *)translation forLanguageCode:(NSString *)languageCode withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)())success error:(void (^)(NSError *))error
{
    [self.manager PUT:[NSString stringWithFormat:@"project/%@/resource/%@/translation/%@", project, resource, languageCode] parameters:[translation toDictionary] success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (success)
        {
            success();
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)translationStringsForLanguageInfo:(TFLanguageInfo *)language forResource:(TFResource *)resource success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self translationStringsForLanguageCode:language.language_code withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationStringsForLanguage:(TFLanguage *)language forResource:(TFResource *)resource success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self translationStringsForLanguageCode:language.code withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationStringsForLanguageCode:(NSString *)languageCode forResource:(TFResource *)resource success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self translationStringsForLanguageCode:languageCode withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationStringsForLanguageCode:(NSString *)languageCode withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"project/%@/resource/%@/translation/%@/strings", project, resource, languageCode] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray* strings = [NSMutableArray array];

        for (NSDictionary* dictionary in responseObject)
        {
            NSError* err;

            TFTranslationString* string = [[TFTranslationString alloc] initWithDictionary:dictionary error:&err];

            if (err)
            {
                if (error)
                {
                    error(err);
                }

                return;
            }

            [strings addObject:string];
        }

        if (success)
        {
            success(strings);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)translationStringsWithKey:(NSString *)key forLanguageInfo:(TFLanguageInfo *)language forResource:(TFResource *)resource success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self translationStringsWithKey:key forLanguageCode:language.language_code withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationStringsWithKey:(NSString *)key forLanguage:(TFLanguage *)language forResource:(TFResource *)resource success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self translationStringsWithKey:key forLanguageCode:language.code withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationStringsWithKey:(NSString *)key forLanguageCode:(NSString *)languageCode forResource:(TFResource *)resource success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self translationStringsWithKey:key forLanguageCode:languageCode withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationStringsWithKey:(NSString *)key forLanguageCode:(NSString *)languageCode withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"project/%@/resource/%@/translation/%@/strings", project, resource, languageCode] parameters:@{ @"key" : key } success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray* strings = [NSMutableArray array];

        for (NSDictionary* dictionary in responseObject)
        {
            NSError* err;

            TFTranslationString* string = [[TFTranslationString alloc] initWithDictionary:dictionary error:&err];

            if (err)
            {
                if (error)
                {
                    error(err);
                }

                return;
            }

            [strings addObject:string];
        }

        if (success)
        {
            success(strings);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

- (void)translationStringsWithContext:(NSString *)context forLanguageInfo:(TFLanguageInfo *)language forResource:(TFResource *)resource success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self translationStringsWithContext:context forLanguageCode:language.language_code withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationStringsWithContext:(NSString *)context forLanguage:(TFLanguage *)language forResource:(TFResource *)resource success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self translationStringsWithContext:context forLanguageCode:language.code withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationStringsWithContext:(NSString *)context forLanguageCode:(NSString *)languageCode forResource:(TFResource *)resource success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self translationStringsWithContext:context forLanguageCode:languageCode withResourceSlug:resource.slug withProjectSlug:resource.project_slug success:success error:error];
}

- (void)translationStringsWithContext:(NSString *)context forLanguageCode:(NSString *)languageCode withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(NSArray *))success error:(void (^)(NSError *))error
{
    [self.manager GET:[NSString stringWithFormat:@"project/%@/resource/%@/translation/%@/strings", project, resource, languageCode] parameters:@{ @"context" : context } success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSMutableArray* strings = [NSMutableArray array];

        for (NSDictionary* dictionary in responseObject)
        {
            NSError* err;

            TFTranslationString* string = [[TFTranslationString alloc] initWithDictionary:dictionary error:&err];

            if (err)
            {
                if (error)
                {
                    error(err);
                }

                return;
            }

            [strings addObject:string];
        }

        if (success)
        {
            success(strings);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *err)
    {
        if (error)
        {
            error(err);
        }
    }];
}

@end
