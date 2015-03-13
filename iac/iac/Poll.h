//
//  Poll.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 10/03/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface Poll : NSManagedObject


@property (nonatomic, retain) NSManagedObjectContext *managedObjectModel;

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSNumber * inquest_id;
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSNumber * synched;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * user_id;

+(bool)save:(NSString *)_title WithUserId:(NSNumber *)userid Withinquestid:(NSNumber *)inquest_id WithResponse:(NSString *)_response
WithQuestion:(NSString *)_question WithCreated:(NSDate *)_created WithUpdated:(NSDate *)_updated  issynched:(NSNumber *)_synched;

+(Poll *) getPoolbyinquest_id:(NSNumber *)inquest_id;

@end
