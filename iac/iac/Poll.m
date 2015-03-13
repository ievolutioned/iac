//
//  Poll.m
//  iac
//
//  Created by Hipolyto Obeso Huerta on 10/03/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import "Poll.h"


@implementation Poll

@dynamic created;
@dynamic updated;

@dynamic inquest_id;
@dynamic user_id;

@dynamic question;
@dynamic response;

@dynamic synched;

@dynamic title;







+(bool)save:(NSString *)_title WithUserId:(NSNumber *)userid Withinquestid:(NSNumber *)inquest_id WithResponse:(NSString *)_response
 WithQuestion:(NSString *)_question WithCreated:(NSDate *)_created WithUpdated:(NSDate *)_updated  issynched:(NSNumber *)_synched
{
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    
    Poll *failedBankInfo = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Poll"
                            inManagedObjectContext:context];
    
    failedBankInfo.title = _title;
    
    failedBankInfo.inquest_id = inquest_id;
    failedBankInfo.user_id = userid;
    
    failedBankInfo.question = _question;
    failedBankInfo.response = _response;
    
    failedBankInfo.created = _created;
    failedBankInfo.updated = _updated;
    
    failedBankInfo.synched = _synched;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        
    }
    

    
    return YES;
}

/*
+(bool)save:(NSString *)_title WithUserId:(NSNumber *)userid Withinquestid:(NSNumber *)inquest_id WithResponse:(NSString *)_response
WithQuestion:(NSString *)_question WithCreated:(NSDate *)_created WithUpdated:(NSDate *)_updated  issynched:(NSNumber *)_synched
{
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    
    Poll *failedBankInfo = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Poll"
                            inManagedObjectContext:context];
    
    failedBankInfo.title = _title;
    
    failedBankInfo.inquest_id = inquest_id;
    failedBankInfo.user_id = userid;
    
    failedBankInfo.question = _question;
    failedBankInfo.response = _response;
    
    failedBankInfo.created = _created;
    failedBankInfo.updated = _updated;
    
    failedBankInfo.synched = _synched;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        
    }
    
    
    
    return YES;
}
*/
+(Poll *) getPoolbyinquest_id:(NSNumber *)inquest_id
{
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Poll"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"inquest_id = %@",
     [inquest_id stringValue]];
    [request setPredicate:pred];
    
    NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0) {
        
    } else {
        matches = objects[0];
        NSString *appnem = [matches valueForKey:@"title"];
        NSLog( appnem);
        
        return matches;
    }

    
    return nil;
}



@end
