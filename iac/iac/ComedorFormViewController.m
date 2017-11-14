//
//  ComedorFormViewController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 15/03/17.
//  Copyright © 2017 ievolutioned. All rights reserved.
//

#import "ComedorFormViewController.h"
#import "DynamicFromLocalJson.h"
#import "DynamicForm.h"
#import "ServerController.h"
#import "DynamicJsonControllerViewController.h"


@interface ComedorFormViewController ()

@property (nonatomic, strong) NSMutableArray *asistentesAdded;
@property (nonatomic, strong) NSMutableArray *asistentesAddedInvite;
@property (nonatomic, strong) NSMutableArray *asistentesDeletedInvite;
@property (nonatomic, strong) NSMutableArray *asistentesDeleted;
@property (nonatomic, strong) NSArray *comensales;
@property (nonatomic, strong) NSArray *AsistentesServer;
@property (nonatomic, strong) NSString *currentUserId;

@property (nonatomic, strong) NSString *site_id;
@property (nonatomic, strong) NSString *site_name;

@property (nonatomic, assign) BOOL invitadosActivo;

@property (nonatomic, assign) BOOL AddingInvitado;
@property (nonatomic, assign) NSInteger InvitadoIndex;

@property (nonatomic, assign) NSInteger SponsorIndex;

@property (nonatomic, assign) NSInteger ComensalType;



@property (nonatomic, strong) NSMutableArray *comensalAddedNormal;
@property (nonatomic, strong) NSMutableArray *comensalAddedSubsidio;
@property (nonatomic, strong) NSMutableArray *comensalAddedTiempoExtra;

@property (nonatomic, strong) NSMutableArray *comensalAddedInvidadosExtra;
@property (nonatomic, strong) NSMutableArray *comensalAddedInvidadosExtraDeleted;

@property (nonatomic, strong) NSMutableArray *comensalAddedNormalDeleted;
@property (nonatomic, strong) NSMutableArray *comensalAddedSubsidioDeleted;
@property (nonatomic, strong) NSMutableArray *comensalAddedTiempoExtraDeleted;

@property (nonatomic, strong) NSMutableDictionary *currentUserSponsor;

@property (nonatomic, strong) NSDictionary *currentUserSelected;
@end

