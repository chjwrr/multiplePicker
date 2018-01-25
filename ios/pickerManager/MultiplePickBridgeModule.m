//
//  MultiplejPickBridgeModule.m
//  picker
//
//  Created by 尼古拉斯·常·穆罕默德 on 2018/1/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "MultiplePickBridgeModule.h"

#import <React/RCTEventDispatcher.h>
#import "PCAPicker.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface MultiplePickBridgeModule()

@property (nonatomic, weak)    UIWindow * window;
@property (nonatomic, strong)  PCAPicker *picker;
@property (nonatomic, strong)  UIButton *bgView;
@property (nonatomic)          CGFloat pickerHeight;
@property (nonatomic, strong)  NSString *pickerType;

@end

@implementation MultiplePickBridgeModule

@synthesize bridge = _bridge;

RCT_EXPORT_MODULE();


/*
 初始化 picker
 */
RCT_EXPORT_METHOD(init:(NSDictionary *)diction){
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    self.window = [UIApplication sharedApplication].keyWindow;
    
    self.bgView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.0;
    [self.window addSubview:self.bgView];
    [self.bgView addTarget:self action:@selector(hiddentPicker) forControlEvents:UIControlEventTouchUpInside];
    self.bgView.hidden = YES;

    self.pickerHeight = 216 + 44;
    
    // 创建 省市区 picker
    _picker=[[PCAPicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.pickerHeight) diction:diction];
  });
  
  /*
   [self.bridge.eventDispatcher sendAppEventWithName:@"PCAInfoEvent" body:@{@"Province": pDic, @"City":cDic, @"Area":aDic}];
   */
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    [self.window addSubview:self.picker];
  });
  
}

/*
 显示 省市区 picker
 */
RCT_EXPORT_METHOD(showPCAPicker:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  self.bgView.hidden = NO;
  
  if (self.picker) {
    /**
     省市区三级联动
     
     @param pDic 省 信息
     @param cDic 市 信息
     @param aDic 区 信息
     */
    __weak MultiplePickBridgeModule *weakSelf = self;
    self.picker.pcaBlcok = ^(NSDictionary *pDic, NSDictionary *cDic, NSDictionary *aDic){
      
      if ([pDic.allKeys count] != 0) {
        resolve(@{@"Province": pDic, @"City":cDic, @"Area":aDic});
      }
      
      MultiplePickBridgeModule *strongSelf = weakSelf;
      [strongSelf dismissPicker];
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [UIView animateWithDuration:.3 animations:^{
        
        [self.picker setFrame:CGRectMake(0, SCREEN_HEIGHT-self.pickerHeight, SCREEN_WIDTH, self.pickerHeight)];
        self.bgView.alpha = 0.5;

      }];
    });
  }
}



/*
 显示 时间 picker
 */
RCT_EXPORT_METHOD(showTimePicker:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  self.bgView.hidden = NO;
  
  if (self.picker) {
    
    __weak MultiplePickBridgeModule *weakSelf = self;
    self.picker.timeBlcok = ^(NSString *time, NSString *week){
  
      if (![time isEqualToString:@""]) {
        resolve(@{@"time":time, @"week":week});
      }
      
      MultiplePickBridgeModule *strongSelf = weakSelf;
      [strongSelf dismissPicker];
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [UIView animateWithDuration:.3 animations:^{
        
        [self.picker setFrame:CGRectMake(0, SCREEN_HEIGHT-self.pickerHeight, SCREEN_WIDTH, self.pickerHeight)];
        
      }];
    });
  }
}


/*
 显示 自定义多级不联动 picker
 */
RCT_EXPORT_METHOD(showCustomPicker:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  self.bgView.hidden = NO;
  
  if (self.picker) {
   
    __weak MultiplePickBridgeModule *weakSelf = self;
    self.picker.customBlock = ^(NSArray *data){
      
      if ([data count] != 0) {
        resolve(@{@"data":data});
      }
      
      MultiplePickBridgeModule *strongSelf = weakSelf;
      [strongSelf dismissPicker];
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [UIView animateWithDuration:.3 animations:^{
        
        [self.picker setFrame:CGRectMake(0, SCREEN_HEIGHT-self.pickerHeight, SCREEN_WIDTH, self.pickerHeight)];
        
      }];
    });
  }
}


/*
 隐藏 picker
 */
RCT_EXPORT_METHOD(hidePicker){
  [self dismissPicker];
}


/**
 隐藏 view

 @param view 需要隐藏的 view
 */
- (void)dismissPicker{
  if (self.picker) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [UIView animateWithDuration:.3 animations:^{
        [self.picker setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.pickerHeight)];
        self.bgView.alpha = 0.0;
        
      } completion:^(BOOL finished) {
        if (finished){
          //[self.multiplePicker removeFromSuperview];
          self.bgView.hidden = YES;
        }
      }];
    });
  }
}


/**
 点击上方背景  隐藏 picker
 */
- (void)hiddentPicker {
    [self dismissPicker];

}

@end

/*
 dispatch_async(dispatch_get_main_queue(), ^{
 
 [self.bridge.eventDispatcher sendAppEventWithName:@"multiplePickerEvent" body:@"数据"];
 
 });
 */

