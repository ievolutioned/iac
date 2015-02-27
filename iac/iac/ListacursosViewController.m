//
//  ListacursosViewController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 24/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "ListacursosViewController.h"
#import "ServerConnection.h"

@interface ListacursosViewController ()
@property (nonatomic, strong) NSArray *lstCursos;
@end

@implementation ListacursosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FormFieldsCursos" ofType:@"json"];
    NSData *fieldsData = [NSData dataWithContentsOfFile:path];
    
    [self starthud];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            [ServerConnection curseList:^(NSArray * lst) {
        
            self.lstCursos = lst;
        
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Your main thread code goes in here
                    [self.tableView reloadData];
                    
                    [self stophud];

                });
                
                
            }];
    });
   
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestCurses)
                  forControlEvents:UIControlEventValueChanged];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Curses

-(void)getLatestCurses
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [ServerConnection curseList:^(NSArray * lst) {
            
            self.lstCursos = lst;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //Your main thread code goes in here
                [self.tableView reloadData];
                
                if (self.refreshControl) {
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"MMM d, h:mm a"];
                    NSString *title = [NSString stringWithFormat:@"Ultima Actualizaciòn: %@", [formatter stringFromDate:[NSDate date]]];
                    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                                forKey:NSForegroundColorAttributeName];
                    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
                    self.refreshControl.attributedTitle = attributedTitle;
                    
                    [self.refreshControl endRefreshing];
                }
                
            });
            
            
        }];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.lstCursos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"CellItem";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell = nil;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILabel * lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, [[UIScreen mainScreen] bounds].size.width - 80, 25)];
    lblDescription.textColor = [UIColor blackColor];

    
    NSDictionary *item = [self.lstCursos objectAtIndex:indexPath.row];
    
    lblDescription.text = [item objectForKey:@"title"];
    
    //cell.detailTextLabel.text = [item objectForKey:@"title"];
    
    
    lblDescription.backgroundColor = [UIColor clearColor];
    [cell addSubview:lblDescription];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllEmpleadoController *rm = [[AllEmpleadoController alloc] init];
    
    [self.navigationController pushViewController:rm animated:rm];
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