@implementation ComedorFormViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self starthud];
    
    
    self.ComensalType = 0;
    
    if (self.comensalAddedNormal == nil)
        self.comensalAddedNormal = [[NSMutableArray alloc] init];
    
    if (self.comensalAddedSubsidio == nil)
        self.comensalAddedSubsidio = [[NSMutableArray alloc] init];
    
    if (self.comensalAddedTiempoExtra == nil)
        self.comensalAddedTiempoExtra = [[NSMutableArray alloc] init];
    
    if (self.comensalAddedInvidadosExtra == nil)
        self.comensalAddedInvidadosExtra = [[NSMutableArray alloc] init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(valueSelectedToDeleted:)
                                                 name:@"valueSelectedToDeleted"
                                               object:nil];
    
    [ServerController ProfileList:^(NSDictionary * lst) {
        
        @try {
            
            @try {
                NSArray *siteList = [lst objectForKey:@"site_id"];
                
                self.site_id = [siteList objectAtIndex:0];
            } @catch (NSException *exception) {
                self.site_id  = [lst objectForKey:@"site_id"];
            } @finally {
                
            }
            
            
            @try
            {
                if ([lst objectForKey:@"site"])
                {
                    self.site_name = [[lst objectForKey:@"site"] objectForKey:@"name"];
                }
            }
            @catch (NSException *exception)
            {
               self.site_name = @"Monterrey";
            }
            @finally
            {
                
            }
           
            
            [ServerController ComensalesList:self.site_id withhandler:^(NSArray *lst) {
                
                self.comensales = lst;
                
                for (NSDictionary *comensal in self.comensales)
                {
                    
                    NSArray *usuario = [comensal objectForKey:@"commensals"];
                    NSDictionary *info_dining_room = [comensal objectForKey:@"info_dining_room"];
                    
                    for (NSDictionary *user in usuario) {
                        NSLog(@"%@",[comensal objectForKey:@"commensals"]);
                        NSLog(@"%@",usuario);
                        
                        
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        
                        
                        NSMutableArray *FoodTypes = [[NSMutableArray alloc] init];
                        [FoodTypes addObject:@"Agua"];
                        [FoodTypes addObject:@"Refresco"];
                        [FoodTypes addObject:@"Comida"];
                        
                        
                        NSString *iac_id = [NSString stringWithFormat:@"%@",[user objectForKey:@"iac_id"]];
                        NSString *idUser = [NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
                        
                        if (iac_id.length <= 0)
                            iac_id = idUser;
                        
                        if ([iac_id isEqualToString:@"<null>"])
                            iac_id = idUser;
                        
                        NSString *commensal_type = [NSString stringWithFormat:@"%@",[user objectForKey:@"commensal_type"]];
                        
                        [dic setObject:FoodTypes forKey:@"options"];
                        [dic setObject:iac_id forKey:@"key"];
                        [dic setObject:idUser forKey:@"extrakey"];
                        
                        [dic setObject:@"FXFormDefaultCellCustom" forKey:@"cell"];
                        
                        bool AlredyAdded = NO;
                        
                        
                        NSString *support =  [info_dining_room objectForKey:@"support"];
                        
                        if ([support isEqualToString:@"food"])
                        {
                            
                            [dic setObject:@"Comida" forKey:@"default"];
                        }
                        else if ([support isEqualToString:@"water"])
                        {
                            
                            [dic setObject:@"Agua" forKey:@"default"];
                        }
                        else if ([support isEqualToString:@"soda"])
                        {
                            
                            [dic setObject:@"Refresco" forKey:@"default"];
                        }
                        
                        [dic setObject:@"true" forKey:@"deleteicon"];
                        [dic setObject:@"true" forKey:@"isServer"];
                        
                        NSString *created_at =  [info_dining_room objectForKey:@"created_at"];
                        
                        
                        
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"];
                        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
                        
                        
                        
                        NSDateFormatter *df = [[NSDateFormatter alloc] init];
                        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
                        NSDate *date = [df dateFromString: created_at];
                        
                        
                        
                        NSString *strToday = [dateFormat  stringFromDate:date];// string with yyyy-MM-dd format
                        
                        NSString *name = [NSString stringWithFormat:@"%@",[user objectForKey:@"name"]];
                        
                        [dic setObject:name forKey:@"title"];
                         [dic setObject:strToday forKey:@"titledate"];
                        
                        
                        NSString *clasification =  [info_dining_room objectForKey:@"clasification"];
                        
                        int clasification_type = 0;
                        
                        if ([clasification isEqualToString:@"normal"])
                        {
                            clasification_type = 0;
                        }
                        else if ([clasification isEqualToString:@"subsidy"])
                        {
                            clasification_type = 1;
                        }
                        else if ([clasification isEqualToString:@"extra_time"])
                        {
                            clasification_type = 2;
                        }
                        else if ([clasification isEqualToString:@"guest"])
                        {
                            clasification_type = 3;
                        }
                        
                        
                        if (clasification_type == 0)
                        {
                            for (NSDictionary *check in self.comensalAddedNormal) {
                                
                                if ([check objectForKey:@"key"])
                                {
                                    if ([[check objectForKey:@"key"] isEqualToString:iac_id])
                                    {
                                        AlredyAdded = YES;
                                    }
                                }
                            }
                            
                            if (!AlredyAdded)
                                [self.comensalAddedNormal insertObject:dic atIndex:0];
                        }
                        else if (clasification_type == 1)
                        {
                            for (NSDictionary *check in self.comensalAddedSubsidio) {
                                
                                if ([check objectForKey:@"key"])
                                {
                                    if ([[check objectForKey:@"key"] isEqualToString:iac_id])
                                    {
                                        AlredyAdded = YES;
                                    }
                                }
                            }
                            
                            if (!AlredyAdded)
                                [self.comensalAddedSubsidio insertObject:dic atIndex:0];
                        }
                        else if (clasification_type == 2)
                        {
                            for (NSDictionary *check in self.comensalAddedTiempoExtra) {
                                
                                if ([check objectForKey:@"key"])
                                {
                                    if ([[check objectForKey:@"key"] isEqualToString:iac_id])
                                    {
                                        AlredyAdded = YES;
                                    }
                                }
                            }
                            
                            if (!AlredyAdded)
                                [self.comensalAddedTiempoExtra insertObject:dic atIndex:0];
                        }
                        else if (clasification_type == 3)
                        {
                            AlredyAdded = NO;
                            
                            if (!AlredyAdded)
                            {
                                if ([commensal_type isEqualToString:@"empleado"])
                                {
                                    NSMutableDictionary *dicSponsor = [[NSMutableDictionary alloc] init];
                                    
                                    [dicSponsor setObject:iac_id  forKey:@"key"];
                                    
                                    [dicSponsor setObject:[[NSMutableArray alloc] init] forKey:@"options"];
                                    
                                    [dicSponsor setObject:@"default" forKey:@"type"];
                                    
                                    [dicSponsor setObject:@"FXFormTextFieldCell" forKey:@"cell"];
                                    
                                    [dicSponsor setObject:@"Patrocinador" forKey:@"title"];
                                    
                                    [dicSponsor setObject:idUser forKey:@"extrakey"];
                                    [dicSponsor setObject:@"true" forKey:@"deleteicon"];
                                    [dicSponsor setObject:@"true" forKey:@"isServer"];
                                   
                                    
                                    [dicSponsor setObject:[[user objectForKey:@"name"] uppercaseString] forKey: @"default"];
                                    
                                    self.currentUserSponsor = dicSponsor;
                                    
                                    [self.comensalAddedInvidadosExtra removeObject:self.currentUserSponsor];
                                    [self.comensalAddedInvidadosExtra insertObject:self.currentUserSponsor atIndex:0];
                                }
                                else
                                {
                                    //[dic removeObjectForKey:@"deleteicon"];
                                    
                                    [self.comensalAddedInvidadosExtra insertObject:dic atIndex:0];
                                    
                                    if (self.currentUserSponsor != nil)
                                    {
                                    [self.comensalAddedInvidadosExtra removeObject:self.currentUserSponsor];
                                    [self.comensalAddedInvidadosExtra insertObject:self.currentUserSponsor atIndex:0];
                                    }
                                }
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                }
                
                [self ReloadDataForm:0];
                
            }];
            
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
        
        
    }];
    
    
    
    // [self ReloadDataForm:0];
    
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Enviar" style:UIBarButtonItemStyleDone target:self action:@selector(sendForm)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)cleanName:(NSString *)name
{
    @try {
        return [name componentsSeparatedByString:@" - "][0];
    } @catch (NSException *exception) {
        return name;
    } @finally {
        
    }
    
}


-(void)ReloadDataForm:(int)index
{
   NSMutableDictionary *myJsonFormCursos = [[NSMutableDictionary alloc] init];
    
    [myJsonFormCursos setObject:@"comedor" forKey:@"key"];
    [myJsonFormCursos setObject:@"Comedor" forKey:@"title"];
    [myJsonFormCursos setObject:@"createListener:" forKey:@"action"];
    
    [myJsonFormCursos setObject:self.site_name forKey:@"default"];
    
     [myJsonFormCursos setObject:@"FXFormTextFieldCell" forKey:@"cell"];
    [myJsonFormCursos setObject:@"true" forKey:@"isServer"];
    [myJsonFormCursos setObject:@"Seleccione comedor de planta" forKey:@"header"];
    
    
    NSMutableArray *jsonTipoComensales =  [[NSMutableArray alloc] init];
    
    [jsonTipoComensales addObject:@"Normal"];
    [jsonTipoComensales addObject:@"Sin Subsidio"];
    [jsonTipoComensales addObject:@"Tiempo Extra"];
    [jsonTipoComensales addObject:@"Invitado"];
    
    
    NSMutableDictionary *myJsonComensalType = [[NSMutableDictionary alloc] init];
    [myJsonComensalType setObject:jsonTipoComensales forKey:@"options"];
    [myJsonComensalType setObject:@"comedortype" forKey:@"key"];
    [myJsonComensalType setObject:@"Tipo" forKey:@"title"];
    
    
    if (self.ComensalType == 0)
    {
         [myJsonComensalType setObject:@"Normal" forKey:@"default"];
    }
    else if (self.ComensalType == 1)
    {
        [myJsonComensalType setObject:@"Sin Subsidio" forKey:@"default"];
    }
    else if (self.ComensalType == 2)
    {
         [myJsonComensalType setObject:@"Tiempo Extra" forKey:@"default"];
    }
    else
    {
        [myJsonComensalType setObject:@"Invitado" forKey:@"default"];
    }
    
   
    
    
    
    NSMutableArray *asistentesServer = [[NSMutableArray alloc] init];
    
    if (self.comensalAddedNormal == nil)
        self.comensalAddedNormal = [[NSMutableArray alloc] init];
    
    if (self.comensalAddedSubsidio == nil)
        self.comensalAddedSubsidio = [[NSMutableArray alloc] init];
    
    if (self.comensalAddedTiempoExtra == nil)
        self.comensalAddedTiempoExtra = [[NSMutableArray alloc] init];
    
    if (self.comensalAddedNormalDeleted == nil)
        self.comensalAddedNormalDeleted = [[NSMutableArray alloc] init];
    
    if (self.comensalAddedSubsidioDeleted == nil)
        self.comensalAddedSubsidioDeleted = [[NSMutableArray alloc] init];
    
    if (self.comensalAddedTiempoExtraDeleted == nil)
        self.comensalAddedTiempoExtraDeleted = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *toDelete in self.comensalAddedNormalDeleted) {
        
        [self.comensalAddedNormal removeObject:toDelete];
    }
    
    for (NSDictionary *toDelete in self.comensalAddedSubsidioDeleted) {
        
        [self.comensalAddedSubsidio removeObject:toDelete];
    }
    
    for (NSDictionary *toDelete in self.comensalAddedTiempoExtraDeleted) {
        
        [self.comensalAddedTiempoExtra removeObject:toDelete];
    }
    
    for (NSDictionary *toDelete in self.comensalAddedInvidadosExtraDeleted) {
        
        [self.comensalAddedInvidadosExtra removeObject:toDelete];
    }
    
    
    
    BOOL indexAsistentes = YES;
    int indexHeader = 0;
    
    
    for (NSMutableDictionary *empleado in self.asistentesAdded)
    {
        
        if ([empleado objectForKey:@"key"])
        {
            [asistentesServer removeObject:empleado];
            
            if (indexAsistentes &&  ![empleado objectForKey:@"header"])
            {
                indexHeader = 0;
                
                // [empleado setObject:@"Asistentes" forKey:@"header"];
            }
            else
            {
                indexHeader = 0;
                //[empleado  removeObjectForKey:@"header"];
            }
            [empleado  removeObjectForKey:@"header"];
            
            [asistentesServer removeObject:empleado];
            
            [empleado  removeObjectForKey:@"header"];
            
            
            [asistentesServer addObject:empleado];
        }
    }
    
    
    NSMutableDictionary *myJsonForm = [[NSMutableDictionary alloc] init];
    [myJsonForm setObject:@"openCamera:" forKey:@"action"];
    [myJsonForm setObject:@"Agregar Comensal" forKey:@"header"];
    [myJsonForm setObject:@"barcodeReader" forKey:@"key"];
    [myJsonForm setObject:@"Asistente para comedor" forKey:@"title"];
    
    
    
    
    NSMutableArray *jsonForm =  [[NSMutableArray alloc] init];
    
    [jsonForm addObject:myJsonFormCursos];
    
    [jsonForm addObject:myJsonForm];
    
    
    [jsonForm addObject:myJsonComensalType];
    
    
    
    
    
    
    
    
    for (NSMutableDictionary *asistente in asistentesServer)
    {
        if (indexHeader == 0)
        {
            [asistente setObject:@"Comensales" forKey:@"header"];
        }
        [jsonForm addObject:asistente];
        
        indexHeader ++;
    }
    
    NSMutableArray *asistentesServerInvitado = [[NSMutableArray alloc] init];
    
    indexHeader = 0;
    
    for (NSMutableDictionary *empleado in self.comensalAddedNormal)
    {
        [empleado  removeObjectForKey:@"header"];
        
        if (indexHeader == 0)
        {
            [empleado setObject:@"Comensales - Normal" forKey:@"header"];
        }
        
        [empleado setObject:@"placeholder" forKey:@"placeholder"];
        //[empleado setObject:@"detail" forKey:@"detail"];
        
        if ([empleado objectForKey:@"key"])
        {
            [asistentesServerInvitado removeObject:empleado];;
            
            [jsonForm addObject:empleado];
        }
        
        indexHeader ++;
    }
    
    indexHeader = 0;
    
    for (NSMutableDictionary *empleado in self.comensalAddedSubsidio)
    {
        [empleado  removeObjectForKey:@"header"];
        if (indexHeader == 0)
        {
            [empleado setObject:@"Comensales - Subsidio" forKey:@"header"];
        }
        if ([empleado objectForKey:@"key"])
        {
            [asistentesServerInvitado removeObject:empleado];;
            
            [jsonForm addObject:empleado];
        }
        
        indexHeader ++;
    }
    
    indexHeader = 0;
    
    for (NSMutableDictionary *empleado in self.comensalAddedTiempoExtra)
    {
        [empleado  removeObjectForKey:@"header"];
        
        if (indexHeader == 0)
        {
            [empleado setObject:@"Comensales - Tiempo extra" forKey:@"header"];
        }
        
        
        if ([empleado objectForKey:@"key"])
        {
            [asistentesServerInvitado removeObject:empleado];;
            
            [jsonForm addObject:empleado];
        }
        
        indexHeader ++;
    }
    indexHeader = 0;
    for (NSMutableDictionary *empleado in self.comensalAddedInvidadosExtra)
    {
        [empleado  removeObjectForKey:@"header"];
        
        if (indexHeader == 0)
        {
            [empleado setObject:@"Comensales - Invitados" forKey:@"header"];
        }
        
        
        if ([empleado objectForKey:@"key"])
        {
            [asistentesServerInvitado removeObject:empleado];;
            
            [jsonForm addObject:empleado];
        }
        
        indexHeader ++;
    }
    
    
    
    
    self.formController.form  = [[DynamicFromLocalJson alloc] initWitJsonForm:jsonForm];
    
    [self.formController.tableView reloadData];
    
    [self stophud];
    
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"valueSelected"
                                                  object:nil];
}

- (NSArray *)fields
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FormFields" ofType:@"json"];
    NSData *fieldsData = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:fieldsData options:(NSJSONReadingOptions)0 error:NULL];
}



-(void)sendForm
{
    DynamicForm *form = self.formController.form;
    
    [self starthud];
    
    BOOL resp = YES;
    
    
    
    if (resp)
    {
        
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            
            for (NSDictionary *dic in form.fields)
            {
                
                NSString *keyDic = [dic valueForKey:@"key"];
                for (NSMutableDictionary *empleado in self.comensalAddedNormal)
                {
                    if ([keyDic isEqualToString:[empleado valueForKey:@"key"]])
                    {
                        [empleado setObject:[form valueForKey:keyDic] forKey:@"default"];
                    }
                }
                
                for (NSMutableDictionary *empleado in self.comensalAddedSubsidio)
                {
                    if ([keyDic isEqualToString:[empleado valueForKey:@"key"]])
                    {
                        [empleado setObject:[form valueForKey:keyDic] forKey:@"default"];
                    }
                }
                
                for (NSMutableDictionary *empleado in self.comensalAddedTiempoExtra)
                {
                    if ([keyDic isEqualToString:[empleado valueForKey:@"key"]])
                    {
                        [empleado setObject:[form valueForKey:keyDic] forKey:@"default"];
                    }
                }
            }
            
            
            
            
            
            
            
            for(NSDictionary *comensal in self.comensalAddedNormal)
            {
                NSMutableDictionary *dickeys = nil;
                
                dickeys = [[NSMutableDictionary alloc] init];
                
                NSMutableDictionary *dining_register = nil;
                
                dining_register = [[NSMutableDictionary alloc] init];
                
                NSMutableDictionary *commensals_attributes = [[NSMutableDictionary alloc] init];
                
                
                NSMutableDictionary *empleado = [[NSMutableDictionary alloc] init];;
                
                [empleado setObject:@"empleado" forKey:@"commensal_type"];
                
                [empleado setObject:[comensal valueForKey:@"key"] forKey:@"iac_id"];
                
                
                
                [empleado setObject:[self cleanName :[comensal valueForKey:@"title"]] forKey:@"name"];
                
                [commensals_attributes setObject:empleado forKey:@"0"];
                
                NSString *support_id =[comensal valueForKey:@"default"];
                
                if ([support_id isEqualToString:@"Agua"])
                {
                    support_id = @"water";
                }
                else if ([support_id isEqualToString:@"Refresco"])
                {
                    support_id = @"soda";
                }
                else if ([support_id isEqualToString:@"Comida"])
                {
                    support_id = @"food";
                }
                
                dining_register = @{
                                    
                                    @"site_id" : [NSString stringWithFormat:@"%@",self.site_id],
                                    @"discount": [NSString stringWithFormat:@"%@",@"100"],
                                    @"support_id":support_id,
                                    @"clasification_id":[NSString stringWithFormat:@"%@",@"normal"],
                                    @"commensals_attributes":commensals_attributes,
                                    };
                
                dickeys= @{
                           @"dining_register":dining_register,
                           };
                
                NSLog(@"%@",dickeys);
                
                
                [ServerController createFormComedor:dickeys withhandler:^(BOOL resp,NSString *msg) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        
                    });
                    
                }];
            }
            
            for(NSDictionary *comensal in self.comensalAddedSubsidio)
            {
                NSMutableDictionary *dickeys = nil;
                
                dickeys = [[NSMutableDictionary alloc] init];
                
                NSMutableDictionary *dining_register = nil;
                
                dining_register = [[NSMutableDictionary alloc] init];
                
                NSMutableDictionary *commensals_attributes = [[NSMutableDictionary alloc] init];
                
                
                NSMutableDictionary *empleado = [[NSMutableDictionary alloc] init];;
                
                [empleado setObject:@"empleado" forKey:@"commensal_type"];
                
                [empleado setObject:[comensal valueForKey:@"key"] forKey:@"iac_id"];
                
                [empleado setObject:[self cleanName :[comensal valueForKey:@"title"]] forKey:@"name"];
                
                [commensals_attributes setObject:empleado forKey:@"0"];
                
                NSString *support_id =[comensal valueForKey:@"default"];
                
                if ([support_id isEqualToString:@"Agua"])
                {
                    support_id = @"water";
                }
                else if ([support_id isEqualToString:@"Refresco"])
                {
                    support_id = @"soda";
                }
                else if ([support_id isEqualToString:@"Comida"])
                {
                    support_id = @"food";
                }
                
                dining_register = @{
                                    
                                    @"site_id" : [NSString stringWithFormat:@"%@",self.site_id],
                                    @"discount": [NSString stringWithFormat:@"%@",@"100"],
                                    @"support_id":support_id,
                                    @"clasification_id":[NSString stringWithFormat:@"%@",@"subsidy"],
                                    @"commensals_attributes":commensals_attributes,
                                    };
                
                dickeys= @{
                           @"dining_register":dining_register,
                           };
                
                NSLog(@"%@",dickeys);
                
                
                [ServerController createFormComedor:dickeys withhandler:^(BOOL resp,NSString *msg) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        
                    });
                    
                }];
            }
            
            
            for(NSDictionary *comensal in self.comensalAddedTiempoExtra)
            {
                NSMutableDictionary *dickeys = nil;
                
                dickeys = [[NSMutableDictionary alloc] init];
                
                NSMutableDictionary *dining_register = nil;
                
                dining_register = [[NSMutableDictionary alloc] init];
                
                NSMutableDictionary *commensals_attributes = [[NSMutableDictionary alloc] init];
                
                
                NSMutableDictionary *empleado = [[NSMutableDictionary alloc] init];;
                
                [empleado setObject:@"empleado" forKey:@"commensal_type"];
                
                [empleado setObject:[comensal valueForKey:@"key"] forKey:@"iac_id"];
                
                [empleado setObject:[self cleanName :[comensal valueForKey:@"title"]] forKey:@"name"];
                
                [commensals_attributes setObject:empleado forKey:@"0"];
                
                NSString *support_id =[comensal valueForKey:@"default"];
                
                if ([support_id isEqualToString:@"Agua"])
                {
                    support_id = @"water";
                }
                else if ([support_id isEqualToString:@"Refresco"])
                {
                    support_id = @"soda";
                }
                else if ([support_id isEqualToString:@"Comida"])
                {
                    support_id = @"food";
                }
                
                dining_register = @{
                                    
                                    @"site_id" : [NSString stringWithFormat:@"%@",self.site_id],
                                    @"discount": [NSString stringWithFormat:@"%@",@"100"],
                                    @"support_id":support_id,
                                    @"clasification_id":[NSString stringWithFormat:@"%@",@"extra_time"],
                                    @"commensals_attributes":commensals_attributes,
                                    };
                
                dickeys= @{
                           @"dining_register":dining_register,
                           };
                
                NSLog(@"%@",dickeys);
                
                
                [ServerController createFormComedor:dickeys withhandler:^(BOOL resp,NSString *msg) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        
                    });
                    
                }];
            }
            
            NSMutableArray *invitadosDic = [[NSMutableArray alloc] init];
           
            NSMutableArray *dicAuxSponsor = nil;
            dicAuxSponsor = [[NSMutableArray alloc] init];
            
            NSString *support_id = @"";
            
            for(NSDictionary *comensal in self.comensalAddedInvidadosExtra)
            {
                
                if ([comensal objectForKey:@"isServer"])
                {
                    NSLog(@"drr");
                }
                else
                {
                
                NSMutableDictionary *empleado = [[NSMutableDictionary alloc] init];;
                
                
                
                [empleado setObject:[comensal valueForKey:@"key"] forKey:@"iac_id"];
                
                NSString *title = [comensal objectForKey:@"title"];
                
                if ([title isEqualToString:@"Sponsor"])
                {
                    [empleado setObject:@"empleado" forKey:@"commensal_type"];
                    
                    [empleado setObject:[self cleanName :[comensal valueForKey:@"default"]]forKey:@"name"];
                }
                else  if ([title isEqualToString:@"Patrocinador"])
                {
                    [empleado setObject:@"empleado" forKey:@"commensal_type"];
                    
                    [empleado setObject:[self cleanName :[comensal valueForKey:@"default"]]forKey:@"name"];
                }

                else
                {
                    [empleado setObject:@"invitado" forKey:@"commensal_type"];
                    
                    [empleado setObject:[self cleanName :[comensal valueForKey:@"title"]] forKey:@"name"];
                }
                
                
                NSString *support_id =[comensal valueForKey:@"default"];
                
                if ([support_id isEqualToString:@"Agua"])
                {
                    support_id = @"water";
                }
                else if ([support_id isEqualToString:@"Refresco"])
                {
                    support_id = @"soda";
                }
                else
                {
                    support_id = @"food";
                }
                
                if ([title isEqualToString:@"Patrocinador"])
                {
                 
                    if (dicAuxSponsor.count > 0)
                    {
                        
                        NSMutableDictionary *dining_register = nil;
                        
                        dining_register = [[NSMutableDictionary alloc] init];
                        
                        NSMutableDictionary *dickeys = nil;
                        
                        dickeys = [[NSMutableDictionary alloc] init];
                        
                        NSMutableDictionary *commensals_attributes = [[NSMutableDictionary alloc] init];
                        
                        int index = 0;
                        
                        for(NSDictionary *comensal in dicAuxSponsor)
                        {
                           
                            
                             support_id = @"food";
                            
                            [commensals_attributes setObject:comensal forKey:[NSString stringWithFormat:@"%d",index]];
                            
                            
                            index ++;
                        }
                        
                        
                        dining_register = @{
                                            
                                            @"site_id" : [NSString stringWithFormat:@"%@",self.site_id],
                                            @"discount": [NSString stringWithFormat:@"%@",@"100"],
                                            @"support_id":support_id,
                                            @"clasification_id":[NSString stringWithFormat:@"%@",@"guest"],
                                            @"commensals_attributes":commensals_attributes,
                                            };
                        
                        dickeys= @{
                                   @"dining_register":dining_register,
                                   };
                        
                        NSLog(@"%@",dickeys);
                        
                        [ServerController createFormComedor:dickeys withhandler:^(BOOL resp,NSString *msg) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                NSLog(msg);
                                
                            });
                            
                        }];
                        
                        
                    }
                    
                    dicAuxSponsor = nil;
                    
                    dicAuxSponsor = [[NSMutableArray alloc] init];
                    
                     [dicAuxSponsor addObject:empleado];
                }
                else
                {
                    [dicAuxSponsor addObject:empleado];
                    
                }
                
                }
                
            }
            
            if (dicAuxSponsor.count > 0)
            {
                
                NSMutableDictionary *dining_register = nil;
                
                dining_register = [[NSMutableDictionary alloc] init];
                
                NSMutableDictionary *dickeys = nil;
                
                dickeys = [[NSMutableDictionary alloc] init];
                
                NSMutableDictionary *commensals_attributes = [[NSMutableDictionary alloc] init];
                
                int index = 0;
                
                for(NSDictionary *comensal in dicAuxSponsor)
                {
                    
                    
                    support_id = @"food";
                    
                    [commensals_attributes setObject:comensal forKey:[NSString stringWithFormat:@"%d",index]];
                    
                    index ++;
                    
                }
                
                
                dining_register = @{
                                    
                                    @"site_id" : [NSString stringWithFormat:@"%@",self.site_id],
                                    @"discount": [NSString stringWithFormat:@"%@",@"100"],
                                    @"support_id":support_id,
                                    @"clasification_id":[NSString stringWithFormat:@"%@",@"guest"],
                                    @"commensals_attributes":commensals_attributes,
                                    };
                
                dickeys= @{
                           @"dining_register":dining_register,
                           };
                
                NSLog(@"%@",dickeys);
                
                [ServerController createFormComedor:dickeys withhandler:^(BOOL resp,NSString *msg) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSLog(msg);
                        
                    });
                    
                }];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self stophud];
                
            });
            
            
            
            
            
            
            
            
        });
    }
    
    
    
    
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
- (void)createListener:(UITableViewCell<FXFormFieldCell> *)cell
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"valueSelected"
                                               object:nil];
    
    
    
    
}


