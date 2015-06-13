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
    
    NSURL *posterUrl = [NSURL URLWithString:movie.poster];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.myapp.processsmagequeue", NULL);
    dispatch_async(downloadQueue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:posterUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.movieCoverImageView.image = [UIImage imageWithData:imageData];
        });
    });
    
    self.movieTitleLabel.text = movie.name;
    self.ratingView.numberOfStars = [movie.rate stringValue];
}

-(void)prepareForReuse {
    self.movieCoverImageView.image = nil;
}

@end
