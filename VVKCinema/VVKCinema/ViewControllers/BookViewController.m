//
//  BookViewController.m
//  VVKCinema
//
//  Created by Valeri Manchev on 6/20/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "BookViewController.h"
#import "SeatPickerControl.h"
#import "VVKCinemaInfo.h"
#import "LoginViewController.h"
#import "Projection.h"
#import "Seat.h"
#import "ParseInfo.h"
#import "DropTicketViewController.h"
#import "DropTransitionAnimator.h"
#import "Hall.h"

@interface BookViewController () <ParseInfoDelegate, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularLabel;
@property (weak, nonatomic) IBOutlet UIStepper *regularStepper;
@property (weak, nonatomic) IBOutlet UILabel *regularCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentLabel;
@property (weak, nonatomic) IBOutlet UIStepper *studentStepper;
@property (weak, nonatomic) IBOutlet UILabel *studentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentPriceLabel;
@property (weak, nonatomic) IBOutlet SeatPickerControl *seatPicker;

@end

@implementation BookViewController {
    double regularCount;
    double studentCount;
    double totalCount;
//    NSNumber *column;
//    NSNumber *row;
    NSString *seatObjectId;
    NSMutableArray *selectedSeatsArray;
    int currentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    currentIndex = 0;
    
    self.regularLabel.text = [NSString stringWithFormat:@"REGULAR"];
    self.studentLabel.text = [NSString stringWithFormat:@"STUDENT"];
    
    regularCount = 2;
    studentCount = 0;
    
    totalCount = regularCount + studentCount;
    
    self.totalLabel.text = [NSString stringWithFormat:@"TOTAL %.f tickets", totalCount];
    self.regularCountLabel.text = [NSString stringWithFormat:@"%.f", regularCount];
    self.studentCountLabel.text = [NSString stringWithFormat:@"%.f", studentCount];

    self.seatPicker.numberOfSeatsToBeSelected = totalCount;
    
    Projection *selectedProjection = [[VVKCinemaInfo sharedVVKCinemaInfo] selectedProjection];
    
    NSMutableArray *busySeatsArray = [NSMutableArray arrayWithCapacity:0];
    
    for (Seat *seat in selectedProjection.seats) {
        NSNumber *row = [NSNumber numberWithInteger:[seat.row integerValue]];
        NSNumber *column = [NSNumber numberWithInteger:[seat.column integerValue]];
        
        NSInteger seatNumber = [row integerValue] * 10 + [column integerValue];
        NSLog(@"%ld", (long)seatNumber);
        
        [busySeatsArray addObject:[NSNumber numberWithInteger:seatNumber]];
    }
    
    self.seatPicker.busySeats = busySeatsArray;
    
    [self.seatPicker setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookTicket) name:@"BookedNewTicket" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BookedNewTicket" object:nil];
}

- (void)bookTicket {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];
    
    if ( self.regularStepper.value + self.studentStepper.value < 6 ) {
        if ( sender.tag == 0 ) {
            regularCount = value;
            
            self.regularCountLabel.text = [NSString stringWithFormat:@"%.f", regularCount];
        } else {
            studentCount = value;
            
            self.studentCountLabel.text = [NSString stringWithFormat:@"%.f", studentCount];
        }
    }
    
    totalCount = regularCount + studentCount;
    
    self.seatPicker.numberOfSeatsToBeSelected = totalCount;
    
    self.totalLabel.text = [NSString stringWithFormat:@"TOTAL %.f tickets", totalCount];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showLoginVC
{
    LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    beView.frame = self.view.bounds;
    
    loginVC.view.frame = self.view.bounds;
    loginVC.view.backgroundColor = [UIColor clearColor];
    [loginVC.view insertSubview:beView atIndex:0];
    loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:loginVC animated:NO completion:nil];
}

