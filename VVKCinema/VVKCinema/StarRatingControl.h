//
//  AlbumsTableViewCell.h
//  HomeAssignment_v2
//
//  Created by Vladimir Kadurin on 4/17/15.
//  Copyright (c) 2015 Vladimir Kadurin. All rights reserved.
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
