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

+(void)createForm:(NSDictionary *)jsonDic withinquest_id:(NSString *)inquest_id withhandler:(void (^)(BOOL,NSString *))handle;

+(void)updateProfile:(NSDictionary *)jsonDic withinquest_id:(NSString *)inquest_id withhandler:(void (^)(BOOL,NSString *))handler;

+(void)versionList:(void (^)(NSDictionary *))handler;

+(void)curseListAvailable:(void (^)(NSArray *))handler;

+(void)curseListUsersAvailable:(NSString *)CursoId withHandler:(void (^)(NSArray *))handler;
+(void)curseListUsersInfo:(NSString *)UserId withHandler:(void (^)(NSMutableDictionary *))handler;
+(void)createFormAsistencia:(NSDictionary *)jsonDic withiCurse_id:(NSString *)Curse_id withiAttendee_ids:(NSString *)attendee_ids withhandler:(void (^)(BOOL,NSString *))handler;

+(void)ComensalesList:(NSString *)site_id withhandler:(void (^)(NSArray *))handler;
+(void)comensalListUsersAvailable:(NSString *)UserId withRestrinction:(NSString *)Restrinction withHandler:(void (^)(NSMutableDictionary *))handler;

+(void)createFormComedor:(NSDictionary *)jsonDic withhandler:(void (^)(BOOL,NSString *))handler;

+(void)DeleteComensal:(NSString *)user_id withhandler:(void (^)(NSString *))handler;

@end
