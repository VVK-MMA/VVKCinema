//
//  User.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/22/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ticket;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parseId;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSData * avatar;
@property (nonatomic, retain) NSSet *tickets;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addTicketsObject:(Ticket *)value;
- (void)removeTicketsObject:(Ticket *)value;
- (void)addTickets:(NSSet *)values;
- (void)removeTickets:(NSSet *)values;

@end
