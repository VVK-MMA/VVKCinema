//
//  BookViewController.m
//  VVKCinema
//
//  Created by Valeri Manchev on 6/20/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "BookViewController.h"
#import "SeatPickerControl.h"

@interface BookViewController ()

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

- (IBAction)bookSeats:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
