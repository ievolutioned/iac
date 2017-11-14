//
//  DynamicJsonControllerViewController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 11/03/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "DynamicJsonControllerViewController.h"
#import "DynamicFromLocalJson.h"
#import "DynamicForm.h"
#import "ServerController.h"

@interface DynamicJsonControllerViewController ()

@end

@implementation DynamicJsonControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.jsonName.length > 0)
        self.formController.form = [[DynamicFromLocalJson alloc] initWitJsonName:self.jsonName];
    else if (self.jsonForm.count > 0)
        self.formController.form = [[DynamicFromLocalJson alloc] initWitJsonForm:self.jsonForm];
  
    NSLog(@"%@", self.jsonForm);
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Enviar" style:UIBarButtonItemStyleDone target:self action:@selector(sendForm)];

}



-(void)sendForm
{
    DynamicForm *form = self.formController.form;
    
    
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
                
                
                break;
            }
            
        }
        
    }
    
    if (resp)
    {
        [self starthud];
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSMutableDictionary *dickeys = nil;
            
            dickeys = [[NSMutableDictionary alloc] init];
            
            for (NSDictionary *dic in form.fields) {
                
                NSString *key = [dic valueForKey:@"key"];
                id valueee = [form valueForKey:[dic valueForKey:@"key"]];

                NSLog(@"dic: %@ value: %@",key,valueee);
                
            
                [dickeys setValue:valueee forKey:key];
            
            }
            
            [ServerController createForm:dickeys withinquest_id:self.inquest_id withhandler:^(BOOL resp,NSString *msg) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self stophud];
                    
                    if (!resp)
                    {
                        [self show:msg];
                    }
                    else
                    {
                        [self show:msg];
                    }
                });
                
            }];
            
           
           
            
        });
    }
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
    self.HUD.labelText = @"Processing";
    self.HUD.detailsLabelText = @"Please wait...";
    
    
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


- (void)presentNewForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    DynamicForm *form = cell.field.form;
    
    NSDictionary *dicKey =  [form valueForKey:cell.field.key];
    
    if ([dicKey isKindOfClass:[NSDictionary class]])
    {
        
        NSDictionary *dicVal = [dicKey objectForKey:[[dicKey allKeys] objectAtIndex:0]];
        
        NSArray *dicValue = [dicVal objectForKey:[[dicVal allKeys] objectAtIndex:0]];
        
        bool GoBack = YES;
        
        if ([dicValue isKindOfClass:[NSArray class]])
        {
            if (dicValue.count > 0)
            {
                DynamicJsonControllerViewController *dynamic = [[DynamicJsonControllerViewController alloc] init];
                
                dynamic.jsonForm = dicValue;
                
                GoBack = NO;
                
                [self.navigationController pushViewController:dynamic animated:YES];
            }
            
            if (GoBack)
                [self.navigationController popViewControllerAnimated:YES];
            
            NSLog(@"... we are here....");
        }
        
        else
        {
            NSLog(@"... or here....");
            
        }
        
        
        
        
    }
    else
    {
         NSLog(@"... or here 2....");
    }
    
}

-(void)showMsg:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [alertView show];
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
