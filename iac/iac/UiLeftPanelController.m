//
//  UiLeftPanelController.m
//  mapilu
//
//  Created by Hipolyto Obeso Huerta on 04/12/14.
//  Copyright (c) 2014 ievolutioned. All rights reserved.
//

#import "UiLeftPanelController.h"
#import "EncuestaSalidaController.h"
#import "MBProgressHUD.h"
#import "ServerConnection.h"
#import "ServerController.h"
#import "ProfileController.h"
#import "LoginViewController.h"
#import "HomeViewcontroller.h"
#import "FaqController.h"
#import "AppDelegate.h"
#import "AboutController.h"
#import "AsistenciaFormViewController.h"
#import "ComedorFormViewController.h"

@interface UiLeftPanelController ()

@property (nonatomic, strong) NSMutableArray *lstCursos;

@property (nonatomic, strong) FaqController *faqController;
@property (nonatomic, strong) FaqController *termsController;
@property (nonatomic, strong) FaqController *ContactController;
@property (nonatomic, strong) FaqController *HeadController;
@property (nonatomic, strong) FaqController *VideoController;
@property (nonatomic, strong) FaqController *OrganizationController;
@property (nonatomic, strong) AsistenciaFormViewController *AssistsController;
@property (nonatomic, strong) ComedorFormViewController *DinnerController;
@property (nonatomic, strong) EncuestaSalidaController *exitPool;
@property (nonatomic, assign) BOOL IsUserDinner;
@property (nonatomic, strong) NSMutableArray *dynamicForms;


@property (nonatomic, assign) BOOL canDisplayOrganigram;
@property (nonatomic, assign) BOOL canDisplayDinner;
@property (nonatomic, assign) BOOL canDisplayAsistent;


@end

@implementation UiLeftPanelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadData];
    
}

