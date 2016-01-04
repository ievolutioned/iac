//
//  FXFormProfilePasswordController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 04/01/16.
//  Copyright © 2016 ievolutioned. All rights reserved.
//

#import "FXFormProfilePasswordController.h"

@implementation FXFormProfilePasswordController



/*
 @property (nonatomic, copy) NSString *Password;
 @property (nonatomic, copy) NSString *PasswordReply;
 */



- (NSArray *)fields
{
    self.Password = @"";
    self.PasswordReply = @"";
    
    return @[
             
             //we want to add a group header for the field set of fields
             //we do that by adding the header key to the first field in the group//Transaccion
             /*
              Venta = 0,
              Renta,
              VentaRenta,
              
              
              */
             
             
             
             
             @{FXFormFieldKey: @"Contraseña (sin cambios)",FXFormFieldDefaultValue:self.Password}
             ,
             
             @{FXFormFieldKey: @"Confirmacion de contraseña",FXFormFieldDefaultValue:self.PasswordReply},
             
             ];
}

- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    
}



@end
