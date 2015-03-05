//
//  User.h
//  DeviseAuth
//
//  Created by Justin Malone on 2/28/15.
//  Copyright (c) 2015 justinmalone.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSNumber * gender;
@property (nonatomic, strong) NSDate * dob;

- (BOOL)hasValidEmail;
- (BOOL)hasValidPassword;


@end
