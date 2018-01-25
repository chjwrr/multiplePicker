//
//  BaseModel.h
//  picker
//
//  Created by 尼古拉斯·常·穆罕默德 on 2018/1/10.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
  @property (nonatomic, copy)NSString *abb;
  @property (nonatomic, copy)NSString *code;
  @property (nonatomic, copy)NSString *name;
  @property (nonatomic, copy)NSString *spell;
  @property (nonatomic, copy)NSString *str_id;
@end
