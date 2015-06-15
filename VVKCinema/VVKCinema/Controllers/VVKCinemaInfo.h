//
//  VVKCinemaInfo.h
//  VVKCinema
//
//  Created by Valeri Manchev on 6/14/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVKCinemaInfo : NSObject

@property (strong, nonatomic) NSSortDescriptor *sortDescriptor;
@property (strong, nonatomic) NSPredicate *daysPredicate;
@property (strong, nonatomic) NSPredicate *typePredicate;
@property (strong, nonatomic) NSPredicate *genrePredicate;

+ (id)sharedVVKCinemaInfo;

@end
