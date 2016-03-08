//
//  FXFormProfileController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 20/11/15.
//  Copyright © 2015 ievolutioned. All rights reserved.
//

#import "FXFormProfileController.h"

@implementation FXFormProfileController



- (NSArray *)fields
{
    self.NumerodeEmpleado = @"";
    self.Nombre = @"";
    self.Correo = @"";
    self.Departamento = @"";
    self.Divp = @"";
    self.Planta = @"";
    self.TipoDeEmpleado = @"";
    self.FechaDeIngreso = @"";
    self.FechasDeVacaciones = @"";
    self.empleadonumber = @"-";

    return @[
             
              @{FXFormFieldTitle: @"Número de empleado",FXFormFieldKey:@"NumerodeEmpleado", FXFormFieldDefaultValue:self.NumerodeEmpleado,@"userInteractionEnabled": @(NO)}
             ,
                         @{FXFormFieldKey: @"Nombre",FXFormFieldDefaultValue:self.Nombre ,@"userInteractionEnabled": @(NO)},
             
             @{FXFormFieldKey: @"Correo",FXFormFieldDefaultValue:self.Correo},
             
             @{FXFormFieldKey: @"Departamento",FXFormFieldDefaultValue:self.Departamento,@"userInteractionEnabled": @(NO)},
             
             @{FXFormFieldKey: @"Divp",FXFormFieldDefaultValue:self.Divp,@"userInteractionEnabled": @(NO)},
             
             @{FXFormFieldKey: @"Planta",FXFormFieldDefaultValue:self.Planta,@"userInteractionEnabled": @(NO)},
             
             @{FXFormFieldTitle: @"Tipo de empleado",FXFormFieldKey:@"TipoDeEmpleado",FXFormFieldDefaultValue:self.TipoDeEmpleado,@"userInteractionEnabled": @(NO)},
             
             @{FXFormFieldTitle: @"Fecha de ingreso",FXFormFieldKey:@"FechaDeIngreso",FXFormFieldDefaultValue:self.FechaDeIngreso,@"userInteractionEnabled": @(NO)},
             
             @{FXFormFieldTitle: @"Días de Vacaciones",FXFormFieldKey:@"FechasDeVacaciones",
               FXFormFieldDefaultValue:self.FechasDeVacaciones,@"userInteractionEnabled": @(NO)},
             
            // @{FXFormFieldTitle: @"Sing In", FXFormFieldHeader: @"", FXFormFieldAction: @"submitRegistrationForm:"},
             
             ];
}

- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    
}

@end
