//
//  Projection.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/4/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hall, Movie, ProjectionType, Seat;

@interface Projection : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Hall *hall;
@property (nonatomic, retain) Movie *movie;
@property (nonatomic, retain) ProjectionType *projectionType;
@property (nonatomic, retain) NSSet *seats;
@end

@interface Projection (CoreDataGeneratedAccessors)

- (void)addSeatsObject:(Seat *)value;
- (void)removeSeatsObject:(Seat *)value;
- (void)addSeats:(NSSet *)values;
- (void)removeSeats:(NSSet *)values;

@end
