//
//  Movie.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/4/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country, Hall, Language, NSManagedObject;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * poster;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSNumber * subtitled;
@property (nonatomic, retain) NSSet *actors;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) NSManagedObject *director;
@property (nonatomic, retain) NSSet *genres;
@property (nonatomic, retain) NSSet *halls;
@property (nonatomic, retain) Language *language;
@property (nonatomic, retain) NSSet *projections;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addActorsObject:(NSManagedObject *)value;
- (void)removeActorsObject:(NSManagedObject *)value;
- (void)addActors:(NSSet *)values;
- (void)removeActors:(NSSet *)values;

- (void)addGenresObject:(NSManagedObject *)value;
- (void)removeGenresObject:(NSManagedObject *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;

- (void)addHallsObject:(Hall *)value;
- (void)removeHallsObject:(Hall *)value;
- (void)addHalls:(NSSet *)values;
- (void)removeHalls:(NSSet *)values;

- (void)addProjectionsObject:(NSManagedObject *)value;
- (void)removeProjectionsObject:(NSManagedObject *)value;
- (void)addProjections:(NSSet *)values;
- (void)removeProjections:(NSSet *)values;

@end
