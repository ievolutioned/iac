//
//  FXEncuentaSalidaController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 19/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "FXEncuentaSalidaController.h"

@implementation FXEncuentaSalidaController

typedef NS_ENUM(NSInteger, Gender)
{
    GenderMale = 10,
    GenderFemale = 15,
    GenderOther = -1
};


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
             
             
             @{FXFormFieldKey: @"Nombre",FXFormFieldTitle: @"Nombre",FXFormFieldDefaultValue:self.email, FXFormFieldHeader: @"Datos Personales"},
             @{FXFormFieldKey: @"Edad",FXFormFieldTitle: @"Edad",FXFormFieldDefaultValue:self.password},
             @{FXFormFieldKey: @"jefe",FXFormFieldTitle: @"Nombre Jefe",FXFormFieldDefaultValue:self.password},
             @{FXFormFieldKey: @"puesto",FXFormFieldTitle: @"Puesto",FXFormFieldDefaultValue:self.password},
             @{FXFormFieldKey: @"departamento",FXFormFieldTitle: @"Departamento",FXFormFieldDefaultValue:self.password},
             @{FXFormFieldKey: @"Sexo", FXFormFieldOptions: @[@"Hombre", @"Mujer", @"Otro"]},
             //[self genderField],
              @{FXFormFieldKey: @"estadocivil",FXFormFieldTitle: @"Estado Civil",FXFormFieldDefaultValue:self.password},
             @{FXFormFieldKey: @"fechaingreso",FXFormFieldTitle: @"Fecha Ingreso",FXFormFieldType :FXFormFieldTypeDate},
             @{FXFormFieldKey: @"fechabaja",FXFormFieldTitle: @"Fecha Baja",FXFormFieldType :FXFormFieldTypeDate},
             @{FXFormFieldKey: @"sueldo",FXFormFieldTitle: @"Ultimo Sueldo",FXFormFieldDefaultValue:self.password},

            // @{FXFormFieldKey: @"Nombre",FXFormFieldTitle: @"Nombre",FXFormFieldDefaultValue:self.email, FXFormFieldHeader: @"Motivo de Salida"},
            @{FXFormFieldKey: @"rememberMe",FXFormFieldTitle: @"Aceptar otro Empleo", FXFormFieldHeader: @"Motivo de Salida"},
             @{FXFormFieldKey: @"Empresa",FXFormFieldTitle: @"Empresa",FXFormFieldDefaultValue:self.password},
              @{FXFormFieldKey: @"Puesto",FXFormFieldTitle: @"Puesto",FXFormFieldDefaultValue:self.password},
                @{FXFormFieldKey: @"SueldoOfrecido",FXFormFieldTitle: @"SueldoOfrecido",FXFormFieldDefaultValue:self.password},
             @{FXFormFieldKey: @"rememberMe",FXFormFieldTitle: @"Continuar Estudios"},
               @{FXFormFieldKey: @"rememberMe",FXFormFieldTitle: @"Cambio de Residensia"},
               @{FXFormFieldKey: @"rememberMe",FXFormFieldTitle: @"Enfermedad"},
               @{FXFormFieldKey: @"rememberMe",FXFormFieldTitle: @"Negocio Propio"},
               @{FXFormFieldKey: @"rememberMe",FXFormFieldTitle: @"Otras"},
             @{FXFormFieldKey: @"about", FXFormFieldTitle: @"Otras",FXFormFieldType: FXFormFieldTypeLongText},
                         @{FXFormFieldTitle: @"Siguiente", FXFormFieldHeader: @"", FXFormFieldAction: @"submitRegistrationForm:"},
             
             ];
}
- (NSDictionary *)emailField
{
    return @{FXFormFieldTitle: @"Email Address"};
}

- (NSDictionary *)genderField
{
    return @{FXFormFieldTitle: @"Sexo",FXFormFieldOptions: @[@(GenderMale), @(GenderFemale), @(GenderOther)],
             FXFormFieldValueTransformer: ^(id input) {
                 return @{@(GenderMale): @"Hombre",
                          @(GenderFemale): @"Mujer",
                          @(GenderOther): @"Otro"}[input];
             }};
}

- (NSArray *)extraFields
{
    return @[
             @{FXFormFieldTitle: @"Extra Field"},
             ];
}

- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    
}

@end
