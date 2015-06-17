//
//  RegisterViewController.m
//  VVKCinema
//
//  Created by Valeri Manchev on 6/18/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "RegisterViewController.h"
#import "ParseInfo.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.avatarButton.layer.cornerRadius = self.avatarButton.frame.size.height /2;
    self.avatarButton.layer.masksToBounds = YES;
    self.avatarButton.layer.borderWidth = 0;
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)addPhoto:(id)sender {
}

- (IBAction)createUser:(id)sender {
    if ( [self.nameTextField.text isEqualToString:@""] || [self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:@"All fields are required!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }
    
    [[ParseInfo sharedParse] sendSignUpRequestToParseWithUsername:self.nameTextField.text password:self.passwordTextField.text andEmail:self.emailTextField.text];
}

@end
