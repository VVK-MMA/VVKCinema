//
//  DropTransitionAnimator.h
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/21/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropTransitionAnimator : UIDynamicBehavior <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter = isAppearing) BOOL appearing;
@property (nonatomic, assign) NSTimeInterval duration;

@end
