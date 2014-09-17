//
//  AppDelegate.m
//  infcor
//
//  Created by admin notte on 24/07/2014.
//  Copyright (c) 2014 ___calasoc___. All rights reserved.
//

#import "AppDelegate.h"
#import "prefsViewController.h"
#import "ViewController.h"


@implementation AppDelegate


- (id) shared:(NSString *)context
{
//  context.lng = "@co";
//    NSString *lng = @"co";
    return context;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setDefaultValuesForVariables];

    // Override point for customization after application launch.
    ViewController *VC = [[ViewController alloc] init];
    UINavigationController *navViewController = [[UINavigationController alloc] initWithRootViewController:VC];
    self.window.rootViewController = navViewController;
    [self.window makeKeyAndVisible];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
/*    NSURL *scriptUrl = [NSURL URLWithString:@"http://google.com"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (!data)
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pas de Connexion"
                                                        message:@"la banque INFCOR a besoin de se connecter à internet. Verifiez votre connexion"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }*/
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}

- (void)setDefaultValuesForVariables
{
  //  self.params = @"FRANCESE DEFINIZIONE SINONIMI TALIANU";
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
