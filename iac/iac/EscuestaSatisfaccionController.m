//
//  EscuestaSatisfaccionController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 24/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "EscuestaSatisfaccionController.h"
#import "DynamicFormSatisfaccion.h"

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
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
