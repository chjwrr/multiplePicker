//
//  MultiplePicker.m
//  picker
//
//  Created by 尼古拉斯·常·穆罕默德 on 2018/1/9.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "PCAPicker.h"
#import "ModelUtil.h"
#import "UIColor+Hex.h"

#import "ProvinceModel.h"
#import "CityModel.h"
#import "AreaModel.h"


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface PCAPicker()<UIPickerViewDelegate, UIPickerViewDataSource>
  
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *topView;

// 常规属性

@property (nonatomic) PickerType pickerType; // picker 的类型
@property (nonatomic) PickerCenterType pickerCenterType; // 选中 picker row 的类型
@property (nonatomic, strong) NSString *pickerCenterRowColor; // pickerCenterType == line  就是 上下两条线的颜色，  pickerCenterType == color 就是中间部分的背景色

@property (nonatomic, strong) NSString *topViewBgColor; // 标题栏背景色
@property (nonatomic, strong) NSString *leftTitleColor; // 左侧按钮文字颜色
@property (nonatomic, strong) NSString *rightTitleColor; // 右侧按钮文字颜色
@property (nonatomic, strong) NSString *centerTitleColor; // 中间文字颜色
@property (nonatomic, strong) NSString *leftTitle; // 左侧文字
@property (nonatomic, strong) NSString *rightTitle; // 右侧文字
@property (nonatomic, strong) NSString *centerTitle; // 中间文字


// 时间
@property (nonatomic, strong) NSString *currentTime; // 所选中的时间
@property (nonatomic, strong) NSString *currentWeek; // 所选中的时间的星期
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *ymdTimeFormatter; // 年月日 日期格式
@property (nonatomic, strong) NSString *hmTimeFormatter; // 时分 日期格式
@property (nonatomic, strong) NSString *ymdhmTimeFormatter; // 年月日时分 日期格式
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateComponents *comps;

// 自定义多级不联动
@property (nonatomic, strong) NSArray *customData; //数据
@property (nonatomic, strong) NSMutableArray *customSelectData; //选中的数据

// 自定义多级联动
@property (nonatomic, strong) NSArray *customLinkageData; //数据
@property (nonatomic, strong) NSMutableArray *customLinkageSelectData; //选中的数据
@property (nonatomic) NSInteger linkageComponent; //component的个数
@property (nonatomic, strong) NSMutableArray *customLinkageSelectRows; //当前选中的 row 数组
@property (nonatomic, strong) NSMutableArray *customLinkageRows; // 当前 component 的 row 的个数 的数组
@property (nonatomic) NSInteger firstSelRow; //   第一个component 选择的row
@property (nonatomic) NSInteger secondSelRow; //  第二个component 选择的row
@property (nonatomic) NSInteger thirdSelRow; //   第三个component 选择的row
@property (nonatomic) NSInteger fourSelRow; //    第四个component 选择的row
@property (nonatomic) NSInteger fiveSelRow; //    第五个component 选择的row




/*省市区 相关数据*/
@property (nonatomic,strong) NSArray *pcaData;

// 省 当前选择
@property (nonatomic) NSInteger provincNum;
// 市 当前选择
@property (nonatomic) NSInteger cityNum;
// 区 当前选择
@property (nonatomic) NSInteger areaNum;



@end
@implementation PCAPicker
  
