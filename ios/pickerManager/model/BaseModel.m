//
//  BaseModel.m
//  picker
//
//  Created by 尼古拉斯·常·穆罕默德 on 2018/1/10.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
  - (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString: @"id"]){
      [self setValue:value forKey:_str_id];
    }
  }
@end
