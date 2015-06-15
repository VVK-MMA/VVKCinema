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

+ (id)sharedCoreDataInfo;

- (void)saveContext:(NSManagedObjectContext *)context;

- (NSManagedObjectContext *)getContext;

- (BOOL)isCoreDataContainsObjectWithClassName:(NSString *)className WithId:(NSString *)objectId;

- (NSArray *)fetchAllObjectsWithClassName:(NSString *)className;

- (NSArray *)fetchObjectWithEntityName:(NSString *)entityName objectId:(NSString *)objectId andContext:(NSManagedObjectContext *)context;

@end
