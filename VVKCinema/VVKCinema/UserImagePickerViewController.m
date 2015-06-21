//
//  UserImagePickerViewController.m
//  VVKCinema
//
//  Created by AdrenalineHvata on 6/21/15.
//  Copyright (c) 2015 VVK. All rights reserved.
//

#import "UserImagePickerViewController.h"

@interface UserImagePickerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *selectPhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelBUtton;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak,nonatomic) IBOutlet UIImageView *userImageView;
@end

@implementation UserImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.takePhotoButton.layer.cornerRadius = self.takePhotoButton.frame.size.height /2;
    self.takePhotoButton.layer.masksToBounds = YES;
    self.takePhotoButton.layer.borderWidth = 0;
    
    self.selectPhotoButton.layer.cornerRadius = self.selectPhotoButton.frame.size.height /2;
    self.selectPhotoButton.layer.masksToBounds = YES;
    self.selectPhotoButton.layer.borderWidth = 0;
    
    self.cancelBUtton.layer.cornerRadius = self.cancelBUtton.frame.size.height /2;
    self.cancelBUtton.layer.masksToBounds = YES;
    self.cancelBUtton.layer.borderWidth = 0;       // Do any additional setup after loading the view.
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)takePhoto:(UIButton *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    } /*    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    */
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}
#pragma mark - UIImagePickerControlDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.cancelBUtton setImage:chosenImage forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
