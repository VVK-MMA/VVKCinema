//
//  Parse.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/11/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol ParseInfoDelegate;

@protocol ParseInfoDelegate

- (void)userDidSignUpSuccessfully:(BOOL)isSuccessful;

@end

@interface ParseInfo : NSObject

@property (nonatomic) id<ParseInfoDelegate> delegate;

@property (strong, nonatomic) NSDictionary *responseDictionary;

+ (id)sharedParse;

- (NSDictionary *)getAllObjectsWithType:(NSString *)type relatedToObjectWithClassName:(NSString *)className objectId:(NSString *)objectId andKeyName:(NSString *)keyName;

- (void)transferFromServerToCoreDataAllObjectsWithType:(NSString *)type;

- (NSDictionary *)getObjectWithType:(NSString *)type andObjectId:(NSString *)objectId;

- (void)sendSignUpRequestToParseWithName:(NSString *)name password:(NSString *)password andEmail:(NSString *)email;

- (NSDictionary *)loginUserWithUsername:(NSString *)username andPassword:(NSString *)password;

@end
