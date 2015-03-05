//
//  SignUpViewController.m
//  DeviseAuth
//
//  Created by Justin Malone on 2/28/15.
//  Copyright (c) 2015 justinmalone.co. All rights reserved.
//

#import "SignUpViewController.h"
#import "User.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.formScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 568);
//    self.formScrollView.userInteractionEnabled = YES;
//    self.formScrollView.scrollEnabled = YES;
    //self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:.8];
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark -

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (IBAction)signUp:(id)sender {

    User *user = [[User alloc] init];
    
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    
    //    TODO: more validation
    if( ![user hasValidEmail] )
    {
        [[UIApplication sharedApplication] showAlertWithTitle:@"Good Sir or Madam..." message:@"Your email appears to be improperly entered."];
        
    }
    else if( ![user hasValidPassword] )
    {
        [[UIApplication sharedApplication] showAlertWithTitle:@"Notice" message:@"Password must contain 8 - 20 characters."];
    }
    else
    {
        //        HAKWebViewController *vc = [[HAKWebViewController alloc] initWithNibName:@"HAKWebViewController" bundle:nil];
        //        vc.url = [NSURL URLWithString:@"http://www.tailfeatherapp.com/terms"];
        //        HAK
        //        [self presentViewController:vc animated:YES completion:^{
        //           vc.toolbarItems
        //        }];
        
        
        NSDictionary *params = @{ @"user": @{
                                          @"email": user.email,
                                          @"password": user.password
                                          },
                                  @"user_profile": @{
                                          @"gender": user.gender
                                          }
                                  ,
                                  @"user_preferences": @{
                                          @"gender": user.lookingForGender
                                          }
                                  };
        
        [[HAKApiClient sharedClient] postPath:@"users.json"
                                   parameters:params
                                      success:^(AFHTTPRequestOperation *operation, id JSON){
                                          NSLog(@"%@",JSON);
                                          ((AppDelegate*)[UIApplication sharedApplication].delegate ).showFirstUserFlow = YES;
                                          [HAKAuthentication authenticate:user];
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"%@",error.localizedDescription);
                                          [[UIApplication sharedApplication] showAlertWithTitle:@"Notice" message:@" Error creating user"];
                                      }];
    }
}

@end
