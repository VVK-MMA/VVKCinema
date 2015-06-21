//
//  SeatPickerControl.h
//  VVKCinema
//
//  Created by Vladimir Kadurin on 4/17/15.
//  Copyright (c) 2015 Vladimir Kadurin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeatPickerControl : UIControl

@property (nonatomic) NSUInteger numberOfSeatsToBeSelected; //how many tickets
@property (nonatomic) NSUInteger selection;
@property (nonatomic) NSArray *busySeats; //indexes of already busy seats

- (void)setupView;
- (NSMutableArray *)selectedSeats;

@end

