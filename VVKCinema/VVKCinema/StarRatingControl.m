//
//  SongsTableViewCell.m
//  HomeAssignment_v2
//
//  Created by Vladimir Kadurin on 4/17/15.
//  Copyright (c) 2015 Vladimir Kadurin. All rights reserved.
//

#import "StarRatingControl.h"

#define kDefaultNumberOfStars 5
#define kStarPadding 5.0f

@interface StarRatingControl ()
@property (nonatomic) NSInteger numberOfStars;
@property (nonatomic) NSInteger currentIdx;
@property (strong, nonatomic) NSArray *stars;
@property (strong, nonatomic) UIImage *star;
@property (strong, nonatomic) UIImage *highlightedStar;
@end

@implementation StarRatingControl

- (NSArray *)stars
{
    if (!_stars) {
        _stars = [[NSArray alloc] init];
    }
    
    return _stars;
}

- (void)setupView {
	self.clipsToBounds = YES;
	self.currentIdx = -1;
	self.star = [UIImage imageNamed:@"star.png"];
	self.highlightedStar = [UIImage imageNamed:@"star_highlighted.png"];
	NSMutableArray *s = [NSMutableArray arrayWithCapacity:self.numberOfStars];
	for (int i=0; i<_numberOfStars; i++) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:self.star highlightedImage:self.highlightedStar];
		[self addSubview:imageView];
		[s addObject:imageView];
	}
	self.stars = [s copy];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		_numberOfStars = kDefaultNumberOfStars;
		[self setupView];
    }
    return self;
}

- (void)layoutSubviews {
	CGFloat width = (self.frame.size.width - (kStarPadding * (self.numberOfStars + 1))) / self.numberOfStars;
	CGFloat cellWidth = MIN(self.frame.size.height, width);
	CGFloat padding = (self.frame.size.width - (cellWidth * self.numberOfStars + (kStarPadding * (self.numberOfStars + 1)))) / 2.0f;
	
	[self.stars enumerateObjectsUsingBlock:^(UIImageView *star, NSUInteger idx, BOOL *stop) {
		star.frame = CGRectMake(padding + kStarPadding + idx * cellWidth + idx * kStarPadding, (self.frame.size.height - cellWidth) / 2, cellWidth, cellWidth);
	}];
}

#pragma mark - Handling touch

- (UIImageView*)starForPoint:(CGPoint)point {
	for (UIImageView *star in self.stars) {
		if (CGRectContainsPoint(star.frame, point)) {
			return star;
		}
	}
	return nil;
}

- (NSUInteger)indexForStarAtPoint:(CGPoint)point {
	return [self.stars indexOfObject:[self starForPoint:point]];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint point = [touch locationInView:self];	
	NSUInteger index = [self indexForStarAtPoint:point];
	if (index != NSNotFound) {
		[self setRating:index+1];
		if ([self.delegate respondsToSelector:@selector(starRatingControl:willUpdateRating:)]) {
			[self.delegate starRatingControl:self willUpdateRating:self.rating];
		}
	} else if (point.x < ((UIImageView *)[self.stars objectAtIndex:0]).frame.origin.x) {
		[self setRating:0];
		if ([self.delegate respondsToSelector:@selector(starRatingControl:willUpdateRating:)]) {
			[self.delegate starRatingControl:self willUpdateRating:self.rating];
		}
	}

	return YES;		
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
	[super cancelTrackingWithEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint point = [touch locationInView:self];

	NSUInteger index = [self indexForStarAtPoint:point];
	if (index != NSNotFound) {
		[self setRating:index + 1];
		if ([self.delegate respondsToSelector:@selector(starRatingControl:willUpdateRating:)]) {
			[self.delegate starRatingControl:self willUpdateRating:self.rating];
		}
	} else if (point.x < ((UIImageView*)[self.stars objectAtIndex:0]).frame.origin.x) {
		[self setRating:0];
		if ([self.delegate respondsToSelector:@selector(starRatingControl:willUpdateRating:)]) {
			[self.delegate starRatingControl:self willUpdateRating:self.rating];
		}
	}
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	if ([self.delegate respondsToSelector:@selector(starRatingControl:didUpdateRating:)]) {
		[self.delegate starRatingControl:self didUpdateRating:self.rating];
	}
	[super endTrackingWithTouch:touch withEvent:event];
}

#pragma mark - Rating property

- (void)setRating:(NSUInteger)rating {
	self.currentIdx = rating;
	[self.stars enumerateObjectsUsingBlock:^(UIImageView *star, NSUInteger idx, BOOL *stop) {
		star.highlighted = (idx < self.currentIdx);
	}];
}

- (NSUInteger)rating {
	return self.currentIdx;
}

@end
