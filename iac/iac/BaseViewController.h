//
//  BaseViewController.h
//  ReeleaseNew
//
//  Created by Omar Guzmán on 11/18/14.
//  Copyright (c) 2014 iEvolutioned. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class MBProgressHUD;
@interface BaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    
}

@property (nonatomic, retain)  MBProgressHUD *HUD;

- (void)starthud;
- (void)stophud;

+(void)setUserToken:(NSString *)UserToken;
+(NSString *)UserToken;

+(void)setUserData:(NSDictionary *)UserData;
+(NSDictionary *)UserData;

-(void)showMsg:(NSString *)msg;

+(BOOL) isLogin;
+(void) logOut;

+(void) setLogin;
+(void) setLogout;

@end
