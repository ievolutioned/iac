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
#import "FXFormProfilePasswordController.h"
#import "ServerConnection.h"
#import "ServerController.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    
    
    //self.view.backgroundColor = [UIColor clearColor];
    float withImg = [[UIScreen mainScreen] bounds].size.width * .33;
    
    UIView *vheader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 40 + withImg + 20)];
    
    
    
    vheader.backgroundColor = [UIColor clearColor];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Perfil", @"Contraseña", nil]];
    segmentedControl.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 40);
    [segmentedControl addTarget:self action:@selector(segmentedControlHasChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    segmentedControl.tintColor = [UIColor grayColor];
    
    [vheader addSubview:segmentedControl];
    
    segmentedControl.selectedSegmentIndex = 0;
    
    
    UIImage *logo = [UIImage imageNamed:@"logoIconLogin.png"];
    
    UIImageView *vlogo = [[UIImageView alloc] initWithImage:logo];
    
    vlogo.contentMode = UIViewContentModeScaleAspectFit;
    
    vlogo.clipsToBounds = YES;
    
    
    
    vlogo.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width / 2) - (withImg / 2), 40, withImg, withImg);;
    
    [vheader addSubview:vlogo];
    
    self.tableView.tableHeaderView = vheader;
    
    
    
    UIImageView *vbj = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_login.png"]];
    
    vbj.clipsToBounds = YES;
    
    vbj.frame = self.view.frame;
    
    [self starthud];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [ServerController ProfileList:^(NSDictionary * lst) {
            
            self.profileData = lst;
            
            FXFormProfileController *data = (FXFormProfileController *)self.formController.form;
            
            NSDictionary *amidn_info = [lst objectForKey:@"amidn_info"];
            
            data.Nombre = [amidn_info objectForKey:@"name"];
            data.NumerodeEmpleado = [amidn_info objectForKey:@"iac_id"];
            
            NSLog(@"<<<<<<<< Numero de empleado: %@",data.NumerodeEmpleado);
            
            data.Correo = [amidn_info objectForKey:@"email"];
            data.Departamento = [amidn_info objectForKey:@"departament"];
            
            data.Divp = [amidn_info objectForKey:@"divp"];
            
            data.Planta = @"";
            
            data.TipoDeEmpleado = @"";
            
            data.FechaDeIngreso = @"";//[amidn_info objectForKey:@"email"];
            
            data.FechasDeVacaciones = @"";//[amidn_info objectForKey:@"email"];
            
            
            data.NumerodeEmpleado = @"jedi";
            
            NSDictionary *avatar =[amidn_info objectForKey:@"avatar"];
            
            NSString *url = [avatar objectForKey:@"url"];
            
            // [vbj sd_setImageWithURL:[NSURL URLWithString:url]
            //                 placeholderImage:[UIImage imageNamed:@"logoIconLogin.png"]];
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:url]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                     NSLog(@"...");
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
                                        // do something with image
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            vlogo.image = image;
                                            NSLog(@"...");
                                            
                                        });
                                    }
                                }];
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
                [self stophud];
            });
            
            
        }];
        
    });
    
}

- (void)segmentedControlHasChangedValue:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        FXFormProfileController *viewlogin = [[FXFormProfileController alloc] init];
        
        self.formController.form = viewlogin;
    }
    else
    {
        FXFormProfilePasswordController *viewPass = [[FXFormProfilePasswordController alloc] init];
        
        self.formController.form = viewPass;
    }
    
    [self.tableView reloadData];
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
