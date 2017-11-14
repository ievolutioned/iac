//
//  AsistenciaFormViewController.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 20/02/17.
//  Copyright © 2017 ievolutioned. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"
#import "RSBarcodes.h"
#import "MBProgressHUD.h"

@interface AsistenciaFormViewController : FXFormViewController<UINavigationControllerDelegate, UIActionSheetDelegate,UIAlertViewDelegate>
{
    RSScannerViewController *scanner;
}

@property (nonatomic, retain)  MBProgressHUD *HUD;
@property (nonatomic, strong) NSString *inquest_id;
@property (nonatomic, strong) NSArray *jsonForm;
@property (nonatomic, strong) NSString *jsonName;
@property (nonatomic, strong) NSString *valueSelected;

@property (nonatomic, assign) BOOL cameraOpen;

@property (nonatomic, assign) int CurseIndex;
@end
