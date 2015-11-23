//
//  ProfileController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 20/11/15.
//  Copyright © 2015 ievolutioned. All rights reserved.
//

#import "ProfileController.h"
#import "FXForms.h"
#import "FXFormProfileController.h"
#import "ServerConnection.h"
#import "ServerController.h"


@interface ProfileController ()
@property (nonatomic, strong) NSDictionary *profileData;
@end

@implementation ProfileController
#pragma mark - Cicle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        FXFormProfileController *viewlogin = [[FXFormProfileController alloc] init];
        
        self.formController.form = viewlogin;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *vheader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 151)];
    
    UIImage *logo = [UIImage imageNamed:@"logoIconLogin.png"];
    
    UIImageView *vlogo = [[UIImageView alloc] initWithImage:logo];
    
    vlogo.clipsToBounds = YES;
    
    vlogo.frame = vheader.frame;
    
    [vheader addSubview:vlogo];
    
    vheader.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableHeaderView = vheader;
    
    
    
    UIImageView *vbj = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_login.png"]];
    
    vbj.clipsToBounds = YES;
    
    vbj.frame = self.view.frame;
    
    [self.view insertSubview:vbj atIndex:0];
    
    //self.tableView.backgroundView = vbj;
    
    [self starthud];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [ServerController ProfileList:^(NSDictionary * lst) {
            
            self.profileData = lst;
            
            FXFormProfileController *data = (FXFormProfileController *)self.formController.form;
            
            NSDictionary *amidn_info = [lst objectForKey:@"amidn_info"];
            
            data.Nombre = [amidn_info objectForKey:@"name"];
            data.NumerodeEmpleado = [amidn_info objectForKey:@"iac_id"];
            data.Correo = [amidn_info objectForKey:@"email"];
            data.Departamento = [amidn_info objectForKey:@"departament"];

            data.Divp = [amidn_info objectForKey:@"divp"];

            data.Planta = @"";

            data.TipoDeEmpleado = @"";
            
            data.FechaDeIngreso = @"";//[amidn_info objectForKey:@"email"];
            
            data.FechasDeVacaciones = @"";//[amidn_info objectForKey:@"email"];

            /*
             
             self.NumerodeEmpleado = @"";
             self.Nombre = @"";
             self.Correo = @"";
             self.Departamento = @"";
             self.Divp = @"";
             self.Planta = @"";
             self.TipoDeEmpleado = @"";
             self.FechaDeIngreso = @"";
             self.FechasDeVacaciones = @"";

             
             */
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
                [self stophud];
            });
            
            
        }];
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events
- (void)submitRegistrationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
   
    /*
     ((FXFormPickerEmpleadoCell *)cell).field.value = code.stringValue;
     ((FXFormPickerEmpleadoCell *)cell).empleadoNo = code.stringValue;
     [((FXFormPickerEmpleadoCell *)cell) update];
     */
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
