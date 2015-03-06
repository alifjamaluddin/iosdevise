//
//  AppDelegate.m
//  DeviseAuth
//
//  Created by Justin Malone on 2/28/15.
//  Copyright (c) 2015 justinmalone.co. All rights reserved.
//

#import "AppDelegate.h"
#import "UICKeyChainStore.h"

// TODO: change this value
static  NSString *keyChainServiceId = @"com.example.github-token";


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupNotificationObservation];
    
    // Override point for customization after application launch.
    BOOL isLoggedIn = NO;    // from your server response
    
    NSString *storyboardId = isLoggedIn ? @"MainTabController" : @"SignInController";
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:storyboardId];
    
    return YES;
}

- (void)setupNotificationObservation
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveUserToken:)
                                                 name:@"UserSignInNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authorizeUser:)
                                                 name:@"UserSignUpNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutUser:)
                                                 name:@"UserSignOutNotification"
                                               object:nil];
}

- (void)saveUserToken:(NSNotification *) notification
{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService: keyChainServiceId];
    keychain[@"userToken"] = [notification.userInfo objectForKey:@"userToken"];
    dispatch_async(dispatch_get_main_queue(), ^{
            self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"MainTabController"];
    });
}

- (void)authorizeUser:(NSNotification *) notification
{
    NSError *error;
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/api/v1/users/sign_in.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *mapData = @{
                              @"user": @{
                                      @"email": [notification.userInfo objectForKey:@"email"],
                                      @"password": [notification.userInfo objectForKey:@"password"]
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
                                                    
                                                    if (  jsonResults[@"success"]) {
                                                        NSString *usertoken = jsonResults[@"token"];
                                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserSignInNotification"
                                                                                                            object:nil
                                                                                                          userInfo:@{@"userToken": usertoken}];
                                                    } else {
                                                        //check errors
                                                    }
                                                }];
    
    [loginTask resume];
}

- (void)logoutUser:(NSNotification *) notification
{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService: keyChainServiceId];
    keychain[@"userToken"] = nil;
    
    self.window.rootViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"SignInController"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
