//
//  UIColor+Hex.h
//  picker
//
//  Created by 尼古拉斯·常·穆罕默德 on 2018/1/16.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)


/**
 处理16进制颜色

 @param color #123456 、 0X123456、 123456   三种类型
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color;


/**
 处理16进制颜色

 @param color color #123456 、 0X123456、 123456   三种类型
 @param alpha 透明度
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
