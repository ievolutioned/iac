//
//  AsistenciaFormViewController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 20/02/17.
//  Copyright © 2017 ievolutioned. All rights reserved.
//

#import "AsistenciaFormViewController.h"
#import "DynamicFromLocalJson.h"
#import "DynamicForm.h"
#import "ServerController.h"
#import "DynamicJsonControllerViewController.h"

@interface AsistenciaFormViewController ()
{
    
    
}
@property (nonatomic, strong) NSMutableArray *asistentesAdded;
@property (nonatomic, strong) NSMutableArray *asistentesDeleted;
@property (nonatomic, strong) NSArray *cursos;
@property (nonatomic, strong) NSArray *AsistentesServer;
@property (nonatomic, strong) NSString *currentUserId;
@end

@implementation AsistenciaFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self starthud];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"valueSelected"
                                               object:nil];
    
    [ServerController curseListAvailable:^(NSArray *lst) {
        self.cursos = lst;
        
        [self ReloadDataForm:0];
        
    }];
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Enviar" style:UIBarButtonItemStyleDone target:self action:@selector(sendForm)];
}

- (void) viewWillDisappear:(BOOL)animated
{
  
}


-(void)ReloadDataForm:(int)index
{
    [ServerController curseListUsersAvailable:[[self.cursos objectAtIndex:index] objectForKey:@"id"] withHandler:^(NSArray *asistentes) {
        self.AsistentesServer = asistentes;
        NSMutableArray *jsonCursos =  [[NSMutableArray alloc] init];
        
        for (NSDictionary *curso in self.cursos) {
            [jsonCursos addObject:[curso objectForKey:@"name"]];
        }
        
        NSMutableDictionary *myJsonFormCursos = [[NSMutableDictionary alloc] init];
        [myJsonFormCursos setObject:jsonCursos forKey:@"options"];
        [myJsonFormCursos setObject:@"Cursos" forKey:@"key"];
        [myJsonFormCursos setObject:@"Cursos" forKey:@"title"];
        [myJsonFormCursos setObject:[[self.cursos objectAtIndex:index] objectForKey:@"name"] forKey:@"default"];
        [myJsonFormCursos setObject:@"Por favor elija el curso" forKey:@"header"];
        
        NSMutableDictionary *credencialagregada = [[NSMutableDictionary alloc] init];
        
        NSMutableArray *asistentesServer = [[NSMutableArray alloc] init];
        
        if (self.asistentesAdded == nil)
        {
            self.asistentesAdded = [[NSMutableArray alloc] init];
            
            for (NSDictionary *empleado in asistentes) {
                [credencialagregada setObject:[[empleado objectForKey:@"id"] stringValue] forKey:@"key"];
                [credencialagregada setObject:[[empleado objectForKey:@"name"] uppercaseString] forKey:@"title"];
                [credencialagregada setObject:@"editUser:" forKey:@"action"];
                [credencialagregada setObject:@"true" forKey:@"isInline"];
                //[asistentesServer addObject:credencialagregada];
                
                [self.asistentesAdded removeObject:credencialagregada];
                
                [self.asistentesAdded addObject:credencialagregada];
                
                credencialagregada = [[NSMutableDictionary alloc] init];
            }
        }
        for (NSDictionary *toDelete in self.asistentesDeleted) {
            
            [self.asistentesAdded removeObject:toDelete];
        }
        
        BOOL indexAsistentes = YES;
        
        for (NSMutableDictionary *empleado in self.asistentesAdded) {
            
            if ([empleado objectForKey:@"key"])
            {
                [asistentesServer removeObject:empleado];
                
                if (indexAsistentes &&  ![empleado objectForKey:@"header"])
                {
                    [empleado setObject:@"Asistentes" forKey:@"header"];
                }
                else
                    [empleado  removeObjectForKey:@"header"];
                
                
                [asistentesServer removeObject:empleado];
                
                
                
                [asistentesServer addObject:empleado];
                
                indexAsistentes=NO;
            }
        }
        
        
        
        
        
        
        
        NSMutableDictionary *myJsonForm = [[NSMutableDictionary alloc] init];
        [myJsonForm setObject:@"openCamera:" forKey:@"action"];
        [myJsonForm setObject:@"Agregar Asistente" forKey:@"header"];
        [myJsonForm setObject:@"barcodeReader" forKey:@"key"];
        [myJsonForm setObject:@"Presione aqui para agregar un asistente" forKey:@"title"];
        
        
        NSMutableArray *jsonForm =  [[NSMutableArray alloc] init];
        [jsonForm addObject:myJsonFormCursos];
        [jsonForm addObject:myJsonForm];
        
        
        for (NSDictionary *asistente in asistentesServer) {
            [jsonForm addObject:asistente];
        }
        
        
        self.formController.form  = [[DynamicFromLocalJson alloc] initWitJsonForm:jsonForm];
        
        [self.formController.tableView reloadData];
        
        [self stophud];
        
    }];
    
}






- (void) receiveNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    NSLog( @"%@", notification.object);
    [self starthud];
    
    self.CurseIndex = [[NSString stringWithFormat:@"%@",notification.object] integerValue];
    
    self.asistentesAdded = nil;
    self.asistentesDeleted = nil;
    
    [self ReloadDataForm:self.CurseIndex];
}

- (NSArray *)fields
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FormFields" ofType:@"json"];
    NSData *fieldsData = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:fieldsData options:(NSJSONReadingOptions)0 error:NULL];
}



