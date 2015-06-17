//
//  VVKCinemaInfo.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/14/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface VVKCinemaInfo : NSObject

@property (strong, nonatomic) NSSortDescriptor *sortDescriptor;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSPredicate *daysPredicate;
@property (strong, nonatomic) NSPredicate *typePredicate;
@property (strong, nonatomic) NSPredicate *genrePredicate;
@property (strong, nonatomic) NSString *selectedMovie;
@property (strong, nonatomic) User *currentUser;

+ (id)sharedVVKCinemaInfo;

@end
