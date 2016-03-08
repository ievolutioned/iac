//
//  FaqController.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 13/01/16.
//  Copyright © 2016 ievolutioned. All rights reserved.
//

#import "BaseViewController.h"

@interface FaqController : BaseViewController<UIWebViewDelegate>
@property (nonatomic, copy) NSString *customUrl;
@property (nonatomic, assign) BOOL showBack;
@end
