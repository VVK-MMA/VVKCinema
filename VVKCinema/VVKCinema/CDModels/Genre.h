//
//  Genre.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/12/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Genre : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parseId;
@property (nonatomic, retain) NSSet *movies;
@end

@interface Genre (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet *)values;
- (void)removeMovies:(NSSet *)values;

@end
