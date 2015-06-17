//
//  AccountViewController.m
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/9/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "AccountViewController.h"
#import "TicketsView.h"
#import "MapViewController.h"


#define TICKET_HEIGHT 200
#define OFFSET 40
#define TOP_OFFSET 25
#define SIDE_OFFSET 75

@interface AccountViewController() <TicketsViewDelegate>
@property (nonatomic) NSMutableArray *views;
@property (weak, nonatomic) IBOutlet TicketsView *ticketsView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@end

@implementation AccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        //change the font of the view controller's title
    CGRect frame = CGRectZero;
    UILabel *viewControllerTitle = [[UILabel alloc] initWithFrame:frame];
    viewControllerTitle.backgroundColor = [UIColor clearColor];
    viewControllerTitle.font = [UIFont fontWithName:@"Bradley Hand" size:28];
    viewControllerTitle.textAlignment = NSTextAlignmentCenter;
    viewControllerTitle.textColor = [UIColor whiteColor];
    viewControllerTitle.text = self.navigationItem.title;
    [viewControllerTitle sizeToFit];
    // emboss in the same way as the native title
    [viewControllerTitle setShadowColor:[UIColor lightGrayColor]];
    [viewControllerTitle setShadowOffset:CGSizeMake(0.9, - 1.3)];
    self.navigationItem.titleView = viewControllerTitle;
    
    //setup tickets view
    self.ticketsView.delegate = self;
    self.views = [[NSMutableArray alloc] init];
    //maximum 7 tickets can be shown
    for (int i=0;i<7;i++) {
        UIView *thisView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.ticketsView.bounds.size.width + 20, TICKET_HEIGHT)];
        [self.views addObject:thisView];
    }
    
    //test
    self.profileImageView.image = [UIImage imageNamed:@"photo"];
    [self prepareProfileImageView];
    self.nameLabel.text = @"Vladimir Kadurin";
    self.emailLabel.text = @"vladimirkadurin@gmail.com";
}

#pragma mark - IBActions

- (IBAction)backToMovies:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:self completion:nil];
}

- (IBAction)logout:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:self completion:nil];
}


#pragma mark - TicketsViewDelegate

