//
//  HomeViewcontroller.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 19/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "HomeViewcontroller.h"

@interface HomeViewcontroller ()

@end

@implementation HomeViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dom1:(id)sender {
    
    
}

- (IBAction)dom2:(id)sender {
    
    EncuestaSalidaController *salida = [[EncuestaSalidaController alloc] init];
    
    [self.navigationController pushViewController:salida animated:YES];
}

- (IBAction)dom3:(id)sender {
}
@end