-(instancetype)initWithFrame: (CGRect)frame diction: (NSDictionary *)diction {
    self = [super initWithFrame:frame];
    if (self)
    {
      self.backgroundColor=[UIColor whiteColor];

      [self setPickType:[NSString stringWithString:[diction objectForKey:@"pickerType"]]];
      [self setPickCenterRowType:[self setDefaultValue:[NSString stringWithString:[diction objectForKey:@"centerType"]] defaultValue:@"both"]];

      _pickerCenterRowColor = [NSString stringWithString:[self setDefaultValue:[NSString stringWithString:[diction objectForKey:@"centerColor"]] defaultValue:@"#f5f5f5"]];
      _topViewBgColor = [NSString stringWithString:[self setDefaultValue:[NSString stringWithString:[diction objectForKey:@"topViewBgColor"]] defaultValue:@"#f5f5f5"]];
      _leftTitleColor = [NSString stringWithString:[self setDefaultValue:[NSString stringWithString:[diction objectForKey:@"leftTitleColor"]] defaultValue:@"#8F8F8F"]];
      _rightTitleColor =[NSString stringWithString:[self setDefaultValue:[NSString stringWithString:[diction objectForKey:@"rightTitleColor"]] defaultValue:@"#4876FF"]];
      _centerTitleColor = [NSString stringWithString:[self setDefaultValue:[NSString stringWithString:[diction objectForKey:@"centerTitleColor"]] defaultValue:@"#000000"]];
      _leftTitle = [NSString stringWithString:[self setDefaultValue:[NSString stringWithString:[diction objectForKey:@"leftTitle"]] defaultValue:@"取消"]];
      _rightTitle = [NSString stringWithString:[self setDefaultValue:[NSString stringWithString:[diction objectForKey:@"rightTitle"]] defaultValue:@"确定"]];
      _centerTitle = [NSString stringWithString:[self setDefaultValue:[NSString stringWithString:[diction objectForKey:@"centerTitle"]] defaultValue:@"请选择"]];
      
      
      
      // 时间
      _dateFormatter = [[NSDateFormatter alloc] init];
      _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
      _comps = [[NSDateComponents alloc] init];
      
      _ymdTimeFormatter = [NSString stringWithString:[self setDefaultValue:[NSString stringWithFormat:@"%@",[diction objectForKey:@"ymdTimeFormatter"]] defaultValue:@"yyyy-MM-dd"]];
      _hmTimeFormatter = [NSString stringWithString:[self setDefaultValue:[NSString stringWithFormat:@"%@",[diction objectForKey:@"hmTimeFormatter"]] defaultValue:@"HH:mm"]];
      _ymdhmTimeFormatter = [NSString stringWithString:[self setDefaultValue:[NSString stringWithFormat:@"%@",[diction objectForKey:@"ymdhmTimeFormatter"]] defaultValue:@"YYYY-MM-dd HH:mm"]];

      switch (self.pickerType) {
        case PICKER_YMD:
          _dateFormatter.dateFormat = _ymdTimeFormatter;
          break;
        case PICKER_HM:
          _dateFormatter.dateFormat = _hmTimeFormatter;
          break;
        case PICKER_YMDHM:
          _dateFormatter.dateFormat = _ymdhmTimeFormatter;
          break;
        default:
          break;
      }
      _currentTime = [NSString stringWithFormat:@"%@",[_dateFormatter stringFromDate:[NSDate date]]];
      _currentWeek = [NSString stringWithFormat:@"%@", [self getWeek:[NSDate date]]];
  
      
      
      // 自定义多级不联动
      _customData = [NSArray arrayWithArray:[diction objectForKey:@"customData"]];
      _customSelectData = [[NSMutableArray alloc]init];
      
      // 默认全部选择为第一个数据
      for (int i=0; i<[self.customData count]; i++) {
        NSArray *array = [self.customData objectAtIndex:i];
        NSDictionary *diction = [array objectAtIndex:0];
        [self.customSelectData addObject:[diction objectForKey:@"title"]];
      }
      
      
      // 自定义多级联动
      _customLinkageData = [NSArray arrayWithArray:[diction objectForKey:@"customLinkageData"]];
      _customLinkageSelectData = [[NSMutableArray alloc] init];
      _customLinkageRows = [[NSMutableArray alloc] init];
      _customLinkageSelectRows = [[NSMutableArray alloc] init];

      if ([self.customLinkageData count] >0){
        NSDictionary *firstDic = [self.customLinkageData objectAtIndex:0];
        
        [_customLinkageSelectData addObject:[self formatterDic:firstDic]];

        BOOL isEnd = NO;
        _linkageComponent = 1;
        while (!isEnd) {
          if ([[firstDic allKeys] containsObject:@"subs"]) {
            isEnd = NO;
            _linkageComponent ++;
            

            NSArray *subs = [firstDic objectForKey:@"subs"];
            firstDic = [subs objectAtIndex:0];
            [_customLinkageSelectData addObject:[self formatterDic:firstDic]];

          }else
            isEnd = YES;
        }
      }
      _firstSelRow = 0;
      _secondSelRow = 0;
      _thirdSelRow = 0;
      _fourSelRow = 0;
      _fiveSelRow = 0;
      
      
      
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [self addSubview:self.centerView];
        
        if (self.pickerType == PICKER_PCA || self.pickerType == PICKER_CUSTOM || self.pickerType == PICKER_CUSTOMLINKAGE) {
          [self addSubview:self.picker];
        }
        if (self.pickerType == PICKER_YMD) {
          self.datePicker.datePickerMode = UIDatePickerModeDate;
          [self addSubview:self.datePicker];
        }
        if (self.pickerType == PICKER_HM) {
          self.datePicker.datePickerMode = UIDatePickerModeTime;
          [self addSubview:self.datePicker];
        }
        if (self.pickerType == PICKER_YMDHM) {
          self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
          [self addSubview:self.datePicker];
        }
        
        [self addSubview:self.topView];
      });
     
    }
    return self;
  }

