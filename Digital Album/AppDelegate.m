//
//  AppDelegate.m
//  Digital Album
//
//  Created by Ernesto Carrion on 2/17/14.
//  Copyright (c) 2014 Salarion. All rights reserved.
//

#import "AppDelegate.h"
#import "AlbumsViewController.h"
#import <GADRequest.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Tests Ads
    /*[GADRequest request].testDevices = @[GAD_SIMULATOR_ID,
                                         @"74bd061215a350ef58419d4b5507e048910d18bb",
                                         @"22b4d67c6292a65a567949d9d1355a247e80ff17",
                                         @"9cbfc7702b83476e8e6d86f68deea0d30ed13660"];
     */
    [GADRequest request].testDevices = @[GAD_SIMULATOR_ID];
    
    AlbumsViewController * avc = [[AlbumsViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:avc];
    self.window.rootViewController = nav;
    [self styleNavigationBars];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


-(void)styleNavigationBars {
    
    UIImage * navImage = [UIImage imageNamed:@"nav2-background.png"];
    [[UINavigationBar appearance] setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    
    UIColor * color = [UIColor colorWithRed:73.0/255.0 green:47.0/255.0 blue:14.0/255.0 alpha:1];
    UIFont * font = [UIFont fontWithName:@"Noteworthy-Bold" size:22];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : color, NSFontAttributeName : font}];
    [[UINavigationBar appearance] setTintColor:color];
    
    font = [UIFont fontWithName:@"Noteworthy-Bold" size:18];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes: @{NSFontAttributeName : font } forState:UIControlStateNormal];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
