//
//  DynamicFromLocalJson.h
//  iac
//
//  Created by Hipolyto Obeso Huerta on 11/03/15.
//  Copyright (c) 2015 ievolutioned. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface DynamicFromLocalJson : NSObject <FXForm>

- (id)initWitJsonName :(NSString *)_jsonName;

- (id)initWitJsonForm :(NSArray *)_jsonForm;


@property (nonatomic, strong) NSMutableDictionary *valuesByKey;
@property (nonatomic, strong) NSArray *jsonForm;
@property (nonatomic, strong) NSString  *jsonName;

@end