- (void) valueSelectedToDeleted:(NSNotification *) notification
{
    
    NSLog( @"%@", notification.object);
    self.keySelected = [NSString stringWithFormat:@"%@",notification.object];
    
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Control de Comedor"
                                                      message:@"¿Deseas eliminar este comensal?"
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Si", nil];
    
    myAlert.tag = 1;
    
    
    
    [myAlert show];
}


- (void)openCamera:(UITableViewCell<FXFormFieldCell> *)cell
{
    //[self presentViewController:scanner animated:YES completion:nil]
    
    
    
    DynamicForm *form = self.formController.form;
    self.invitadosActivo = NO;
    
    
    BOOL resp = NO;
    
    for (NSDictionary *dic in form.fields) {
        
        NSLog(@"%@", dic);
        
        
        NSString *comedortype = [dic valueForKey:@"key"];
        
        if ([comedortype isEqualToString:@"comedortype"])
        {
            comedortype =[dic valueForKey:@"key"];
            
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
            
            resp = YES;
        }
        
        if (resp)
        {
            if ([[form valueForKey:[dic valueForKey:@"key"]] isEqualToString:@"Normal"])
            {
                self.ComensalType = 0;
            }
            else if ([[form valueForKey:[dic valueForKey:@"key"]] isEqualToString:@"Sin Subsidio"])
            {
                self.ComensalType = 1;
            }
            else if ([[form valueForKey:[dic valueForKey:@"key"]] isEqualToString:@"Tiempo Extra"])
            {
                self.ComensalType = 2;
            }
            else
            {
                self.invitadosActivo = YES;
                
                self.ComensalType = 3;
            }
            break;
        }
    }
    
    for (NSDictionary *dic in form.fields)
    {
        
        NSString *keyDic = @"";
        
        @try {
             keyDic = [dic valueForKey:@"key"];
        } @catch (NSException *exception) {
            NSLog(@"%@",dic);
        } @finally {
            
        }
       
        
        if (keyDic.length >0)
        {
            for (NSMutableDictionary *empleado in self.comensalAddedNormal)
            {
                if ([keyDic isEqualToString:[empleado valueForKey:@"key"]])
                {
                    [empleado setObject:[form valueForKey:keyDic] forKey:@"default"];
                }
            }
            
            for (NSMutableDictionary *empleado in self.comensalAddedSubsidio)
            {
                if ([keyDic isEqualToString:[empleado valueForKey:@"key"]])
                {
                    [empleado setObject:[form valueForKey:keyDic] forKey:@"default"];
                }
            }
            
            for (NSMutableDictionary *empleado in self.comensalAddedTiempoExtra)
            {
                if ([keyDic isEqualToString:[empleado valueForKey:@"key"]])
                {
                    [empleado setObject:[form valueForKey:keyDic] forKey:@"default"];
                }
            }
            
            
            for (NSMutableDictionary *empleado in self.comensalAddedInvidadosExtra)
            {
                if ([keyDic isEqualToString:[empleado valueForKey:@"key"]])
                {
                    NSString *defaultStr = [form valueForKey:keyDic];
                    
                    [empleado setObject:defaultStr forKey:@"default"];
                }
            }
        }
        
    }
    
    
    
    
    
    
    
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
        
        
        
        if (self.invitadosActivo)
        {
            alert.title = @"Agregar Patrocinador";
            
            if (self.AddingInvitado)
            {
                alert.title = @"Agregar Invitado";
                
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Agregar Nombre", nil) style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
                    [self actionSheet:nil didDismissWithButtonIndex:2];
                }]];
            }
            
        }
        
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
                                                                          
                                                                          if ( self.ComensalType != 3)
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
            case 2:
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nombre"
                                                                  message:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancelar"
                                                        otherButtonTitles:@"Continuar", nil];
                message.tag = 2;
                
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
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            BOOL MustExit = NO;
            
            NSDictionary *elementToDelete = nil;
            NSDictionary *elementToDeleteGuest = nil;
            for (NSMutableDictionary *empleado in self.comensalAddedNormal)
            {
                if ([[empleado objectForKey:@"key"] isEqualToString:self.keySelected])
                {
                    elementToDelete = empleado;
                    [self.comensalAddedNormal removeObject:empleado];
                    MustExit = YES;
                    break;
                }
            }
            
            for (NSMutableDictionary *empleado in self.comensalAddedSubsidio)
            {
                if ([[empleado objectForKey:@"key"] isEqualToString:self.keySelected])
                {
                    elementToDelete = empleado;
                    [self.comensalAddedSubsidio removeObject:empleado];
                    MustExit = YES;
                    break;
                }
            }
            
            for (NSMutableDictionary *empleado in self.comensalAddedTiempoExtra)
            {
                if ([[empleado objectForKey:@"key"] isEqualToString:self.keySelected])
                {
                    elementToDelete = empleado;
                    [self.comensalAddedTiempoExtra removeObject:empleado];
                    MustExit = YES;
                    break;
                }
            }
            
            int index = 0;
            
            NSMutableArray *deleteItems = [[NSMutableArray alloc] init];
            bool mustAddingDinners = NO;
            
            for (NSMutableDictionary *empleado in self.comensalAddedInvidadosExtra)
            {
                if ([[empleado objectForKey:@"key"] isEqualToString:self.keySelected])
                {
                    if ([[empleado objectForKey:@"title"] isEqualToString:@"Patrocinador"])
                    {
                       [deleteItems addObject:empleado];
                        mustAddingDinners = TRUE;
                        
                        [self.comensalAddedSubsidio removeObject:empleado];
                        
                        BOOL alredyAdded = YES;
                        
                        for (NSMutableDictionary *empleado in self.comensalAddedInvidadosExtra)
                        {
                            if ([[empleado objectForKey:@"title"] isEqualToString:@"Patrocinador"] && !alredyAdded)
                            {
                                break;
                            }
                            else
                            {
                                alredyAdded = NO;
                                [deleteItems addObject:empleado];
                            }
                            
                        }
                    }
                    else
                    {
                        [self.comensalAddedSubsidio removeObject:empleado];
                        
                        NSString *keyId = [empleado objectForKey:@"extrakey"];
                        
                        [ServerController DeleteComensal:keyId withhandler:^(NSString *resp) {
                            [self ReloadDataForm:self.CurseIndex];
                        }];
                        
                        MustExit = NO;
                        break;

                    }
                }
                
                index ++;
            }
            
            if (deleteItems.count >0)
            {
                for (NSDictionary *dinners in deleteItems)
                {
                    NSString *keyId = [dinners objectForKey:@"extrakey"];
                    
                    [ServerController DeleteComensal:keyId withhandler:^(NSString *resp) {
                        
                    }];
                    
                    [self ReloadDataForm:self.CurseIndex];
                }
            }
            
            if (MustExit)
            {
                [self ReloadDataForm:self.CurseIndex];
                
                NSString *keyId = [elementToDelete objectForKey:@"extrakey"];
                
                [ServerController DeleteComensal:keyId withhandler:^(NSString *resp) {
                    [self ReloadDataForm:self.CurseIndex];
                }];
                
                if (index > 0)
                {
                    keyId = [elementToDeleteGuest objectForKey:@"extrakey"];
                    
                    [ServerController DeleteComensal:keyId withhandler:^(NSString *resp) {
                        NSLog(resp);
                    }];
                }
                
            }
            
        }
    }
    else if (alertView.tag == 3)
    {
        if (buttonIndex == 1)
        {
            self.AddingInvitado = YES;
            
            [self openCamera:nil];
        }
        else{
            [self.currentUserSponsor setObject:@"true" forKey:@"deleteicon"];
            [self.comensalAddedInvidadosExtra insertObject:self.currentUserSponsor atIndex:0];
            
            self.AddingInvitado = NO;
            
            [self ReloadDataForm:self.CurseIndex];
        }
    }
    else
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        
        UITextField *username = [alertView textFieldAtIndex:0];
        
        self.field.value = username.text;
        
        if (alertView.tag== 2)
        {
            
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            
            NSMutableArray *FoodTypes = [[NSMutableArray alloc] init];
            [FoodTypes addObject:@"Agua"];
            [FoodTypes addObject:@"Refresco"];
            [FoodTypes addObject:@"Comida"];
            
            
            [dic setObject:FoodTypes forKey:@"options"];
            
            NSString *key = @"";
            
            [dic setObject:key forKey:@"key"];
            
            
            
            
            NSString *idUser = key;
            
            
            [dic setObject:idUser forKey:@"extrakey"];
            [dic setObject:@"true" forKey:@"deleteicon"];
            
            [dic setObject:[username.text uppercaseString] forKey:@"title"];
            // [dic setObject:@"editUser:" forKey:@"action"];
            
            [dic setObject:@"Comida" forKey:@"default"];
            
            
            NSMutableDictionary *dicCopy = [[NSMutableDictionary alloc] init];
            
            [dicCopy setObject:FoodTypes forKey:@"options"];
            [dicCopy setObject:key forKey:@"key"];
            [dicCopy setObject:[[username.text uppercaseString] uppercaseString] forKey:@"title"];
            
            [dicCopy setObject:@"Comida" forKey:@"default"];
            [dicCopy setObject:@"Asistentes" forKey:@"header"];
            
            [dic removeObjectForKey:@"deleteicon"];
            
            [self.comensalAddedInvidadosExtra insertObject:dic atIndex:0];
           
            
            [self.comensalAddedInvidadosExtraDeleted removeObject:dic];
            [self.comensalAddedInvidadosExtraDeleted removeObject:dicCopy];
            
            NSString *titleMesg = @"¿Deseas agregar otro invitado?";
            
            
            UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Control de Comedor"
                                                              message:titleMesg
                                                             delegate:self
                                                    cancelButtonTitle:@"No"
                                                    otherButtonTitles:@"Si", nil];
            
            myAlert.tag = 3;
            
            [myAlert show];

            
            [self ReloadDataForm:self.CurseIndex];

        }
        else
            [self FillEmpleadoAsitente:username.text];
    }
    
}

