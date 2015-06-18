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
