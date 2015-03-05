//
//  SignInViewController.m
//  DeviseAuth
//
//  Created by Justin Malone on 2/28/15.
//  Copyright (c) 2015 justinmalone.co. All rights reserved.
//

#import "SignInViewController.h"
#import "User.h"

@interface SignInViewController ()

@end

@implementation SignInViewController
{
    BOOL _resetPassword;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:.2 alpha:.4]};
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your email..." attributes:attributes];
    
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your password..." attributes:attributes];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.signInButton.enabled = [self validInput];
    
}


//------------------------------------------------



- (BOOL)validInput
{
//    return [self.emailTextField.text length]>0 && [self.passwordTextField.text length]>5 && [self.emailTextField.text isValidEMail];
    return true;
}


//------------------------------------------------



#pragma mark -

- (IBAction)signIn:(id)sender {
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    User *user = [[User alloc] init];
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    
    if( ![user hasValidEmail] )
    {
        [[UIApplication sharedApplication] showAlertWithTitle:@"Notice" message:@"Email is not valid."];
        
    }
    else if( ![user hasValidPassword] )
    {
        [[UIApplication sharedApplication] showAlertWithTitle:@"Notice" message:@"Password must contain 6 - 20 characters."];
    }
    else
    {
        [HAKAuthentication authenticate:user];
    }
}


//------------------------------------------------


- (IBAction)resetPassword:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need Password Help?"
                                                    message:@"We will email you instructions explaining how to reset it!"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Send", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"your email address...";
    [alert textFieldAtIndex:0].clearsOnBeginEditing = NO;
    if( self.emailTextField.text ){
        [alert textFieldAtIndex:0].text = self.emailTextField.text;
    }
    [alert show];
}


//------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//------------------------------------------------

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return [[alertView textFieldAtIndex:0].text isValidEMail];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( buttonIndex == 1  ){
        NSDictionary *params = @{@"email":[alertView textFieldAtIndex:0].text};
        
        [[HAKApiClient sharedClient] putPath:@"forgot_password.json"
                                  parameters:params
                                     success:^(AFHTTPRequestOperation *operation, id JSON){
                                         NSLog(@"%@",JSON);
                                         [[UIApplication sharedApplication] showAlertWithTitle:@"Notice" message:@"Password reset, check your email for instructions."];
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [HAKAuthentication setPassword:nil];
                                         NSLog(@"%@",error.localizedDescription);
                                         
                                         id JSON = nil;
                                         NSString *server_error = [error.userInfo objectForKey: NSLocalizedRecoverySuggestionErrorKey];
                                         if( server_error){
                                             NSLog(@"%@",server_error);
                                             NSError *_error =nil;
                                             NSData *data = [server_error dataUsingEncoding:NSUTF8StringEncoding];
                                             JSON = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:0
                                                                                      error:&_error];
                                         }
                                         NSLog(@"%@",JSON);
                                         NSString *msg = [[JSON objectForKey:@"error"] objectForKey:@"message"];
                                         if( !msg ){
                                             msg = error.localizedDescription;
                                         }
                                         [[UIApplication sharedApplication] showAlertWithTitle:@"Notice" message:msg];
                                     }];
        
    }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if( [self validInput] ){
        self.signInButton.enabled = YES;
    }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if( [self validInput] ){
        self.signInButton.enabled = YES;
        [self signIn:self.signInButton];
    }
    return NO;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if( [self validInput] ){
        self.signInButton.enabled = YES;
    }
    return YES;
}


@end
