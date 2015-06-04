//
//  ProjectionType.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/4/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface ProjectionType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *projections;
@end

@interface ProjectionType (CoreDataGeneratedAccessors)

- (void)addProjectionsObject:(NSManagedObject *)value;
- (void)removeProjectionsObject:(NSManagedObject *)value;
- (void)addProjections:(NSSet *)values;
- (void)removeProjections:(NSSet *)values;

@end
