//
//  Ticket.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/4/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Ticket : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSManagedObject *seat;
@property (nonatomic, retain) NSManagedObject *ticketType;
@property (nonatomic, retain) NSManagedObject *user;

@end
