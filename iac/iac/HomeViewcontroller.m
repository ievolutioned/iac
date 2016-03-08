//
//  HomeViewcontroller.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 19/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "HomeViewcontroller.h"
#import "LoginViewController.h"
#import "ServerController.h"
#import "BaseViewController.h"
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
        
        UINavigationController *navLog = [[UINavigationController alloc] initWithRootViewController:controller];
        navLog.navigationBar.translucent = YES;
        [self.navigationController presentViewController:navLog animated:YES completion:nil];
        
        return;
    }
    
    NSDictionary *data  = [BaseViewController UserData];
    
    NSString *admin_token = [data objectForKey:@"admin_token"];
    
    
    if (admin_token.length <= 0)
    {
        
        LoginViewController *controller = [[LoginViewController alloc] init];
        UINavigationController *navLog = [[UINavigationController alloc] initWithRootViewController:controller];
        navLog.navigationBar.translucent = YES;
        [self.navigationController presentViewController:navLog animated:YES completion:nil];
    }
    
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
    [self.splitViewController.displayModeButtonItem action];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) goback
{
    if ([self.webView canGoBack])
        [ self.webView goBack];
    else
    {
        
        NSLog(@"can't go back");

        NSDictionary *data  = [BaseViewController UserData];
        
        NSString *admin_token = [data objectForKey:@"admin_token"];

        
        NSString *urlPage = [NSString stringWithFormat:@"https://iacgroup.herokuapp.com/admin?ref=%@&token_access=%@",@"xedni/draobhsad",admin_token];
        
        //[self starthud];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPage]]];

    }
   }

-(void) goNext
{
    [self.webView goForward];
}


-(void) viewDidAppear:(BOOL)animated
{
    
   
    
    if ([BaseViewController isLogin] && ![BaseViewController ishomeLoaded])
    {
        NSDictionary *data  = [BaseViewController UserData];
        
        NSString *admin_token = [data objectForKey:@"admin_token"];
        
        
        if (admin_token.length > 0)
        {
            NSString *urlPage = [NSString stringWithFormat:@"https://iacgroup.herokuapp.com/admin?ref=%@&token_access=%@",@"xedni/draobhsad",admin_token];
            
            //[self starthud];
            
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPage]]];
            
          
            UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIImage *leftIcon = [UIImage imageNamed:@"leftIcon"];
            
            [leftBtn setImage:leftIcon forState:UIControlStateNormal];
            
            leftBtn.frame = CGRectMake(0, 5, 25, 25);
            
            [leftBtn addTarget:self
                              action:@selector(goback)
                    forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            UIImage *rightIcon = [UIImage imageNamed:@"RightIcon"];
            
            [leftBtn addTarget:self
                        action:@selector(goNext)
              forControlEvents:UIControlEventTouchUpInside];
            
            [rightBtn setImage:rightIcon forState:UIControlStateNormal];
            
            rightBtn.frame = CGRectMake(60, 5, 25, 25);

            
            UIView *vCenter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            
            
            [vCenter addSubview:leftBtn];
            
                [vCenter addSubview:rightBtn];
            
                     //   self.navigationItem.titleView = vCenter;
            
            //[self.navigationItem.titleView sizeToFit];

        }
        else
        {
            LoginViewController *controller = [[LoginViewController alloc] init];
            
            UINavigationController *navLog = [[UINavigationController alloc] initWithRootViewController:controller];
            navLog.navigationBar.translucent = YES;
            [self.navigationController presentViewController:navLog animated:YES completion:nil];        }
    }
    else if ([self.webView canGoBack])
        [ self.webView goBack];
    
}

-(void)initViews
{
    self.picture = [[UIImageView alloc] init];
    self.picture.image = [UIImage imageNamed:@"logoIcon.jpg"];
    
    self.picture.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:self.picture];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
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
                                                          attribute:NSLayoutAttributeLeft
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

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return YES;
}

- (void)handleRightSwipe:(UISwipeGestureRecognizer *)recognizer {
    
   }

#pragma mark - New Browser
-(void)openExternalURL:(NSURL *)url
{
    FaqController *faq = [[FaqController alloc] init];
    faq.customUrl = [url absoluteString];
    faq.showBack = YES;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:faq];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:nil];
}
//NSLog(@"%@",[url absoluteString]);
//[self openExternalURL:url];//Handle External URL here


#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //[self stophud];
    if ( [self.loaded isEqualToString:@"0"])
    {
        self.loaded = @"1";
        [self starthud];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [ServerController curseList:^(NSArray * lst) {
                [BaseViewController setUserMenu:lst];
            }];
            
        });
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loaded = @"1";
    [self stophud];
    
    [BaseViewController setishomeLoaded];
    
     NSString *yourHTMLSourceCodeString = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
    NSLog(@"%@",yourHTMLSourceCodeString);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [self stophud];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked){
        
        NSURL *url = request.URL;
        NSLog(@"%@",[url absoluteString]);
        [self openExternalURL:url];//Handle External URL here
        
    }
    
    return YES;
    
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