- (NSMutableDictionary *)formatterDic: (NSDictionary *)dic {
  NSMutableDictionary *ddd = [[NSMutableDictionary alloc]init];
  for (int i = 0; i<[[dic allKeys] count]; i++) {
    NSString *string = [[dic allKeys] objectAtIndex:i];
    if (![string isEqualToString:@"subs"]) {
      [ddd setObject:[dic objectForKey:string] forKey:string];
    }
  }
  return ddd;
}
/**
 设置默认值
 */
- (NSString *)setDefaultValue:(NSString *)value defaultValue:(NSString *)deValue{
  if (value && ![value isEqualToString:@""] && value != NULL) {
    return value;
  }
  return deValue;
}

/*********************************************** picker 相关*********************************************************/

/**
 设置 picker 类型

 @param type 返回类型
 */
- (void)setPickType:(NSString *)type{
  if ([type isEqualToString:@"PCA"]) {
    self.pickerType = PICKER_PCA;
  }
  if ([type isEqualToString:@"YMD"]) {
    self.pickerType = PICKER_YMD;
  }
  if ([type isEqualToString:@"HM"]) {
    self.pickerType = PICKER_HM;
  }
  if ([type isEqualToString:@"YMDHM"]) {
    self.pickerType = PICKER_YMDHM;
  }
  if ([type isEqualToString:@"CUSTOM"]) {
    self.pickerType = PICKER_CUSTOM;
  }
  if ([type isEqualToString:@"CUSTOMLINKAGE"]) {
    self.pickerType = PICKER_CUSTOMLINKAGE;
  }
}


/**
 设置 选中 picker row 的样式

 @param selectType 样式类型
 */
- (void)setPickCenterRowType:(NSString *)centerType {
  if ([centerType isEqualToString:@"line"]) {
    self.pickerCenterType = CENTER_TYPE_LINE;
  }
  if ([centerType isEqualToString:@"color"]) {
    self.pickerCenterType = CENTER_TYPE_COLOR;
  }
  if ([centerType isEqualToString:@"both"]) {
    self.pickerCenterType = CENTER_TYPE_BOTH;
  }
}


/**
 初始化 pickerView 选中部分的布局

 @return 返回 view
 */
- (UIView *)centerView {
  if (!_centerView) {
    _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+ (216-36)/2, SCREEN_WIDTH, 36)];
    
    if (self.pickerCenterType == CENTER_TYPE_COLOR) {
      [self addBGColor:_centerView alpha:1];
    }else if (self.pickerCenterType == CENTER_TYPE_LINE) {
      [self addLineToView:_centerView];
    }else if(self.pickerCenterType == CENTER_TYPE_BOTH){
      [self addBGColor:_centerView alpha:0.5];
      [self addLineToView:_centerView];
    }
  
  }
  return _centerView;
}


