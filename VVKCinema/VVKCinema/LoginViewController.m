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
#import "ParseInfo.h"
#import "User.h"
#import "AccountViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController() <ParseInfoDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

@implementation LoginViewController {
    NSString *fbEmail;
    NSString *fbName;
    NSString *fbPassword;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.facebookButton.layer.cornerRadius = self.facebookButton.frame.size.height /2;
    self.facebookButton.layer.masksToBounds = YES;
    self.facebookButton.layer.borderWidth = 0;
    
    self.registerButton.layer.cornerRadius = self.registerButton.frame.size.height /2;
    self.registerButton.layer.masksToBounds = YES;
    self.registerButton.layer.borderWidth = 0;
    
    if ( [[VVKCinemaInfo sharedVVKCinemaInfo] currentUser] ) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)loginButtonClicked:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"error %@",error);
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Cancelled");
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                [self fetchUserInfo];
            }
        }
    }];
}

- (void)userDidPostSuccessfully:(BOOL)isSuccessful {
    if ( [[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsUserWithClassName:@"User" andEmail:fbEmail] ) {
        NSArray *userArray = [[CoreDataInfo sharedCoreDataInfo] fetchUserWithEmail:fbEmail andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
            
        [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:userArray[0]];
    } else {
        User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
            
        newUser.parseId = fbPassword;
        newUser.name = fbName;
        newUser.password = fbPassword;
        newUser.email = fbEmail;
            
        [[CoreDataInfo sharedCoreDataInfo] saveContext:[[CoreDataInfo sharedCoreDataInfo] context]];
        
        [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:newUser];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fetchUserInfo {
    if ( [FBSDKAccessToken currentAccessToken] ) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if ( !error ) {
                 fbEmail = [result objectForKey:@"email"];
                 fbName = [result objectForKey:@"name"];
                 fbPassword = [result objectForKey:@"id"];
                 
                 ParseInfo *parseInfoClass = [ParseInfo sharedParse];
                 parseInfoClass.delegate = self;
                 
                 [parseInfoClass sendSignUpRequestToParseWithName:fbName password:fbPassword andEmail:fbEmail];
             }
             else {
                 NSLog(@"Error %@",error);
             }
         }];
    } else {
        NSLog(@"User is not Logged in");
    }
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
    
    NSDictionary *userDictionary = [[ParseInfo sharedParse] loginUserWithUsername:self.emailTextField.text andPassword:self.passwordTextField.text];
    
    if ( [[userDictionary objectForKey:@"code"] integerValue] == 101 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:@"Invalid login parameters!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }

    NSString *objectId = [userDictionary objectForKey:@"objectId"];
    NSString *username = [userDictionary objectForKey:@"username"];
    NSString *name = [userDictionary objectForKey:@"name"];
    NSString *email = [userDictionary objectForKey:@"email"];
    
    if ( [[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"User" WithId:objectId] ) {
        NSArray *userArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"User" objectId:objectId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
        
        [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:userArray[0]];
    } else {
        User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
        
        newUser.parseId = objectId;
        newUser.username = username;
        newUser.name = name;
        newUser.email = email;
        
        [[CoreDataInfo sharedCoreDataInfo] saveContext:[[CoreDataInfo sharedCoreDataInfo] context]];
        
        [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:newUser];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserLoggedIn" object:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
