//
//  AboutController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 24/02/16.
//  Copyright © 2016 ievolutioned. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()

@property (nonatomic, retain) NSString *updateUrl;
@property (nonatomic, retain) NSString *shortVersion;
@property (nonatomic, retain) UIButton *btnUpdate;
@property (nonatomic, retain) UIButton *btnCheck;
@property (nonatomic, retain) UILabel *lblServerVersion;

@end

@implementation AboutController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self AddElements];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)AddElements
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *vheader = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, [[UIScreen mainScreen] bounds].size.width/2, 151)];
    
    UIImage *logo = [UIImage imageNamed:@"logoIconLogin.png"];
    
    UIImageView *vlogo = [[UIImageView alloc] initWithImage:logo];
    
    vlogo.clipsToBounds = YES;
    
    vlogo.frame = CGRectMake( ([[UIScreen mainScreen] bounds].size.width/2) - ((logo.size.width/3)/2), 20, logo.size.width/3, logo.size.height/3);
    
    [vlogo setContentMode:UIViewContentModeScaleAspectFit];
    
    [vheader addSubview:vlogo];
    
    vheader.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:vlogo];
    
    UILabel *lblcopyRight = [[UILabel alloc] initWithFrame:CGRectMake(0, vlogo.frame.size.height + vlogo.frame.origin.y, [[UIScreen mainScreen] bounds].size.width, 35)];
    
    lblcopyRight.font = [UIFont systemFontOfSize:11];
    
    lblcopyRight.textColor = [UIColor blackColor];
    
    lblcopyRight.textAlignment = NSTextAlignmentCenter;
    
    lblcopyRight.text = @"Iacna Hermosillo S de RL de CV. All rights reserved.";
    
    lblcopyRight.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:lblcopyRight];
    
    UILabel * lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, lblcopyRight.frame.size.height + lblcopyRight.frame.origin.y, [[UIScreen mainScreen] bounds].size.width, 35)];
    lblDescription.textColor = [UIColor blackColor];
    
    lblDescription.textAlignment = NSTextAlignmentCenter;
    
    self.shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    lblDescription.text = [NSString stringWithFormat:@"Versión Actual %@",self.shortVersion];
    
    lblDescription.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:lblDescription];
    
    //Iacna Hermosillo S de RL de CV. All rights reserved.
    
    
    
    self.lblServerVersion = [[UILabel alloc] initWithFrame:CGRectMake(0, lblDescription.frame.size.height + lblDescription.frame.origin.y, [[UIScreen mainScreen] bounds].size.width, 35)];
    self.lblServerVersion.textColor = [UIColor blackColor];
    
    self.lblServerVersion.textAlignment = NSTextAlignmentCenter;
    
    self.lblServerVersion.text = [NSString stringWithFormat:@"Ultima Version disponible %@",@"[Cargando...]"];
    
    
    
    self.lblServerVersion.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.lblServerVersion];
    
    
    self.btnUpdate = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btnUpdate addTarget:self
               action:@selector(updtatedVersion)
     forControlEvents:UIControlEventTouchUpInside];
    [self.btnUpdate setTitle:@"Descargar Versión" forState:UIControlStateNormal];
    self.btnUpdate.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width / 2) - (([[UIScreen mainScreen] bounds].size.width / 2)/2),  self.lblServerVersion.frame.size.height + self.lblServerVersion.frame.origin.y + 5,[[UIScreen mainScreen] bounds].size.width/2, 40.0);
    
    [self.btnUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     self.btnUpdate.hidden = YES;
    self.btnUpdate.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.btnUpdate];
    
    
    
    self.btnCheck = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btnCheck addTarget:self
               action:@selector(checkVersion)
     forControlEvents:UIControlEventTouchUpInside];
    [self.btnCheck setTitle:@"Revisar" forState:UIControlStateNormal];
    self.btnCheck.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width / 2) - (([[UIScreen mainScreen] bounds].size.width / 2)/2),  self.lblServerVersion.frame.size.height + self.lblServerVersion.frame.origin.y + 5,[[UIScreen mainScreen] bounds].size.width/2, 40.0);
    
    [self.btnCheck setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnCheck.hidden = YES;
    self.btnCheck.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.btnCheck];
    
  
    
    [self checkService];
    
}

-(void) checkService
{
    
     self.lblServerVersion.text = [NSString stringWithFormat:@"Ultima Version disponible %@",@"[Cargando...]"];
    self.shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
     
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [ServerController versionList:^(NSDictionary * nn) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *version_ios = [[nn objectForKey:@"last_versions_mobiles"] objectForKey:@"version_ios"];
                
                self.lblServerVersion.text = [NSString stringWithFormat:@"Ultima Version disponible %@",version_ios];
                
                self.updateUrl = [[nn objectForKey:@"last_versions_mobiles"] objectForKey:@"url_ios"];
                
                if (![version_ios isEqualToString:self.shortVersion])
                {
                    self.btnCheck.hidden = YES;
                    self.btnUpdate.hidden = NO;
                }
                else
                {
                   
                    self.btnUpdate.hidden = YES;
                    self.btnCheck.hidden = NO;
                }
                
            });
            
            
        }];
    });
}

- (void)updtatedVersion
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.updateUrl ]];
}

- (void)checkVersion
{
    [self checkService];
}

@end
