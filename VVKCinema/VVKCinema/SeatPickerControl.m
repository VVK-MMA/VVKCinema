//
//  SongsTableViewCell.m
//  HomeAssignment_v2
//
//  Created by Vladimir Kadurin on 4/17/15.
//  Copyright (c) 2015 Vladimir Kadurin. All rights reserved.
//

#import "SeatPickerControl.h"

#define kDefaultNumberOfSeats 80
#define kSeatPadding 5.0f
#define kSeatsPerRow 10

@interface SeatPickerControl ()
@property (nonatomic) NSInteger numberOfSeats;
@property (nonatomic) NSInteger currentIdx;
@property (strong, nonatomic) NSArray *seats;
@property (strong, nonatomic) UIImage *seat;
@property (strong, nonatomic) UIImage *highlightedSeat;
@property (strong, nonatomic) UIImage *busySeat;

@property (strong, nonatomic) NSMutableArray *selectedSeats; //gives the indexes of the newly created seats
@end

@implementation SeatPickerControl

- (NSArray *)stars
{
    if (!_seats) {
        _seats = [[NSArray alloc] init];
    }
    
    return _seats;
}

- (NSMutableArray *)selectedSeats
{
    if (!_selectedSeats) {
        _selectedSeats = [[NSMutableArray alloc] init];
    }
    
    return _selectedSeats;
}

- (void)setupView {
	self.clipsToBounds = YES;
	self.currentIdx = -1;
	self.seat = [UIImage imageNamed:@"empty.png"];
	self.highlightedSeat = [UIImage imageNamed:@"current.png"];
    self.busySeat = [UIImage imageNamed:@"selected.png"];
	NSMutableArray *s = [NSMutableArray arrayWithCapacity:self.numberOfSeats];
	for (int i=0; i<_numberOfSeats; i++) {
        UIImageView *imageView;
        if ([self.busySeats containsObject:[NSNumber numberWithInt:i]]) {
            imageView = [[UIImageView alloc] initWithImage:self.busySeat];
        } else {
            imageView = [[UIImageView alloc] initWithImage:self.seat highlightedImage:self.highlightedSeat];
        }
		[self addSubview:imageView];
		[s addObject:imageView];
	}
	self.seats = [s copy];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		_numberOfSeats = kDefaultNumberOfSeats;
        _numberOfSeatsToBeSelected = 3;
        _busySeats = [[NSArray alloc] initWithObjects:@0, @3, @8, @9, @20, @21, @22, @33, @34, @79, nil];
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews {
	
    NSInteger cellWidth = 25;
    
    [self.stars enumerateObjectsUsingBlock:^(UIImageView *seat, NSUInteger idx, BOOL *stop) {
        NSInteger row = idx / kSeatsPerRow;
        seat.frame = CGRectMake( (idx - row * kSeatsPerRow) * (cellWidth + kSeatPadding), row * (cellWidth + kSeatPadding), cellWidth, cellWidth);
    }];
}

#pragma mark - Handling touch

- (UIImageView*)seatForPoint:(CGPoint)point {
	for (UIImageView *seat in self.seats) {
		if (CGRectContainsPoint(seat.frame, point)) {
			return seat;
		}
	}
	return nil;
}

- (NSUInteger)indexForSeatAtPoint:(CGPoint)point {
	return [self.seats indexOfObject:[self seatForPoint:point]];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint point = [touch locationInView:self];
    [self.selectedSeats removeAllObjects];
	NSUInteger index = [self indexForSeatAtPoint:point];
	if (index != NSNotFound) {
		[self setSelection:index];
	} else if (point.x < ((UIImageView *)[self.stars objectAtIndex:0]).frame.origin.x) {
		[self setSelection:0];
	}

	return YES;		
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
	[super cancelTrackingWithEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint point = [touch locationInView:self];

	NSUInteger index = [self indexForSeatAtPoint:point];
	if (index != NSNotFound) {
		[self setSelection:index];
	} else if (point.x < ((UIImageView *)[self.stars objectAtIndex:0]).frame.origin.x) {
		[self setSelection:0];
	}
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    [self.stars enumerateObjectsUsingBlock:^(UIImageView *seat, NSUInteger idx, BOOL *stop) {
        if (seat.highlighted == YES) {
            [self.selectedSeats addObject:[NSNumber numberWithInteger:idx]];
        }
    }];
    //test
    NSLog(@"...");
    for (NSNumber *num in self.selectedSeats) {
        NSLog(@"%ld", (long)[num integerValue]);
    }
}

#pragma mark - Selection property

- (void)setSelection:(NSUInteger)selection
{
    self.currentIdx = selection;
    __block NSInteger currentSelection = self.numberOfSeatsToBeSelected;
    
    [self.stars enumerateObjectsUsingBlock:^(UIImageView *seat, NSUInteger idx, BOOL *stop) {
        if (idx >= self.currentIdx && idx <= self.currentIdx + currentSelection - 1) {
            if ([self.busySeats containsObject:[NSNumber numberWithInteger:idx]]) {
                currentSelection++;
            } else {
                seat.highlighted = YES;
            }
        }
        else {
            seat.highlighted = NO;
        }
    }];
    
    NSInteger remainingSeats = 0;
    if ((self.currentIdx + currentSelection) > kDefaultNumberOfSeats) {
        remainingSeats = (self.currentIdx + currentSelection) - kDefaultNumberOfSeats;
        __block NSInteger count = 0;
        [self.stars enumerateObjectsUsingBlock:^(UIImageView *seat, NSUInteger idx, BOOL *stop) {
            if (![self.busySeats containsObject:[NSNumber numberWithInteger:idx]]) {
                seat.highlighted = YES;
                count++;
                if (count == remainingSeats) {
                    *stop = YES;
                }
            }
        }];
    }
}

- (NSUInteger)selection
{
	return self.currentIdx;
}

@end
