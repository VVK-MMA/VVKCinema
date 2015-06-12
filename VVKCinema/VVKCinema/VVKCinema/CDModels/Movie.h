//
//  Movie.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/12/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Country, Director, Genre, Hall, Language, Projection;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * poster;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSNumber * subtitled;
@property (nonatomic, retain) NSString * parseId;
@property (nonatomic, retain) NSSet *actors;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) Director *director;
@property (nonatomic, retain) NSSet *genres;
@property (nonatomic, retain) NSSet *halls;
@property (nonatomic, retain) Language *language;
@property (nonatomic, retain) NSSet *projections;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addActorsObject:(Actor *)value;
- (void)removeActorsObject:(Actor *)value;
- (void)addActors:(NSSet *)values;
- (void)removeActors:(NSSet *)values;

- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;

- (void)addHallsObject:(Hall *)value;
- (void)removeHallsObject:(Hall *)value;
- (void)addHalls:(NSSet *)values;
- (void)removeHalls:(NSSet *)values;

- (void)addProjectionsObject:(Projection *)value;
- (void)removeProjectionsObject:(Projection *)value;
- (void)addProjections:(NSSet *)values;
- (void)removeProjections:(NSSet *)values;

@end
