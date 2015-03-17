//
//  FXFormLoginController.h
//  mapilu
//
//  Created by Hipolyto Obeso Huerta on 27/01/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface FXFormLoginController : NSObject<FXForm>
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;

@end
