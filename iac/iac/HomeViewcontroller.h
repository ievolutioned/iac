//
//  HomeViewcontroller.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 19/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "BaseViewController.h"
#import "EncuestaSalidaController.h"
#import "RSBarcodes.h"
@interface HomeViewcontroller : BaseViewController<UIWebViewDelegate>

{
    RSScannerViewController *scanner;
}
- (IBAction)dom1:(id)sender;
- (IBAction)dom2:(id)sender;
- (IBAction)dom3:(id)sender;
@property (nonatomic, copy) NSString *loaded;
@end
