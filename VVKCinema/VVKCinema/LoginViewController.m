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

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.facebookButton.layer.cornerRadius = self.facebookButton.frame.size.height /2;
    self.facebookButton.layer.masksToBounds = YES;
    self.facebookButton.layer.borderWidth = 0;
    
    self.registerButton.layer.cornerRadius = self.registerButton.frame.size.height /2;
    self.registerButton.layer.masksToBounds = YES;
    self.registerButton.layer.borderWidth = 0;
}

#pragma mark - IBActions

- (IBAction)dismissVC:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)login:(id)sender {
    if ( [self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:@"All fields are required!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }
    
    NSArray *userArray = [[CoreDataInfo sharedCoreDataInfo] fetchUserWithEmail:self.emailTextField.text andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
    
    if ( userArray ) {
        if ( [userArray count] == 0 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:@"Non-existing user!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        
        User *currentUser = userArray[0];
        
        if ( [currentUser.password isEqualToString:self.passwordTextField.text] ) {
            [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:currentUser];
            
            [self dismissViewControllerAnimated:NO completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:@"Wrong Password!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
    }
}

@end
