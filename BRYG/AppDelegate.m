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
    [self updateSettingsBundleInfo];
    
    [Appirater setAppId:@"1007459535"];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setDebug:NO];
    
    [Fabric with:@[CrashlyticsKit]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [self loadGamePlay];
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

- (void)loadGamePlay
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BRYGBoardViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"GamePlayViewController"];
    
    [self.window setRootViewController:controller];
}

- (void)loadWelcomeScreen
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BRYGWelcomeViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
    
    [self.window setRootViewController:controller];
}

- (void)updateSettingsBundleInfo {
    
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    NSString *date = [[NSBundle mainBundle] infoDictionary][@"BuildDate"];
    
    [[NSUserDefaults standardUserDefaults] setObject:version
                                              forKey:@"version_preference"];
    
    [[NSUserDefaults standardUserDefaults] setObject:date
                                              forKey:@"date_preference"];
}

@end
