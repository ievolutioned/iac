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
    NSString *urlsource = [NSString stringWithFormat:@"https://iacgroup.herokuapp.com/api/services/access?iac_id=%@&password=%@",username,pass];
    
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

+(void)versionList:(void (^)(NSDictionary *))handler
{
    NSString *urlsource = @"https://iacgroup.herokuapp.com/api/services/mobile_versions/";
    
    NSString *escapedUrl = [urlsource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *jsonString = [ServerController performServiceCallVersionToUrl:escapedUrl secretString:[self getVersionSecretString] dateString:[self getDateString] andDeviceID:[self getDeviceID]];
    
    NSLog(@"%@",jsonString);
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    
    handler (dictionary);

    //performServiceCallVersionToUrl
}

+(void)curseList:(void (^)(NSArray *))handler
{
    NSString *urlsource = [NSString stringWithFormat:@"%@?admin-token=%@",@"https://iacgroup.herokuapp.com/api/inquests",[BaseViewController UserToken]];
    
    NSString *escapedUrl = [urlsource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *jsonString = [ServerController performServiceCallToUrl:escapedUrl secretString:[self getPropertiesSecretString] dateString:[self getDateString] andDeviceID:[self getDeviceID]];
    
    NSLog(@"%@",jsonString);
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    bool status = NO;
    NSString *msg = @"";
    
    if ([dictionary valueForKey:@"inquests"])
    {
       
        NSArray *lst = [dictionary objectForKey:@"inquests"];
         handler(lst);
    }
    else
    {
        handler(nil);
        
    }
    
    

}


+(void)ProfileList:(void (^)(NSMutableDictionary *))handler
{
    NSString *urlsource = [NSString stringWithFormat:@"%@?admin-token=%@",@"http://iacgroup.herokuapp.com/api/admin/get_info_admin",[BaseViewController UserToken]];
    
    NSString *escapedUrl = [urlsource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *jsonString = [ServerController performServiceCallToUrl:escapedUrl secretString:[self getProfileSecretString] dateString:[self getDateString] andDeviceID:[self getDeviceID]];
    
    NSLog(@"%@",jsonString);
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    bool status = NO;
    NSString *msg = @"";
    
    if ([dictionary valueForKey:@"amidn_info"])
    {
        
        handler(dictionary);
    }
    else
    {
        handler(dictionary);
        
    }
    
    
    
}


+(void)createForm:(NSDictionary *)jsonDic withinquest_id:(NSString *)inquest_id withhandler:(void (^)(BOOL,NSString *))handler
{
    NSString *urlsource = @"https://iacgroup.herokuapp.com/api/user_responses/";
    
    NSString *escapedUrl = [urlsource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *UserData  =[BaseViewController UserData];
    
    
    NSDictionary *responseDic = @{
                                  @"response" : jsonDic,
                               };
    
    NSDictionary *data = @{
                               @"inquest_id" : inquest_id,
                               @"iac_id": [UserData objectForKey:@"amin_iac_id"],
                               @"user_response":responseDic,
                               };
    
    
    
    NSError *writeError = nil;
    
    NSData *jsonDataRequest = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&writeError];
    
    NSString *jsonRequest = [[NSString alloc] initWithData:jsonDataRequest encoding:NSUTF8StringEncoding];
    
    
    NSString *jsonString = [ServerController performServicePostToUrl:escapedUrl secretString:[self getCreateFormSecretString] dateString:[self getDateString] andDeviceID:[self getDeviceID] withJSON:jsonRequest];
    
    NSLog(@"%@",jsonString);
    
    NSData *dataResp = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    
   
    
    
    NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:dataResp options:kNilOptions error:nil];
    
    bool status = NO;
    NSString *msg = @"";
    
    NSString *statusStr = [[dictionary valueForKey:@"status"] stringValue];
    
    if (![statusStr isEqualToString:@"200"])
    {
        status = NO;
        
        msg = @"Error formulario bloqueado, dias restantes";
        
        
        
        if ([dictionary valueForKey:@"days_remaining"])
        {
            msg =  [NSString stringWithFormat:@"%@:%@",msg,[[dictionary valueForKey:@"days_remaining"] stringValue]];
        }
        else
        {
            if ([dictionary valueForKey:@"error"])
                msg = [dictionary valueForKey:@"error"];
            else
                msg = @"Error formulario bloqueado.";


        }
    }
    else
    {
        msg = @"Formulario Enviado";

        status = YES;
        
    }
    
    handler(status,msg);
}



+(void)updateProfile:(NSDictionary *)jsonDic withinquest_id:(NSString *)inquest_id withhandler:(void (^)(BOOL,NSString *))handler
{
    NSString *urlsource = [NSString stringWithFormat:@"%@?admin-token=%@",@"http://iacgroup.herokuapp.com/api/admin/update_admin",[BaseViewController UserToken]];
    
    NSString *escapedUrl = [urlsource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *UserData  =[BaseViewController UserData];
    
    
  
    
    NSDictionary *data = nil;
    
    if ([jsonDic objectForKey:@"password"])
    {
        data = @{
                 @"email" : [jsonDic objectForKey:@"email"],
                 @"password": [jsonDic objectForKey:@"password"],
                 @"password_confirmation":[jsonDic objectForKey:@"password"],
                 };
    }
    else
    {
        data = @{
                 @"email" : [jsonDic objectForKey:@"email"]
                };
    }
    
    
    NSDictionary *responseDic = @{
                                  @"admin" : data,
                                  };
    
    
    NSError *writeError = nil;
    
    NSData *jsonDataRequest = [NSJSONSerialization dataWithJSONObject:responseDic options:NSJSONWritingPrettyPrinted error:&writeError];
    
    NSString *jsonRequest = [[NSString alloc] initWithData:jsonDataRequest encoding:NSUTF8StringEncoding];
    
    
    NSString *jsonString = [ServerController performServicePutProfileUpdateToUrl:escapedUrl secretString:[self getUpdateProfileSecretString] dateString:[self getDateString] andDeviceID:[self getDeviceID] withJSON:jsonRequest];
    
    NSLog(@"%@",jsonString);
    
    NSData *dataResp = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    
    
    NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:dataResp options:kNilOptions error:nil];
    
    bool status = NO;
    NSString *msg = @"";
    
    msg = @"Perfil Actualizado";
    
    status = YES;
    
    handler(status,msg);
}


+(NSString *) performServicePutProfileUpdateToUrl:(NSString *) escapedUrl secretString:(NSString *) secretString dateString:(NSString *) dateString andDeviceID:(NSString *) deviceID withJSON:(NSString *)json
{
    
    id stringReply;
    @try {
        NSURL *Myurl = [NSURL URLWithString:escapedUrl];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: Myurl];
        
        [request setHTTPMethod:@"PUT"];
        //3bdac397f6b625ed86d05c46b4228f6d
        [request setValue:@"V1" forHTTPHeaderField:@"X-version"];
        [request setValue:@"d4e9a9414181819f3a47ff1ddd9b2ca3" forHTTPHeaderField:@"X-token"];
        
        [request setValue:[BaseViewController UserToken] forHTTPHeaderField:@"X-admin-token"];
        
        
        
        [request setValue:deviceID forHTTPHeaderField:@"X-device-id"];
        [request setValue:dateString forHTTPHeaderField:@"X-device-date"];
        [request setValue:secretString forHTTPHeaderField:@"X-secret"];
        
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
        
        //set post data of request
        NSData *body = [json dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setValue:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
        
        [request setHTTPBody:body];
        
        
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error != nil) {
            NSLog(@"Error: %@", error);
            
        }
        else {
            stringReply = [(NSString *)[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSHTTPURLResponse *httpResponse;
            httpResponse = (NSHTTPURLResponse *)response;
            
            NSLog(@"%ld",(long)httpResponse.statusCode);
        }
        
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        return stringReply;
    }
}


+(NSString *) performServicePostToUrl:(NSString *) escapedUrl secretString:(NSString *) secretString dateString:(NSString *) dateString andDeviceID:(NSString *) deviceID withJSON:(NSString *)json
{
    
    id stringReply;
    @try {
        NSURL *Myurl = [NSURL URLWithString:escapedUrl];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: Myurl];
        
        [request setHTTPMethod:@"POST"];
        //3bdac397f6b625ed86d05c46b4228f6d
        [request setValue:@"V1" forHTTPHeaderField:@"X-version"];
        [request setValue:@"d4e9a9414181819f3a47ff1ddd9b2ca3" forHTTPHeaderField:@"X-token"];
        
       [request setValue:[BaseViewController UserToken] forHTTPHeaderField:@"X-admin-token"];
       
        
        
        [request setValue:deviceID forHTTPHeaderField:@"X-device-id"];
        [request setValue:dateString forHTTPHeaderField:@"X-device-date"];
        [request setValue:secretString forHTTPHeaderField:@"X-secret"];
        
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
        
        //set post data of request
        NSData *body = [json dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setValue:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
        
        [request setHTTPBody:body];

        
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error != nil) {
            NSLog(@"Error: %@", error);
            
        }
        else {
            stringReply = [(NSString *)[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSHTTPURLResponse *httpResponse;
            httpResponse = (NSHTTPURLResponse *)response;
            
            NSLog(@"%ld",(long)httpResponse.statusCode);
        }
        
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        return stringReply;
    }
}

+(NSString *) performServiceCallToUrl:(NSString *) escapedUrl secretString:(NSString *) secretString dateString:(NSString *) dateString andDeviceID:(NSString *) deviceID
{
    
    id stringReply;
    @try {
        NSURL *Myurl = [NSURL URLWithString:escapedUrl];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: Myurl];
        
        [request setHTTPMethod:@"GET"];
        //3bdac397f6b625ed86d05c46b4228f6d
        [request setValue:@"V1" forHTTPHeaderField:@"X-version"];
        [request setValue:@"d4e9a9414181819f3a47ff1ddd9b2ca3" forHTTPHeaderField:@"X-token"];
        
        if ([BaseViewController isLogin ])
        {
            [request setValue:[BaseViewController UserToken] forHTTPHeaderField:@"X-admin-token"];
        
               }
        else
            [request setValue:@"nosession" forHTTPHeaderField:@"X-admin-token"];
        
        
        [request setValue:deviceID forHTTPHeaderField:@"X-device-id"];
        [request setValue:dateString forHTTPHeaderField:@"X-device-date"];
         [request setValue:secretString forHTTPHeaderField:@"X-secret"];
        
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
        
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error != nil) {
            NSLog(@"Error: %@", error);
            
        }
        else {
            stringReply = [(NSString *)[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSHTTPURLResponse *httpResponse;
            httpResponse = (NSHTTPURLResponse *)response;
            
            NSLog(@"%ld",(long)httpResponse.statusCode);
        }
        
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
        return stringReply;
    }
}



+(NSString *) performServiceCallVersionToUrl:(NSString *) escapedUrl secretString:(NSString *) secretString dateString:(NSString *) dateString andDeviceID:(NSString *) deviceID
{
    
    id stringReply;
    @try {
        NSURL *Myurl = [NSURL URLWithString:escapedUrl];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: Myurl];
        
        [request setHTTPMethod:@"GET"];
        //3bdac397f6b625ed86d05c46b4228f6d
        [request setValue:@"V1" forHTTPHeaderField:@"X-version"];
        [request setValue:@"d4e9a9414181819f3a47ff1ddd9b2ca3" forHTTPHeaderField:@"X-token"];
      [request setValue:@"nosession" forHTTPHeaderField:@"X-admin-token"];
      
        
        
        [request setValue:deviceID forHTTPHeaderField:@"X-device-id"];
        [request setValue:dateString forHTTPHeaderField:@"X-device-date"];
        [request setValue:secretString forHTTPHeaderField:@"X-secret"];
        
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"json" forHTTPHeaderField:@"Data-Type"];
        
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (error != nil) {
            NSLog(@"Error: %@", error);
            
        }
        else {
            stringReply = [(NSString *)[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSHTTPURLResponse *httpResponse;
            httpResponse = (NSHTTPURLResponse *)response;
            
            NSLog(@"%ld",(long)httpResponse.statusCode);
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
   NSString *secretString = [NSString stringWithFormat:@"d4e9a9414181819f3a47ff1ddd9b2ca3-%@-%@-V1-%@-%@-%@", @"services", @"access", [self getReverseIDFromDeviceID:[self getDeviceID]],@"nosession", [self getDateString]];
   // NSString *secretString = [NSString stringWithFormat:@"3b7336f6d1f2a733903b6cd828cafdfc-%@-%@-V2-%@-%@-%@", @"services", @"access", [self getReverseIDFromDeviceID:[self getDeviceID]],@"nosession", [self getDateString]];
    NSString *secret = [secretString MD5Digest];
    return secret;
}


+(NSString *) getVersionSecretString
{
    NSString *secretString = [NSString stringWithFormat:@"d4e9a9414181819f3a47ff1ddd9b2ca3-%@-%@-V1-%@-%@-%@", @"services", @"mobile_versions", [self getReverseIDFromDeviceID:[self getDeviceID]],@"nosession", [self getDateString]];
    // NSString *secretString = [NSString stringWithFormat:@"3b7336f6d1f2a733903b6cd828cafdfc-%@-%@-V2-%@-%@-%@", @"services", @"access", [self getReverseIDFromDeviceID:[self getDeviceID]],@"nosession", [self getDateString]];
    NSString *secret = [secretString MD5Digest];
    return secret;
}

+(NSString *) getCreateFormSecretString
{
    
    NSString *secretString = [NSString stringWithFormat:@"d4e9a9414181819f3a47ff1ddd9b2ca3-%@-%@-V1-%@-%@-%@", @"user_responses", @"create", [self getReverseIDFromDeviceID:[self getDeviceID]],[BaseViewController UserToken],[self getDateString]];
    
    //NSString *secretString = [NSString stringWithFormat:@"3b7336f6d1f2a733903b6cd828cafdfc-%@-%@-V2-%@-%@", @"properties", @"index", [self getReverseIDFromDeviceID:[self getDeviceID]],[self getDateString]];
    
    NSString *secret = [secretString MD5Digest];
    return secret;
}


+(NSString *) getUpdateProfileSecretString
{
    
    NSString *secretString = [NSString stringWithFormat:@"d4e9a9414181819f3a47ff1ddd9b2ca3-%@-%@-V1-%@-%@-%@", @"admin", @"update_admin", [self getReverseIDFromDeviceID:[self getDeviceID]],[BaseViewController UserToken],[self getDateString]];
    
    //NSString *secretString = [NSString stringWithFormat:@"3b7336f6d1f2a733903b6cd828cafdfc-%@-%@-V2-%@-%@", @"properties", @"index", [self getReverseIDFromDeviceID:[self getDeviceID]],[self getDateString]];
    
    NSString *secret = [secretString MD5Digest];
    return secret;
}

+(NSString *) getPropertiesSecretString
{

    NSString *secretString = [NSString stringWithFormat:@"d4e9a9414181819f3a47ff1ddd9b2ca3-%@-%@-V1-%@-%@-%@", @"inquests", @"index", [self getReverseIDFromDeviceID:[self getDeviceID]],[BaseViewController UserToken],[self getDateString]];

    //NSString *secretString = [NSString stringWithFormat:@"3b7336f6d1f2a733903b6cd828cafdfc-%@-%@-V2-%@-%@", @"properties", @"index", [self getReverseIDFromDeviceID:[self getDeviceID]],[self getDateString]];

    NSString *secret = [secretString MD5Digest];
    return secret;
}

+(NSString *) getProfileSecretString
{
    
    NSString *secretString = [NSString stringWithFormat:@"d4e9a9414181819f3a47ff1ddd9b2ca3-%@-%@-V1-%@-%@-%@", @"admin", @"get_info_admin", [self getReverseIDFromDeviceID:[self getDeviceID]],[BaseViewController UserToken],[self getDateString]];
    
    //NSString *secretString = [NSString stringWithFormat:@"3b7336f6d1f2a733903b6cd828cafdfc-%@-%@-V2-%@-%@", @"properties", @"index", [self getReverseIDFromDeviceID:[self getDeviceID]],[self getDateString]];
    
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
