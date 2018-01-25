//
//  ModelUtil.m
//  picker
//
//  Created by 尼古拉斯·常·穆罕默德 on 2018/1/10.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "ModelUtil.h"

#import "ProvinceModel.h"
#import "CityModel.h"
#import "AreaModel.h"

@implementation ModelUtil

  + (NSArray *)fixCityUtil {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"];
    
    NSData *cityData = [NSData dataWithContentsOfFile:path];
    
    
    //解析JSON
    NSArray *data = [NSJSONSerialization JSONObjectWithData:cityData
                                            options:NSJSONReadingMutableLeaves
                                              error:nil];
    
    
    NSMutableArray *provinces = [[NSMutableArray alloc]init];

    for (int i = 0; i<[data count]; i++) {
      
      // 省 信息
      ProvinceModel *provinceModel = [[ProvinceModel alloc]init];
      NSDictionary *provinceDic = [data objectAtIndex:i];
      
      provinceModel.abb = [provinceDic objectForKey:@"abb"];
      provinceModel.code = [provinceDic objectForKey:@"code"];
      provinceModel.str_id = [provinceDic objectForKey:@"id"];
      provinceModel.name = [provinceDic objectForKey:@"name"];
      provinceModel.spell = [provinceDic objectForKey:@"spell"];

      
      // 市 信息
      NSMutableArray *citys = [[NSMutableArray alloc]init];
      NSArray *city =[provinceDic objectForKey:@"city"];
      
      for (int j = 0; j<[city count]; j++) {
        CityModel *cityModel = [[CityModel alloc]init];
        NSDictionary *cityDic = [city objectAtIndex:j];

        cityModel.abb = [cityDic objectForKey:@"abb"];
        cityModel.code = [cityDic objectForKey:@"code"];
        cityModel.str_id = [cityDic objectForKey:@"id"];
        cityModel.name = [cityDic objectForKey:@"name"];
        cityModel.spell = [cityDic objectForKey:@"spell"];
        
        
        // 区 信息
        NSMutableArray *areas = [[NSMutableArray alloc]init];
        NSArray *area =[cityDic objectForKey:@"area"];
        
        for (int z = 0; z<[area count]; z++) {
          AreaModel *areaModel = [[AreaModel alloc]init];
          NSDictionary *areaDic = [area objectAtIndex:z];
          
          areaModel.abb = [areaDic objectForKey:@"abb"];
          areaModel.code = [areaDic objectForKey:@"code"];
          areaModel.str_id = [areaDic objectForKey:@"id"];
          areaModel.name = [areaDic objectForKey:@"name"];
          areaModel.spell = [areaDic objectForKey:@"spell"];
          
          [areas addObject:areaModel];
        }
        
        cityModel.area = [NSArray arrayWithArray:areas];
        
        [citys addObject:cityModel];
        
      }
      provinceModel.city = [NSArray arrayWithArray:citys];

      [provinces addObject:provinceModel];
    }
  
    return [NSArray arrayWithArray:provinces];
  }
  
@end
