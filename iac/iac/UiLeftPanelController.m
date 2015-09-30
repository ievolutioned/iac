//
//  UiLeftPanelController.m
//  mapilu
//
//  Created by Hipolyto Obeso Huerta on 04/12/14.
//  Copyright (c) 2014 ievolutioned. All rights reserved.
//

#import "UiLeftPanelController.h"
#import "EncuestaSalidaController.h"


@interface UiLeftPanelController ()

@end

@implementation UiLeftPanelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        return 1;
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
            return @"SITIOS DE INTERES";
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
        }
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                 lblDescription.text = @"Recibos de Nómina";
            }   break;
            case 1:
            {
                lblDescription.text = @"Programa de Reconocimientos";
            }   break;
                
            default:
            {
                 lblDescription.text = @"Agregar Usuario";
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
            case 0:
            {
                ListacursosViewController *lst = [[ListacursosViewController alloc] initWithStyle:UITableViewStylePlain];
                lst.title = @"Asistencia a Cursos";
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lst];
                
                nav.navigationBar.translucent = NO;
                
                self.sidePanelController.centerPanel = nav;

                
            }   break;
            case 1:
            {
                
                 EncuestaSalidaController *salida = [[EncuestaSalidaController alloc] init];
                
                salida.title = @"Encuesta de Salida";
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:salida];
                
                nav.navigationBar.translucent = NO;
                
                self.sidePanelController.centerPanel = nav;

                
            }   break;
                
            default:
            {
                
                EscuestaSatisfaccionController *salida = [[EscuestaSatisfaccionController alloc] init];
                
                salida.title = @"Encuesta de Satisfacción";
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:salida];
                
                nav.navigationBar.translucent = NO;
                
                self.sidePanelController.centerPanel = nav;

                return;
            }
                break;
        }
    }
    else
    {
        WebViewController *listcustomer = [[WebViewController alloc] init];
        
        switch (indexPath.row) {
            case 0:
            {
                listcustomer.urltoLoad = @"https://portal0012.globalview.adp.com/iac";
            }   break;
            case 1:
            {
                listcustomer.urltoLoad = @"http://iacrewardsprogram.com/Services/default.aspx";
            }   break;
                
            default:
            {
                return;
            }
                break;
        }
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listcustomer];
        
        nav.navigationBar.translucent = NO;
        
        self.sidePanelController.centerPanel = nav;
    }
    
    
    
    
}


@end
