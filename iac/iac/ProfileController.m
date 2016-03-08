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
@property (nonatomic, strong) UIImageView *vlogo;
@property (nonatomic, strong) NSString *pass;
@property (nonatomic, strong) NSString *passinput;
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
    
    self.passinput = @"0";
    
    //self.view.backgroundColor = [UIColor clearColor];
    float withImg = [[UIScreen mainScreen] bounds].size.width;
    
    
    float withImgImage = [[UIScreen mainScreen] bounds].size.width * .95;
    
    UIView *vheader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, withImgImage)];
    
    
    
    vheader.backgroundColor = [UIColor clearColor];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Perfil", @"Contraseña", nil]];
    segmentedControl.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 40);
    [segmentedControl addTarget:self action:@selector(segmentedControlHasChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    segmentedControl.tintColor = [UIColor grayColor];
    
    [vheader addSubview:segmentedControl];
    
    segmentedControl.selectedSegmentIndex = 0;
    
    
    UIImage *logo = [UIImage imageNamed:@"logoIconLogin.png"];
    
    self.vlogo = [[UIImageView alloc] initWithImage:logo];
    
    self.vlogo.contentMode = UIViewContentModeScaleAspectFit;
    
    self.vlogo.clipsToBounds = YES;
    
    
    
    self.vlogo.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width / 2) - (withImgImage / 2), 40, withImgImage, withImgImage - 40);;
    
    [vheader addSubview:self.vlogo];
    
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
            
            if (amidn_info == nil)
                amidn_info = lst;
            
            if ([amidn_info objectForKey:@"name"])
                data.Nombre = [amidn_info objectForKey:@"name"];
            
            if ([amidn_info objectForKey:@"iac_id"])
                data.NumerodeEmpleado = [amidn_info objectForKey:@"iac_id"];
            
            NSLog(@"<<<<<<<< Numero de empleado: %@",data.NumerodeEmpleado);
            
            if ([amidn_info objectForKey:@"email"])
                data.Correo = [amidn_info objectForKey:@"email"];
            
            if ([amidn_info objectForKey:@"departament"])
            {
                NSString *Departamento = [amidn_info objectForKey:@"departament"];
                data.Departamento = Departamento;
            }
            if ([amidn_info objectForKey:@"department"])
            {
                @try
                {
                    NSDictionary *department = [amidn_info objectForKey:@"department"];
                    
                    if (department != nil)
                    {
                        if ([department objectForKey:@"title"])
                        {
                            data.Departamento = [department objectForKey:@"title"];
                        }
                    }
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
                
                
            }
            
            if ([amidn_info objectForKey:@"site_id"])
            {
                NSString *site_id = [amidn_info objectForKey:@"site_id"];
                data.Planta  = site_id;
                
                if ([amidn_info objectForKey:@"site"])
                {
                    NSDictionary *site = [amidn_info objectForKey:@"site"];
                    
                    NSString *nameSite = [site objectForKey:@"name"];
                    
                    data.Planta  = nameSite;
                }
            }
            
            if ([amidn_info objectForKey:@"type_iac"])
            {
                NSString *type_iac = [amidn_info objectForKey:@"type_iac"];
                data.TipoDeEmpleado  = type_iac;
            }
            
            
            if ([amidn_info objectForKey:@"divp"])
                data.Divp = [amidn_info objectForKey:@"divp"];
            
            if ([amidn_info objectForKey:@"date_of_admission"])
            {
                NSString *date_of_admission = [amidn_info objectForKey:@"date_of_admission"];
                
                if (!date_of_admission || [date_of_admission isKindOfClass:[NSNull class]])
                {
                    NSLog(@"11");
                }
                else
                    data.FechaDeIngreso  = [date_of_admission substringToIndex:10];;
            }
            
            if ([amidn_info objectForKey:@"holidays"])
            {
                NSString *holidays = [amidn_info objectForKey:@"holidays"];
                data.FechasDeVacaciones  = holidays;
            }
            
            
            
            @try {
                NSDictionary *avatar =[amidn_info objectForKey:@"avatar"];
                
                if ([avatar objectForKey:@"url"])
                {
                    NSString *url = @"http://res.cloudinary.com/iacgroup/image/upload/v1430237512/";
                    
                    if (url.length > 0)
                    {
                        if ([amidn_info objectForKey:@"avatar_cloudinary"])
                        {
                            NSString *avatar_cloudinary =[amidn_info objectForKey:@"avatar_cloudinary"];
                            
                            NSString *urlMain = url;
                            NSArray *parts = [urlMain componentsSeparatedByString:@"/"];
                            NSString *imageName = [parts lastObject];
                            
                            
                            url = [urlMain stringByReplacingOccurrencesOfString: imageName withString:@""];
                            
                            SDWebImageManager *manager = [SDWebImageManager sharedManager];
                            
                            [self.vlogo setContentMode:UIViewContentModeScaleAspectFit];
                            
                            data.Correo = [amidn_info objectForKey:@"email"];
                            
                            [manager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url,avatar_cloudinary]]
                                                  options:0
                                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                     // progression tracking code
                                                     NSLog(@"...");
                                                 }
                                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                    if (image) {
                                                        // do something with image
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            self.vlogo.image = image;
                                                            NSLog(@"...");
                                                            
                                                        });
                                                    }
                                                }];
                            
                            
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self.tableView reloadData];
                                
                                [self stophud];
                            });
                        }
                        
                    }
                    
                }
            }
            @catch (NSException *exception) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                    [self stophud];
                });
            }
            @finally {
                
            }
            
            
            
            
        }];
        
    });
    
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Enviar" style:UIBarButtonItemStyleDone target:self action:@selector(sendForm)];
    
}


