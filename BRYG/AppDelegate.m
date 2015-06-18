//
//  AppDelegate.m
//  BRYG
//
//  Created by Ahmed Omer on 16/06/2015.
//  Copyright (c) 2015 Ahmed Omer. All rights reserved.
//

#import "AppDelegate.h"
#import "BRYGWelcomeViewController.h"
#import "BRYGBoardViewController.h"

#import <Appirater/Appirater.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appirater setAppId:@"1007459535"];
    [Appirater setDebug:NO];
    
    [Fabric with:@[CrashlyticsKit]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [self loadGamePlay:NO];
    }
    
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self loadWelcomeScreen];
    }
    
    [self.window makeKeyAndVisible];
    
    [Appirater appLaunched:YES];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [Appirater appEnteredForeground:YES];
}

- (void)loadGamePlay:(BOOL)animated
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BRYGBoardViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"GamePlayViewController"];
    
    if (animated)
    {
        [UIView transitionWithView:self.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.window.rootViewController = controller;
                        }
                        completion:^(BOOL finished) {
                            
                            [controller layoutBlocks];
                        }];
    }
    
    else
    {
        [self.window setRootViewController:controller];
        [controller layoutBlocks];
    }
}

- (void)loadWelcomeScreen
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BRYGWelcomeViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    
    [self.window setRootViewController:controller];
}

@end