-(void)FillEmpleadoAsitente:(NSString *)idUser
{
    [self starthud];
    
    NSString *Restrinction = @"true";
    
    if (self.ComensalType != 0)
        Restrinction = @"false";
    
    [ServerController comensalListUsersAvailable:idUser withRestrinction:Restrinction withHandler:^(NSDictionary *lst) {
        
        @try {
            
            if (lst != nil)
            {
                if ([lst objectForKey:@"comensal"])
                {
                    NSDictionary *user = [lst objectForKey:@"comensal"];
                    
                    if (user == [NSNull null])
                    {
                        user = nil;
                    }
                    else if (user == NULL)
                    {
                        user = nil;
                    }
                    
                    if (user != nil)
                    {
                        if ([user objectForKey:@"iac_id"])
                        {
                            if (self.asistentesAdded == nil)
                                self.asistentesAdded = [[NSMutableArray alloc] init];
                            
                            if (self.asistentesAddedInvite == nil)
                                self.asistentesAddedInvite = [[NSMutableArray alloc] init];
                            
                            
                            
                            
                            BOOL AlredyAdded = NO;
                            
                            
                            for (NSDictionary *server in self.AsistentesServer) {
                                
                                if ([server objectForKey:@"iac_id"] == [user objectForKey:@"iac_id"] && self.asistentesAdded.count > 0)
                                {
                                    AlredyAdded = YES;
                                    break;
                                }
                            }
                            
                            
                            
                            for (NSDictionary *server in self.asistentesAdded)
                            {
                                
                                if ([server objectForKey:@"iac_id"] == [user objectForKey:@"iac_id"] && self.asistentesAdded.count > 0)
                                {
                                    AlredyAdded = YES;
                                    break;
                                }
                            }
                            
                            AlredyAdded = NO;
                            
                            
                            if (!AlredyAdded)
                            {
                                
                                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                                
                                
                                NSMutableArray *FoodTypes = [[NSMutableArray alloc] init];
                                [FoodTypes addObject:@"Agua"];
                                [FoodTypes addObject:@"Refresco"];
                                [FoodTypes addObject:@"Comida"];
                                
                                
                                [dic setObject:FoodTypes forKey:@"options"];
                                [dic setObject:[user objectForKey:@"iac_id"] forKey:@"key"];
                                
                                
                                
                                
                                NSString *idUser = [NSString stringWithFormat:@"%@",[user objectForKey:@"id"]];
                                
                                
                                [dic setObject:idUser forKey:@"extrakey"];
                                [dic setObject:@"true" forKey:@"deleteicon"];
                                
                                [dic setObject:[[user objectForKey:@"name"] uppercaseString] forKey:@"title"];
                                // [dic setObject:@"editUser:" forKey:@"action"];
                                
                                [dic setObject:@"Comida" forKey:@"default"];
                                
                                
                                NSMutableDictionary *dicCopy = [[NSMutableDictionary alloc] init];
                                
                                [dicCopy setObject:FoodTypes forKey:@"options"];
                                [dicCopy setObject:[user objectForKey:@"iac_id"] forKey:@"key"];
                                [dicCopy setObject:[[user objectForKey:@"name"] uppercaseString] forKey:@"title"];
                                
                                [dicCopy setObject:@"Comida" forKey:@"default"];
                                [dicCopy setObject:@"Asistentes" forKey:@"header"];
                                
                                
                                if (self.comensalAddedNormal == nil)
                                    self.comensalAddedNormal = [[NSMutableArray alloc] init];
                                
                                if (self.comensalAddedSubsidio == nil)
                                    self.comensalAddedSubsidio = [[NSMutableArray alloc] init];
                                
                                if (self.comensalAddedTiempoExtra == nil)
                                    self.comensalAddedTiempoExtra = [[NSMutableArray alloc] init];
                                
                                if (self.comensalAddedInvidadosExtra == nil)
                                    self.comensalAddedInvidadosExtra = [[NSMutableArray alloc] init];
                                
                                if (self.comensalAddedNormalDeleted == nil)
                                    self.comensalAddedNormalDeleted = [[NSMutableArray alloc] init];
                                
                                if (self.comensalAddedSubsidioDeleted == nil)
                                    self.comensalAddedSubsidioDeleted = [[NSMutableArray alloc] init];
                                
                                if (self.comensalAddedTiempoExtraDeleted == nil)
                                    self.comensalAddedTiempoExtraDeleted = [[NSMutableArray alloc] init];
                                
                                if (self.comensalAddedInvidadosExtra == nil)
                                    self.comensalAddedInvidadosExtra = [[NSMutableArray alloc] init];
                                
                                if (self.comensalAddedInvidadosExtraDeleted == nil)
                                    self.comensalAddedInvidadosExtraDeleted = [[NSMutableArray alloc] init];
                                
                                switch (self.ComensalType) {
                                    case 0:
                                    {
                                        [self.comensalAddedNormal insertObject:dic atIndex:0];
                                        
                                        [self.comensalAddedNormalDeleted removeObject:dic];
                                        [self.comensalAddedNormalDeleted removeObject:dicCopy];
                                    }
                                        break;
                                    case 1:
                                    {
                                        [self.comensalAddedSubsidio insertObject:dic atIndex:0];
                                        
                                        [self.comensalAddedSubsidioDeleted removeObject:dic];
                                        [self.comensalAddedSubsidioDeleted removeObject:dicCopy];
                                    }
                                        break;
                                    case 2:
                                    {
                                        [self.comensalAddedTiempoExtra insertObject:dic atIndex:0];
                                        
                                        [self.comensalAddedTiempoExtraDeleted removeObject:dic];
                                        [self.comensalAddedTiempoExtraDeleted removeObject:dicCopy];
                                    }
                                        break;
                                        
                                    case 3:
                                    {
                                        if (self.invitadosActivo)
                                        {
                                            if (self.AddingInvitado)
                                            {
                                                
                                                [dic removeObjectForKey:@"deleteicon"];
                                                
                                                [self.comensalAddedInvidadosExtra insertObject:dic atIndex:0];
                                                 //[self.currentUserSponsor setObject:@"true" forKey:@"deleteicon"];
                                                //[self.comensalAddedInvidadosExtra insertObject:self.currentUserSponsor atIndex:0];
                                                
                                                [self.comensalAddedInvidadosExtraDeleted removeObject:dic];
                                                [self.comensalAddedInvidadosExtraDeleted removeObject:dicCopy];
                                                
                                                self.AddingInvitado = NO;
                                                
                                                NSString *titleMesg = @"¿Deseas agregar otro invitado?";
                                                
                                                
                                                UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Control de Comedor"
                                                                                                  message:titleMesg
                                                                                                 delegate:self
                                                                                        cancelButtonTitle:@"No"
                                                                                        otherButtonTitles:@"Si", nil];
                                                
                                                myAlert.tag = 3;
                                                
                                                [myAlert show];
                                                
                                            }
                                            else
                                            {
                                                
                                                NSMutableDictionary *dicSponsor = [[NSMutableDictionary alloc] init];
                                                
                                                [dicSponsor setObject:[user objectForKey:@"iac_id"]  forKey:@"key"];
                                                
                                                [dicSponsor setObject:@"Patrocinador" forKey:@"title"];
                                                
                                                [dicSponsor setObject:[[user objectForKey:@"name"] uppercaseString] forKey: @"default"];
                                                
                                                [dicSponsor setObject:@"true" forKey:@"deleteicon"];
                                                [dicSponsor setObject:idUser forKey:@"extrakey"];
                                                [dicSponsor setObject:@"true" forKey:@"deleteicon"];
                                                
                                                self.currentUserSponsor = dicSponsor;
                                                
                                                self.AddingInvitado = YES;
                                                
                                                [self openCamera:nil];
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self stophud];
                                                    
                                                });
                                                
                                                return;
                                            }
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                    }
                                        break;
                                }
                                
                                
                                
                                
                            }
                            else
                            {
                                self.currentUserSelected = user;
                                
                                NSString *titleMesg = [NSString stringWithFormat:@"El usuario %@ ya ha sido agregado, ¿deseas agregarlo de nuevo?",[user objectForKey:@"name"]];
                                
                                
                                UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Control de Comedor"
                                                                                  message:titleMesg
                                                                                 delegate:self
                                                                        cancelButtonTitle:@"No"
                                                                        otherButtonTitles:@"Si", nil];
                                
                                myAlert.tag = 12347;
                                
                                [myAlert show];
                                
                                
                                // [self show:@"El registro de asistencia de este empleado ya existe"];
                            }
                            
                            [self ReloadDataForm:self.CurseIndex];
                        }
                        else
                            [self show:@"Empleado No encontrado"];
                    }
                    else
                    {
                        double error_code = [[lst objectForKey:@"error_code"] doubleValue];
                        
                        
                        if (error_code == 2)
                        {
                            [self show:@"Por favor cambie el tipo, este empleado no puede ser dado de alta como tipo Normal"];
                        }
                        else
                        {
                            [self show:@"Empleado No encontrado"];
                        }
                    }
                    
                    
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
    if (alertView.tag == 1)
    {
        return YES;
    }
    if (alertView.tag == 3)
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
