//
//  AccountViewController.m
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/9/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "AccountViewController.h"

@implementation AccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

#pragma mark - IBActions

- (IBAction)backToMovies:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:self completion:nil];
}

- (IBAction)logout:(UIBarButtonItem *)sender
{
    
}
@end
