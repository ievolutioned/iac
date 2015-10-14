//
//  BaseViewController.m
//  ReeleaseNew
//
//  Created by Omar Guzmán on 11/18/14.
//  Copyright (c) 2014 iEvolutioned. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()
@property(nonatomic, strong) NSArray *settingsOptions;
@property (nonatomic, strong) UIImageView * lefttitle;
@property (nonatomic, strong) UITableView * settingsView;
@property (nonatomic, strong) UIButton * settingsButton;

@property (nonatomic, strong) UILabel * lblDate;
@property (nonatomic, strong) UILabel * lblTime;

@property(nonatomic, strong) UIPopoverController *popOver;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    }

-(void)checkAnimation
{
}
-(void)updateDateTimeLabels
{
   
}


-(IBAction)openSettings
{
 
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - hud
- (void)starthud
{
    NSLog(@"starthud");
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.labelText = @"Processing";
    self.HUD.detailsLabelText = @"Please wait...";
    
    
    [self.view addSubview:self.HUD];
    
    [self.HUD show:YES];
    
    
    
    [self.HUD bringSubviewToFront:self.HUD];
}
- (void)stophud
{
    NSLog(@"stophud");
    [self.HUD  hide:YES];
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

-(void)showMsg:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [alertView show];
}

#pragma mark - User Properties

+(void)setUserToken:(NSString *)UserToken
{
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    
    [defs setValue:UserToken forKey:@"setUserToken_3"];
    
    [defs setBool:YES forKey:@"currentUser_3"];
}

+(NSString *)UserToken
{
    NSDictionary *dic = [self UserData];
    
    return [dic objectForKey:@"admin_token"];
}

+(void)setUserData:(NSDictionary *)UserData
{
    
    [[NSUserDefaults standardUserDefaults] setObject:UserData forKey:@"UserData_3"];
    //...
   // NSDictionary * myDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"dictionaryKey"];
}

+(NSDictionary *)UserData
{
     return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserData_3"];
}



+(BOOL) isLogin
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL isUserLogged = ([defaults boolForKey:@"currentUser_3"]);
    
    return isUserLogged;
}

+(void) logOut
{
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    
    [defs setBool:NO forKey:@"currentUser_3"];
    
    //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserData_3"];
    
    
    [defs synchronize];
}

+(void) setLogin
{
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    
    [defs setBool:YES forKey:@"currentUser_3"];
    
    
}



@end
