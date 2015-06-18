//
//  StartRatingControl.h
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/18/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StarRatingDelegate;

@interface StarRatingControl : UIControl

@property (nonatomic) NSUInteger rating;
@property (weak, nonatomic)  id <StarRatingDelegate, NSObject> delegate;

@end

@protocol StarRatingDelegate

@optional
- (void)starRatingControl:(StarRatingControl *)control didUpdateRating:(NSUInteger)rating;
- (void)starRatingControl:(StarRatingControl *)control willUpdateRating:(NSUInteger)rating;

@end
