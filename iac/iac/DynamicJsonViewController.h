//
//  DynamicJsonViewController.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 11/03/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"
#import "MBProgressHUD.h"

@class MBProgressHUD;
@interface DynamicJsonViewController : UIViewController


@property (nonatomic, retain)  MBProgressHUD *HUD;


@property (nonatomic, strong) NSString *jsonName;
@property (nonatomic, strong) NSString *title;


@end
