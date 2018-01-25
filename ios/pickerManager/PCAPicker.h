//
//  MultiplePicker.h
//  picker
//
//  Created by 尼古拉斯·常·穆罕默德 on 2018/1/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

// picker 的类型
typedef enum : NSUInteger {
  PICKER_PCA,     // 省市区
  PICKER_YMD,     // 年月日
  PICKER_HM,      // 时分
  PICKER_YMDHM,   // 年月日时分
  PICKER_CUSTOM,  // 自定义多级不联动
  PICKER_CUSTOMLINKAGE // 自定义多级联动
} PickerType;

// 选中pieker row 的类型
typedef enum : NSUInteger {
  CENTER_TYPE_LINE, // 上下两条线
  CENTER_TYPE_COLOR, // 中间背景色
  CENTER_TYPE_BOTH // 背景色和上下两条线都有
} PickerCenterType;



/**
 省市区 block

 @param pDic 省
 @param cDic 市
 @param aDic 区
 */
typedef void(^PCAblock)(NSDictionary *pDic, NSDictionary *cDic, NSDictionary *aDic);


/**
 年月日 block

 @param NSString 选择的时间
 */
typedef void (^YMDBlock)(NSString *date, NSString *week);


typedef void (^CUSTOMBlock)(NSArray *data);
@interface PCAPicker : UIView

@property (nonatomic, copy) PCAblock pcaBlcok;
@property (nonatomic, copy) YMDBlock timeBlcok;
@property (nonatomic, copy) CUSTOMBlock customBlock;


/*
 PCA       ===    PICKER_PCA
 YMD       ===    PICKER_YMD
 HM        ===    PICKER_HM
 YMDHM     ===    PICKER_YMDHM
 CUSTOM    ===    PICKER_CUSTOM
 */

/*
line       ===    CENTER_TYPE_LINE
color      ===    CENTER_TYPE_COLOR
both       ===    CENTER_TYPE_BOTH
*/


/**
 初始化方法

 @param frame 位置
 @param diction 属性
 @return showView
 */

-(instancetype)initWithFrame: (CGRect)frame diction: (NSDictionary *)diction;
@end
