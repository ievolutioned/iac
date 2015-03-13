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
    
    
    [self.rootViewController showLeftPanelAnimated:YES];
    
    
    self.rootViewController.rightPanel = nil;
    
    self.window.rootViewController = self.rootViewController;;
    
    [self.window makeKeyAndVisible];
    
    
    //[Poll save:@"this is a test" WithUserId:[[NSNumber alloc] initWithInt:20] Withinquestid:[[NSNumber alloc] initWithInt:20] WithResponse:@"{}" WithQuestion:@"{}" WithCreated:[NSDate date] WithUpdated:[NSDate date] issynched:[[NSNumber alloc] initWithInt:0]];
    
   // Poll *encuents = [Poll getPoolbyinquest_id:[[NSNumber alloc] initWithInt:20]];
    
    //NSLog(encuents.title);
    
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



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "ievolutioned.coredatesample2" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
