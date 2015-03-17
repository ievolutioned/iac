//
//  ServerController.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 16/03/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "ServerController.h"

@implementation ServerController

+(void)doLogin:(NSString * )username  withPass:(NSString *)pass withCallback:(void(^)(bool ,NSString *)) callback
{
    NSString *urlsource = [NSString stringWithFormat:@"https://iacgroup.herokuapp.com/api/services/access?emai=%@&password=%@",username,pass];
    NSString *escapedUrl = [urlsource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [ServerController performServiceCallToUrl:escapedUrl secretString:[self getLoginSecretString] dateString:[self getDateString] andDeviceID:[self getDeviceID]];
    
    NSLog(@"%@",jsonString);
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    bool status = NO;
    NSString *msg = @"";
    
    if ([[dictionary valueForKey:@"status"] isEqualToString:@"unprocessable_entity"])
    {
        status = NO;
        
        msg = [dictionary valueForKey:@"error"];
    }
    else
    {
        status = YES;
        
        [BaseViewController setLogin];
        [BaseViewController setUserData:dictionary];
    }
    
    callback(status,msg);
}


+(NSString *) performServiceCallToUrl:(NSString *) escapedUrl secretString:(NSString *) secretString dateString:(NSString *) dateString andDeviceID:(NSString *) deviceID
{
    
    id stringReply;
    @try {
        NSURL *Myurl = [NSURL URLWithString:escapedUrl];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: Myurl];
        
        [request setHTTPMethod: @"GET"];
        //3bdac397f6b625ed86d05c46b4228f6d
        [request setValue:@"V2" forHTTPHeaderField:@"X-version"];
        [request setValue:@"3b7336f6d1f2a733903b6cd828cafdfc" forHTTPHeaderField:@"X-token"];
        [request setValue:secretString forHTTPHeaderField:@"X-secret"];
        [request setValue:dateString forHTTPHeaderField:@"X-device-date"];
        [request setValue:deviceID forHTTPHeaderField:@"X-device-id"];
        
        
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (data == nil) {
            // Check for problems
            if (error != nil) {
                NSLog(@"Error: %@", error);
                
            }
        }
        else {
            stringReply = [(NSString *)[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSHTTPURLResponse *httpResponse;
            httpResponse = (NSHTTPURLResponse *)response;
        }
        
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        return stringReply;
    }
}


#pragma mark Request Helper

+(NSString *) getLoginSecretString
{
    NSString *secretString = [NSString stringWithFormat:@"d4e9a9414181819f3a47ff1ddd9b2ca3-%@-%@-V1-%@-%@-%@", @"properties", @"access", [self getReverseIDFromDeviceID:[self getDeviceID]],@"nosession", [self getDateString]];
    NSString *secret = [secretString MD5Digest];
    return secret;
}

+(NSString *) getPropertiesSecretString
{
    NSString *secretString = [NSString stringWithFormat:@"d4e9a9414181819f3a47ff1ddd9b2ca3-%@-%@-V1-%@-%@", @"properties", @"index", [self getReverseIDFromDeviceID:[self getDeviceID]],[self getDateString]];
    NSString *secret = [secretString MD5Digest];
    return secret;
}

+(NSString *) getDeviceID
{
    NSUUID *identifierForVendor = [[UIDevice currentDevice] identifierForVendor];
    NSString *deviceID = [identifierForVendor UUIDString];
    return deviceID;
}

+(NSString *) getReverseIDFromDeviceID:(NSString *) deviceID
{
    NSMutableString *reversedID = [NSMutableString string];
    NSInteger charIndex = [deviceID length];
    while (deviceID && charIndex > 0) {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reversedID appendString:[deviceID substringWithRange:subStrRange]];
    }
    return reversedID;
}

+(NSString *) getDateString
{
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateformate stringFromDate:[NSDate date]];
    return date;
}

@end