/**
 view 增加背景色

 @param view 要添加背景色的view
 @param alpha 背景色透明度
 */
- (void)addBGColor:(UIView *)view alpha:(CGFloat)alpha {
  view.backgroundColor = [UIColor colorWithHexString:self.pickerCenterRowColor alpha:alpha];
}

/**
 view 增加上下两条线

 @param view 要增加线的view
 */
- (void)addLineToView:(UIView *)view {
  CALayer *topLayer = [CALayer layer];
  topLayer.frame = CGRectMake(0, 0, view.frame.size.width, 1);
  topLayer.backgroundColor =  [UIColor colorWithHexString:self.pickerCenterRowColor].CGColor;
  [view.layer addSublayer:topLayer];
  
  CALayer *bottomLayer = [CALayer layer];
  bottomLayer.frame = CGRectMake(0, view.frame.size.height - 1, _centerView.frame.size.width, 1);
  bottomLayer.backgroundColor = [UIColor colorWithHexString:self.pickerCenterRowColor].CGColor;
  [view.layer addSublayer:bottomLayer];
}


/**
 初始化 picker

 @return 返回 picker
 */
- (UIPickerView *)picker {
  if (!_picker){
    _picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 216)];
    _picker.delegate = self;
    _picker.dataSource = self;
  }
  return _picker;
}



/**
 初始化 省市区 数据

 @return 返回 省市区 数据
 */
- (NSArray *)pcaData{
  if(!_pcaData){
    _pcaData=[NSArray arrayWithArray:[ModelUtil fixCityUtil]];
  }
  return _pcaData;
}

/**
 设置省市区初始值
 */
