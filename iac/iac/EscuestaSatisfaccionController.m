//
//  EscuestaSatisfaccionController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 24/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "EscuestaSatisfaccionController.h"
#import "DynamicFormSatisfaccion.h"
#import "FXEncuentaSalidaController.h"
#import "DynamicForm.h"
#import "LoadingCameraViewController.h"
#import "DynamicJsonControllerViewController.h"
@interface EscuestaSatisfaccionController ()

@end

@implementation EscuestaSatisfaccionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.formController.form = [[DynamicFormSatisfaccion alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    NSLog(@"...");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)presentNewForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    DynamicForm *form = cell.field.form;
    
    NSDictionary *dicKey =  [form valueForKey:cell.field.key];
    
    if ([dicKey isKindOfClass:[NSDictionary class]])
    {
        
        NSDictionary *dicVal = [dicKey objectForKey:[[dicKey allKeys] objectAtIndex:0]];
        
        NSArray *dicValue = [dicVal objectForKey:[[dicVal allKeys] objectAtIndex:0]];
        
        if ([dicValue isKindOfClass:[NSArray class]])
        {
            if (dicValue.count > 0)
            {
                DynamicJsonControllerViewController *dynamic = [[DynamicJsonControllerViewController alloc] init];
                
                dynamic.jsonForm = dicValue;
                
                [self.navigationController pushViewController:dynamic animated:YES];
            }
            
            
            
            NSLog(@"... we are here....");
        }
        
        else
        {
            NSLog(@"... or here....");
            
        }
        
        
        
        
    }
    else
    {
        
    }
    
}

@end
