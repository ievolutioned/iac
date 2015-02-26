//
//  AllEmpleadoController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 25/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "AllEmpleadoController.h"
#import "RootForm.h"
@interface AllEmpleadoController ()

@end

@implementation AllEmpleadoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.formController.form = [[RootForm alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    
    scanner = [[RSScannerViewController alloc] initWithCornerView:YES
                                                      controlView:YES
                                                  barcodesHandler:^(NSArray *barcodeObjects) {
                                                      if (barcodeObjects.count > 0) {
                                                          [barcodeObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  AVMetadataMachineReadableCodeObject *code = obj;
                                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Barcode found"
                                                                                                                  message:code.stringValue
                                                                                                                 delegate:self
                                                                                                        cancelButtonTitle:@"OK"
                                                                                                        otherButtonTitles:nil];
                                                                  //[scanner dismissViewControllerAnimated:true completion:nil];
                                                                  //[scanner.navigationController popViewControllerAnimated:YES];
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      [scanner dismissViewControllerAnimated:true completion:nil];
                                                                   //   [alert show];
                                                                  
                                                                      ((FXFormPickerEmpleadoCell *)cell).field.value = code.stringValue;
                                                                      ((FXFormPickerEmpleadoCell *)cell).empleadoNo = code.stringValue;
                                                                      [((FXFormPickerEmpleadoCell *)cell) update];
                                                                  
                                                                  });
                                                              });
                                                          }];
                                                      }
                                                      
                                                  }
               
                                          preferredCameraPosition:AVCaptureDevicePositionBack];
    
    [scanner setIsButtonBordersVisible:YES];
    [scanner setStopOnFirst:YES];
    
    NSLog(@"..");
   
    [self presentViewController:scanner animated:YES completion:nil];
    
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
