//
//  Country.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/4/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *movies;
@end

@interface Country (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(NSManagedObject *)value;
- (void)removeMoviesObject:(NSManagedObject *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;

@end