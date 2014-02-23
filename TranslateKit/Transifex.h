//
//  Transifex.h
//  Manager
//
//  Created by Dal Rupnik on 05/02/14.
//  Copyright (c) 2014 arvystate.net. All rights reserved.
//

#import "TFProject.h"
#import "TFResource.h"
#import "TFOrganization.h"
#import "TFLanguage.h"
#import "TFMaintainer.h"
#import "TFTranslation.h"
#import "TFTranslationString.h"
#import "TFLanguageInfo.h"

/*!
 * Transifex v2 API singleton object, built on AFNetworking to allow simple block access to the API
 */
@interface Transifex : NSObject

@property (nonatomic, readonly) NSString* username;
@property (nonatomic, readonly) NSString* password;
@property (nonatomic, readonly) NSURL* url;

- (id)initWithURL:(NSURL *)url;

/*!
 * Prepares client to use correct username and client
 */
- (void)setupWithUsername:(NSString *)username password:(NSString *)password;

/*!
 * Default client is connected directly to public Transifex servers
 */
+ (Transifex *)defaultClient;

//
// Project API
//

/*!
 * Retrieves all projects available to user
 */
- (void)projects:(void (^)(NSArray* projects))success error:(void (^)(NSError *error))error;

/*!
 * Retrieves the project with slug
 */
- (void)projectWithSlug:(NSString *)slug success:(void (^)(TFProject* project))success error:(void (^)(NSError *error))error;

//
// Resource API
//

/*!
 * Returns all resources for specific project
 */
- (void)resourcesForProject:(TFProject *)project success:(void (^)(NSArray* resources))success error:(void (^)(NSError *error))error;

/*!
 * Returns all resources for specific project
 */
- (void)resourcesForProjectSlug:(NSString *)project success:(void (^)(NSArray* resources))success error:(void (^)(NSError *error))error;

/*!
 * Returns specific resource for resource slug in project
 */
- (void)resourceForResourceSlug:(NSString *)resource withProject:(TFProject *)project success:(void (^)(TFResource* resource))success error:(void (^)(NSError *error))error;

/*!
 * Returns specific resource for resource slug in project
 */
- (void)resourceForResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(TFResource* resource))success error:(void (^)(NSError *error))error;

/*!
 * Returns resource content for resource slug in project
 */
- (void)resourceContentForResource:(TFResource *)resource success:(void (^)(TFTranslation* translation))success error:(void (^)(NSError *error))error;

/*!
 * Returns resource content for resource slug in project
 */
- (void)resourceContentForResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(TFTranslation* translation))success error:(void (^)(NSError *error))error;

/*!
 * Updates resource content of the source language with the provided translation
 */
- (void)resourceUpdateSourceContent:(TFTranslation *)translation forResourceSlug:(TFResource *)resource success:(void (^)())success error:(void (^)(NSError *error))error;

/*!
 * Updates resource content of the source language with the provided translation
 */
- (void)resourceUpdateSourceContent:(TFTranslation *)translation withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)())success error:(void (^)(NSError *error))error;

//
// Language API - returns TFLanguageInfo object
//

/*!
 * Returns available languages in project
 */
- (void)languagesForProject:(TFProject *)project success:(void (^)(NSArray* languages))success error:(void (^)(NSError *error))error;

/*!
 * Returns available languages in project
 */
- (void)languagesForProjectSlug:(NSString *)project success:(void (^)(NSArray* languages))success error:(void (^)(NSError *error))error;

/*!
 * Returns language details for specific language code in project
 */
- (void)languageForLanguageCode:(NSString *)languageCode forProject:(TFProject *)project success:(void (^)(TFLanguageInfo* language))success error:(void (^)(NSError *error))error;

/*!
 * Returns language details for specific language code in project
 */
- (void)languageForLanguageCode:(NSString *)languageCode withProjectSlug:(NSString *)project success:(void (^)(TFLanguageInfo* language))success error:(void (^)(NSError *error))error;

//
// Language Info API - returns TFLanguage object
//

/*!
 * Returns all available languages
 */
- (void)languages:(void (^)(NSArray* languages))success error:(void (^)(NSError *error))error;

/*!
 * Returns language for language code
 */
