//
//  TicketsView.m
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/11/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "TicketsView.h"

@interface TicketsView()

#define OFFSET_TOP 10.f
#define PAGE_PEAK 50.f
#define MINIMUM_ALPHA 0.5f
#define MINIMUM_SCALE 0.9f
#define TOP_OFFSET_HIDE 20.f
#define BOTTOM_OFFSET_HIDE 75.f
#define COLLAPSED_OFFSET 50.f

@property (nonatomic) UIScrollView *theScrollView;
@property (nonatomic) NSInteger selectedTicketIndex;
@property (nonatomic) NSInteger ticketsCount;
@property (nonatomic) NSMutableArray *tickets;
@property (nonatomic) NSRange visibleTickets;
@end

@implementation TicketsView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.delegate) {
        self.ticketsCount = [self.delegate numberOfTicketsForTicketsView:self];
    }
    
    self.visibleTickets = NSMakeRange(0, 0);
    
    [self.tickets removeAllObjects];
    
    for (NSInteger i=0; i<self.ticketsCount; i++) {
        [self.tickets addObject:[NSNull null]];
    }
    
    self.theScrollView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.theScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), (CGRectGetHeight(self.bounds)));
    [self addSubview:self.theScrollView];
    
    [self setTicketAtOffset:self.theScrollView.contentOffset];
    [self reloadVisibleTickets];
}

