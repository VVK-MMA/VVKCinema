//
//  VVKCinemaInfo.m
//  VVKCinema
//
//  Created by Valeri Manchev on 6/14/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "VVKCinemaInfo.h"

@implementation VVKCinemaInfo

#pragma mark Class Methods

+ (id)sharedVVKCinemaInfo {
    static VVKCinemaInfo *sharedVVKCinemaInfo = nil;
    
    @synchronized(self) {
        if ( sharedVVKCinemaInfo == nil )
            sharedVVKCinemaInfo = [[self alloc] init];
        
    }
    
    return sharedVVKCinemaInfo;
}

@end