-(void)loadData
{
    NSDictionary *amidn_info = [BaseViewController UserData];
    
    
    
    if ([amidn_info objectForKey:@"role"])
    {
        NSString *role = [amidn_info objectForKey:@"role"];
        
        NSString *professional_group = [amidn_info objectForKey:@"professional_group"];
        
        if ([role isEqualToString:@"admin"])
        {
            self.canDisplayOrganigram = YES;
            self.canDisplayAsistent = YES;
            self.canDisplayDinner = YES;
        }
        else if ([role isEqualToString:@"rh"])
        {
            self.canDisplayOrganigram = YES;
            self.canDisplayAsistent = YES;
            self.canDisplayDinner = YES;
        }
        
        if ([professional_group isEqualToString:@"M4"])
        {
            self.canDisplayOrganigram = YES;
        }
        else if ([professional_group isEqualToString:@"M5"])
        {
            self.canDisplayOrganigram = YES;
        }
        else if ([professional_group isEqualToString:@"E1"])
        {
            self.canDisplayOrganigram = YES;
        }
        
    }
    else if ([amidn_info objectForKey:@"admin_rol"])
    {
        NSString *role = [amidn_info objectForKey:@"admin_rol"];
        
        NSString *professional_group = [amidn_info objectForKey:@"professional_group"];
        
        if ([role isEqualToString:@"admin"])
        {
            self.canDisplayOrganigram = YES;
            self.canDisplayAsistent = YES;
            self.canDisplayDinner = YES;
        }
        else if ([role isEqualToString:@"rh"])
        {
            self.canDisplayOrganigram = YES;
            self.canDisplayAsistent = YES;
            self.canDisplayDinner = YES;
        }
        
        if ([professional_group isEqualToString:@"M4"])
        {
            self.canDisplayOrganigram = YES;
        }
        else if ([professional_group isEqualToString:@"M5"])
        {
            self.canDisplayOrganigram = YES;
        }
        else if ([professional_group isEqualToString:@"E1"])
        {
            self.canDisplayOrganigram = YES;
        }
        
    }
    
    if ([amidn_info objectForKey:@"type_iac"])
    {
        NSString *type_iac = [amidn_info objectForKey:@"type_iac"];
        if ([type_iac isEqualToString:@"comedor"])
        {
            self.IsUserDinner = YES;
        }
    }
    
    if (self.IsUserDinner)
    {
        [self.tableView reloadData];
    }
    else
    {
        self.lstCursos = [[NSMutableArray alloc] init];
        
        NSDictionary *LoadingDic = @{
                                     @"name" : @"Loading...",
                                     
                                     };
        
        
        [self.lstCursos addObject:LoadingDic];
        
        [self.tableView reloadData];
        
        
        if ([BaseViewController UserMenu].count <= 0)
        {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [ServerController curseList:^(NSArray * lst) {
                    
                    self.lstCursos = [[NSMutableArray alloc] init];
                    self.dynamicForms = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *str in lst)
                    {
                        [self.lstCursos addObject:str];
                        
                        DynamicJsonControllerViewController *json = [[DynamicJsonControllerViewController alloc] init];
                        NSDictionary *dic = str;
                        json.inquest_id = [[dic objectForKey:@"id"] stringValue];
                        json.jsonForm = [dic objectForKey:@"content"];
                        json.title = [dic objectForKey:@"title"];
                        
                        [self.dynamicForms addObject:json];
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.tableView reloadData];
                        
                    });
                    
                    
                }];
                
            });
        }
        else
        {
            self.lstCursos = [[NSMutableArray alloc] init];
            self.dynamicForms = [[NSMutableArray alloc] init];
            for (NSDictionary *str in [BaseViewController UserMenu])
            {
                [self.lstCursos addObject:str];
                
                DynamicJsonControllerViewController *json = [[DynamicJsonControllerViewController alloc] init];
                NSDictionary *dic = str;
                json.inquest_id = [[dic objectForKey:@"id"] stringValue];
                json.jsonForm = [dic objectForKey:@"content"];
                json.title = [dic objectForKey:@"title"];
                
                [self.dynamicForms addObject:json];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
            });
        }
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    NSLog(@"ee");
    
    [self loadData] ;
    
     [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.IsUserDinner)
        return 2;
    else
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.IsUserDinner)
    {
        if (section == 0)
        {
            return 1;
        }
        else
            return 3;
    }
    
    
    if (section == 0)
    {
        int rows = 6;
        
        if (self.canDisplayOrganigram)
            rows++;
        if (self.canDisplayAsistent)
            rows++;
        if (self.canDisplayDinner)
            rows++;
        
        return rows;
    }
    else if (section == 1)
        return self.lstCursos.count;
    else
        return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"FORMULARIOS";
            break;
            
        default:
            return @"MI PERFIL";
            break;
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"CellItem";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell = nil;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILabel * lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(25, 8, 220, 25)];
    lblDescription.textColor = [UIColor darkTextColor];
    
    if (indexPath.section == 0)
    {
        lblDescription.frame = CGRectMake(14, 8, 220, 25);
        lblDescription.textColor = [UIColor blackColor];
        
       
        
       if (self.IsUserDinner)
        {
           lblDescription.text = @"COMEDOR";
        }
        else
        {
            
            if (self.canDisplayAsistent && !self.canDisplayDinner && !self.canDisplayOrganigram)
            {
                switch (indexPath.row) {
                    case 0:
                        lblDescription.text = @"INICIO";
                        break;
                        
                    case 1:
                        lblDescription.text = @"PREGUNTAS FRECUENTES";
                        break;
                        
                    case 2:
                        lblDescription.text = @"POLITICAS PROCEDIMIENTOS FORMATOS";
                        break;
                    case 3:
                        lblDescription.text = @"CONTACTO";
                        break;
                    case 4:
                        lblDescription.text = @"HEAD COUNT IAC MÉXICO";
                        break;
                    case 5:
                        lblDescription.text = @"VIDEOTECA";
                        break;
                    case 6:
                        lblDescription.text = @"ASISTENCIAS";
                        break;
                        
                }
            }
            else
            {
                switch (indexPath.row) {
                    case 0:
                        lblDescription.text = @"INICIO";
                        break;
                        
                    case 1:
                        lblDescription.text = @"PREGUNTAS FRECUENTES";
                        break;
                        
                    case 2:
                        lblDescription.text = @"POLITICAS PROCEDIMIENTOS FORMATOS";
                        break;
                    case 3:
                        lblDescription.text = @"CONTACTO";
                        break;
                    case 4:
                        lblDescription.text = @"HEAD COUNT IAC MÉXICO";
                        break;
                    case 5:
                        lblDescription.text = @"VIDEOTECA";
                        break;
                    case 6:
                        lblDescription.text = @"ORGANIGRAMAS";
                        break;
                    case 7:
                        lblDescription.text = @"ASISTENCIAS";
                        break;
                    case 8:
                        lblDescription.text = @"COMEDOR";
                        break;
                        
                }
            }
            
        
        }
    }
    else if (indexPath.section == 1)
    {
        if (self.IsUserDinner)
        {
            switch (indexPath.row) {
                case 0:
                {
                    lblDescription.text = @"MI PERFIL";
                }   break;
                    
                case 1:
                {
                    lblDescription.text = @"ACERCA DE";
                }   break;
                default:
                {
                    lblDescription.text = @"CERRAR SESION";
                }
                    break;
            }
        }
        else
        {
        NSDictionary *dic = [self.lstCursos objectAtIndex:indexPath.row];
        
        lblDescription.text = [dic objectForKey:@"name"];
        }
        
    }
    else if (indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:
            {
                lblDescription.text = @"MI PERFIL";
            }   break;
                
            case 1:
            {
                lblDescription.text = @"ACERCA DE";
            }   break;
            default:
            {
                lblDescription.text = @"CERRAR SESION";
            }
                break;
        }
    }
    
    
    lblDescription.backgroundColor = [UIColor clearColor];
    [cell addSubview:lblDescription];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.AssistsController != nil)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self.AssistsController
                                                    name:@"valueSelected"
                                                  object:nil];
    }
    
    if (self.DinnerController != nil)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self.DinnerController
                                                    name:@"valueSelected"
                                                  object:nil];
    }
    
    if (indexPath.section == 0)
    {
        
        UIViewController *dash = nil;
        
        if (self.IsUserDinner)
        {
            self.DinnerController = [[ComedorFormViewController alloc] init];
            
            dash = self.DinnerController;
        }
        else if (self.canDisplayAsistent && !self.canDisplayDinner && !self.canDisplayOrganigram)
        {
            switch (indexPath.row) {
                case 0:
                {
                    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                    
                    dash = appDelegate.det;
                }
                    break;
                case 1:
                {
                    if (self.faqController == nil)
                        self.faqController = [[FaqController alloc] init];
                    
                    dash = self.faqController;
                }
                    break;
                case 2:
                {
                    if (self.termsController == nil)
                    {
                        self.termsController = [[FaqController alloc] init];
                        
                        self.termsController.customUrl = @"https://iacgroup.herokuapp.com/admin/procedures";
                    }
                    
                    dash = self.termsController;
                    
                    break;
                }
                case 3:
                {
                    if (self.ContactController == nil)
                    {
                        self.ContactController = [[FaqController alloc] init];
                        
                        self.ContactController.customUrl = @"https://iacgroup.herokuapp.com/admin/comment";
                    }
                    
                    dash = self.ContactController;
                    
                    break;
                }
                case 4:
                {
                    if (self.HeadController == nil)
                    {
                        self.HeadController = [[FaqController alloc] init];
                        
                        self.HeadController.customUrl = @"https://iacgroup.herokuapp.com/admin/head_count";
                    }
                    
                    dash = self.HeadController;
                    
                    break;
                }
                    
                case 5:
                {
                    if (self.VideoController == nil)
                    {
                        self.VideoController = [[FaqController alloc] init];
                        
                        self.VideoController.customUrl = @"https://iacgroup.herokuapp.com/admin/videoteca";
                    }
                    
                    dash = self.VideoController;
                    
                    break;
                }
                case 6:
                {
                    self.AssistsController = [[AsistenciaFormViewController alloc] init];
                    
                    dash = self.AssistsController;
                    
                    break;
                }
                    
            }
        }
        else
        {
        
        switch (indexPath.row) {
            case 0:
            {
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                
                dash = appDelegate.det;
            }
                break;
            case 1:
            {
                if (self.faqController == nil)
                    self.faqController = [[FaqController alloc] init];
                
                dash = self.faqController;
            }
                break;
            case 2:
            {
                if (self.termsController == nil)
                {
                    self.termsController = [[FaqController alloc] init];
                
                    self.termsController.customUrl = @"https://iacgroup.herokuapp.com/admin/procedures";
                }
                
                dash = self.termsController;
                
                break;
            }
            case 3:
            {
                if (self.ContactController == nil)
                {
                    self.ContactController = [[FaqController alloc] init];
                    
                    self.ContactController.customUrl = @"https://iacgroup.herokuapp.com/admin/comment";
                }
                
                dash = self.ContactController;
                
                break;
            }
            case 4:
            {
                if (self.HeadController == nil)
                {
                    self.HeadController = [[FaqController alloc] init];
                    
                    self.HeadController.customUrl = @"https://iacgroup.herokuapp.com/admin/head_count";
                }
                
                dash = self.HeadController;
                
                break;
            }
                
            case 5:
            {
                if (self.VideoController == nil)
                {
                    self.VideoController = [[FaqController alloc] init];
                    
                    self.VideoController.customUrl = @"https://iacgroup.herokuapp.com/admin/videoteca";
                }
                
                dash = self.VideoController;
                
                break;
            }
            case 6:
            {
                if (self.OrganizationController == nil)
                {
                    self.OrganizationController = [[FaqController alloc] init];
                    
                    self.OrganizationController.customUrl = @"http://iacgroup.herokuapp.com/admin/organization_charts";
                }
                
                dash = self.OrganizationController;
                
                break;
            }
            case 7:
            {
                self.AssistsController = [[AsistenciaFormViewController alloc] init];
                
                dash = self.AssistsController;
                
                break;
            }
            case 8:
            {
                self.DinnerController = [[ComedorFormViewController alloc] init];
                
                dash = self.DinnerController;
                
                break;
            }
                
        }
        }
       
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dash];
        
        nav.navigationBar.translucent = NO;
        
        nav.navigationBar.tintColor = [UIColor darkGrayColor];
        
        self.sidePanelController.centerPanel = nav;
        
    }
    else if (indexPath.section == 1)
    {
        if (self.IsUserDinner)
        {
            UIViewController *controller = nil;
            
            
            
            
            
            
            switch (indexPath.row) {
                case 0:
                {
                    controller = [[ProfileController alloc] init];
                    
                }   break;
                case 1:
                {
                    controller = [[AboutController alloc] init];
                }   break;
                    
                default:
                {
                    
                    [BaseViewController setLogout];
                    
                    LoginViewController *controller = [[LoginViewController alloc] init];
                    
                    UINavigationController *navLog = [[UINavigationController alloc] initWithRootViewController:controller];
                    navLog.navigationBar.translucent = YES;
                    [self.navigationController presentViewController:navLog animated:YES completion:nil];
                    
                    
                    
                    return;
                }
                    break;
            }
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            
            nav.navigationBar.translucent = NO;
            nav.navigationBar.tintColor = [UIColor darkGrayColor];
            self.sidePanelController.centerPanel = nav;
        }
        else
        {
        switch (indexPath.row) {
            case 991:
            {
                ListacursosViewController *lst = [[ListacursosViewController alloc] initWithStyle:UITableViewStylePlain];
                lst.title = @"Asistencia a Cursos";
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lst];
                
                nav.navigationBar.translucent = NO;
                 nav.navigationBar.tintColor = [UIColor darkGrayColor];
                self.sidePanelController.centerPanel = nav;
                
                
            }   break;
            case 0:
            {
             
                if (self.exitPool == nil)
                {
                
                self.exitPool = [[EncuestaSalidaController alloc] init];
                
                self.exitPool.title = @"Encuesta de Salida";
                }
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.exitPool];
                
                nav.navigationBar.translucent = NO;
                 nav.navigationBar.tintColor = [UIColor darkGrayColor];
                self.sidePanelController.centerPanel = nav;
                
                
            }   break;
                
            default:
            {
                 UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: [self.dynamicForms objectAtIndex:indexPath.row]];
                
                nav.navigationBar.translucent = NO;
                 nav.navigationBar.tintColor = [UIColor darkGrayColor];
                self.sidePanelController.centerPanel = nav;
                
                return;
            }
                break;
        }
        }
    }
    else if (indexPath.section == 2)
    {
        
        UIViewController *controller = nil;
        
        
        
        
        
        
        switch (indexPath.row) {
            case 0:
            {
                controller = [[ProfileController alloc] init];
                
            }   break;
            case 1:
            {
                controller = [[AboutController alloc] init];
            }   break;
                
            default:
            {
                
                [BaseViewController setLogout];
                
                LoginViewController *controller = [[LoginViewController alloc] init];
                
                UINavigationController *navLog = [[UINavigationController alloc] initWithRootViewController:controller];
                navLog.navigationBar.translucent = YES;
                [self.navigationController presentViewController:navLog animated:YES completion:nil];
                
               
                
                return;
            }
                break;
        }
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        
        nav.navigationBar.translucent = NO;
         nav.navigationBar.tintColor = [UIColor darkGrayColor];
        self.sidePanelController.centerPanel = nav;
    }
    
    
    
    
}


@end
