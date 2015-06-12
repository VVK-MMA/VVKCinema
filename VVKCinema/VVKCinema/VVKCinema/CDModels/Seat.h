//
//  Seat.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/12/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Projection, Ticket;

@interface Seat : NSManagedObject

@property (nonatomic, retain) NSNumber * busy;
@property (nonatomic, retain) NSNumber * column;
@property (nonatomic, retain) NSNumber * row;
@property (nonatomic, retain) NSString * parseId;
@property (nonatomic, retain) Projection *projection;
@property (nonatomic, retain) Ticket *ticket;

@end
