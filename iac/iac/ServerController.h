//
//  ServerController.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 16/03/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import "NSString+MD5.h"
#import "BaseViewController.h"
@interface ServerController : NSObject

+(void)doLogin:(NSString * )username  withPass:(NSString *)pass withCallback:(void(^)(bool ,NSString *)) callback;

+(void)curseList:(void (^)(NSArray *))handler;

+(void)ProfileList:(void (^)(NSMutableDictionary *))handler;
@end
