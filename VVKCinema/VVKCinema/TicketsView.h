//
//  TicketsView.h
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/11/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TicketsViewDelegate;

@interface TicketsView : UIView

@property (nonatomic) id<TicketsViewDelegate> delegate;

@end

@protocol TicketsViewDelegate

- (UIView *)ticketsView:(TicketsView *)ticketsView ticketForIndex:(NSInteger)index;
- (NSInteger)numberOfTicketsForTicketsView:(TicketsView *)ticketsView;

@end
