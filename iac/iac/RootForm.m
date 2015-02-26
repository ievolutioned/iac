//
//  RootForm.m
//  BasicExample
//
//  Created by Nick Lockwood on 04/03/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "RootForm.h"


@implementation RootForm

- (id)init
{
    if ((self = [super init]))
    {
      // self.inlineArray = @[@"Foo", @"Bar", @"Baz"];
    }
    return self;
}

- (NSDictionary *)inlineArrayField
{
    return @{FXFormFieldTitle: @"Empleados",FXFormFieldInline: @YES,FXFormFieldTemplate: @{FXFormFieldType: FXFormFieldTypeEmpleado,FXFormFieldAction: @"submitRegistrationForm:",FXFormFieldTitle: @"Agregar Codigo"}};
}

@end
