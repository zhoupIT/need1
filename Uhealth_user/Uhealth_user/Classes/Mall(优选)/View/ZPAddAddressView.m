//
//  ZPAddAddressView.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/22.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAddAddressView.h"
#import "ZPTextView.h"
#define PICKER_HEIGHT   216
@interface ZPAddAddressView()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger _provinceIndex;   // 省份选择 记录
    NSInteger _cityIndex;       // 市选择 记录
    NSInteger _districtIndex;   // 区选择 记录
}

@property (nonatomic, strong) UIPickerView * pickerView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSArray * arrayDS;



@end

@implementation ZPAddAddressView

+ (instancetype)addAddressView {
    NSArray* nibView = [[NSBundle mainBundle] loadNibNamed:@"ZPAddAddressView" owner:nil options:nil];
    return [nibView firstObject];
}

- (IBAction)setDefault:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.placeholder = @"详细地址";
    [self.textView setPlaceholderColor:[UIColor lightGrayColor]];
    
    UIView *pickBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - PICKER_HEIGHT, kSCREEN_WIDTH, PICKER_HEIGHT+45)];
    UIToolbar *inputAccessoryView= [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 45)];
    
    
    inputAccessoryView.barStyle=UIBarStyleDefault;
    inputAccessoryView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:ZPMyOrderDetailFontColor forKey:NSForegroundColorAttributeName];
    
    [inputAccessoryView sizeToFit];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAccessory)];
    [cancelBtn setTitleTextAttributes:dic forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneAccessory)];
    [doneBtn setTitleTextAttributes:dic forState:UIControlStateNormal];
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *array = [NSArray arrayWithObjects:cancelBtn,flexibleSpaceLeft, doneBtn,nil];
    
    [inputAccessoryView setItems:array];
    
    [pickBackView addSubview:inputAccessoryView];
    [pickBackView addSubview:self.pickerView];
    
    
     self.textField.inputView = pickBackView;
    [self initData];
    // 默认Picker状态
    [self resetPickerSelectRow];
  
}

-(void)initData
{
    _provinceIndex = _cityIndex = _districtIndex = 0;
}

#pragma mark - Load DataSource

// 读取本地Plist加载数据源
-(NSArray *)arrayDS
{
    if(!_arrayDS){
        NSString * path = [[NSBundle mainBundle] pathForResource:@"Province" ofType:@"plist"];
        _arrayDS = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _arrayDS;
}

// 懒加载方式
-(UIPickerView *)pickerView
{
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 45, kSCREEN_WIDTH, PICKER_HEIGHT)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.userInteractionEnabled = YES;
    }
    return _pickerView;
}

-(void)resetPickerSelectRow
{
    [self.pickerView selectRow:_provinceIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:_cityIndex inComponent:1 animated:YES];
    [self.pickerView selectRow:_districtIndex inComponent:2 animated:YES];
}

#pragma mark - PickerView Delegate

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// 每列有多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0){
        return self.arrayDS.count;
    }
    else if (component == 1){
        return [self.arrayDS[_provinceIndex][@"childrenAreas"] count];
    }
    else{
        return [self.arrayDS[_provinceIndex][@"childrenAreas"][_cityIndex][@"childrenAreas"] count];
    }
}

// 返回每一行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0){
        return self.arrayDS[row][@"areaName"];
    }
    else if (component == 1){
        return self.arrayDS[_provinceIndex][@"childrenAreas"][row][@"areaName"];
    }
    else{
        return self.arrayDS[_provinceIndex][@"childrenAreas"][_cityIndex][@"childrenAreas"][row][@"areaName"];
    }
}

// 滑动或点击选择，确认pickerView选中结果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(component == 0){
        _provinceIndex = row;
        _cityIndex = 0;
        _districtIndex = 0;
        
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
    }
    else if (component == 1){
        _cityIndex = row;
        _districtIndex = 0;
        
        [self.pickerView reloadComponent:2];
    }
    else{
        _districtIndex = row;
    }
    
    // 重置当前选中项
    [self resetPickerSelectRow];
}

#pragma mark - Touch
- (void)cancelAccessory {
     [self.textField resignFirstResponder];
}

- (void)doneAccessory {
    
    self.provinceName = self.arrayDS[_provinceIndex][@"areaName"];
    self.cityName = self.arrayDS[_provinceIndex][@"childrenAreas"][_cityIndex][@"areaName"];
    self.countryName = self.arrayDS[_provinceIndex][@"childrenAreas"][_cityIndex][@"childrenAreas"][_districtIndex][@"areaName"];
    
    NSString *address = [NSString stringWithFormat:@"%@-%@-%@", self.provinceName, self.cityName, self.countryName ];
    if ([self.countryName isEqualToString:@"--"]) {
        self.countryName = @"";
        address = [NSString stringWithFormat:@"%@-%@", self.provinceName, self.cityName];
    }
    
    self.provinceId= self.arrayDS[_provinceIndex][@"areaCode"];
    self.cityId = self.arrayDS[_provinceIndex][@"childrenAreas"][_cityIndex][@"areaCode"];
    self.counntryId = self.arrayDS[_provinceIndex][@"childrenAreas"][_cityIndex][@"childrenAreas"][_districtIndex][@"areaCode"];
    
    
    self.textField.text = address;
    [self.textField resignFirstResponder];
}
@end