-(void)sendForm
{
    [self starthud];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableDictionary *dickeys = nil;
        
        [ServerController createFormAsistencia:dickeys withiCurse_id:[[self.cursos objectAtIndex:self.CurseIndex] objectForKey:@"id"] withiAttendee_ids:[self getIds] withhandler:^(BOOL resp,NSString *msg) {
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


#pragma mark - aisstentes
- (void)editUser:(UITableViewCell<FXFormFieldCell> *)cell
{
    NSLog(@"%@", cell.field.key);
    self.currentUserId = cell.field.key;
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Control de Asistencia"
                                                      message:@"¿Deseas eliminar este asistente?"
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Si", nil];
    
    myAlert.tag = 12345;
    
    
    
    [myAlert show];
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

-(void)agregarOtro
{
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Control de Asistencia"
                                                      message:@"¿Deseas agregar otro asistente?"
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Si", nil];
    
    myAlert.tag = 12346;
    
     [myAlert show];
}

-(void)OpenCamera
{
    self.cameraOpen = YES;
    scanner = [[RSScannerViewController alloc] initWithCornerView:YES
                                                      controlView:YES
                                                  barcodesHandler:^(NSArray *barcodeObjects) {
                                                      if (barcodeObjects.count > 0) {
                                                          [barcodeObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  AVMetadataMachineReadableCodeObject *code = obj;
                                                                  
                                                                  
                                                                  if (self.cameraOpen)
                                                                  {
                                                                      self.cameraOpen = NO;
                                                                      
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          [scanner dismissViewControllerAnimated:true completion:nil];
                                                                          [self FillEmpleadoAsitente:code.stringValue];
                                                                          
                                                                          [self agregarOtro];
                                                                      });
                                                                  }
                                                                  /*
                                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Barcode found"
                                                                   message:code.stringValue
                                                                   delegate:self
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil];
                                                                   //[scanner dismissViewControllerAnimated:true completion:nil];
                                                                   //[scanner.navigationController popViewControllerAnimated:YES];
                                                                   */
                                                                 
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
    
    
}

- (void)actionSheet:(__unused UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (YES)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                
                [self OpenCamera];
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
    else
    {
        
    }
}

-(NSString *)getIds
{
    NSString *resp = @"";
    NSString *coma = @"";
    
    for (NSDictionary *dic in self.asistentesAdded)
    {
        resp = [NSString stringWithFormat:@"%@%@%@",resp,coma,[dic objectForKey:@"key"]];
        coma = @",";
    }
    
    return resp;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12346)
    {
        if (buttonIndex == 1)
        {
            [self OpenCamera];
        }
    }
    else if (alertView.tag == 12345)
    {
        if (buttonIndex == 1)
        {
            if (self.asistentesDeleted == nil)
                self.asistentesDeleted = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dic in self.asistentesAdded)
            {
                if ([[dic objectForKey:@"key"] isEqualToString:self.currentUserId])
                {
                    [self.asistentesDeleted addObject:dic];
                    break;
                }
            }
            
            [self ReloadDataForm:self.CurseIndex];
        }
    }
    else
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        
        UITextField *username = [alertView textFieldAtIndex:0];
        
        self.field.value = username.text;
        
        
        [self FillEmpleadoAsitente:username.text];
    }
    
}

-(void)FillEmpleadoAsitente:(NSString *)idUser
{
    [self starthud];
    
    [ServerController curseListUsersInfo:idUser withHandler:^(NSDictionary *lst) {
        
        @try {
            
            if (lst != nil)
            {
                if ([lst objectForKey:@"info_attendee"])
                {
                    NSDictionary *user = [lst objectForKey:@"info_attendee"];
                    if (user != nil)
                    {
                        if ([user objectForKey:@"id"])
                        {
                            if (self.asistentesAdded == nil)
                                self.asistentesAdded = [[NSMutableArray alloc] init];
                            
                            BOOL AlredyAdded = NO;
                            for (NSDictionary *server in self.AsistentesServer) {
                                
                                if ([server objectForKey:@"id"] == [user objectForKey:@"id"] && self.asistentesAdded.count > 0)
                                {
                                    AlredyAdded = YES;
                                    break;
                                }
                            }
                            
                            if (!AlredyAdded)
                            {
                                
                                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                                
                                [dic setObject:[[user objectForKey:@"id"] stringValue] forKey:@"key"];
                                [dic setObject:[[user objectForKey:@"name"] uppercaseString] forKey:@"title"];
                                [dic setObject:@"editUser:" forKey:@"action"];
                                [dic setObject:@"true" forKey:@"isInline"];
                                
                                NSMutableDictionary *dicCopy = [[NSMutableDictionary alloc] init];
                                
                                [dicCopy setObject:[[user objectForKey:@"id"] stringValue] forKey:@"key"];
                                [dicCopy setObject:[[user objectForKey:@"name"] uppercaseString] forKey:@"title"];
                                [dicCopy setObject:@"editUser:" forKey:@"action"];
                                [dicCopy setObject:@"Asistentes" forKey:@"header"];
                                
                                [self.asistentesAdded insertObject:dic atIndex:0];
                                // [self.asistentesAdded addObject:dic];
                                
                                [self.asistentesDeleted removeObject:dic];
                                [self.asistentesDeleted removeObject:dicCopy];
                            }
                            else
                            {
                                [self show:@"El registro de asistencia de este empleado ya existe"];
                            }
                            
                            [self ReloadDataForm:self.CurseIndex];
                        }
                        else
                            [self show:@"Empleado No encontrado"];
                    }
                    else
                        [self show:@"Empleado No encontrado"];
                    
                }
                else
                    [self show:@"Empleado No encontrado"];
            }
            else
                [self show:@"Empleado No encontrado"];
            
        } @catch (NSException *exception) {
            [self show:@"Empleado No encontrado"];
        } @finally {
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stophud];
            
        });
        
    }];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag == 12345)
    {
        return YES;
    }
    
    if (alertView.tag == 12346)
    {
        return YES;
    }
    
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
