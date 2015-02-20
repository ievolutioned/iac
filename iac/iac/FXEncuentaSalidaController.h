//
//  FXEncuentaSalidaController.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 19/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
@interface FXEncuentaSalidaController : NSObject<FXForm>
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) BOOL isotroempleo;
@property (nonatomic, assign) BOOL rememberMe;
@end
