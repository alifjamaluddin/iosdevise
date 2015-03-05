//
//  SignUpViewController.m
//  DeviseAuth
//
//  Created by Justin Malone on 2/28/15.
//  Copyright (c) 2015 justinmalone.co. All rights reserved.
//

#import "SignUpViewController.h"


@interface SignUpViewController ()

@end



@implementation SignUpViewController

@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self =[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.user = [[User alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.user = [[User alloc] init];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.signUpButton.enabled = [self validInput];
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)validInput
{
    return [self.user hasValidEmail] && [self.user hasValidPassword];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark -


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (IBAction)signUp:(id)sender {
    [self syncUserDataFromInput:nil];
    NSError *error;
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/api/v1/users.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *mapData = @{
                              @"user": @{
                                      @"email": self.user.email,
                                      @"password": self.user.password
                                      }
                              };
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionTask *loginTask = [urlSession dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error ){
                                                    if (error != nil) {
                                                        NSLog(@"%s", [error.localizedDescription UTF8String]);
                                                        //TODO: alert view with error
                                                        return;
                                                    }
                                                    
                                                    NSError *jsonError;
                                                    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                options:0
                                                                                                                  error:&jsonError];
                                                    NSLog(@"%@", jsonResults);
                                                    
                                                    if ( jsonResults[@"success"]) {
                                                        //TODO: redrect to auth
                                                    } else {
                                                        //check for errors
                                                    }
                                                }];
    
    [loginTask resume];

}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark TextField
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self syncUserDataFromInput:textField];
    if( [self validInput] ){
        self.signUpButton.enabled = YES;
    }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self syncUserDataFromInput:textField];
    [textField resignFirstResponder];
    if( [self validInput] ){
        self.signInButton.enabled = YES;
        [self signUp:self.signUpButton];
    }
    return NO;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self syncUserDataFromInput:textField];
    if( [self validInput] ){
        self.signUpButton.enabled = YES;
    }
    return YES;
}

- (void) syncUserDataFromInput:(UITextField *)textField
{
    if (!textField || textField == self.emailTextField) {
        self.user.email = self.emailTextField.text;
    }
    
    if (!textField || textField == self.passwordTextField) {
        self.user.password = self.passwordTextField.text;
    }
    
}
@end
