//
//  BRYGWelcomeViewController.m
//  BRYG
//
//  Created by Ahmed Omer on 18/06/2015.
//  Copyright (c) 2015 Ahmed Omer. All rights reserved.
//

#import "AppDelegate.h"
#import "BRYGWelcomeViewController.h"

@implementation BRYGWelcomeViewController

- (IBAction)next
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [delegate loadGamePlay];
}

@end
