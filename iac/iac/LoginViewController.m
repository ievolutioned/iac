//
//  LoginViewController.m
//  mapilu
//
//  Created by Hipolyto Obeso Huerta on 27/01/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "LoginViewController.h"
#import "FXFormLoginController.h"
#import "ServerController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
#pragma mark - Cicle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        FXFormLoginController *viewlogin = [[FXFormLoginController alloc] init];
        
        self.formController.form = viewlogin;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events
- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    FXFormLoginController *form = cell.field.form;
    
    if (form.NoEmpleado.length <= 0)
        [self show:@"No. Empleado es Requerido"];
    else if (form.password.length <= 0)
        [self show:@"La Contraseña es Requerida"];
    /*
    else if (![self NSStringIsValidEmail:form.email])
        [self show:@"El Correo Electronico no es valido"];
     */
    else
    {
        [self starthud];
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [ServerController doLogin:form.NoEmpleado withPass:form.password withCallback:^(bool susses, NSString * msg) {
                
                if (susses)
                {
                    NSLog(@"login Ok");
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                    [self show:msg];
                
                
                [self stophud];
                
            }];
        });
     
        
        
    }
    
}

#pragma mark - Valid Email

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - Msg

-(void)show:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
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


@end
