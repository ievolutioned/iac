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

@interface UiLeftPanelController ()
@property (nonatomic, strong) NSMutableArray *lstCursos;
@end

@implementation UiLeftPanelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.lstCursos = [[NSMutableArray alloc] init];
    
    NSDictionary *LoadingDic = @{
                                       @"name" : @"Loading...",
                                       
                                       };

    
    [self.lstCursos addObject:LoadingDic];

    [self.tableView reloadData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
         [ServerController curseList:^(NSArray * lst) {
        
        self.lstCursos = [[NSMutableArray alloc] init];
        
        
        NSDictionary *EncuestadeSalida = @{
                                    @"name" : @"Encuesta de Salida",
                                    
                                    };
        
        
        [self.lstCursos addObject:EncuestadeSalida];
        
        NSDictionary *EvaluaciondePagos = @{
                                           @"name" : @"Evaluacion de Pagos",
                                           
                                           };
        
        [self.lstCursos addObject:EvaluaciondePagos];
        
        for (NSDictionary *str in lst)
        {
             [self.lstCursos addObject:str];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
            
        });
        
        
    }];
         
           });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return self.lstCursos.count;
    else
        return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILabel * lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(57, 8, 220, 25)];
    lblDescription.textColor = [UIColor blackColor];
    
    if (indexPath.section == 0)
    {
        /*
        switch (indexPath.row) {
              
            case 0:
            {
                 lblDescription.text = @"Asistencia a Cursos";
            }   break;
            case 1:
            {
                lblDescription.text = @"Encuesta de Salida";
            }
                break;
                
            default:
            {
                 lblDescription.text = @"Encuesta de Satisfacción";
            }
                break;
                 
                
            case 0:
            {
                lblDescription.text = @"Encuesta de Salida";
            }   break;
            case 1:
            {
                lblDescription.text = @"Evaluacion de Pagos";
            }
                break;
            case 2:
            {
                lblDescription.text = @"Evaluacion de Servicios Sanitarios";
            }
                break;
            case 3:
            {
                lblDescription.text = @"Evaluacion de la Enfermeria";
            }
                break;
            case 4:
            {
                lblDescription.text = @"Evaluacion de el Transporte";
            }
                break;
            case 5:
            {
                lblDescription.text = @"Evaluacion de el Comedor";
            }
                break;

                
            default:
            {
                lblDescription.text = @"Encuesta de Satisfacción";
            }
                break;
        }
         
         */
        NSDictionary *dic = [self.lstCursos objectAtIndex:indexPath.row];
        
        lblDescription.text = [dic objectForKey:@"name"];
         
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                 lblDescription.text = @"MI PERFIL";
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
    
   
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 1:
            {
                ListacursosViewController *lst = [[ListacursosViewController alloc] initWithStyle:UITableViewStylePlain];
                lst.title = @"Asistencia a Cursos";
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lst];
                
                nav.navigationBar.translucent = NO;
                
                self.sidePanelController.centerPanel = nav;

                
            }   break;
            case 0:
            {
                
                 EncuestaSalidaController *salida = [[EncuestaSalidaController alloc] init];
                
                salida.title = @"Encuesta de Salida";
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:salida];
                
                nav.navigationBar.translucent = NO;
                
                self.sidePanelController.centerPanel = nav;

                
            }   break;
                
            default:
            {
                DynamicJsonControllerViewController *json = [[DynamicJsonControllerViewController alloc] init];
                NSDictionary *dic = [self.lstCursos objectAtIndex:indexPath.row];
                json.jsonForm = [dic objectForKey:@"content"];
                
                //EscuestaSatisfaccionController *salida = [[EscuestaSatisfaccionController alloc] init];
                
                json.title = [dic objectForKey:@"title"];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:json];
                
                nav.navigationBar.translucent = NO;
                
                self.sidePanelController.centerPanel = nav;

                return;
            }
                break;
        }
    }
    else
    {
        
        UIViewController *controller = nil;
        
        
        
        
        
        
        switch (indexPath.row) {
            case 0:
            {
                controller = [[ProfileController alloc] init];
                
            }   break;
            case 1:
            {
                controller = [[WebViewController alloc] init];
               // listcustomer.urltoLoad = @"http://iacrewardsprogram.com/Services/default.aspx";
                ((WebViewController *)controller).urltoLoad = @"https://portal0012.globalview.adp.com/iac";
            }   break;
                
            default:
            {
                
                [BaseViewController setLogout];
                
                LoginViewController *controller = [[LoginViewController alloc] init];
                
                [self.navigationController presentViewController:controller animated:YES completion:nil];
                return;
            }
                break;
        }
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        
        nav.navigationBar.translucent = NO;
        
        self.sidePanelController.centerPanel = nav;
    }
    
    
    
    
}


@end
