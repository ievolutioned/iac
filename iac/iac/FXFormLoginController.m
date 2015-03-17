//
//  FXFormLoginController.m
//  mapilu
//
//  Created by Hipolyto Obeso Huerta on 27/01/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "FXFormLoginController.h"

@implementation FXFormLoginController



- (NSArray *)fields
{
    
    self.email = @"";
    self.password = @"";
    return @[
             
             //we want to add a group header for the field set of fields
             //we do that by adding the header key to the first field in the group//Transaccion
             /*
              Venta = 0,
              Renta,
              VentaRenta,
              
              
              */
             
             
             @{FXFormFieldKey: @"email",FXFormFieldDefaultValue:self.email, FXFormFieldHeader: @"Account"},
             @{FXFormFieldKey: @"password",FXFormFieldDefaultValue:self.password},
              @{FXFormFieldTitle: @"Sing In", FXFormFieldHeader: @"", FXFormFieldAction: @"submitRegistrationForm:"},
             
             ];
}

- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    
}

@end
