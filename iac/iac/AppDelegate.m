//
//  AppDelegate.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 19/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "AppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import "HomeViewcontroller.h"
#import "UiLeftPanelController.h"
#import "JASidePanelController.h"
#import "objc/message.h"

@interface AppDelegate () <UIApplicationDelegate>

@property (nonatomic, strong) HomeViewcontroller * det;
@property (strong, nonatomic) JASidePanelController *rootViewController;

@property (nonatomic) BOOL screenIsPortraitOnly;
@property (nonatomic) BOOL screenIsLansCapeOnly;

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
  [Crashlytics startWithAPIKey:@"2b0ffb50e0ea57df9f66aed239124e0a9117c7ac"];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UiLeftPanelController *leftPanel = [[UiLeftPanelController alloc] initWithStyle:UITableViewStylePlain];
    
    self.rootViewController = [[JASidePanelController alloc] init];
    self.rootViewController.shouldDelegateAutorotateToVisiblePanel = YES;
    
    self.rootViewController.leftPanel = [[UINavigationController alloc] initWithRootViewController:leftPanel];;
    
    self.rootViewController.leftFixedWidth = 240;
    
    HomeViewcontroller *dash = [[HomeViewcontroller alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dash];
    
    nav.navigationBar.translucent = NO;
    
    self.rootViewController.centerPanel = nav;
    
    
    [self.rootViewController showLeftPanelAnimated:NO];
    
    
    self.rootViewController.rightPanel = nil;
    
    
    
    self.window.rootViewController = self.rootViewController;;
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
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

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
        return NO;
    }



-(void)reverseLandCape

{
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    
    
    [UIApplication sharedApplication].statusBarOrientation = UIDeviceOrientationPortrait;
    
    
    
    // [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait];
    
    
    
    
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
       //objc_msgSend()
        //objc_msgSend([UIDevice currentDevice], @selector(setOrientation:),    UIDeviceOrientationPortrait );
        
    }
    
    
    
    
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    NSUInteger orientations = UIInterfaceOrientationMaskPortrait;
    if (self.screenIsPortraitOnly) {
        return UIInterfaceOrientationMaskPortrait;
    }
    else if (self.screenIsLansCapeOnly) {
        return UIInterfaceOrientationMaskLandscape;
    }
    else {
        if(self.window.rootViewController){
            
            UiLeftPanelController *leftPanel = (UiLeftPanelController *)self.window.rootViewController;
            
            
            
            UIViewController *presentedViewController = [[leftPanel.navigationController viewControllers] lastObject];
            orientations = [presentedViewController supportedInterfaceOrientations];
            
            if (presentedViewController != nil)
                NSLog(@"..");
        }
        return orientations;
    }
}


@end
