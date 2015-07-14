//
//  AppDelegate.m
//  HCPSalesAid
//
//  Created by cmholden on 26/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>


@interface AppDelegate ()

@end

@implementation AppDelegate{
    BOOL _isFullScreen;
}
#define BASE_URL "https://salesassetsappbc0c02b2a.us1.hana.ondemand.com/HCPSalesApp/"
//@"https://salesassetsapps0007106801trial.hanatrial.ondemand.com/HCPSalesApp/"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentBaseURL = [defaults objectForKey:@"baseurl"];
    NSString *currentDefBaseURL = @BASE_URL;
    
    
    [defaults setObject:currentDefBaseURL forKey:@"default_baseurl"];
    if( currentBaseURL == nil || [currentBaseURL isEqualToString:@""])
        [defaults setObject:currentDefBaseURL forKey:@"baseurl"];
    
    NSInteger tab = -1;
    [[NSUserDefaults standardUserDefaults] setInteger:tab forKey:@"selectedTab"];
    
    [defaults synchronize];
    // Add this if you only want to change Selected Image color
    // and/or selected image text
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setSelectedImageTintColor:[Utilities getSAPGold]];
     
     
     // Add this code to change StateNormal text Color,
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateNormal];
    
    // then if StateSelected should be different, you should add this code
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [Utilities getSAPGold]}
                                           forState:UIControlStateSelected];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    
    // repeat for every tab, but increment the index each time
    UITabBarItem *firstTab = [tabBar.items objectAtIndex:0];
    // also repeat for every tab
    firstTab.image = [[UIImage imageNamed:@"TabBar-Home-Inactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    firstTab.selectedImage = [[UIImage imageNamed:@"TabBar-Home-Active.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *secondTab = [tabBar.items objectAtIndex:1];
    // also repeat for every tab
    secondTab.image = [[UIImage imageNamed:@"TabBar-Favorites-Inactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    secondTab.selectedImage = [[UIImage imageNamed:@"TabBar-Favorites-Active.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UITabBarItem *thirdTab = [tabBar.items objectAtIndex:2];
    // also repeat for every tab
    thirdTab.image = [[UIImage imageNamed:@"TabBar-Forums-InActive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    thirdTab.selectedImage = [[UIImage imageNamed:@"TabBar-Forums-Active.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *fourthTab = [tabBar.items objectAtIndex:3];
    // also repeat for every tab
    fourthTab.image = [[UIImage imageNamed:@"TabBar-Menu-Inactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    fourthTab.selectedImage = [[UIImage imageNamed:@"TabBar-Menu-Active.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return YES;
}
//Allow rotate on video and pdf otherwise portrait
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if( [window.rootViewController.presentedViewController isKindOfClass:[MPMoviePlayerViewController class]] ||
       [window.rootViewController.presentedViewController isKindOfClass:[ReaderViewController class]] ){

        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
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
