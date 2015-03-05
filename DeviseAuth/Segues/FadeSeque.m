//
//  FadeSeque.m
//  DeviseAuth
//
//  Created by vanessa hutchison on 3/4/15.
//  Copyright (c) 2015 justinmalone.co. All rights reserved.
//

#import "FadeSeque.h"

@implementation FadeSeque

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self) {
        
    }
    return self;
}

- (void)perform
{
    //TODO: Fade
    
    [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
}

@end