- (void)setFirstPCASelect {
  self.provincNum = 0;
  self.cityNum = 0;
  self.areaNum = 0;
}

  
#pragma UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
  
  UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
  label.textAlignment = NSTextAlignmentCenter;
  label.lineBreakMode = NSLineBreakByTruncatingMiddle;
  
  
  switch (self.pickerType) {
    case PICKER_PCA:{
      // 省市区
      if (component == 0){
        ProvinceModel *provinceModel = [self.pcaData objectAtIndex:row];
        label.text = provinceModel.name;
      }
      if (component == 1){
        ProvinceModel *provinceModel = [self.pcaData objectAtIndex:self.provincNum];
        CityModel *cityModel = [provinceModel.city objectAtIndex:row];
        label.text = cityModel.name;
      }
      if (component == 2) {
        ProvinceModel *provinceModel = [self.pcaData objectAtIndex:self.provincNum];
        CityModel *cityModel = [provinceModel.city objectAtIndex:self.cityNum];
        AreaModel *areaModel = [cityModel.area objectAtIndex:row];
        label.text = areaModel.name;
      }
    }
      break;
    case PICKER_CUSTOM:{
      NSArray *comArr = [self.customData objectAtIndex:component];
      NSDictionary *diction = [NSDictionary dictionaryWithDictionary: [comArr objectAtIndex:row]];
      label.text = [diction objectForKey:@"title"];
    }
      break;
    case PICKER_CUSTOMLINKAGE:{
      if (component == 0){
        NSDictionary *dic = [self.customLinkageData objectAtIndex:row];
        label.text = [dic objectForKey:@"title"];
      }
      if (component == 1){
        NSDictionary *dic = [self.customLinkageData objectAtIndex:self.firstSelRow];
        NSDictionary *dicc = [[dic objectForKey:@"subs"] objectAtIndex:row];
        label.text = [dicc objectForKey:@"title"];
      }
      if (component == 2) {
        NSDictionary *dic = [self.customLinkageData objectAtIndex:self.firstSelRow];
        NSDictionary *dicc = [[dic objectForKey:@"subs"] objectAtIndex:self.secondSelRow];
        NSDictionary *diccc = [[dicc objectForKey:@"subs"] objectAtIndex:row];
        label.text = [diccc objectForKey:@"title"];
      }
      if (component == 3) {
        NSDictionary *dic = [self.customLinkageData objectAtIndex:self.firstSelRow];
        NSDictionary *dicc = [[dic objectForKey:@"subs"] objectAtIndex:self.secondSelRow];
        NSDictionary *diccc = [[dicc objectForKey:@"subs"] objectAtIndex:self.thirdSelRow];
        NSDictionary *dicccc = [[diccc objectForKey:@"subs"] objectAtIndex:row];
        label.text = [dicccc objectForKey:@"title"];
      }
      if (component == 4) {
        NSDictionary *dic = [self.customLinkageData objectAtIndex:self.firstSelRow];
        NSDictionary *dicc = [[dic objectForKey:@"subs"] objectAtIndex:self.secondSelRow];
        NSDictionary *diccc = [[dicc objectForKey:@"subs"] objectAtIndex:self.thirdSelRow];
        NSDictionary *dicccc = [[diccc objectForKey:@"subs"] objectAtIndex:self.fourSelRow];
        NSDictionary *diccccc = [[dicccc objectForKey:@"subs"] objectAtIndex:row];
        label.text = [diccccc objectForKey:@"title"];
      }
      
    }
      break;
    default:
      label.text = @"默认";
      break;
  }

  
  return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

  switch (self.pickerType) {
    case PICKER_PCA:{
      if (component == 0) {
        self.provincNum = row;
        
        self.cityNum = 0;
        self.areaNum = 0;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];

      }
      
      if (component == 1) {
        self.cityNum = row;
        
        self.areaNum = 0;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];

      }
      if (component == 2) {
        self.areaNum = row;
      }
    }
      
      break;
    case PICKER_CUSTOM:{
      
      NSArray *array = [self.customData objectAtIndex:component];
      NSDictionary *diction = [array objectAtIndex:row];
      
      [self.customSelectData replaceObjectAtIndex:component withObject:[diction objectForKey:@"title"]];
      
    }
      break;
    case PICKER_CUSTOMLINKAGE:{
      if (component == 0) {
        self.firstSelRow = row;
        
        self.secondSelRow = 0;
        self.thirdSelRow = 0;
        self.fourSelRow = 0;
        self.fiveSelRow = 0;

        [pickerView reloadAllComponents];

      }
      
      if (component == 1) {
        self.secondSelRow = row;
        self.thirdSelRow = 0;
        self.fourSelRow = 0;
        self.fiveSelRow = 0;
        
        [pickerView reloadAllComponents];

      }
      if (component == 2) {
        self.thirdSelRow = row;
        self.fourSelRow = 0;
        self.fiveSelRow = 0;
        
        [pickerView reloadAllComponents];

      
      }
      if (component == 3) {
        self.fourSelRow = row;
        self.fiveSelRow = 0;
        [pickerView reloadAllComponents];

      }
      if (component == 4) {
        self.fiveSelRow = row;
      }
      
      for (NSInteger i = component+1; i<self.linkageComponent; i++) {
        [pickerView selectRow:0 inComponent:i animated:YES];
      }
      
    }
      break;
    default:
      break;
  }
  
}

  
#pragma UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  switch (self.pickerType) {
    case PICKER_PCA:
      return 3;
      break;
    case PICKER_CUSTOM:
      return [self.customData count];
      break;
    case PICKER_CUSTOMLINKAGE:
      return self.linkageComponent;
      break;
    default:
      return 0;
      break;
  }
}
  
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  
  switch (self.pickerType) {
    case PICKER_PCA:{
      // 省市区
      if (component == 0){
        return self.pcaData.count;
      }
      if (component == 1){
        ProvinceModel *provinceModel = [self.pcaData objectAtIndex:self.provincNum];
        return provinceModel.city.count;
      }
      ProvinceModel *provinceModel = [self.pcaData objectAtIndex:self.provincNum];
      CityModel *cityModel = [provinceModel.city objectAtIndex:self.cityNum];
      return cityModel.area.count;
    }
     
      break;
    case PICKER_CUSTOM:{
      
      return [[self.customData objectAtIndex:component] count];
      
    }
      break;
    case PICKER_CUSTOMLINKAGE:{
      
      if (component == 0){
        return [self.customLinkageData count];
      }else if (component == 1){
        NSDictionary *dic = [self.customLinkageData objectAtIndex:self.firstSelRow];
        return [[dic objectForKey:@"subs"] count];
      }else if (component == 2) {
        NSDictionary *dic = [self.customLinkageData objectAtIndex:self.firstSelRow];
        NSDictionary *dicc = [[dic objectForKey:@"subs"] objectAtIndex:self.secondSelRow];
        return [[dicc objectForKey:@"subs"] count];
      }else if (component == 3) {
        NSDictionary *dic = [self.customLinkageData objectAtIndex:self.firstSelRow];
        NSDictionary *dicc = [[dic objectForKey:@"subs"] objectAtIndex:self.secondSelRow];
        NSDictionary *diccc = [[dicc objectForKey:@"subs"] objectAtIndex:self.thirdSelRow];
        return [[diccc objectForKey:@"subs"] count];
      }
      NSDictionary *dic = [self.customLinkageData objectAtIndex:self.firstSelRow];
      NSDictionary *dicc = [[dic objectForKey:@"subs"] objectAtIndex:self.secondSelRow];
      NSDictionary *diccc = [[dicc objectForKey:@"subs"] objectAtIndex:self.thirdSelRow];
      NSDictionary *dicccc = [[diccc objectForKey:@"subs"] objectAtIndex:self.fourSelRow];
      return [[dicccc objectForKey:@"subs"] count];
    
    }
      break;
    default:
      return 1;
      break;
  }

}

