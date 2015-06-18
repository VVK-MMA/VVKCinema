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

- (instancetype)init {
    self = [super init];
    
    if ( self ) {
        self.context = [self getContext];
    }
    
    return self;
}

- (void)saveContext:(NSManagedObjectContext *)context {
    NSError *saveError = nil;
    
    if ( ![context save:&saveError] )
    {
        NSLog(@"Save did not complete successfully. Error: %@", [saveError localizedDescription]);
    }
}

- (NSManagedObjectContext *)getContext {
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ( [delegate performSelector:@selector(managedObjectContext)] ) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (BOOL)isCoreDataContainsObjectWithClassName:(NSString *)className WithId:(NSString *)objectId {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:className];
    
    NSError *error = nil;
    
    NSArray *objects = [[[CoreDataInfo sharedCoreDataInfo] context] executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    else {
        for ( NSManagedObject *object in objects ) {
            if ( [[object valueForKey:@"parseId"] isEqualToString:objectId] ) {
                return YES;
            }
        }
    }
    
    return  NO;
}

- (BOOL)isCoreDataContainsUserWithClassName:(NSString *)className andEmail:(NSString *)email {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:className];
    
    NSError *error = nil;
    
    NSArray *objects = [[[CoreDataInfo sharedCoreDataInfo] context] executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    else {
        for ( NSManagedObject *object in objects ) {
            if ( [[object valueForKey:@"email"] isEqualToString:email] ) {
                return YES;
            }
        }
    }
    
    return  NO;
}

- (NSArray *)fetchAllObjectsWithClassName:(NSString *)className {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:className];
    
    NSError *error = nil;
    
    NSArray *objects = [[[CoreDataInfo sharedCoreDataInfo] getContext] executeFetchRequest:request error:&error];
    
    if ( error != nil ) {
        NSLog(@"%@", error);
        
        return nil;
    }
    
    return objects;
}

- (NSArray *)fetchObjectWithEntityName:(NSString *)entityName objectId:(NSString *)objectId andContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:[NSString stringWithFormat:@"%@", entityName] inManagedObjectContext:context]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"parseId = '%@'", objectId]];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *entitiesArray = [[[CoreDataInfo sharedCoreDataInfo] getContext] executeFetchRequest:request error:&error];
    
    if ( error ) {
        NSLog(@"%@: Error fetching context: %@", [self class], [error localizedDescription]);
        NSLog(@"entitiesArray: %@",entitiesArray);
        
        return nil;
    }
    
    return entitiesArray;
}

- (NSArray *)fetchUserWithEmail:(NSString *)email andContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"email = '%@'", email]];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    
    NSArray *entitiesArray = [[[CoreDataInfo sharedCoreDataInfo] getContext] executeFetchRequest:request error:&error];
    
    if ( error ) {
        NSLog(@"%@: Error fetching context: %@", [self class], [error localizedDescription]);
        NSLog(@"entitiesArray: %@",entitiesArray);
        
        return nil;
    }
    
    return entitiesArray;
}

@end
