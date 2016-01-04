//
//  FXFormProfilePasswordController.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 04/01/16.
//  Copyright © 2016 ievolutioned. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface FXFormProfilePasswordController : NSObject<FXForm>
@property (nonatomic, copy) NSString *Password;
@property (nonatomic, copy) NSString *PasswordReply;
@end
