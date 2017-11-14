//
//  LoadingCameraViewController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 26/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "LoadingCameraViewController.h"

@interface LoadingCameraViewController ()
@property (nonatomic, strong) UIImageView *picture;
@end

@implementation LoadingCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    [self initViews];
    [self initConstraints];

    scanner = [[RSScannerViewController alloc] initWithCornerView:YES
                                                      controlView:YES
                                                  barcodesHandler:^(NSArray *barcodeObjects) {
                                                      if (barcodeObjects.count > 0) {
                                                          [barcodeObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  AVMetadataMachineReadableCodeObject *code = obj;
                                                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Barcode found"
                                                                                                                  message:code.stringValue
                                                                                                                 delegate:self
                                                                                                        cancelButtonTitle:@"OK"
                                                                                                        otherButtonTitles:nil];
                                                                  //[scanner dismissViewControllerAnimated:true completion:nil];
                                                                  //[scanner.navigationController popViewControllerAnimated:YES];
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      [scanner dismissViewControllerAnimated:true completion:nil];
                                                                      [alert show];
                                                                  });
                                                              });
                                                          }];
                                                      }
                                                      
                                                  }
               
                                          preferredCameraPosition:AVCaptureDevicePositionBack];
    
    [scanner setIsButtonBordersVisible:YES];
    [scanner setStopOnFirst:YES];
    
   [self.view addSubview:scanner.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self // put here the view controller which has to be notified
                                             selector:@selector(orientationChanged:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];

}




-(void)onTick
{
     [self presentViewController:scanner animated:YES completion:nil];
   //[self.view addSubview:scanner.view];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        // change positions etc of any UIViews for Landscape
        
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];

        
    } else {
        // change position etc for Portait
        
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 2.0
                                                      target: self
                                                    selector:@selector(onTick)
                                                    userInfo: nil repeats:NO];

    }
     //[self.view addSubview:scanner.view];
    // forward the rotation to any child view controllers if required
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initViews
{
    self.picture = [[UIImageView alloc] init];
    self.picture.image = [UIImage imageNamed:@"logoIcon.jpg"];
    
    self.picture.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:self.picture];
}

-(void)initConstraints
{
    self.picture.translatesAutoresizingMaskIntoConstraints = NO;
    
    id views = @{
                 @"picture": self.picture,
                 
                 };
    
    // picture constraints
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[picture]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[picture]|" options:0 metrics:nil views:views]];
    
    
    
}
@end
