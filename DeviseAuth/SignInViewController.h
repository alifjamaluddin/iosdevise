//
//  SignInViewController.h
//  DeviseAuth
//
//  Created by Justin Malone on 2/28/15.
//  Copyright (c) 2015 justinmalone.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface SignInViewController : UIViewController
<UITextFieldDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordButton;

- (IBAction)signIn:(id)sender;

- (IBAction)resetPassword:(id)sender;

@end
