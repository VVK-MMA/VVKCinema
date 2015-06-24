//
//  CoreDataInfo.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/15/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataInfo : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;

/**
 *  CoreDataInfo
 *
 *  @return singleton instance of type CoreDataInfo
 */
+ (id)sharedCoreDataInfo;

/**
 *  Save chosen context
 *
 *  @param context context that we want to save
 */
- (void)saveContext:(NSManagedObjectContext *)context;

/**
 *  Check if object exist in Core Data
 *
 *  @param className className of the object
 *  @param value     value for the key
 *  @param key       key of the object
 *
 *  @return YES if the object exist and NO if not
 */
- (BOOL)isCoreDataContainsObjectWithClassName:(NSString *)className andValue:(NSString *)value forKey:(NSString *)key;

/**
 *  Take all objects from Core Data with chosen className
 *
 *  @param className className of the objects
 *
 *  @return array with all objects
 */
- (NSArray *)fetchAllObjectsWithClassName:(NSString *)className;

/**
 *  Take object from Core Data with chosen className and objectId
 *
 *  @param entityName entityName of the object
 *  @param objectId   objectId of the object
 *  @param context    context from where we search for
 *
 *  @return array with the object
 */
- (NSArray *)fetchObjectWithEntityName:(NSString *)entityName objectId:(NSString *)objectId andContext:(NSManagedObjectContext *)context;

/**
 *  Take User from Core Data with given email
 *
 *  @param email   email of the User
 *  @param context context from where we search for
 *
 *  @return array with the User
 */
- (NSArray *)fetchUserWithEmail:(NSString *)email andContext:(NSManagedObjectContext *)context;

/**
 *  Take all Projections from Core Data with date and movieId
 *
 *  @param date    date of the Projections
 *  @param movieId movieId of the Movie of the Projections
 *  @param context context from where we search for
 *
 *  @return array with all Projections
 */
- (NSArray *)fetchAllProjectionsWithDate:(NSString *)date movieId:(NSString *)movieId andContext:(NSManagedObjectContext *)context;

@end
