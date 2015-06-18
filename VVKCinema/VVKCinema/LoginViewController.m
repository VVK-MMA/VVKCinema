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
    
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.frame = CGRectMake((self.mainView.frame.size.width / 2) - 45, 270, 90, 90);
//    loginButton.layer.cornerRadius = loginButton.frame.size.height /2;
//    loginButton.layer.masksToBounds = YES;
//    loginButton.layer.borderWidth = 0;
//    
//    UILabel *dynamicFacebookLabel = [[UILabel alloc] init];
//    dynamicFacebookLabel.textColor = [UIColor whiteColor];
//    dynamicFacebookLabel.frame = CGRectMake((self.mainView.frame.size.width / 2) - 34, 368, 68, 18);
//    dynamicFacebookLabel.text = @"Facebook";
//    dynamicFacebookLabel.font = [UIFont systemFontOfSize:15];
//    [dynamicFacebookLabel setTextAlignment:NSTextAlignmentCenter];
    
//    loginButton.imageView.image = [UIImage imageNamed:@"facebook"];
//    loginButton.backgroundColor = [UIColor whiteColor];
//    loginButton.center = self.view.center;
    
//    [self.view addSubview:loginButton];
//    [self.view addSubview:dynamicFacebookLabel];
//    
//    if ([FBSDKAccessToken currentAccessToken]) {
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//             if (!error) {
//                 NSLog(@"fetched user:%@", result);
//             }
//         }];
//    }
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
                // Do work
                [self fetchUserInfo];
//                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
    }];
}

- (void)userDidSignUpSuccessfully:(BOOL)isSuccessful {
//    if ( isSuccessful ) {
        if ( [[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsUserWithClassName:@"User" andEmail:fbEmail] ) {
            NSArray *userArray = [[CoreDataInfo sharedCoreDataInfo] fetchUserWithEmail:fbEmail andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
            
            [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:userArray[0]];
        } else {
            User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
            
            newUser.parseId = fbPassword;
            newUser.name = fbName;
            newUser.password = fbPassword;
            newUser.email = fbEmail;
            //    newUser.createdAt = createdAt;
            //    newUser.sessionToken = sessionToken;
            //    newUser.updatedAt = updatedAt;
            
            [[CoreDataInfo sharedCoreDataInfo] saveContext:[[CoreDataInfo sharedCoreDataInfo] context]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectionsAddedToCoreData" object:nil];
            
            [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:newUser];
        }
//    }
    
//    AccountViewController *accountVC = [[AccountViewController alloc] init];
//    
//    [self presentModalViewController:accountVC animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fetchUserInfo {
    if ( [FBSDKAccessToken currentAccessToken] ) {
        NSLog(@"Token is available");
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if ( !error ) {
                 NSLog(@"Fetched User Information:%@", result);
                 
                 fbEmail = [result objectForKey:@"email"];
                 NSLog(@"%@", fbEmail);
                 
                 fbName = [result objectForKey:@"name"];
                 NSLog(@"%@", fbName);
                 
                 fbPassword = [result objectForKey:@"id"];
                 NSLog(@"%@", fbPassword);
                 
                 ParseInfo *parseInfoClass = [ParseInfo sharedParse];
                 parseInfoClass.delegate = self;
                 
                 [parseInfoClass sendSignUpRequestToParseWithName:fbName password:fbPassword andEmail:fbEmail];
                 
//                 if ( [[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsUserWithClassName:@"User" andEmail:email] ) {
//                     NSArray *userArray = [[CoreDataInfo sharedCoreDataInfo] fetchUserWithEmail:email andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
//                     
//                     [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:userArray[0]];
//                 } else {
//                     User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
//                     
//                     newUser.parseId = password;
//                     newUser.name = name;
//                     newUser.password = password;
//                     newUser.email = email;
//                     //    newUser.createdAt = createdAt;
//                     //    newUser.sessionToken = sessionToken;
//                     //    newUser.updatedAt = updatedAt;
//                     
//                     [[CoreDataInfo sharedCoreDataInfo] saveContext:[[CoreDataInfo sharedCoreDataInfo] context]];
//                     
//                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectionsAddedToCoreData" object:nil];
//                     
//                     [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:newUser];
//                 }
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
    NSLog(@"%@", userDictionary);
    
    if ( [[userDictionary objectForKey:@"code"] integerValue] == 101 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:@"Invalid login parameters!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }

    NSString *objectId = [userDictionary objectForKey:@"objectId"];
//    NSLog(@"%@", objectId);
    
    NSString *username = [userDictionary objectForKey:@"username"];
//    NSLog(@"%@", username);
    
    NSString *createdAt = [userDictionary objectForKey:@"createdAt"];
//    NSLog(@"%@", createdAt);
    
    NSString *sessionToken = [userDictionary objectForKey:@"sessionToken"];
//    NSLog(@"%@", sessionToken);
    
    NSString *updatedAt = [userDictionary objectForKey:@"updatedAt"];
//    NSLog(@"%@", updatedAt);
    
    NSString *name = [userDictionary objectForKey:@"name"];
    //    NSLog(@"%@", updatedAt);
    
    NSString *email = [userDictionary objectForKey:@"email"];
    //    NSLog(@"%@", updatedAt);
    
    if ( [[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"User" WithId:objectId] ) {
        NSArray *userArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"User" objectId:objectId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
        
        [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:userArray[0]];
    } else {
        User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
        
        newUser.parseId = objectId;
        newUser.username = username;
        newUser.name = name;
        newUser.email = email;
        //    newUser.createdAt = createdAt;
        //    newUser.sessionToken = sessionToken;
        //    newUser.updatedAt = updatedAt;
        
        [[CoreDataInfo sharedCoreDataInfo] saveContext:[[CoreDataInfo sharedCoreDataInfo] context]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ProjectionsAddedToCoreData" object:nil];
        
        [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:newUser];
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
//    NSArray *userArray = [[CoreDataInfo sharedCoreDataInfo] fetchUserWithEmail:self.emailTextField.text andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
//    
//    if ( userArray ) {
//        if ( [userArray count] == 0 ) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:@"Non-existing user!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            
//            [alert show];
//            
//            return;
//        }
//        
//        User *currentUser = userArray[0];
//        
//        if ( [currentUser.password isEqualToString:self.passwordTextField.text] ) {
//            [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:currentUser];
//            
//            [self dismissViewControllerAnimated:NO completion:nil];
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:@"Wrong Password!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            
//            [alert show];
//            
//            return;
//        }
//    }
}

@end
