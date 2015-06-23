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
 *  @param password password of the new User (no access to the password on the server)
 *  @param email    email of the new User (unique)
 */
- (void)sendSignUpRequestToParseWithName:(NSString *)name password:(NSString *)password andEmail:(NSString *)email;

/**
 *  Create new Seat object to the server
 *
 *  @param column       column of the new Seat
 *  @param row          row of the new Seat
 *  @param projectionId projectionId of the Projection where the new Seat is
 */
- (void)bookNewSeatToParseWithColumn:(NSNumber *)column row:(NSNumber *)row andProjectionId:(NSString *)projectionId;

/**
 *  Create new Ticket object to the server
 *
 *  @param seat       seat of the new Ticket
 *  @param ticketType ticketType of the new Ticket (regular or student)
 *  @param userId     userId of the logged in User who book the new Ticket
 */
- (void)bookNewTicketToParseWithSeat:(NSString *)seat ticketType:(NSString *)ticketType andUserId:(NSString *)userId;

/**
 *  Send post request to the server to login
 *
 *  @param username username of the existing User (same like the email - unique)
 *  @param password password of the existing User (no access to the password on the server - hidden)
 *
 *  @return dictionary with information about the User from the server
 */
- (NSDictionary *)loginUserWithUsername:(NSString *)username andPassword:(NSString *)password;

/**
 *  Take the booked Seat from the current Projection
 *
 *  @param column     column of the booked Seat
 *  @param row        row of the booked Seat
 *  @param projection id of the Projection where the booked Seat is
 *
 *  @return dictionary with information about the booked Seat from the server
 */
- (NSDictionary *)getSeatWithClassName:(NSString *)className column:(NSNumber *)column row:(NSNumber *)row fromProjection:(NSString *)projection;

@end
