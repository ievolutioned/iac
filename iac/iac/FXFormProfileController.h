//
//  FXFormProfileController.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 20/11/15.
//  Copyright © 2015 ievolutioned. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface FXFormProfileController : NSObject<FXForm>
@property (nonatomic, copy) NSString *empleadonumber;
@property (nonatomic, copy) NSString *NumerodeEmpleado;
@property (nonatomic, copy) NSString *Nombre;
@property (nonatomic, copy) NSString *Correo;
@property (nonatomic, copy) NSString *Departamento;
@property (nonatomic, copy) NSString *Divp;
@property (nonatomic, copy) NSString *Planta;
@property (nonatomic, copy) NSString *TipoDeEmpleado;
@property (nonatomic, copy) NSString *FechaDeIngreso;
@property (nonatomic, copy) NSString *FechasDeVacaciones;


@end
