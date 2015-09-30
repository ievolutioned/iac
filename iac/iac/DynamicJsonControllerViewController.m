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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
    }
    
}

-(void)showMsg:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [alertView show];
}
@end
