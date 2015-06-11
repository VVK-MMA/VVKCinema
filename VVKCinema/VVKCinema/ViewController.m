//
//  ViewController.m
//  VVKCinema
//
//  Created by Valeri Manchev on 5/24/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "SortOptionsViewController.h"
#import "AccountViewController.h"
#import "AppDelegate.h"
#import "DaysViewController.h"
#import "TypeViewController.h"
#import "TransitionAnimator.h"
#import "GenreViewController.h"

@interface ViewController () <UICollectionViewDataSource, UIViewControllerTransitioningDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPredicate *predicate;
@property (weak, nonatomic) IBOutlet UICollectionView *moviesCollectionView;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

static NSString * const movieCellIdentifier = @"MovieCell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        [self alert]; */
    
    self.moviesCollectionView.dataSource = self;
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.title = @"VVK Cinema";
    
    
    
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
    
    //setup status bar
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.appDelegate.initialLaunch) {
        [self setupBackground];
        self.appDelegate.initialLaunch = NO;
    }
}
#pragma mark - Setters

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    request.fetchBatchSize = 5;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rate" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    request.predicate = self.predicate;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.moviesCollectionView insertItemsAtIndexPaths:@[newIndexPath]];
            break;
        case NSFetchedResultsChangeDelete:
            [self.moviesCollectionView deleteItemsAtIndexPaths:@[indexPath]];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.moviesCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            break;
        case NSFetchedResultsChangeMove: {
            [self.moviesCollectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        }
    }
}

#pragma mark - IBActions

- (IBAction)showSortVC:(UIBarButtonItem *)sender
{
    SortOptionsViewController *sovc = [self.storyboard instantiateViewControllerWithIdentifier:@"SortVC"];
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    beView.frame = self.view.bounds;
    
    sovc.view.frame = self.view.bounds;
    sovc.view.backgroundColor = [UIColor clearColor];
    [sovc.view insertSubview:beView atIndex:0];
    sovc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:sovc animated:NO completion:nil];
}

- (IBAction)showAccountVC:(UIBarButtonItem *)sender
{
    UINavigationController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountNC"];
    avc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //test
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:movieCellIdentifier forIndexPath:indexPath];
    
    //test
    Movie *movie = [[Movie alloc] init];
    
    cell.movie = movie;
    
    [self setupCell:cell];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Days"] || [segue.identifier isEqualToString:@"Type"] || [segue.identifier isEqualToString:@"Genre"]) {
        UIViewController *toVC = segue.destinationViewController;
        toVC.modalPresentationStyle = UIModalPresentationCustom;
        toVC.transitioningDelegate = self;
    }
}

- (IBAction)unwindToViewController:(UIStoryboardSegue *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    id<UIViewControllerAnimatedTransitioning> animationController;
    
    if ([presented isKindOfClass:[UINavigationController class]] &&
        [((UINavigationController *)presented).topViewController isKindOfClass:[DaysViewController class]]) {
        TransitionAnimator *animator = [[TransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = 0.35;
        animationController = animator;
    }
    else if ([presented isKindOfClass:[UINavigationController class]] &&
             [((UINavigationController *)presented).topViewController isKindOfClass:[TypeViewController class]]) {
        TransitionAnimator *animator = [[TransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = 0.35;
        animationController = animator;
    }else if ([presented isKindOfClass:[UINavigationController class]] &&
              [((UINavigationController *)presented).topViewController isKindOfClass:[GenreViewController class]]) {
        TransitionAnimator *animator = [[TransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = 0.35;
        animationController = animator;
    }
    
    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id<UIViewControllerAnimatedTransitioning> animationController;
    
    if ([dismissed isKindOfClass:[UINavigationController class]] &&
        [((UINavigationController *)dismissed).topViewController isKindOfClass:[DaysViewController class]]) {
        TransitionAnimator *animator = [[TransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = 0.35;
        animationController = animator;
    }
    else if ([dismissed isKindOfClass:[UINavigationController class]] &&
             [((UINavigationController *)dismissed).topViewController isKindOfClass:[TypeViewController class]]) {
        TransitionAnimator *animator = [[TransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = 0.35;
        animationController = animator;
    }else if ([dismissed isKindOfClass:[UINavigationController class]] &&
              [((UINavigationController *)dismissed).topViewController isKindOfClass:[GenreViewController class]]) {
        TransitionAnimator *animator = [[TransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = 0.35;
        animationController = animator;
    }
    return animationController;
}

#pragma mark - Helper Methods

- (void)setupCell:(MovieCell *)cell
{
    cell.layer.masksToBounds = NO;
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowRadius = 5.0f;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    cell.layer.shadowOpacity = 0.5f;
    
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.layer.shouldRasterize = YES;
}

- (void)setupBackground
{
    //first drape
    UIImage *drapeImage = [UIImage imageNamed:@"left.png"];
    
    CALayer *drape = [CALayer layer];
    drape.opaque = NO;
    drape.contents = (id)drapeImage.CGImage;
    drape.bounds = CGRectMake(0, 0, drapeImage.size.width, drapeImage.size.height);
    drape.position = CGPointMake(drape.bounds.size.width / 2,
                                 drapeImage.size.height / 2);
    [self.view.layer addSublayer:drape];
    
    CGPoint startPt = CGPointMake(drape.bounds.size.width / 2,
                                  drapeImage.size.height / 2);
    CGPoint endPt = CGPointMake(drape.bounds.size.width / -2,
                                drape.position.y);
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    anim.fromValue = [NSValue valueWithCGPoint:startPt];
    anim.toValue = [NSValue valueWithCGPoint:endPt];
    anim.repeatCount = 1;
    anim.duration = 1.5;
    
    //second drape
    UIImage *drapeImage2 = [UIImage imageNamed:@"right.png"];
    
    CALayer *drape2 = [CALayer layer];
    drape2.opaque = NO;
    drape2.contents = (id)drapeImage2.CGImage;
    drape2.bounds = CGRectMake(0, 0, drapeImage2.size.width, drapeImage2.size.height);
    drape2.position = CGPointMake(drape2.bounds.size.width / 2 - 20,
                                  drapeImage2.size.height / 2);
    [self.view.layer addSublayer:drape2];
    
    CGPoint endPt2 = CGPointMake(self.view.bounds.size.width + drape2.bounds.size.width / 2,
                                 drape2.position.y);
    CGPoint startPt2 = CGPointMake(drape2.bounds.size.width / 2 - 20,
                                   drapeImage2.size.height / 2);
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"position"];
    anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    anim2.fromValue = [NSValue valueWithCGPoint:startPt2];
    anim2.toValue = [NSValue valueWithCGPoint:endPt2];
    anim2.repeatCount = 1;
    anim2.duration = 1.5;
    
    double delayInSeconds1 = 0.5;
    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds1 * NSEC_PER_SEC));
    dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
        [drape addAnimation:anim forKey:@"position"];
        [drape2 addAnimation:anim2 forKey:@"position"];
    });
    
    double delayInSeconds = 1.8;
    dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
        [drape removeFromSuperlayer];
        [drape2 removeFromSuperlayer];
    });
}
#pragma mark - Helper methods

- (void)alert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"There was a problem with the database. Fetch could not be performed!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