/*********************************************** topView 相关*********************************************************/

- (UIView *)topView {
  if (!_topView) {
    
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _topView.backgroundColor = [UIColor colorWithHexString:self.topViewBgColor];
    
    // 左侧
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(10, 0, 100, 44);
    [_topView addSubview:leftBtn];
    [leftBtn setTitle:self.leftTitle forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithHexString:self.leftTitleColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithHexString:self.leftTitleColor alpha:0.5] forState:UIControlStateHighlighted];
    leftBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [leftBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    // 中间
    UILabel *centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 200, 44)];
    [_topView addSubview:centerLabel];
    centerLabel.text = self.centerTitle;
    centerLabel.textColor = [UIColor colorWithHexString:self.centerTitleColor];
    centerLabel.textAlignment = NSTextAlignmentCenter;
    
    // 右侧
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 110, 0, 100, 44);
    [_topView addSubview:rightBtn];
    [rightBtn setTitle:self.rightTitle forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:self.rightTitleColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:self.rightTitleColor alpha:0.5] forState:UIControlStateHighlighted];
    rightBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [rightBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];

  }
  return _topView;
}


/**
 取消 按钮事件
 */
- (void)cancelAction {
  
  [self dismiss];

  if (self.pickerType == PICKER_PCA){
    _pcaBlcok(@{}, @{}, @{});

  }
  
  if (self.pickerType == PICKER_YMD || self.pickerType == PICKER_HM || self.pickerType == PICKER_YMDHM) {
    _timeBlcok(@"",@"");
  }
  
  if (self.pickerType == PICKER_CUSTOM || self.pickerType == PICKER_CUSTOMLINKAGE){
    _customBlock(@[]);
  }
  
}

/**
 确定 按钮事件
 */
- (void)sureAction {
  
  [self dismiss];
  [self getSelectData];
}


/**
 动画消失 picker
 */
- (void)dismiss {
  dispatch_async(dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:.25f animations:^{
      [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260)];
    }];
  });
}


/**
 获取 选中的数据
 */