#pragma mark - setup methods
- (void)setup
{
    self.ticketsCount = 0;
    self.selectedTicketIndex = -1;
    
    self.tickets = [[NSMutableArray alloc] init];
    self.visibleTickets = NSMakeRange(0, 0);
    
    self.theScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.theScrollView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Page Selection
- (void)selectTicketAtIndex:(NSInteger)index
{
    if (index != self.selectedTicketIndex) {
        self.selectedTicketIndex = index;
        NSInteger visibleEnd = self.visibleTickets.location + self.visibleTickets.length;
        [self hideTicketsBehind:NSMakeRange(self.visibleTickets.location, index-self.visibleTickets.location)];
        if (index+1 < visibleEnd) {
            NSInteger start = index+1;
            NSInteger stop = visibleEnd-start;
            [self hideTicketsInFront:NSMakeRange(start,stop)];
        }
        self.theScrollView.scrollEnabled = NO;
    } else {
        self.selectedTicketIndex = -1;
        [self resetTickets];
    }
}

- (void)resetTickets
{
    NSInteger start = self.visibleTickets.location;
    NSInteger stop = self.visibleTickets.location + self.visibleTickets.length;
    [UIView beginAnimations:@"stackReset" context:nil];
    [UIView setAnimationDuration:.4f];
    for (NSInteger i=start;i < stop;i++) {
        UIView *page = [self.tickets objectAtIndex:i];
        page.layer.transform = CATransform3DMakeScale(MINIMUM_SCALE, MINIMUM_SCALE, 1.f);
        CGRect thisFrame = page.frame;
        thisFrame.origin.y = OFFSET_TOP + i * PAGE_PEAK;
        page.frame = thisFrame;
    }
    [UIView commitAnimations];
    self.theScrollView.scrollEnabled = YES;
}

- (void)hideTicketsBehind:(NSRange)backPages
{
    NSInteger start = backPages.location;
    NSInteger stop = backPages.location + backPages.length;
    [UIView beginAnimations:@"stackHideBack" context:nil];
    [UIView setAnimationDuration:.4f];
    for (NSInteger i=start;i <= stop;i++) {
        UIView *page = (UIView*)[self.tickets objectAtIndex:i];
        CGRect thisFrame = page.frame;
        NSInteger visibleIndex = i-self.visibleTickets.location;
        thisFrame.origin.y = self.theScrollView.contentOffset.y + TOP_OFFSET_HIDE + visibleIndex * COLLAPSED_OFFSET;
        page.frame = thisFrame;
    }
    [UIView commitAnimations];
}

- (void)hideTicketsInFront:(NSRange)frontPages
{
    NSInteger start = frontPages.location;
    NSInteger stop = frontPages.location + frontPages.length;
    [UIView beginAnimations:@"ticketsHideFront" context:nil];
    [UIView setAnimationDuration:.4f];
    for (NSInteger i = start; i < stop; i++) {
        UIView *page = (UIView*)[self.tickets objectAtIndex:i];
        CGRect thisFrame = page.frame;
        thisFrame.origin.y = self.theScrollView.contentOffset.y + 200 - BOTTOM_OFFSET_HIDE + i * COLLAPSED_OFFSET;
        page.frame = thisFrame;
    }
    [UIView commitAnimations];
}

#pragma mark - displaying tickets
- (void)reloadVisibleTickets
{
    NSInteger start = self.visibleTickets.location;
    NSInteger stop = self.visibleTickets.location + self.visibleTickets.length;
    
    for (NSInteger i = start; i < stop; i++) {
        UIView *page = [self.tickets objectAtIndex:i];
        
        if (i == 0 || [self.tickets objectAtIndex:i-1] == [NSNull null]) {
            page.layer.transform = CATransform3DMakeScale(MINIMUM_SCALE, MINIMUM_SCALE, 1.f);
        } else{
            [UIView beginAnimations:@"ticketsScrolling" context:nil];
            [UIView setAnimationDuration:.4f];
            page.layer.transform = CATransform3DMakeScale(MINIMUM_SCALE, MINIMUM_SCALE, 1.f);
            [UIView commitAnimations];
        }
    }
}

- (void)setTicketAtOffset:(CGPoint)offset
{
    if ([self.tickets count] > 0 ) {
        CGPoint start = CGPointMake(offset.x - CGRectGetMinX(self.theScrollView.frame), offset.y -(CGRectGetMinY(self.theScrollView.frame)));
        
        CGPoint end = CGPointMake(MAX(0, start.x) + CGRectGetWidth(self.bounds), MAX(OFFSET_TOP, start.y) + CGRectGetHeight(self.bounds));
        
        NSInteger startIndex = 0;
        for (NSInteger i=0; i < [self.tickets count]; i++) {
            if (PAGE_PEAK * (i+1) > start.y) {
                startIndex = i;
                break;
            }
        }
        
        NSInteger endIndex = 0;
        for (NSInteger i=0; i < [self.tickets count]; i++) {
            if ((PAGE_PEAK * i < end.y && PAGE_PEAK * (i + 1) >= end.y ) || i == [self.tickets count]-1) {
                endIndex = i + 1;
                break;
            }
        }
        
        startIndex = MAX(startIndex - 1, 0);
        endIndex = MIN(endIndex, [self.tickets count] - 1);
        CGFloat pagedLength = endIndex - startIndex + 1;
        
        if (self.visibleTickets.location != startIndex || self.visibleTickets.length != pagedLength) {
            _visibleTickets.location = startIndex;
            _visibleTickets.length = pagedLength;
            for (NSInteger i = startIndex; i <= endIndex; i++) {
                [self setTicketAtIndex:i];
            }
        }
    }
}

- (void)setTicketAtIndex:(NSInteger)index
{
    if (index >= 0 && index < [self.tickets count]) {
        UIView *page = [self.tickets objectAtIndex:index];
        if ((!page || (NSObject*)page == [NSNull null]) && self.delegate) {
            page = [self.delegate ticketsView:self ticketForIndex:index];
            [self.tickets replaceObjectAtIndex:index withObject:page];
            page.frame = CGRectMake(0.f, index * PAGE_PEAK, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            page.layer.zPosition = index;
        }
        
        if (![page superview]) {
            if ((index == 0 || [self.tickets objectAtIndex:index-1] == [NSNull null]) && index+1 < [self.tickets count]) {
                UIView *topPage = [self.tickets objectAtIndex:index+1];
                [self.theScrollView insertSubview:page belowSubview:topPage];
            } else {
                [self.theScrollView addSubview:page];
            }
            page.tag = index;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [page addGestureRecognizer:tap];
    }
}

#pragma mark - gesture recognizer
- (void)tapped:(UIGestureRecognizer*)sender
{
    
    UIView *page = [sender view];
    NSInteger index = [self.tickets indexOfObject:page];
    CGRect pageTouchFrame = page.frame;
    if (self.selectedTicketIndex == index) {
        pageTouchFrame.size.height = CGRectGetHeight(pageTouchFrame)-COLLAPSED_OFFSET;
    } else if (self.selectedTicketIndex != -1) {
        pageTouchFrame.size.height = COLLAPSED_OFFSET;
    } else if ( index+1 < [self.tickets count] ) {
        pageTouchFrame.size.height = PAGE_PEAK;
    }
    [self selectTicketAtIndex:index];
}


@end
