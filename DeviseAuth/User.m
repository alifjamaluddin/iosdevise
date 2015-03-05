//
//  User.m
//  DeviseAuth
//
//  Created by Justin Malone on 2/28/15.
//  Copyright (c) 2015 justinmalone.co. All rights reserved.
//

#import "User.h"

static const int PASSWORD_MIN = 6;
static const int PASSWORD_MAX = 20;

@implementation User

- (BOOL)hasValidEmail
{
    if (self.email.length == 0) {
        return NO;
    }
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    return [emailTest evaluateWithObject:self.email];
}

- (BOOL)hasValidPassword
{
    if (self.password.length == 0) {
        return NO;
    }
    
    if (self.password.length >= PASSWORD_MIN && self.password.length <= PASSWORD_MAX) {
        return YES;
    }
    return NO;
}

@end
