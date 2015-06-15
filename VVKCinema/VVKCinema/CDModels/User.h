//
//  User.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/12/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Ticket;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * parseId;
@property (nonatomic, retain) Ticket *tickets;

@end
