//
//  LoginViewController.m
//  VVKCinema
//
//  Created by Vladimir Kadurin on 6/9/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "LoginViewController.h"
#import "CoreDataInfo.h"
#import "User.h"
#import "VVKCinemaInfo.h"

@interface LoginViewController()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

#pragma mark - IBActions

- (IBAction)dismissVC:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)login:(id)sender {
    NSArray *userArray = [[CoreDataInfo sharedCoreDataInfo] fetchUserWithUsername:self.usernameTextField.text andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
    
    if ( userArray ) {
        User *currentUser = userArray[0];
        
        if ( [currentUser.password isEqualToString:self.passwordTextField.text] ) {
            [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:currentUser];
            
//            NSLog(@"%@", [[VVKCinemaInfo sharedVVKCinemaInfo] currentUser]);
            
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
    else {
//        for (User *user in users) {
//            if ( [user.userName isEqualToString:self.userNameTextField.text] ) {
//                if ( [user.password isEqualToString:self.passwordTextField.text] ) {
//                    //                    NSLog(@"Existing user");
//                    
//                    [[RentApartmentsInfo sharedRentApartmentsInfo] setUser:user];
//                    
//                    break;
//                }
//            }
//        }
//        
//        if ( [[RentApartmentsInfo sharedRentApartmentsInfo] user] == nil ) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong User!" message:@"The user is invalid!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            
//            [alert show];
//        }
    }
}

@end
