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

@interface BookViewController () <ParseInfoDelegate>

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
    NSNumber *column;
    NSNumber *row;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
        row = [NSNumber numberWithInteger:[seat.row integerValue]];
        column = [NSNumber numberWithInteger:[seat.column integerValue]];
        
        NSInteger seatNumber = [row integerValue] * 10 + [column integerValue];
        NSLog(@"%ld", (long)seatNumber);
        
        [busySeatsArray addObject:[NSNumber numberWithInteger:seatNumber]];
    }
    
    self.seatPicker.busySeats = busySeatsArray;
    
    [self.seatPicker setupView];
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
    if ( ![[VVKCinemaInfo sharedVVKCinemaInfo] currentUser] ) {
        [self showLoginVC];
    } else {
        NSNumber *selection = [NSNumber numberWithUnsignedInteger:self.seatPicker.selection];
        NSLog(@"%@", selection);
        
        column = [NSNumber numberWithInteger:[selection integerValue] % 10];
        NSLog(@"%@", column);
        
        row = [NSNumber numberWithInteger:[selection integerValue] / 10];
        NSLog(@"%@", row);
        
        ParseInfo *parseInfo = [ParseInfo sharedParse];
        parseInfo.delegate = self;
        
        [parseInfo bookNewSeatToParseWithColumn:column row:row andProjectionId:[[[VVKCinemaInfo sharedVVKCinemaInfo] selectedProjection] parseId]];
    }
}

- (void)userDidPostSuccessfully:(BOOL)isSuccessful {
//    NSDictionary *seatResultsDictionary = [[ParseInfo sharedParse] getSeatWithClassName:@"Seat" column:column row:row fromProjection:[[[VVKCinemaInfo sharedVVKCinemaInfo] selectedProjection] parseId]];
//    
//    for (id seatResultsDictionaryKey in seatResultsDictionary) {
//        NSDictionary *seatDictionary = seatResultsDictionary[seatResultsDictionaryKey];
//        
//        for (id seatDict in seatDictionary) {
//            NSString *seatObjectId = [seatDict objectForKey:@"objectId"];
//            NSLog(@"%@", seatObjectId);
//        }
//    }
    
//    [parseInfoClass bookNewTicketToParseWithSeat:<#(NSString *)#> ticketType:<#(NSString *)#> andUserId:<#(NSString *)#>:column row:row andProjectionId:[[[VVKCinemaInfo sharedVVKCinemaInfo] selectedProjection] parseId]];
}

@end