-(void)sendForm
{
    FXFormProfileController *data = (FXFormProfileController *)self.formController.form;
    
    bool resp = YES;
    
    if ([self.passinput isEqualToString:@"0"])
    {
        if (data.Correo.length <= 0)
        {
            [self show:@"El correo es requerido"];
            resp = NO;
        }
        else if (![self NSStringIsValidEmail:data.Correo])
        {
            [self show:@"El correo es invalido"];
            resp = NO;
        }
        if (resp)
        {
            [self starthud];
            
            NSDictionary *dataDic  = @{
                                       @"email" : data.Correo
                                       };
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                
                
                [ServerController updateProfile:dataDic withinquest_id:@"123" withhandler:^(BOOL resp, NSString *msg) {
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
    else
    {
        if (data.Correo.length <= 0)
        {
            [self show:@"El correo es requerido"];
            resp = NO;
        }
        else if (![self NSStringIsValidEmail:data.Correo])
        {
            [self show:@"El correo es invalido"];
            resp = NO;
        }
        else if (self.pass.length <= 0)
        {
            [self show:@"La contraseña es requerida"];
            resp = NO;
        }
        
        if (resp)
        {
            [self starthud];
            
            NSDictionary *dataDic  = @{
                                       @"email" : data.Correo,
                                       @"password" : self.pass
                                       };
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                
                
                [ServerController updateProfile:dataDic withinquest_id:@"123" withhandler:^(BOOL resp, NSString *msg) {
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
    
    
}

- (void)segmentedControlHasChangedValue:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        
        FXFormProfilePasswordController *dataPass = (FXFormProfilePasswordController *)self.formController.form;
        
        if (dataPass.Password.length > 0)
        {
            NSString *pass = dataPass.Password;
            NSString *passRep = dataPass.PasswordReply;
            if ([pass isEqualToString:passRep])
            {
                self.passinput = @"1";
            }
            else
            {
                self.passinput = @"0";
                return;
            }
                
        }
        
        FXFormProfileController *data = [[FXFormProfileController alloc] init];
        self.formController.form = data;
        
        NSDictionary *lst = self.profileData;
        
        NSDictionary *amidn_info = [lst objectForKey:@"amidn_info"];
        
        
       if (amidn_info == nil)
            amidn_info = lst;
        
        if ([amidn_info objectForKey:@"name"])
            data.Nombre = [amidn_info objectForKey:@"name"];
        
        if ([amidn_info objectForKey:@"iac_id"])
            data.NumerodeEmpleado = [amidn_info objectForKey:@"iac_id"];
        
        NSLog(@"<<<<<<<< Numero de empleado: %@",data.NumerodeEmpleado);
        
        if ([amidn_info objectForKey:@"email"])
            data.Correo = [amidn_info objectForKey:@"email"];
        
        if ([amidn_info objectForKey:@"departament"])
        {
            NSString *Departamento = [amidn_info objectForKey:@"departament"];
            data.Departamento = Departamento;
        }
        if ([amidn_info objectForKey:@"department"])
        {
            @try
            {
                NSDictionary *department = [amidn_info objectForKey:@"department"];
                
                if (department != nil)
                {
                    if ([department objectForKey:@"title"])
                    {
                        data.Departamento = [department objectForKey:@"title"];
                    }
                }
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
            
        }
        
        if ([amidn_info objectForKey:@"site_id"])
        {
            NSString *site_id = [amidn_info objectForKey:@"site_id"];
            data.Planta  = site_id;
        }
        
        if ([amidn_info objectForKey:@"type_iac"])
        {
            NSString *type_iac = [amidn_info objectForKey:@"type_iac"];
            data.TipoDeEmpleado  = type_iac;
        }
        
        
        if ([amidn_info objectForKey:@"divp"])
            data.Divp = [amidn_info objectForKey:@"divp"];
        
        if ([amidn_info objectForKey:@"date_of_admission"])
        {
            NSString *date_of_admission = [amidn_info objectForKey:@"date_of_admission"];
            if (!date_of_admission || [date_of_admission isKindOfClass:[NSNull class]])
            {
                NSLog(@"11");
            }
            else
                data.FechaDeIngreso  = [date_of_admission substringToIndex:10];;
        }
        
        if ([amidn_info objectForKey:@"holidays"])
        {
            NSString *holidays = [amidn_info objectForKey:@"holidays"];
            data.FechasDeVacaciones  = holidays;
        }
        
        
        
        
        
        
        
        
        
        
        
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
