//
//  ServerConnection.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 27/02/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "ServerConnection.h"

@implementation ServerConnection


+(void)curseList:(void (^)(NSArray *))handler
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:@"https://iacgroup.herokuapp.com/courses.json"]];
    
    [request setHTTPMethod:@"GET"];
    
    [request setValue:0 forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        
        NSLog(@"Terminado bajado de info");
        
        @try {
            if(!error)
            {
                NSArray *responseJson2 = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
                
                if (responseJson2.count > 0)
                {
                    
                    handler(responseJson2);
                }
                else
                    handler(nil);
            }
            else
            {
                
                handler(nil);
                
            }
        }
        @catch (NSException *exception) {
            
            
            handler(nil);
        }
        @finally {
            
        }
        
    }];
    
    
}

@end
