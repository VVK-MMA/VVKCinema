//
//  RegisterViewController.m
//  VVKCinema
//
//  Created by Valeri Manchev on 6/18/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "RegisterViewController.h"
#import "ParseInfo.h"
#import "UserImagePickerViewController.h"
#import "VVKCinemaInfo.h"
#import "CoreDataInfo.h"
#import "AccountViewController.h"

@interface RegisterViewController () <ParseInfoDelegate>

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avatarButton.layer.cornerRadius = self.avatarButton.frame.size.height /2;
    self.avatarButton.layer.masksToBounds = YES;
    self.avatarButton.layer.borderWidth = 0;
}

- (void)putImageToButton {
    if ( [[VVKCinemaInfo sharedVVKCinemaInfo] avatarImageData] ) {
        [self.avatarButton setImage:[UIImage imageWithData:[[VVKCinemaInfo sharedVVKCinemaInfo] avatarImageData]] forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(putImageToButton) name:@"ImageSelected" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ImageSelected" object:nil];
}

- (void)userDidPostSuccessfully:(BOOL)isSuccessful {
    if ( isSuccessful ) {
//        [self dismissViewControllerAnimated:NO completion:nil];
        
        //
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
        
        if ( [[CoreDataInfo sharedCoreDataInfo] isCoreDataContainsObjectWithClassName:@"User" andValue:objectId forKey:@"parseId"] ) {
            NSArray *userArray = [[CoreDataInfo sharedCoreDataInfo] fetchObjectWithEntityName:@"User" objectId:objectId andContext:[[CoreDataInfo sharedCoreDataInfo] context]];
            
            [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:userArray[0]];
        } else {
            User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[CoreDataInfo sharedCoreDataInfo] context]];
            
            newUser.parseId = objectId;
            newUser.username = username;
            newUser.name = name;
            newUser.email = email;
            newUser.avatar = UIImagePNGRepresentation([self.avatarButton imageForState:UIControlStateNormal]);
            
            [[CoreDataInfo sharedCoreDataInfo] saveContext:[[CoreDataInfo sharedCoreDataInfo] context]];
            
            [[VVKCinemaInfo sharedVVKCinemaInfo] setCurrentUser:newUser];
            
            //        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadyForTicketsTransfer" object:nil];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReadyForTicketsTransfer" object:nil];
        
        [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:@"Invalid register parameters!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }    
}

- (void)showAccountVC
{
    AccountViewController *accountVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Account"];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:accountVC];
    accountVC.modalTransitionStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)addPhoto:(id)sender {
    UserImagePickerViewController *uipvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserImage"];
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    beView.frame = self.view.bounds;
    
    uipvc.view.frame = self.view.bounds;
    uipvc.view.backgroundColor = [UIColor clearColor];
    [uipvc.view insertSubview:beView atIndex:0];
    uipvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:uipvc animated:NO completion:nil];
}

- (IBAction)createUser:(id)sender {
    if ( [self.nameTextField.text isEqualToString:@""] || [self.emailTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""] ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WARNING!" message:@"All fields are required!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }
    
    ParseInfo *parseInfoClass = [ParseInfo sharedParse];
    parseInfoClass.delegate = self;
    
    [parseInfoClass sendSignUpRequestToParseWithName:self.nameTextField.text password:self.passwordTextField.text andEmail:self.emailTextField.text];
}

@end
