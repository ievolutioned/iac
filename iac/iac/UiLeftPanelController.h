//
//  UiLeftPanelController.h
//  mapilu
//
//  Created by Hipolyto Obeso Huerta on 04/12/14.
//  Copyright (c) 2014 ievolutioned. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "WebViewController.h"
#import "RSBarcodes.h"
#import "EscuestaSatisfaccionController.h"

@interface UiLeftPanelController : UITableViewController
{
     RSScannerViewController *scanner;
}

@end