- (IBAction)bookSeats:(id)sender {
    currentIndex = 0;
    
    if ( ![[VVKCinemaInfo sharedVVKCinemaInfo] currentUser] ) {
        [self showLoginVC];
    } else {
        selectedSeatsArray = [self.seatPicker selectedSeats];
        
        ParseInfo *parseInfo = [ParseInfo sharedParse];
        parseInfo.delegate = self;
        
        for (NSNumber *selectedSeat in selectedSeatsArray) {
            NSNumber *column = [NSNumber numberWithInteger:[selectedSeat integerValue] % 10];
            
            NSNumber *row = [NSNumber numberWithInteger:[selectedSeat integerValue] / 10];
            
            [parseInfo bookNewSeatToParseWithColumn:column row:row andProjectionId:[[[VVKCinemaInfo sharedVVKCinemaInfo] selectedProjection] parseId]];
        }
    }
    
    [self showReservedTicket];
}

- (void)userDidPostSuccessfully:(BOOL)isSuccessful {
    NSNumber *selectedSeat = selectedSeatsArray[currentIndex];
    
    NSNumber *column = [NSNumber numberWithInteger:[selectedSeat integerValue] % 10];
    
    NSNumber *row = [NSNumber numberWithInteger:[selectedSeat integerValue] / 10];
    
    NSDictionary *seatResultsDictionary = [[ParseInfo sharedParse] getSeatWithClassName:@"Seat" column:column row:row fromProjection:[[[VVKCinemaInfo sharedVVKCinemaInfo] selectedProjection] parseId]];
    
    for (id seatResultsDictionaryKey in seatResultsDictionary) {
        NSDictionary *seatDictionary = seatResultsDictionary[seatResultsDictionaryKey];
        
        for (id seatDict in seatDictionary) {
            seatObjectId = [seatDict objectForKey:@"objectId"];
            NSLog(@"%@", seatObjectId);

            NSString *seatColumn = [seatDict objectForKey:@"column"];
            NSLog(@"%@", seatColumn);

            NSString *seatRow = [seatDict objectForKey:@"row"];
            NSLog(@"%@", seatRow);
            
            ParseInfo *parseInfo = [ParseInfo sharedParse];
            parseInfo.delegate = self;
            
            [parseInfo bookNewTicketToParseWithSeat:seatObjectId ticketType:@"" andUserId:[[[VVKCinemaInfo sharedVVKCinemaInfo] currentUser] parseId]];
        }
    }
    
    currentIndex++;
}

#pragma mark - Navigation

- (IBAction)showReservedTicket
{
    DropTicketViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReservedTicket"];
    UIViewController *toVC = dvc;
    
    dvc.projectionTypeLabel.text = [[[[VVKCinemaInfo sharedVVKCinemaInfo] selectedProjection] hall] name];
    NSLog(@"%@", dvc.projectionTypeLabel.text);
    
    NSNumber *selectedSeat = selectedSeatsArray[0];
    NSNumber *row = [NSNumber numberWithInteger:[selectedSeat integerValue] / 10];
    
    dvc.rowLabel.text = [row stringValue];
    NSLog(@"%@", dvc.rowLabel.text);
    dvc.seatLabel.text = [selectedSeatsArray componentsJoinedByString:@", "];;
    NSLog(@"%@", dvc.seatLabel.text);
    
    toVC.modalPresentationStyle = UIModalPresentationCustom;
    toVC.transitioningDelegate = self;
    [self presentViewController:toVC animated:YES completion:nil];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"Drop"]) {
//        UIViewController *toVC = segue.destinationViewController;
//        toVC.modalPresentationStyle = UIModalPresentationCustom;
//        toVC.transitioningDelegate = self;
//    }
//}

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
    
    if ([presented isKindOfClass:[DropTicketViewController class]]) {
        DropTransitionAnimator *animator = [[DropTransitionAnimator alloc] init];
        animator.appearing = YES;
        animator.duration = 1.5;
        animationController = animator;
    }
    
    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id<UIViewControllerAnimatedTransitioning> animationController;
    
    if ([dismissed isKindOfClass:[DropTicketViewController class]]) {
        DropTransitionAnimator *animator = [[DropTransitionAnimator alloc] init];
        animator.appearing = NO;
        animator.duration = 3.0;
        animationController = animator;
    }
    
    return animationController;
}


@end