- (void)getSelectData {
  
  if (self.pickerType == PICKER_PCA){
    ProvinceModel *pModel = [self.pcaData objectAtIndex:self.provincNum];
    NSDictionary *pDic = @{@"id": pModel.str_id,
                           @"code": pModel.code,
                           @"name": pModel.name,
                           @"spell": pModel.spell,
                           @"abb": pModel.abb,
                           };
    
    CityModel *cModel = [pModel.city objectAtIndex:self.cityNum];
    NSDictionary *cDic = @{@"id": cModel.str_id,
                           @"code": cModel.code,
                           @"name": cModel.name,
                           @"spell": cModel.spell,
                           @"abb": cModel.abb,
                           };
    
    AreaModel *aModel = [cModel.area objectAtIndex:self.areaNum];
    NSDictionary *aDic = @{@"id": aModel.str_id,
                           @"code": aModel.code,
                           @"name": aModel.name,
                           @"spell": aModel.spell,
                           @"abb": aModel.abb,
                           };

    _pcaBlcok(pDic, cDic, aDic);
  }
  
  if (self.pickerType == PICKER_YMD || self.pickerType == PICKER_HM || self.pickerType == PICKER_YMDHM) {
    _timeBlcok(_currentTime, _currentWeek);
  }
  if (self.pickerType == PICKER_CUSTOM){
    _customBlock([NSArray arrayWithArray:self.customSelectData]);
  }
  if (self.pickerType == PICKER_CUSTOMLINKAGE){
  
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    [arr addObject:[NSNumber numberWithInteger:self.firstSelRow]];
    [arr addObject:[NSNumber numberWithInteger:self.secondSelRow]];
    [arr addObject:[NSNumber numberWithInteger:self.thirdSelRow]];
    [arr addObject:[NSNumber numberWithInteger:self.fourSelRow]];
    [arr addObject:[NSNumber numberWithInteger:self.fiveSelRow]];
    [self.customLinkageSelectData removeAllObjects];
    
    if ([self.customLinkageData count] >0){
      NSDictionary *firstDic = [self.customLinkageData objectAtIndex:[[arr objectAtIndex:0] integerValue]];
      [_customLinkageSelectData addObject:[self formatterDic:firstDic]];

      BOOL isEnd = NO;
      NSInteger count = 1;
      while (!isEnd) {
        if ([[firstDic allKeys] containsObject:@"subs"]) {
          isEnd = NO;
          
          NSArray *subs = [firstDic objectForKey:@"subs"];
          firstDic = [subs objectAtIndex:[[arr objectAtIndex:count] integerValue]];
          [_customLinkageSelectData addObject:[self formatterDic:firstDic]];
          count ++;

        }else
          isEnd = YES;
      }
    }
    
    _customBlock([NSArray arrayWithArray:self.customLinkageSelectData]);
  }

}

/*********************************************** datePicker 相关*********************************************************/


- (UIDatePicker *)datePicker {
  if (!_datePicker) {
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 216)];
    _datePicker.date = [NSDate date];
    [_datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
  
  }
  return _datePicker;
}


/**
 时间选取器选取时间
 */
- (void)dateChanged {
  NSDate *theDate = _datePicker.date;
  _currentTime = [_dateFormatter stringFromDate:theDate];
  _currentWeek = [self getWeek:theDate];
}

- (NSString *)getWeek:(NSDate *)date {
  
  
  NSInteger unitFlags =NSCalendarUnitWeekday;
  _comps = [_calendar components:unitFlags fromDate:date];
  
  switch ([_comps weekday]) {
    case 1:
      return @"星期日";
      break;
    case 2:
       return @"星期一";
      break;
    case 3:
       return @"星期二";
      break;
    case 4:
       return @"星期三";
      break;
    case 5:
       return @"星期四";
      break;
    case 6:
       return @"星期五";
      break;
    case 7:
       return @"星期六";
      break;
      
    default:
      return @"星期八";
      break;
  }

}





@end

