//
//  VVKCinemaInfo.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/14/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "Projection.h"

@interface VVKCinemaInfo : NSObject

@property (strong, nonatomic) NSSortDescriptor *sortDescriptor;
@property (strong, nonatomic) NSString *sort;

@property (strong, nonatomic) NSPredicate *daysPredicate;
@property (strong, nonatomic) NSNumber *currentDay;

@property (strong, nonatomic) NSPredicate *typePredicate;
@property (strong, nonatomic) NSNumber *currentType;

@property (strong, nonatomic) NSNumber *ticketIndex;

@property (nonatomic) NSData *avatarImageData;

@property (strong, nonatomic) NSPredicate *genrePredicate;
@property (strong, nonatomic) NSNumber *currentGenre;

@property (strong, nonatomic) Movie *selectedMovie;
@property (strong, nonatomic) Projection *selectedProjection;
@property (strong, nonatomic) User *currentUser;

/**
 *  VVKCinemaInfo
 *
 *  @return singleton instance of type VVKCinemaInfo
 */
+ (id)sharedVVKCinemaInfo;

@end
