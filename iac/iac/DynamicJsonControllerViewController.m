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
@end
