//
//  MovieCell.m
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/9/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "MovieCell.h"
#import "RatingView.h"

@interface MovieCell()
@property (weak, nonatomic) IBOutlet UIImageView *movieCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet RatingView *ratingView;
@end

@implementation MovieCell

- (void)setMovie:(Movie *)movie
{
    _movie = movie;
    
    //test
    self.movieCoverImageView.image = [UIImage imageNamed:@"entourage"];
    self.movieTitleLabel.text = @"Entourage";
    self.ratingView.numberOfStars = 4;
}

@end