- (void)languageForLanguageInfo:(TFLanguageInfo *)language success:(void (^)(TFLanguage* language))success error:(void (^)(NSError *error))error;

/*!
 * Returns language for language code
 */
- (void)languageForLanguageCode:(NSString *)languageCode success:(void (^)(TFLanguage* language))success error:(void (^)(NSError *error))error;

//
// Translation API
//

/*!
 * Returns translation for language code
 */
- (void)translationForLanguageInfo:(TFLanguageInfo *)language forResource:(TFResource *)resource success:(void (^)(TFTranslation* translation))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation for language code
 */
- (void)translationForLanguage:(TFLanguage *)language forResource:(TFResource *)resource success:(void (^)(TFTranslation* translation))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation for language code
 */
- (void)translationForLanguageCode:(NSString *)languageCode forResource:(TFResource *)resource success:(void (^)(TFTranslation* translation))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation for language code
 */
- (void)translationForLanguageCode:(NSString *)languageCode withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(TFTranslation* translation))success error:(void (^)(NSError *error))error;

/*!
 * Updates translation content of resource and language code
 */
- (void)translationUpdateContent:(TFTranslation *)translation forLanguageInfo:(TFLanguageInfo *)language forResource:(TFResource *)resource success:(void (^)())success error:(void (^)(NSError *error))error;

/*!
 * Updates translation content of resource and language code
 */
- (void)translationUpdateContent:(TFTranslation *)translation forLanguage:(TFLanguage *)language forResource:(TFResource *)resource success:(void (^)())success error:(void (^)(NSError *error))error;

/*!
 * Updates translation content of resource and language code
 */
- (void)translationUpdateContent:(TFTranslation *)translation forLanguageCode:(NSString *)languageCode forResource:(TFResource *)resource success:(void (^)())success error:(void (^)(NSError *error))error;

/*!
 * Updates translation content of resource and language code
 */
- (void)translationUpdateContent:(TFTranslation *)translation forLanguageCode:(NSString *)languageCode withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)())success error:(void (^)(NSError *error))error;

//
// Translation strings API
//

/*!
 * Returns translation strings for specific language code
 */
- (void)translationStringsForLanguageInfo:(TFLanguageInfo *)language forResource:(TFResource *)resource success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation strings for specific language code
 */
- (void)translationStringsForLanguage:(TFLanguage *)language forResource:(TFResource *)resource success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation strings for specific language code
 */
- (void)translationStringsForLanguageCode:(NSString *)languageCode forResource:(TFResource *)resource success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation strings for specific language code
 */
- (void)translationStringsForLanguageCode:(NSString *)languageCode withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation strings for specific language code that match specific key
 */
- (void)translationStringsWithKey:(NSString *)key forLanguageInfo:(TFLanguageInfo *)language forResource:(TFResource *)resource success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation strings for specific language code that match specific key
 */
- (void)translationStringsWithKey:(NSString *)key forLanguage:(TFLanguage *)language forResource:(TFResource *)resource success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation strings for specific language code that match specific key
 */
- (void)translationStringsWithKey:(NSString *)key forLanguageCode:(NSString *)languageCode forResource:(TFResource *)resource success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation strings for specific language code that match specific key
 */
- (void)translationStringsWithKey:(NSString *)key forLanguageCode:(NSString *)languageCode withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation strings for specific language code that match specific context
 */
- (void)translationStringsWithContext:(NSString *)context forLanguageInfo:(TFLanguageInfo *)language forResource:(TFResource *)resource success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation strings for specific language code that match specific context
 */
- (void)translationStringsWithContext:(NSString *)context forLanguage:(TFLanguage *)language forResource:(TFResource *)resource success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation strings for specific language code that match specific context
 */
- (void)translationStringsWithContext:(NSString *)context forLanguageCode:(NSString *)languageCode forResource:(TFResource *)resource success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

/*!
 * Returns translation strings for specific language code that match specific context
 */
- (void)translationStringsWithContext:(NSString *)context forLanguageCode:(NSString *)languageCode withResourceSlug:(NSString *)resource withProjectSlug:(NSString *)project success:(void (^)(NSArray* strings))success error:(void (^)(NSError *error))error;

@end
