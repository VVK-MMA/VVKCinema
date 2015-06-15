//
//  RatingView.m
//  HomeAssignment2
//
//  Created by Vladimir Kadurin on 4/12/15.
//  Copyright (c) 2015 Vladimir Kadurin. All rights reserved.
//

#import "RatingView.h"

@interface RatingView()
@end

#define DISTANCE_COEFICIENT 0.38
#define OFFSET 11

@implementation RatingView

- (void)drawRect:(CGRect)rect
{
    NSInteger currentXOffset = OFFSET;
    NSInteger filledStars = 0;
    NSInteger starWidth = (self.frame.size.width - 20) / 5;
    
    if (starWidth > self.frame.size.height) {
        starWidth = self.frame.size.height;
    }
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [[UIColor blackColor] setStroke];
    [[UIColor yellowColor] setFill];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = 1;
    
    static CGFloat armRotation = M_PI * 2.0/5.0;
    CGFloat distance = starWidth * DISTANCE_COEFICIENT;
    
    for (int i = 0; i < 5; i++) {
        CGFloat angle = armRotation;
        CGPoint point = CGPointMake(currentXOffset, (self.frame.size.height - starWidth) / 2);
        [path moveToPoint:point];
        for (int i = 0; i < 5; i++) {
            point.x += (CGFloat)cos((double)angle)*distance;
            point.y += (CGFloat)sin((double)angle)*distance;
            [path addLineToPoint:point];
            angle -= armRotation;
            point.x += (CGFloat)cos((double)angle)*distance;
            point.y += (CGFloat)sin((double)angle)*distance;
            [path addLineToPoint:point];
            angle += armRotation * 2;
        }
        [path closePath];
        [path stroke];
        
        if (filledStars < self.numberOfStars) {
            [path fill];
            filledStars ++;
        }
        
        currentXOffset += starWidth + 1;
    }
}


@end
