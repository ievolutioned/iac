//
//  EncuestaSalidaController.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 19/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "FXForms.h"
#import "MBProgressHUD.h"
#import "RSBarcodes.h"
@interface EncuestaSalidaController : FXFormViewController
{
    RSScannerViewController *scanner;
}

@property (nonatomic, retain)  MBProgressHUD *HUD;

@end
