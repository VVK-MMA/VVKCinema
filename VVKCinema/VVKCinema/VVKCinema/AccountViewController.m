//
//  AccountViewController.m
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/9/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "AccountViewController.h"
#import "TicketsView.h"

#define TICKET_HEIGHT 200

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
    
    self.title = @"Profile";
    
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
