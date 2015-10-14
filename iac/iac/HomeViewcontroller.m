//
//  HomeViewcontroller.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 19/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "HomeViewcontroller.h"
#import "LoginViewController.h"

@interface HomeViewcontroller ()
@property (nonatomic, strong) UIImageView *picture;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation HomeViewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self initConstraints];
    
    self.loaded = @"0";
    
    if (![BaseViewController isLogin])
    {
        
        LoginViewController *controller = [[LoginViewController alloc] init];
        
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
    
    NSDictionary *data  = [BaseViewController UserData];
    
    NSString *admin_token = [data objectForKey:@"admin_token"];
    
    
    if (admin_token.length <= 0)
    {
        
        LoginViewController *controller = [[LoginViewController alloc] init];
        
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    if ([BaseViewController isLogin])
    {
        NSDictionary *data  = [BaseViewController UserData];
        
        NSString *admin_token = [data objectForKey:@"admin_token"];
        
        
        if (admin_token.length > 0)
        {
        NSString *urlPage = [NSString stringWithFormat:@"https://iacgroup.herokuapp.com/admin?ref=%@&token_access=%@",@"xedni/draobhsad",admin_token];
        
        //[self starthud];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPage]]];
        }
        else
        {
            LoginViewController *controller = [[LoginViewController alloc] init];
            
            [self.navigationController presentViewController:controller animated:YES completion:nil];
        }
    }
 
}

-(void)initViews
{
    self.picture = [[UIImageView alloc] init];
    self.picture.image = [UIImage imageNamed:@"logoIcon.jpg"];
    
    self.picture.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:self.picture];
    
    
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    
    
    
    self.webView.tag = 56;
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(0.0, 50.0)"]];
    
    [self.view addSubview:self.webView];
    
    self.webView.scalesPageToFit = YES;
    
    self.webView.delegate = self;
    
    self.webView.userInteractionEnabled = YES;
    
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO; //add this line.
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.webView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
}

#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[self stophud];
    if ( [self.loaded isEqualToString:@"0"])
    {
         self.loaded = @"1";
        [self starthud];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     self.loaded = @"1";
    [self stophud];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [self stophud];
}

-(void)initConstraints
{
    /*
     self.picture.translatesAutoresizingMaskIntoConstraints = NO;
     
     id views = @{
     @"picture": self.picture,
     
     };
     
     // picture constraints
     [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[picture]|" options:0 metrics:nil views:views]];
     [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[picture]|" options:0 metrics:nil views:views]];
     
     */
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)dom1:(id)sender {
    
    [self presentViewController:scanner animated:YES completion:nil];
}

- (IBAction)dom2:(id)sender {
    
    EncuestaSalidaController *salida = [[EncuestaSalidaController alloc] init];
    
    [self.navigationController pushViewController:salida animated:YES];
}

- (IBAction)dom3:(id)sender {
}
@end
