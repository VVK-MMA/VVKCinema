//
//  Seat.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/4/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, Ticket;

@interface Seat : NSManagedObject

@property (nonatomic, retain) NSNumber * busy;
@property (nonatomic, retain) NSNumber * column;
@property (nonatomic, retain) NSNumber * row;
@property (nonatomic, retain) NSManagedObject *projection;
@property (nonatomic, retain) Ticket *ticket;

@end
