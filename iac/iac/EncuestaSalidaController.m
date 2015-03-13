//
//  EncuestaSalidaController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 19/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "EncuestaSalidaController.h"
#import "FXEncuentaSalidaController.h"
#import "DynamicForm.h"
#import "LoadingCameraViewController.h"
@interface EncuestaSalidaController ()

@end

@implementation EncuestaSalidaController

#pragma mark - Cicle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        
        //FXEncuentaSalidaController *viewlogin = [[FXEncuentaSalidaController alloc] init];
        
        //self.formController.form = viewlogin;
        
        //
        self.formController.form = [[DynamicForm alloc] init];
    }
    return self;
}


-(bool) validateField:(NSArray *)fields withCell:(UITableViewCell<FXFormFieldCell> *)cell
{
    DynamicForm *form = cell.field.form;
    
    BOOL resp = YES;
    
    for (NSDictionary *dic in form.fields) {
        
        
        if ([dic valueForKey:@"validate"] != nil)
        {
            id valueee = [form valueForKey:[dic valueForKey:@"key"]];
            
            if ([valueee isKindOfClass:[NSString class]])
            {
                if (valueee == (id)[NSNull null] || ( (NSString *) valueee).length == 0 )
                {
                    resp = NO;
                }
            }
            else
            {
                if (valueee == [NSNull null])
                {
                    resp = NO;
                }
                else if (valueee == nil)
                {
                    resp = NO;
                }
            }
         
            if (!resp)
            {
                NSString *title = [dic valueForKey:@"title"];
                
                if (title.length == 0)
                    title = [dic valueForKey:@"key"];
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self show:[NSString stringWithFormat:@"%@ es requerido",title]];
                });
                
                
                return resp;
            }
            
        }
        
    }
    
    
    
    return resp;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.alredyPresenting = NO;
}

- (void)presentNewForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    DynamicForm *form = cell.field.form;
    
    
    NSArray *options =  [form valueForKey:@"reasonToLeave"];
    
    if (options.count == 0)
        self.alredyPresenting = NO;
    
    for (NSString *op in options) {
        
        if ([[op lowercaseString] isEqualToString:@"aceptar otro empleo"])
        {
            
            if (!self.alredyPresenting)
            {
                self.alredyPresenting = YES;
            
                [self presentFormFromOption];
            }
            break;
        }
    }
    
    if (!self.alredyPresenting)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)presentFormFromOption
{
    DynamicJsonControllerViewController *dynamic = [[DynamicJsonControllerViewController alloc] init];
    
    dynamic.jsonName = @"FormFieldsMotivo";
    
    [self.navigationController pushViewController:dynamic animated:YES];
    
}

- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    DynamicForm *form = cell.field.form;

    
    if (![self validateField:form.fields withCell:cell])
    {
        return;
    }
    
    
    
    /*
    if ([[form valueForKey:@"agreedToTerms"] boolValue])
    {
        [[[UIAlertView alloc] initWithTitle:@"Login Form Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"User Error" message:@"Please agree to the terms and conditions before proceeding" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Yes Sir!", nil] show];
    }
*/
}

-(void) describeDictionary :(NSDictionary *)dict
{
    NSArray *keys;
    int i, count;
    id key, value;
    
    keys = [dict allKeys];
    count = [keys count];
    for (i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [dict objectForKey: key];
        NSLog (@"Key: %@ for value: %@", key, value);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Msg

-(void)show:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [alertView show];
}

#pragma mark - hud

- (void)starthud
{
    NSLog(@"starthud");
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.labelText = @"Cargando";
    self.HUD.detailsLabelText = @"Por favor Espere...";
    
    
    [self.view addSubview:self.HUD];
    
    [self.HUD show:YES];
    
    
    
    [self.HUD bringSubviewToFront:self.HUD];
}



- (void)stophud
{
    NSLog(@"stophud");
    [self.HUD  hide:YES];
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}




#pragma mark - reader
- (void)openCamera:(UITableViewCell<FXFormFieldCell> *)cell
{
    //[self presentViewController:scanner animated:YES completion:nil]
  

    if ([UIAlertController class])
    {
        UIAlertControllerStyle style = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? UIAlertControllerStyleAlert: UIAlertControllerStyleActionSheet;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:style];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Escanear Credencial", nil) style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self actionSheet:nil didDismissWithButtonIndex:0];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Agregar Manualmente", nil) style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [self actionSheet:nil didDismissWithButtonIndex:1];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancelar", nil) style:UIAlertActionStyleCancel handler:NULL]];
        
       
        [self presentViewController:alert animated:YES completion:NULL];
    }
    else
    {
        
        [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancelar", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Escanear Credencial", nil), NSLocalizedString(@"Agregar Manualmente", nil), nil] showInView:self.view];
    }
}




#pragma mark - Navigation

-(void) cancelScannel
{
    [scanner dismissViewControllerAnimated:YES completion:nil];
    
    scanner = nil;
}

-(void) flipCamera
{
    [scanner switchCamera];
    
}

- (void)actionSheet:(__unused UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex)
    {
        case 0:
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
                                                                              [alert show];
                                                                          });
                                                                      });
                                                                  }];
                                                              }
                                                              
                                                          }
                       
                                                  preferredCameraPosition:AVCaptureDevicePositionBack];
            
            [scanner setIsButtonBordersVisible:YES];
            [scanner setStopOnFirst:YES];
            
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scanner];
            
            nav.navigationBar.translucent = NO;
            
            scanner.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelScannel)];
            
            scanner.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Flip" style:UIBarButtonItemStyleDone target:self action:@selector(flipCamera)];
            
            [self presentViewController:nav animated:YES completion:nil];
            
            
            break;
        }
        case 1:
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No. De Credencial"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancelar"
                                                    otherButtonTitles:@"Continuar", nil];
            
            [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            [message show];
            break;
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    UITextField *username = [alertView textFieldAtIndex:0];
    
    self.field.value = username.text;
    
   
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 1 )
    {
        
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
