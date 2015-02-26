//
//  ListacursosViewController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 24/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "ListacursosViewController.h"

@interface ListacursosViewController ()
@property (nonatomic, strong) NSArray *lstCursos;
@end

@implementation ListacursosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FormFieldsCursos" ofType:@"json"];
    NSData *fieldsData = [NSData dataWithContentsOfFile:path];
    
    self.lstCursos = [NSJSONSerialization JSONObjectWithData:fieldsData options:(NSJSONReadingOptions)0 error:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UILabel * lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(57, 8, [[UIScreen mainScreen] bounds].size.width - 80, 25)];
    lblDescription.textColor = [UIColor blackColor];

    
    NSDictionary *item = [self.lstCursos objectAtIndex:indexPath.row];
    
    lblDescription.text = [item objectForKey:@"title"];
    
    //cell.detailTextLabel.text = [item objectForKey:@"title"];
    
    
    lblDescription.backgroundColor = [UIColor clearColor];
    [cell addSubview:lblDescription];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllEmpleadoController *rm = [[AllEmpleadoController alloc] init];
    
    [self.navigationController pushViewController:rm animated:rm];
}

@end
