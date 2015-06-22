//
//  Ticket.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/22/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Seat, TicketType, User;

@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSString * parseId;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) Seat *seat;
@property (nonatomic, retain) TicketType *ticketType;
@property (nonatomic, retain) User *user;

@end
