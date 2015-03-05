//
//  SignUpViewController.h
//  DeviseAuth
//
//  Created by Justin Malone on 2/28/15.
//  Copyright (c) 2015 justinmalone.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface SignUpViewController : UIViewController
<UITextFieldDelegate>

@property (strong, nonatomic) User *user;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

- (IBAction)signUp:(id)sender;

@end
