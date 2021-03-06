//
//  CoreDataInfo.m
//  VVKCinema
//
//  Created by Valeri Manchev on 6/15/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "CoreDataInfo.h"
#import "Movie.h"

#import <UIKit/UIKit.h>

@implementation CoreDataInfo

#pragma mark Class Methods

+ (id)sharedCoreDataInfo {
    static CoreDataInfo *sharedCoreDataInfo = nil;
    
    @synchronized(self) {
        if ( sharedCoreDataInfo == nil )
            sharedCoreDataInfo = [[self alloc] init];
    }
    
    return sharedCoreDataInfo;
}


#pragma mark Private Methods

- (instancetype)init {
    self = [super init];
    
    if ( self ) {
        self.context = [self getContext];
    }
    
    return self;
}

- (NSManagedObjectContext *)getContext {
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ( [delegate performSelector:@selector(managedObjectContext)] ) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (NSArray *)entitiesArrayFromRequest:(NSFetchRequest *)request {
    NSError *error = nil;
    
    NSArray *entitiesArray = [[[CoreDataInfo sharedCoreDataInfo] getContext] executeFetchRequest:request error:&error];
    
    if ( error ) {
        NSLog(@"%@: Error fetching context: %@", [self class], [error localizedDescription]);
        
        return nil;
    }
    
    return entitiesArray;
}


#pragma mark Public Methods

- (void)saveContext:(NSManagedObjectContext *)context {
    NSError *saveError = nil;
    
    if ( ![context save:&saveError] )
    {
        NSLog(@"Save did not complete successfully. Error: %@", [saveError localizedDescription]);
    }
}

- (BOOL)isCoreDataContainsObjectWithClassName:(NSString *)className andValue:(NSString *)value forKey:(NSString *)key {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:className];
    
    NSError *error = nil;
    
    NSArray *objects = [[[CoreDataInfo sharedCoreDataInfo] context] executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    else {
        for ( NSManagedObject *object in objects ) {
            if ( [[object valueForKey:[NSString stringWithFormat:@"%@", key]] isEqualToString:value] ) {
                return YES;
            }
        }
    }
    
    return  NO;
}

- (NSArray *)fetchAllObjectsWithClassName:(NSString *)className {
    return [self entitiesArrayFromRequest:[[NSFetchRequest alloc]initWithEntityName:className]];
}

- (NSArray *)fetchObjectWithEntityName:(NSString *)entityName objectId:(NSString *)objectId andContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:[NSString stringWithFormat:@"%@", entityName] inManagedObjectContext:context]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"parseId = '%@'", objectId]]];
    
    return [self entitiesArrayFromRequest:request];
}

- (NSArray *)fetchAllProjectionsWithDate:(NSString *)date movieId:(NSString *)movieId andContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"Projection" inManagedObjectContext:context]];
    
    NSString *startOfDay = [NSString stringWithFormat:@"%@.2015 00:00", date];
    NSString *endOfDay = [NSString stringWithFormat:@"%@.2015 23:59", date];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d.MM.yyyy HH:mm"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDate *startOfDayDate = [dateFormat dateFromString:startOfDay];
    NSDate *endOfDayDate = [dateFormat dateFromString:endOfDay];

    NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startOfDayDate, endOfDayDate];
    NSPredicate *moviePredicate = [NSPredicate predicateWithFormat:@"movie.parseId like %@", movieId];
    
    NSMutableArray *predicatesArray = [NSMutableArray arrayWithCapacity:0];
    
    [predicatesArray addObject:datePredicate];
    [predicatesArray addObject:moviePredicate];
    
    NSPredicate *combinePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];

    [request setPredicate:combinePredicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    
    return [self entitiesArrayFromRequest:request];
}

- (NSArray *)fetchUserWithEmail:(NSString *)email andContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"email = '%@'", email]]];
    
    return [self entitiesArrayFromRequest:request];
}

@end
