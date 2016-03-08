//
//  FaqController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 13/01/16.
//  Copyright © 2016 ievolutioned. All rights reserved.
//

#import "FaqController.h"

@interface FaqController ()
@property (nonatomic, strong) UIImageView *picture;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *loaded;

@end

@implementation FaqController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
    self.loaded = @"0";
  
    NSDictionary *data  = [BaseViewController UserData];
    
    NSString *admin_token = [data objectForKey:@"admin_token"];
    
    NSString *urlPage = [NSString stringWithFormat:@"https://iacgroup.herokuapp.com/admin/asks?ref=%@&token_access=%@",@"xedni/draobhsad",admin_token];
    
    if (self.customUrl.length > 0)
        urlPage = [NSString stringWithFormat:@"%@?ref=%@&token_access=%@",self.customUrl,@"xedni/draobhsad",admin_token];
    

    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlPage]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
   
    
}

-(void)initViews
{
    self.picture = [[UIImageView alloc] init];
    self.picture.image = [UIImage imageNamed:@"logoIcon.jpg"];
    
    self.picture.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:self.picture];
    
    
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];  //Change self.view.bounds to a smaller CGRect if you don't want it to take up the whole screen
    
    
    
    self.webView.tag = 56;
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"window.scrollTo(50.0, 50.0)"]];
    
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


@end
