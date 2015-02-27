//
//  ServerConnection.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 27/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

+(void)curseList:(void (^)(NSArray *))handler;

@end
