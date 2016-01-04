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
    
    return @[
             
             //we want to add a group header for the field set of fields
             //we do that by adding the header key to the first field in the group//Transaccion
             /*
              Venta = 0,
              Renta,
              VentaRenta,
              
              
              */
            
             
             
             
             @{FXFormFieldKey: @"Número de empleado",FXFormFieldDefaultValue:self.NumerodeEmpleado}
             ,
             
             @{FXFormFieldKey: @"Nombre",FXFormFieldDefaultValue:self.Nombre},
             
             @{FXFormFieldKey: @"Correo",FXFormFieldDefaultValue:self.Correo},
             
             @{FXFormFieldKey: @"Departamento",FXFormFieldDefaultValue:self.Departamento},
             
             @{FXFormFieldKey: @"Divp",FXFormFieldDefaultValue:self.Divp},
             
             @{FXFormFieldKey: @"Planta",FXFormFieldDefaultValue:self.Planta},
             
             @{FXFormFieldKey: @"Tipo de empleado",FXFormFieldDefaultValue:self.TipoDeEmpleado},
             
             @{FXFormFieldKey: @"Fecha de ingreso",FXFormFieldDefaultValue:self.FechaDeIngreso},
             
             @{FXFormFieldKey: @"Fechas de vacaciones",FXFormFieldDefaultValue:self.FechasDeVacaciones},
             
            // @{FXFormFieldTitle: @"Sing In", FXFormFieldHeader: @"", FXFormFieldAction: @"submitRegistrationForm:"},
             
             ];
}

- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    
}

@end