- (UIView *)ticketsView:(TicketsView *)ticketsView ticketForIndex:(NSInteger)index
{
    UIView *viewToAdd = [self.views objectAtIndex:index];
    viewToAdd.layer.masksToBounds = YES;
    viewToAdd.opaque = NO;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"ticket"];
    imageView.frame = CGRectMake(0, 0, self.ticketsView.bounds.size.width + 20, TICKET_HEIGHT);
    [viewToAdd addSubview:imageView];
    
    UIFont *staticLabelsFont = [UIFont fontWithName:@"American Typewriter" size:14.0f];
    UIFont *dynamicLabelsFont = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:14.0f];;
    
    UILabel *movieTitleLabel = [[UILabel alloc] init];
    movieTitleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20.0f];
    movieTitleLabel.textColor = [UIColor blackColor];
    movieTitleLabel.adjustsFontSizeToFitWidth = YES;
    movieTitleLabel.minimumScaleFactor = 0.8;
    movieTitleLabel.textAlignment = NSTextAlignmentRight;
    
    UILabel *hallLabel = [[UILabel alloc] init];
    hallLabel.font = staticLabelsFont;
    hallLabel.textColor = [UIColor darkGrayColor];
    hallLabel.adjustsFontSizeToFitWidth = YES;
    hallLabel.minimumScaleFactor = 0.8;
    
    UILabel *rowLabel = [[UILabel alloc] init];
    rowLabel.font = staticLabelsFont;
    rowLabel.textColor = [UIColor darkGrayColor];
    rowLabel.adjustsFontSizeToFitWidth = YES;
    rowLabel.minimumScaleFactor = 0.8;
    
    UILabel *seatLabel = [[UILabel alloc] init];
    seatLabel.font = staticLabelsFont;
    seatLabel.textColor = [UIColor darkGrayColor];
    seatLabel.adjustsFontSizeToFitWidth = YES;
    seatLabel.minimumScaleFactor = 0.8;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = staticLabelsFont;
    dateLabel.textColor = [UIColor darkGrayColor];
    dateLabel.adjustsFontSizeToFitWidth = YES;
    dateLabel.minimumScaleFactor = 0.8;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = staticLabelsFont;
    timeLabel.textColor = [UIColor darkGrayColor];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.minimumScaleFactor = 0.8;

    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = staticLabelsFont;
    priceLabel.textColor = [UIColor darkGrayColor];
    priceLabel.adjustsFontSizeToFitWidth = YES;
    priceLabel.minimumScaleFactor = 0.8;
    
    UILabel *dynamicHallLabel = [[UILabel alloc] init];
    dynamicHallLabel.font = dynamicLabelsFont;
    dynamicHallLabel.textColor = [UIColor blackColor];
    dynamicHallLabel.adjustsFontSizeToFitWidth = YES;
    dynamicHallLabel.minimumScaleFactor = 0.8;
    
    UILabel *dynamicRowLabel = [[UILabel alloc] init];
    dynamicRowLabel.font = dynamicLabelsFont;
    dynamicRowLabel.textColor = [UIColor blackColor];
    dynamicRowLabel.adjustsFontSizeToFitWidth = YES;
    dynamicRowLabel.minimumScaleFactor = 0.8;
    
    UILabel *dynamicSeatsLabel = [[UILabel alloc] init];
    dynamicSeatsLabel.font = dynamicLabelsFont;
    dynamicSeatsLabel.textColor = [UIColor blackColor];
    dynamicSeatsLabel.adjustsFontSizeToFitWidth = YES;
    dynamicSeatsLabel.minimumScaleFactor = 0.8;
    
    UILabel *dynamicDateLabel = [[UILabel alloc] init];
    dynamicDateLabel.font = dynamicLabelsFont;
    dynamicDateLabel.textColor = [UIColor blackColor];
    dynamicDateLabel.adjustsFontSizeToFitWidth = YES;
    dynamicDateLabel.minimumScaleFactor = 0.8;
    
    UILabel *dynamicTimeLabel = [[UILabel alloc] init];
    dynamicTimeLabel.font = dynamicLabelsFont;
    dynamicTimeLabel.textColor = [UIColor blackColor];
    dynamicTimeLabel.adjustsFontSizeToFitWidth = YES;
    dynamicTimeLabel.minimumScaleFactor = 0.8;
    
    UILabel *dynamicPriceLabel = [[UILabel alloc] init];
    dynamicPriceLabel.font = dynamicLabelsFont;
    dynamicPriceLabel.textColor = [UIColor blackColor];
    dynamicPriceLabel.adjustsFontSizeToFitWidth = YES;
    dynamicPriceLabel.minimumScaleFactor = 0.8;
    
    //dynaic label
    movieTitleLabel.text = @"Jurassic World";
    [movieTitleLabel sizeToFit];
    movieTitleLabel.frame = CGRectMake(imageView.frame.size.width / 2 - movieTitleLabel.frame.size.width / 2, TOP_OFFSET, movieTitleLabel.frame.size.width, movieTitleLabel.frame.size.height);
    
    //static label. DON NOT CHANGE
    hallLabel.text = @"HALL";
    [hallLabel sizeToFit];
    hallLabel.frame = CGRectMake(SIDE_OFFSET, movieTitleLabel.frame.origin.y + movieTitleLabel.frame.size.height + 10, hallLabel.frame.size.width, hallLabel.frame.size.height);
    
    rowLabel.text = @"ROW";
    [rowLabel sizeToFit];
    rowLabel.frame = CGRectMake(hallLabel.frame.origin.x + hallLabel.frame.size.width + OFFSET, hallLabel.frame.origin.y, rowLabel.frame.size.width, rowLabel.frame.size.height);
    
    seatLabel.text = @"SEAT";
    [seatLabel sizeToFit];
    seatLabel.frame = CGRectMake(rowLabel.frame.origin.x + rowLabel.frame.size.width + OFFSET, hallLabel.frame.origin.y, seatLabel.frame.size.width, seatLabel.frame.size.height);
    
    dateLabel.text = @"DATE";
    [dateLabel sizeToFit];
    dateLabel.frame = CGRectMake(hallLabel.frame.origin.x, hallLabel.frame.origin.y + hallLabel.frame.size.height + 30, dateLabel.frame.size.width, dateLabel.frame.size.height);

    timeLabel.text = @"TIME";
    [timeLabel sizeToFit];
    timeLabel.frame = CGRectMake(rowLabel.frame.origin.x, dateLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height);
    
    priceLabel.text = @"PRICE";
    [priceLabel sizeToFit];
    priceLabel.frame = CGRectMake(seatLabel.frame.origin.x, dateLabel.frame.origin.y, priceLabel.frame.size.width, priceLabel.frame.size.height);
    
    //--------------------------------
    //dynamic labels. CHANGE TEXT HERE!
    dynamicHallLabel.text = @"4D";
    [dynamicHallLabel sizeToFit];
    dynamicHallLabel.frame = CGRectMake(hallLabel.frame.origin.x, hallLabel.frame.origin.y + hallLabel.frame.size.height + 3, dynamicHallLabel.frame.size.width, dynamicHallLabel.frame.size.height);
    
    dynamicRowLabel.text = @"6";
    [dynamicRowLabel sizeToFit];
    dynamicRowLabel.frame = CGRectMake(rowLabel.frame.origin.x, dynamicHallLabel.frame.origin.y, dynamicRowLabel.frame.size.width, dynamicRowLabel.frame.size.height);
    
    dynamicSeatsLabel.text = @"3, 4, 5";
    [dynamicSeatsLabel sizeToFit];
    dynamicSeatsLabel.frame = CGRectMake(seatLabel.frame.origin.x, dynamicHallLabel.frame.origin.y, dynamicSeatsLabel.frame.size.width, dynamicSeatsLabel.frame.size.height);
    
    //show only day and month without year because space is limited
    dynamicDateLabel.text = @"17.06";
    [dynamicDateLabel sizeToFit];
    dynamicDateLabel.frame = CGRectMake(dateLabel.frame.origin.x, dateLabel.frame.origin.y + dateLabel.frame.size.height + 3, dynamicDateLabel.frame.size.width, dynamicDateLabel.frame.size.height);
    
    dynamicTimeLabel.text = @"11:40";
    [dynamicTimeLabel sizeToFit];
    dynamicTimeLabel.frame = CGRectMake(timeLabel.frame.origin.x, dynamicDateLabel.frame.origin.y, dynamicTimeLabel.frame.size.width, dynamicTimeLabel.frame.size.height);
    
    dynamicPriceLabel.text = @"7.00lv";
    [dynamicPriceLabel sizeToFit];
    dynamicPriceLabel.frame = CGRectMake(priceLabel.frame.origin.x, dynamicDateLabel.frame.origin.y, dynamicPriceLabel.frame.size.width, dynamicPriceLabel.frame.size.height);
    //-------------------
    //dynamic labels end
    
    [viewToAdd addSubview:imageView];
    [viewToAdd addSubview:movieTitleLabel];
    [viewToAdd addSubview:hallLabel];
    [viewToAdd addSubview:rowLabel];
    [viewToAdd addSubview:seatLabel];
    [viewToAdd addSubview:dateLabel];
    [viewToAdd addSubview:timeLabel];
    [viewToAdd addSubview:priceLabel];
    
    [viewToAdd addSubview:dynamicHallLabel];
    [viewToAdd addSubview:dynamicRowLabel];
    [viewToAdd addSubview:dynamicSeatsLabel];
    [viewToAdd addSubview:dynamicDateLabel];
    [viewToAdd addSubview:dynamicTimeLabel];
    [viewToAdd addSubview:dynamicPriceLabel];
    
    return viewToAdd;
}

- (NSInteger)numberOfTicketsForTicketsView:(TicketsView *)ticketView
{
    //maximum 7 tickets can be shown
    return [self.views count];
}

#pragma mark - Helper methods

- (void)prepareProfileImageView
{
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.borderWidth = 3.0f;
}

@end
