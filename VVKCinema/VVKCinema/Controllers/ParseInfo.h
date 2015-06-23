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

- (void)userDidPostSuccessfully:(BOOL)isSuccessful;

@end

@interface ParseInfo : NSObject

@property (nonatomic) id<ParseInfoDelegate> delegate;

@property (strong, nonatomic) NSDictionary *responseDictionary;

/**
 *  ParseInfo
 *
 *  @return singleton instance of type ParseInfo
 */
+ (id)sharedParse;

/**
 *  Fill Core Data with objects from server (only if they don't exist)
 *
 *  @param type is the name of the class in parse.com
 */
- (void)transferFromServerToCoreDataAllObjectsWithType:(NSString *)type;

/**
 *  Send sign up request (register)
 *
 *  @param name     name of the new User
 *  @param password password of the new User ()
 *  @param email    <#email description#>
 */
- (void)sendSignUpRequestToParseWithName:(NSString *)name password:(NSString *)password andEmail:(NSString *)email;
- (void)bookNewSeatToParseWithColumn:(NSNumber *)column row:(NSNumber *)row andProjectionId:(NSString *)projectionId;
- (void)bookNewTicketToParseWithSeat:(NSString *)seat ticketType:(NSString *)ticketType andUserId:(NSString *)userId;

- (NSDictionary *)loginUserWithUsername:(NSString *)username andPassword:(NSString *)password;
- (NSDictionary *)getSeatWithClassName:(NSString *)className column:(NSNumber *)column row:(NSNumber *)row fromProjection:(NSString *)projection;

@end
