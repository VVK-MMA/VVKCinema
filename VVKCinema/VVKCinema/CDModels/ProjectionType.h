//
//  ProjectionType.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/12/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Projection;

@interface ProjectionType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parseId;
@property (nonatomic, retain) NSSet *projections;
@end

@interface ProjectionType (CoreDataGeneratedAccessors)

- (void)addProjectionsObject:(Projection *)value;
- (void)removeProjectionsObject:(Projection *)value;
- (void)addProjections:(NSSet *)values;
- (void)removeProjections:(NSSet *)values;

@end
