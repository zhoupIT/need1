//
//  ZPPsychologicalAssessController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPsychologicalAssessController.h"
#import "ZPLabel.h"
#import "TYAttributedLabel.h"
#import "TExamTextField.h"
#import "RegexKitLite.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ZPRootWebViewController.h"
@interface ZPPsychologicalAssessController ()<TYAttributedLabelDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *nameLeftName;
@property (nonatomic,strong) UILabel *genderLeftName;
@property (nonatomic,strong) UILabel *birthLeftName;
@property (nonatomic,strong) UILabel *companyLeftName;
@property (nonatomic,strong) UILabel *retireLeftName;
@property (nonatomic,strong) UILabel *smokeLeftName;
@property (nonatomic,strong) UILabel *drinkLeftName;

//职业
@property (nonatomic,strong) UILabel *professionLeftName;
@property (nonatomic,strong) UITextField *professionTextfield;
//部门
@property (nonatomic,strong) UILabel *departmentLeftName;
@property (nonatomic,strong) UITextField *departmentTextfield;
//职位
@property (nonatomic,strong) UILabel *positionLeftName;
@property (nonatomic,strong) UITextField *positionTextfield;
//入职年限
@property (nonatomic,strong) UILabel *entryTimeLeftName;
@property (nonatomic,strong) UITextField *entryTimeTextfield;
//文化程度
@property (nonatomic,strong) UILabel *cultureLeftName;
@property (nonatomic,strong) UITextField *cultureTextfield;
//婚姻状况
@property (nonatomic,strong) UILabel *marriageLeftName;
@property (nonatomic,strong) UITextField *marriageTextfield;
//居住情况
@property (nonatomic,strong) UILabel *livingLeftName;
@property (nonatomic,strong) UITextField *livingTextfield;

@property (nonatomic,strong) UITextField *nameTextfield;
@property (nonatomic,strong) UIButton *mButton;
@property (nonatomic,strong) UIButton *fButton;
@property (nonatomic,strong) UITextField *birthTextfield;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UILabel *companyLabel;
@property (nonatomic,strong) UIButton *yesButton;
@property (nonatomic,strong) UIButton *noButton;
@property (nonatomic,strong) UIButton *selSmokeButton;
@property (nonatomic,strong) UIButton *selDrinkButton;

@property (nonatomic,strong) UIPickerView *pickView;
@property (nonatomic,strong) UIPickerView *pickView1;
@property (nonatomic,strong) UIPickerView *pickView2;
@property (nonatomic,strong) UIPickerView *pickView3;
@property (nonatomic,strong) UIPickerView *livingPickView;
//是否退休
@property (nonatomic,strong) TYAttributedLabel *selRetireLabel;
@property (nonatomic,strong) TYTextContainer *selRettextContainer;

//吸烟
@property (nonatomic,strong) UIButton *selSmobutton1;
@property (nonatomic,strong) UIButton *selSmobutton2;
@property (nonatomic,strong) UIButton *selSmobutton3;
@property (nonatomic,strong) TYAttributedLabel *selSlabel1;
@property (nonatomic,strong) TYTextContainer *selSmotextContainer1;
@property (nonatomic,strong) TYAttributedLabel *selSlabel2;
@property (nonatomic,strong) TYTextContainer *selSmotextContainer2;


@property (nonatomic,strong) UIButton *resultSmobutton;

//饮酒
@property (nonatomic,strong) UIButton *selDributton1;
@property (nonatomic,strong) UIButton *selDributton2;
@property (nonatomic,strong) UIButton *selDributton3;
@property (nonatomic,strong) UIButton *selDributton4;
@property (nonatomic,strong) TYAttributedLabel *selDlabel1;
@property (nonatomic,strong) TYTextContainer *selDritextContainer1;
@property (nonatomic,strong) TYAttributedLabel *selDlabel2;
@property (nonatomic,strong) TYTextContainer *selDritextContainer2;
@property (nonatomic,strong) TYAttributedLabel *selDlabel3;
@property (nonatomic,strong) TYTextContainer *selDritextContainer3;
@property (nonatomic,strong) UIButton *resultDributton;


@property (nonatomic,strong) UIView *backView1;
@property (nonatomic,strong) UIView *backView2;
@property (nonatomic,strong) UIView *backView3;
@property (nonatomic,strong) UIView *backView4;

@property (nonatomic,strong) UIView *backView5;
@property (nonatomic,strong) UIView *backView6;
@property (nonatomic,strong) UIView *backView7;

@property (nonatomic,strong) UIView *newbackView1;
@property (nonatomic,strong) UIView *newbackView2;
@property (nonatomic,strong) UIView *newbackView3;
@property (nonatomic,strong) UIView *newbackView4;

@property (nonatomic,strong) UIView *newbackView5;
@property (nonatomic,strong) UIView *newbackView6;
@property (nonatomic,strong) UIView *newbackView7;


@property (nonatomic,strong) UIButton *nextBtn;


@property (nonatomic,strong) NSArray *pickViewData;


@end

@implementation ZPPsychologicalAssessController
#define kExamTextFieldWidth 50
#define kExamTextFieldHeight 20
#define kTextFieldTag 1000
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
    [self setData];
}

- (void)setData {
    self.nameTextfield.text = self.model.name;
    if ([self.model.gender isEqualToString:@"m"]) {
        self.mButton.selected = YES;
        self.fButton.selected = NO;
    } else {
        self.mButton.selected = NO;
        self.fButton.selected = YES;
    }
    
    self.mButton.backgroundColor = self.mButton.isSelected?ZPMyOrderDetailValueFontColor:[UIColor whiteColor];
    self.mButton.layer.borderColor = self.mButton.isSelected?[UIColor whiteColor].CGColor:ZPMyOrderDetailFontColor.CGColor;
    self.fButton.backgroundColor = self.fButton.isSelected?ZPMyOrderDetailValueFontColor:[UIColor whiteColor];
    self.fButton.layer.borderColor = self.fButton.isSelected?[UIColor whiteColor].CGColor:ZPMyOrderDetailFontColor.CGColor;
    
    self.birthTextfield.text = self.model.birthday;
    self.companyLabel.text = self.model.company;
    for (TYTextStorage *textStorage in self.selSmotextContainer1.textStorages) {
        if ([textStorage isKindOfClass:[TYViewStorage class]]) {
            TYViewStorage *viewStorage = (TYViewStorage *)textStorage;
            if ([viewStorage.view isKindOfClass:[TExamTextField class]]) {
                TExamTextField *textField = (TExamTextField *)viewStorage.view;
                textField.text = @"12";
            }
        }
    }
    for (TYTextStorage *textStorage in self.selSmotextContainer2.textStorages) {
        if ([textStorage isKindOfClass:[TYViewStorage class]]) {
            TYViewStorage *viewStorage = (TYViewStorage *)textStorage;
            if ([viewStorage.view isKindOfClass:[TExamTextField class]]) {
                TExamTextField *textField = (TExamTextField *)viewStorage.view;
                textField.text = @"12";
            }
        }
    }
    
    
    for (TYTextStorage *textStorage in self.selDritextContainer1.textStorages) {
        if ([textStorage isKindOfClass:[TYViewStorage class]]) {
            TYViewStorage *viewStorage = (TYViewStorage *)textStorage;
            if ([viewStorage.view isKindOfClass:[TExamTextField class]]) {
                TExamTextField *textField = (TExamTextField *)viewStorage.view;
                switch (viewStorage.tag) {
                    case 1000:
                    {
                        textField.text = @"1";
                    }
                        break;
                    case 1001:
                    {
                        textField.text = @"6";
                    }
                        break;
                    case 1002:
                    {
                        textField.text = @"2";
                    }
                        break;
                    case 1003:
                    {
                        textField.text = @"8";
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
    for (TYTextStorage *textStorage in self.selDritextContainer2.textStorages) {
        if ([textStorage isKindOfClass:[TYViewStorage class]]) {
            TYViewStorage *viewStorage = (TYViewStorage *)textStorage;
            if ([viewStorage.view isKindOfClass:[TExamTextField class]]) {
                TExamTextField *textField = (TExamTextField *)viewStorage.view;
            
                switch (viewStorage.tag) {
                    case 1000:
                    {
                        textField.text = @"1";
                    }
                        break;
                    case 1001:
                    {
                        textField.text = @"6";
                    }
                        break;
                    case 1002:
                    {
                        textField.text = @"2";
                    }
                        break;
                    case 1003:
                    {
                        textField.text = @"8";
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
    for (TYTextStorage *textStorage in self.selDritextContainer3.textStorages) {
        if ([textStorage isKindOfClass:[TYViewStorage class]]) {
            TYViewStorage *viewStorage = (TYViewStorage *)textStorage;
            if ([viewStorage.view isKindOfClass:[TExamTextField class]]) {
                TExamTextField *textField = (TExamTextField *)viewStorage.view;
                switch (viewStorage.tag) {
                    case 1000:
                    {
                        textField.text = @"1";
                    }
                        break;
                    case 1001:
                    {
                        textField.text = @"6";
                    }
                        break;
                    case 1002:
                    {
                        textField.text = @"2";
                    }
                        break;
                    case 1003:
                    {
                        textField.text = @"8";
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
}

- (void)initAll {
    self.title = @"身心健康评估系统";
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 50, 0));
    [self.scrollView sd_addSubviews:@[self.backView1,self.backView2,self.backView3,self.backView4,self.backView5,self.backView6,self.backView7,self.newbackView1,self.newbackView2,self.newbackView3,self.newbackView4,self.newbackView5,self.newbackView6,self.newbackView7]];
    
    self.backView1.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.scrollView, 8)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    
    [self.backView1 sd_addSubviews:@[self.nameLeftName,self.nameTextfield]];
    self.nameLeftName.sd_layout
    .leftSpaceToView(self.backView1,16)
    .topSpaceToView(self.backView1, 0)
    .heightIs(49);
    [self.nameLeftName setSingleLineAutoResizeWithMaxWidth:75];
 
    self.nameTextfield.sd_layout
    .rightSpaceToView(self.backView1, 16)
    .leftSpaceToView(self.nameLeftName, 10)
    .heightIs(49)
    .topSpaceToView(self.backView1, 0);

    
    self.backView2.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.backView1, 1)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    
    [self.backView2 sd_addSubviews:@[self.genderLeftName,self.mButton,self.fButton]];
    self.genderLeftName.sd_layout
    .leftSpaceToView(self.backView2, 16)
    .topSpaceToView(self.backView2, 0)
    .heightIs(49);
    [self.genderLeftName setSingleLineAutoResizeWithMaxWidth:65];
    
    self.fButton.sd_layout
    .rightSpaceToView(self.backView2, 16)
    .heightIs(23)
    .widthIs(50)
    .centerYEqualToView(self.backView2);
    self.mButton.sd_layout
    .rightSpaceToView(self.fButton, 10)
    .heightIs(23)
    .widthIs(50)
    .centerYEqualToView(self.backView2);
    
    
    self.backView3.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.backView2, 1)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    
    [self.backView3 sd_addSubviews:@[self.birthLeftName,self.birthTextfield]];
    self.birthLeftName.sd_layout
    .leftSpaceToView(self.backView3, 16)
    .topSpaceToView(self.backView3, 0)
    .heightIs(49);
     [self.birthLeftName setSingleLineAutoResizeWithMaxWidth:65];
    
    self.birthTextfield.sd_layout
    .rightSpaceToView(self.backView3, 16)
    .leftSpaceToView(self.backView3, 10)
    .heightIs(49)
    .topEqualToView(self.birthLeftName);
    
    //职业
    /*
    self.newbackView1.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.backView3, 1)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    [self.newbackView1 sd_addSubviews:@[self.professionLeftName,self.professionTextfield]];
    self.professionLeftName.sd_layout
    .leftSpaceToView(self.newbackView1, 16)
    .topSpaceToView(self.newbackView1, 0)
    .heightIs(49);
    [self.professionLeftName setSingleLineAutoResizeWithMaxWidth:65];
    
    self.professionTextfield.sd_layout
    .rightSpaceToView(self.newbackView1, 16)
    .leftSpaceToView(self.professionLeftName, 10)
    .heightIs(49)
    .topEqualToView(self.professionLeftName);
    */
    
    //公司名称
    self.backView4.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.backView3, 1)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    
    [self.backView4 sd_addSubviews:@[self.companyLeftName,self.companyLabel]];
    self.companyLeftName.sd_layout
    .leftSpaceToView(self.backView4, 16)
    .topSpaceToView(self.backView4, 0)
    .heightIs(49);
    [self.companyLeftName setSingleLineAutoResizeWithMaxWidth:65];

    self.companyLabel.sd_layout
    .rightSpaceToView(self.backView4, 16)
    .leftSpaceToView(self.companyLeftName, 10)
    .heightIs(49)
    .topEqualToView(self.companyLeftName);
    
    //部门
    self.newbackView2.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.backView4, 1)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    [self.newbackView2 sd_addSubviews:@[self.departmentLeftName,self.departmentTextfield]];
    self.departmentLeftName.sd_layout
    .leftSpaceToView(self.newbackView2, 16)
    .topSpaceToView(self.newbackView2, 0)
    .heightIs(49);
    [self.departmentLeftName setSingleLineAutoResizeWithMaxWidth:65];
    
    self.departmentTextfield.sd_layout
    .rightSpaceToView(self.newbackView2, 16)
    .leftSpaceToView(self.departmentLeftName, 10)
    .heightIs(49)
    .topEqualToView(self.departmentLeftName);
    //职位
    self.newbackView3.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.newbackView2, 1)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    [self.newbackView3 sd_addSubviews:@[self.positionLeftName,self.positionTextfield]];
    self.positionLeftName.sd_layout
    .leftSpaceToView(self.newbackView3, 16)
    .topSpaceToView(self.newbackView3, 0)
    .heightIs(49);
    [self.positionLeftName setSingleLineAutoResizeWithMaxWidth:65];
    
    self.positionTextfield.sd_layout
    .rightSpaceToView(self.newbackView3, 16)
    .leftSpaceToView(self.positionLeftName, 10)
    .heightIs(49)
    .topEqualToView(self.positionLeftName);
    /*
    //入职年限
    self.newbackView4.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.newbackView3, 1)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    [self.newbackView4 sd_addSubviews:@[self.entryTimeLeftName,self.entryTimeTextfield]];
    self.entryTimeLeftName.sd_layout
    .leftSpaceToView(self.newbackView4, 16)
    .topSpaceToView(self.newbackView4, 0)
    .heightIs(49);
    [self.entryTimeLeftName setSingleLineAutoResizeWithMaxWidth:65];
    
    self.entryTimeTextfield.sd_layout
    .rightSpaceToView(self.newbackView4, 16)
    .leftSpaceToView(self.entryTimeLeftName, 10)
    .heightIs(49)
    .topEqualToView(self.entryTimeLeftName);
    //文化程度
    self.newbackView5.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.newbackView4, 1)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    [self.newbackView5 sd_addSubviews:@[self.cultureLeftName,self.cultureTextfield]];
    self.cultureLeftName.sd_layout
    .leftSpaceToView(self.newbackView5, 16)
    .topSpaceToView(self.newbackView5, 0)
    .heightIs(49);
    [self.cultureLeftName setSingleLineAutoResizeWithMaxWidth:65];
    
    self.cultureTextfield.sd_layout
    .rightSpaceToView(self.newbackView5, 16)
    .leftSpaceToView(self.cultureLeftName, 10)
    .heightIs(49)
    .topEqualToView(self.cultureLeftName);
    //婚姻状况
    self.newbackView6.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.newbackView5, 1)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    [self.newbackView6 sd_addSubviews:@[self.marriageLeftName,self.marriageTextfield]];
    self.marriageLeftName.sd_layout
    .leftSpaceToView(self.newbackView6, 16)
    .topSpaceToView(self.newbackView6, 0)
    .heightIs(49);
    [self.marriageLeftName setSingleLineAutoResizeWithMaxWidth:65];
    
    self.marriageTextfield.sd_layout
    .rightSpaceToView(self.newbackView6, 16)
    .leftSpaceToView(self.marriageLeftName, 10)
    .heightIs(49)
    .topEqualToView(self.marriageLeftName);
    //居住情况
    self.newbackView7.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.newbackView6, 1)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    [self.newbackView7 sd_addSubviews:@[self.livingLeftName,self.livingTextfield]];
    self.livingLeftName.sd_layout
    .leftSpaceToView(self.newbackView7, 16)
    .topSpaceToView(self.newbackView7, 0)
    .heightIs(49);
    [self.livingLeftName setSingleLineAutoResizeWithMaxWidth:65];
    
    self.livingTextfield.sd_layout
    .rightSpaceToView(self.newbackView7, 16)
    .leftSpaceToView(self.livingLeftName, 10)
    .heightIs(49)
    .topEqualToView(self.livingLeftName);
    
    //退休
    self.backView5.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.newbackView7, 1)
    .heightIs(49)
    .rightSpaceToView(self.scrollView, 0);
    
    [self.backView5 sd_addSubviews:@[self.retireLeftName,self.yesButton,self.noButton]];
    self.retireLeftName.sd_layout
    .leftSpaceToView(self.backView5, 16)
    .topSpaceToView(self.backView5, 0)
    .heightIs(49);
    [self.retireLeftName setSingleLineAutoResizeWithMaxWidth:65];
    
    self.noButton.sd_layout
    .rightSpaceToView(self.backView5, 16)
    .heightIs(23)
    .widthIs(50)
    .centerYEqualToView(self.retireLeftName);
    self.yesButton.sd_layout
    .rightSpaceToView(self.noButton, 10)
    .heightIs(23)
    .widthIs(50)
    .centerYEqualToView(self.retireLeftName);
    [self createRetireTextContainer:@"请问退休年龄是[@]岁"];
     */
    
    //吸烟
    self.backView6.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.newbackView3, 6)
    .rightSpaceToView(self.scrollView, 0)
    .autoHeightRatio(0);
    
    
    [self.backView6 sd_addSubviews:@[self.smokeLeftName,self.selSmokeButton,self.selSmobutton1,self.selSmobutton2,self.selSmobutton3,self.resultSmobutton]];
    self.smokeLeftName.sd_layout
    .leftSpaceToView(self.backView6, 16)
    .topSpaceToView(self.backView6, 0)
    .heightIs(49);
    [self.smokeLeftName setSingleLineAutoResizeWithMaxWidth:65];
    
    self.selSmokeButton.sd_layout
    .rightSpaceToView(self.backView6, 16)
    .heightIs(49)
    .widthIs(62)
    .topSpaceToView(self.backView6, 0);
    self.selSmokeButton.imageView.sd_layout
    .rightSpaceToView(self.selSmokeButton, 0)
    .widthIs(18)
    .heightIs(18)
    .centerYEqualToView(self.selSmokeButton);
    self.selSmokeButton.titleLabel.sd_layout
    .leftSpaceToView(self.selSmokeButton, 0)
    .heightIs(16)
    .rightSpaceToView(self.selSmokeButton.imageView, 0)
    .centerYEqualToView(self.selSmokeButton);
    
    self.selSmobutton1.sd_layout
    .topSpaceToView(self.smokeLeftName, 0)
    .leftSpaceToView(self.backView6, 16)
    .rightSpaceToView(self.backView6, 16)
    .heightIs(13);
    self.selSmobutton1.imageView.sd_layout
    .leftSpaceToView(self.selSmobutton1, 0)
    .heightIs(13)
    .widthIs(13)
    .centerYEqualToView(self.selSmobutton1);
    self.selSmobutton1.titleLabel.sd_layout
    .leftSpaceToView(self.selSmobutton1.imageView, 10)
    .heightIs(13)
    .rightSpaceToView(self.selSmobutton1, 0)
    .centerYEqualToView(self.selSmobutton1);
   
    [self createTextContainer:@"每天平均吸[@]根，共吸了[@]年"];
//    [self createTextContainer:@"每天平均吸[@]根，共吸了[@]年" withTYTextContainer:self.selSmotextContainer1 withBackView:self.backView6 withLabel:self.selSlabel1 withButton:self.selSmobutton1];
    
    self.selSmobutton2.sd_layout
    .topSpaceToView(self.selSlabel1, 16)
    .leftSpaceToView(self.backView6, 16)
    .rightSpaceToView(self.backView6, 16)
    .heightIs(13);
    self.selSmobutton2.imageView.sd_layout
    .leftSpaceToView(self.selSmobutton2, 0)
    .heightIs(13)
    .widthIs(13)
    .centerYEqualToView(self.selSmobutton2);
    self.selSmobutton2.titleLabel.sd_layout
    .leftSpaceToView(self.selSmobutton2.imageView, 10)
    .heightIs(13)
    .rightSpaceToView(self.selSmobutton2, 0)
    .centerYEqualToView(self.selSmobutton2);
    [self createTextContainer2:@"每天平均吸[@]根，共吸了[@]年"];
    
    self.selSmobutton3.sd_layout
    .topSpaceToView(self.selSlabel2, 16)
    .leftSpaceToView(self.backView6, 16)
    .rightSpaceToView(self.backView6, 16)
    .heightIs(13);
    self.selSmobutton3.imageView.sd_layout
    .leftSpaceToView(self.selSmobutton3, 0)
    .heightIs(13)
    .widthIs(13)
    .centerYEqualToView(self.selSmobutton3);
    self.selSmobutton3.titleLabel.sd_layout
    .leftSpaceToView(self.selSmobutton3.imageView, 10)
    .heightIs(13)
    .rightSpaceToView(self.selSmobutton3, 0)
    .centerYEqualToView(self.selSmobutton3);
    
    self.resultSmobutton.sd_layout
    .topSpaceToView(self.smokeLeftName, 0)
    .leftSpaceToView(self.backView6, 16)
    .rightSpaceToView(self.backView6, 16)
    .heightIs(13);
    self.resultSmobutton.imageView.sd_layout
    .leftSpaceToView(self.resultSmobutton, 0)
    .heightIs(13)
    .widthIs(13)
    .centerYEqualToView(self.resultSmobutton);
    self.resultSmobutton.titleLabel.sd_layout
    .leftSpaceToView(self.resultSmobutton.imageView, 10)
    .heightIs(13)
    .rightSpaceToView(self.resultSmobutton, 0)
    .centerYEqualToView(self.resultSmobutton);
    self.resultSmobutton.hidden = YES;
    
    [self.backView6 setupAutoHeightWithBottomViewsArray:@[self.selSmobutton3,self.smokeLeftName] bottomMargin:16];
    
   
    
    
//    [self.backView6 setupAutoHeightWithBottomView:self.smokeLeftName bottomMargin:0];
    
    //饮酒
    self.backView7.sd_layout
    .leftSpaceToView(self.scrollView, 0)
    .topSpaceToView(self.backView6, 6)
    .autoHeightRatio(0)
    .rightSpaceToView(self.scrollView, 0);
    
    [self.backView7 sd_addSubviews:@[self.drinkLeftName,self.selDrinkButton,self.selDributton1,self.selDributton2,self.selDributton3,self.selDributton4,self.resultDributton]];
    self.drinkLeftName.sd_layout
    .leftSpaceToView(self.backView7, 16)
    .topSpaceToView(self.backView7, 0)
    .heightIs(50);
    [self.drinkLeftName setSingleLineAutoResizeWithMaxWidth:65];
    self.selDrinkButton.sd_layout
    .rightSpaceToView(self.backView7, 16)
    .heightIs(49)
    .widthIs(62)
    .topSpaceToView(self.backView7, 0);
    self.selDrinkButton.imageView.sd_layout
    .rightSpaceToView(self.selDrinkButton, 0)
    .widthIs(18)
    .heightIs(18)
    .centerYEqualToView(self.selDrinkButton);
    self.selDrinkButton.titleLabel.sd_layout
    .leftSpaceToView(self.selDrinkButton, 0)
    .heightIs(16)
    .rightSpaceToView(self.selDrinkButton.imageView, 0)
    .centerYEqualToView(self.selDrinkButton);
    
    self.selDributton1.sd_layout
    .topSpaceToView(self.drinkLeftName, 0)
    .leftSpaceToView(self.backView7, 16)
    .rightSpaceToView(self.backView7, 16)
    .heightIs(13);
    self.selDributton1.imageView.sd_layout
    .leftSpaceToView(self.selDributton1, 0)
    .heightIs(13)
    .widthIs(13)
    .centerYEqualToView(self.selDributton1);
    self.selDributton1.titleLabel.sd_layout
    .leftSpaceToView(self.selDributton1.imageView, 10)
    .heightIs(13)
    .rightSpaceToView(self.selDributton1, 0)
    .centerYEqualToView(self.selDributton1);
     [self createTextContainerDrink1:@"啤酒每天喝[@]瓶\n白酒每天喝[@]两\n红酒每天喝[@]杯\n洋酒每天喝[@]两"];
    
    
    self.selDributton2.sd_layout
    .topSpaceToView(self.selDlabel1, 16)
    .leftSpaceToView(self.backView7, 16)
    .rightSpaceToView(self.backView7, 16)
    .heightIs(13);
    self.selDributton2.imageView.sd_layout
    .leftSpaceToView(self.selDributton2, 0)
    .heightIs(13)
    .widthIs(13)
    .centerYEqualToView(self.selDributton2);
    self.selDributton2.titleLabel.sd_layout
    .leftSpaceToView(self.selDributton2.imageView, 10)
    .heightIs(13)
    .rightSpaceToView(self.selDributton2, 0)
    .centerYEqualToView(self.selDributton2);
    [self createTextContainerDrink2:@"啤酒每天喝[@]瓶\n白酒每天喝[@]两\n红酒每天喝[@]杯\n洋酒每天喝[@]两"];
    
    self.selDributton3.sd_layout
    .topSpaceToView(self.selDlabel2, 16)
    .leftSpaceToView(self.backView7, 16)
    .rightSpaceToView(self.backView7, 16)
    .heightIs(13);
    self.selDributton3.imageView.sd_layout
    .leftSpaceToView(self.selDributton3, 0)
    .heightIs(13)
    .widthIs(13)
    .centerYEqualToView(self.selDributton3);
    self.selDributton3.titleLabel.sd_layout
    .leftSpaceToView(self.selDributton3.imageView, 10)
    .heightIs(13)
    .rightSpaceToView(self.selDributton3, 0)
    .centerYEqualToView(self.selDributton3);
    [self createTextContainerDrink3:@"啤酒每天喝[@]瓶\n白酒每天喝[@]两\n红酒每天喝[@]杯\n洋酒每天喝[@]两"];
    
    
    self.selDributton4.sd_layout
    .topSpaceToView(self.selDlabel3, 16)
    .leftSpaceToView(self.backView7, 16)
    .rightSpaceToView(self.backView7, 16)
    .heightIs(13);
    self.selDributton4.imageView.sd_layout
    .leftSpaceToView(self.selDributton4, 0)
    .heightIs(13)
    .widthIs(13)
    .centerYEqualToView(self.selDributton4);
    self.selDributton4.titleLabel.sd_layout
    .leftSpaceToView(self.selDributton4.imageView, 10)
    .heightIs(13)
    .rightSpaceToView(self.selDributton4, 0)
    .centerYEqualToView(self.selDributton4);
    
    self.resultDributton.sd_layout
    .topSpaceToView(self.drinkLeftName, 0)
    .leftSpaceToView(self.backView7, 16)
    .rightSpaceToView(self.backView7, 16)
    .heightIs(13);
    self.resultDributton.imageView.sd_layout
    .leftSpaceToView(self.resultDributton, 0)
    .heightIs(13)
    .widthIs(13)
    .centerYEqualToView(self.resultDributton);
    self.resultDributton.titleLabel.sd_layout
    .leftSpaceToView(self.resultDributton.imageView, 10)
    .heightIs(13)
    .rightSpaceToView(self.resultDributton, 0)
    .centerYEqualToView(self.resultDributton);
    self.resultDributton.hidden = YES;
   
     [self.backView7 setupAutoHeightWithBottomViewsArray:@[self.selDributton4,self.drinkLeftName] bottomMargin:16];
//    [self.backView7 setupAutoHeightWithBottomView:self.smokeLeftName bottomMargin:0];
    [self.scrollView setupAutoContentSizeWithBottomView:self.backView7 bottomMargin:10];
    
    [self expandRetireView:NO];
    
    [self isHiddenSmokeView:YES];
    self.backView6.sd_layout.heightIs(49);
    [self.backView6 updateLayout];
    [self.backView6 setupAutoHeightWithBottomView:self.smokeLeftName bottomMargin:0];
    
    [self isHiddenDrinkView:YES];
    self.backView7.sd_layout.heightIs(49);
    [self.backView7 updateLayout];
    [self.backView7 setupAutoHeightWithBottomView:self.drinkLeftName bottomMargin:0];
  
    [self.view addSubview:self.nextBtn];
    self.nextBtn.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50)
    .bottomEqualToView(self.view);
    
}

- (void)createRetireTextContainer:(NSString *)text
{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    
    // 整体设置属性
    textContainer.linesSpacing = 2;
    textContainer.paragraphSpacing = 5;
    textContainer.textColor = ZPMyOrderDetailFontColor;
    textContainer.font = [UIFont systemFontOfSize:13];
    
    // 填空题
    NSArray *blankStorage = [self parseTextFieldsWithString:text];
    [textContainer addTextStorageArray:blankStorage];
    
    self.selRettextContainer = [textContainer createTextContainerWithTextWidth:kSCREEN_WIDTH];
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]initWithFrame:CGRectZero];
    [self.backView5 addSubview:label];
    self.selRetireLabel = label;
    label.delegate = self;
    
    label.textContainer = self.selRettextContainer;
    
    [label sizeToFit];
    
    label.sd_layout
    .leftSpaceToView(self.backView5, 39)
    .rightSpaceToView(self.backView5, 16)
    .heightIs([label getSizeWithWidth:(kSCREEN_WIDTH-26-16)].height)
    .topSpaceToView(self.retireLeftName, 10);
}

// withTYTextContainer:(TYTextContainer *)contaniner withBackView:(UIView *)backView withLabel:(TYAttributedLabel *)attritlabel withButton:(UIButton *)tempButton
- (void)createTextContainer:(NSString *)text
{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    
    // 整体设置属性
    textContainer.linesSpacing = 2;
    textContainer.paragraphSpacing = 5;
    textContainer.textColor = ZPMyOrderDetailFontColor;
    textContainer.font = [UIFont systemFontOfSize:13];
    
    // 填空题
    NSArray *blankStorage = [self parseTextFieldsWithString:text];
    [textContainer addTextStorageArray:blankStorage];
    
    self.selSmotextContainer1 = [textContainer createTextContainerWithTextWidth:kSCREEN_WIDTH];
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]initWithFrame:CGRectZero];
    [self.backView6 addSubview:label];
    self.selSlabel1 = label;
    label.delegate = self;
    
    label.textContainer = self.selSmotextContainer1;
    
    [label sizeToFit];
    
    label.sd_layout
    .leftSpaceToView(self.backView6, 39)
    .rightSpaceToView(self.backView6, 16)
    .heightIs([label getSizeWithWidth:(kSCREEN_WIDTH-26-16)].height)
    .topSpaceToView(self.selSmobutton1, 10);
}

- (void)createTextContainer2:(NSString *)text
{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    
    // 整体设置属性
    textContainer.linesSpacing = 2;
    textContainer.paragraphSpacing = 5;
    textContainer.textColor = ZPMyOrderDetailFontColor;
    textContainer.font = [UIFont systemFontOfSize:13];
    
    // 填空题
    NSArray *blankStorage = [self parseTextFieldsWithString:text];
    [textContainer addTextStorageArray:blankStorage];
    
    self.selSmotextContainer2 = [textContainer createTextContainerWithTextWidth:kSCREEN_WIDTH];
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]initWithFrame:CGRectZero];
    [self.backView6 addSubview:label];
    self.selSlabel2 = label;
    label.delegate = self;
    
    label.textContainer = self.selSmotextContainer2;
    
    [label sizeToFit];
    
    label.sd_layout
    .leftSpaceToView(self.backView6, 39)
    .rightSpaceToView(self.backView6, 16)
    .heightIs([label getSizeWithWidth:(kSCREEN_WIDTH-26-16)].height)
    .topSpaceToView(self.selSmobutton2, 10);
}

- (void)createTextContainerDrink1:(NSString *)text
{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    
    // 整体设置属性
    textContainer.linesSpacing = 2;
    textContainer.paragraphSpacing = 5;
    textContainer.textColor = ZPMyOrderDetailFontColor;
    textContainer.font = [UIFont systemFontOfSize:13];
    
    // 填空题
    NSArray *blankStorage = [self parseTextFieldsWithString:text];
    [textContainer addTextStorageArray:blankStorage];
    
    self.selDritextContainer1 = [textContainer createTextContainerWithTextWidth:kSCREEN_WIDTH];
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]initWithFrame:CGRectZero];
    [self.backView7 addSubview:label];
    self.selDlabel1 = label;
    label.delegate = self;
    
    label.textContainer = self.selDritextContainer1;
    
    [label sizeToFit];
    
    label.sd_layout
    .leftSpaceToView(self.backView7, 39)
    .rightSpaceToView(self.backView7, 16)
    .heightIs([label getSizeWithWidth:(kSCREEN_WIDTH-26-16)].height)
    .topSpaceToView(self.selDributton1, 10);
}

- (void)createTextContainerDrink2:(NSString *)text
{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    
    // 整体设置属性
    textContainer.linesSpacing = 2;
    textContainer.paragraphSpacing = 5;
    textContainer.textColor = ZPMyOrderDetailFontColor;
    textContainer.font = [UIFont systemFontOfSize:13];
    
    // 填空题
    NSArray *blankStorage = [self parseTextFieldsWithString:text];
    [textContainer addTextStorageArray:blankStorage];
    
    self.selDritextContainer2 = [textContainer createTextContainerWithTextWidth:kSCREEN_WIDTH];
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]initWithFrame:CGRectZero];
    [self.backView7 addSubview:label];
    self.selDlabel2 = label;
    label.delegate = self;
    
    label.textContainer = self.selDritextContainer2;
    
    [label sizeToFit];
    
    label.sd_layout
    .leftSpaceToView(self.backView7, 39)
    .rightSpaceToView(self.backView7, 16)
    .heightIs([label getSizeWithWidth:(kSCREEN_WIDTH-26-16)].height)
    .topSpaceToView(self.selDributton2, 10);
}

- (void)createTextContainerDrink3:(NSString *)text
{
    // 属性文本生成器
    TYTextContainer *textContainer = [[TYTextContainer alloc]init];
    textContainer.text = text;
    
    // 整体设置属性
    textContainer.linesSpacing = 2;
    textContainer.paragraphSpacing = 5;
    textContainer.textColor = ZPMyOrderDetailFontColor;
    textContainer.font = [UIFont systemFontOfSize:13];
    
    // 填空题
    NSArray *blankStorage = [self parseTextFieldsWithString:text];
    [textContainer addTextStorageArray:blankStorage];
    
    self.selDritextContainer3 = [textContainer createTextContainerWithTextWidth:kSCREEN_WIDTH];
    
    TYAttributedLabel *label = [[TYAttributedLabel alloc]initWithFrame:CGRectZero];
    [self.backView7 addSubview:label];
    self.selDlabel3 = label;
    label.delegate = self;
    
    label.textContainer = self.selDritextContainer3;
    
    [label sizeToFit];
    
    label.sd_layout
    .leftSpaceToView(self.backView7, 39)
    .rightSpaceToView(self.backView7, 16)
    .heightIs([label getSizeWithWidth:(kSCREEN_WIDTH-26-16)].height)
    .topSpaceToView(self.selDributton3, 10);
}

// 解析填空
- (NSArray *)parseTextFieldsWithString:(NSString *)string
{
    NSMutableArray *textFieldArray = [NSMutableArray array];
    [string enumerateStringsMatchedByRegex:@"\\[@\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if (captureCount > 0) {
            TExamTextField *textField = [[TExamTextField alloc]initWithFrame:CGRectMake(0, 0, kExamTextFieldWidth, kExamTextFieldHeight)];
            textField.textColor = ZPMyOrderDetailFontColor;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.font = [UIFont systemFontOfSize:13];
            textField.keyboardType = UIKeyboardTypeNumberPad;
            TYViewStorage *viewStorage = [[TYViewStorage alloc]init];
            viewStorage.range = capturedRanges[0];
            viewStorage.view = textField;
            viewStorage.tag = kTextFieldTag + textFieldArray.count;;
            
            [textFieldArray addObject:viewStorage];
        }
    }];
    
    return textFieldArray.count > 0 ?[textFieldArray copy] : nil;
}


- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    if (self.birthTextfield.isFirstResponder)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        self.birthTextfield.text = [formatter stringFromDate:sender.date];
        self.model.birthday = self.birthTextfield.text;
    }
}

- (void)pickerValueChanged:(UIPickerView *)pickerView {

}

#pragma mark - 展开收起退休
- (void)expandRetireView:(BOOL)expand {
    [self.view endEditing:YES];
    if (!expand) {
        //收起
        self.selRetireLabel.hidden = YES;
        self.backView5.sd_layout.heightIs(49);
        [self.backView5 updateLayout];
        [self.backView5 setupAutoHeightWithBottomView:self.retireLeftName bottomMargin:0];
    } else {
        //展开
        self.selRetireLabel.hidden = NO;
        [self.backView5 setupAutoHeightWithBottomView:self.selRetireLabel bottomMargin:10];
        [self.backView5 updateLayout];
    }
}

#pragma mark - 展开收起吸烟
- (void)expandSmokeView:(UIButton *)btn {
    [self.view endEditing:YES];
    btn.selected = !btn.selected;
    if (!btn.selected) {
        if (self.model.smoking !=nil && self.model.smoking.length) {
            //选择了
            self.resultSmobutton.hidden = NO;
            [self.resultSmobutton setTitle:self.model.smoking forState:UIControlStateNormal];
            [self isHiddenSmokeView:YES];
            
            self.backView6.sd_layout.heightIs(49+50);
            [self.backView6 updateLayout];
            [self.backView6 setupAutoHeightWithBottomView:self.resultSmobutton bottomMargin:16];
        } else {
            [self isHiddenSmokeView:YES];
            self.backView6.sd_layout.heightIs(49);
            [self.backView6 updateLayout];
            [self.backView6 setupAutoHeightWithBottomView:self.smokeLeftName bottomMargin:0];
        }
    } else {
         self.resultSmobutton.hidden = YES;
        [self isHiddenSmokeView:NO];
        [self.backView6 setupAutoHeightWithBottomView:self.selSmobutton3 bottomMargin:10];
        [self.backView6 updateLayout];
    }
}

- (void)isHiddenSmokeView:(BOOL)hidden {
     self.selSmobutton1.hidden = hidden;
     self.selSmobutton2.hidden = hidden;
     self.selSmobutton3.hidden = hidden;
     self.selSlabel1.hidden = hidden;
     self.selSlabel2.hidden = hidden;
}

#pragma mark - 展开收起饮酒
- (void)expandDrinkView:(UIButton *)btn {
    [self.view endEditing:YES];
    btn.selected = !btn.selected;
   
    if (!btn.selected) {
        if (self.model.drinking !=nil && self.model.drinking.length) {
            //选择了
            self.resultDributton.hidden = NO;
            [self.resultDributton setTitle:self.model.drinking forState:UIControlStateNormal];
            [self isHiddenDrinkView:YES];
            
            self.backView7.sd_layout.heightIs(49+50);
            [self.backView7 updateLayout];
            [self.backView7 setupAutoHeightWithBottomView:self.resultDributton bottomMargin:16];
        } else {
            [self isHiddenDrinkView:YES];
            self.backView7.sd_layout.heightIs(49);
            [self.backView7 updateLayout];
            [self.backView7 setupAutoHeightWithBottomView:self.drinkLeftName bottomMargin:0];
        }
     } else {
           self.resultDributton.hidden = YES;
          [self isHiddenDrinkView:NO];
        [self.backView7 setupAutoHeightWithBottomView:self.selDributton4 bottomMargin:10];
         [self.backView7 updateLayout];
     }
}

- (void)isHiddenDrinkView:(BOOL)hidden {
    self.selDributton1.hidden = hidden;
    self.selDributton2.hidden = hidden;
    self.selDributton3.hidden = hidden;
     self.selDributton4.hidden = hidden;
    self.selDlabel1.hidden = hidden;
    self.selDlabel2.hidden = hidden;
    self.selDlabel3.hidden = hidden;
}

#pragma mark - 选择性别
- (void)selectGenderEvent:(UIButton *)btn {
    [self.view endEditing:YES];
    self.mButton.selected = NO;
    self.fButton.selected = NO;
    btn.selected = YES;
    self.mButton.backgroundColor = self.mButton.isSelected?ZPMyOrderDetailValueFontColor:[UIColor whiteColor];
    self.mButton.layer.borderColor = self.mButton.isSelected?[UIColor whiteColor].CGColor:ZPMyOrderDetailFontColor.CGColor;
    self.fButton.backgroundColor = self.fButton.isSelected?ZPMyOrderDetailValueFontColor:[UIColor whiteColor];
    self.fButton.layer.borderColor = self.fButton.isSelected?[UIColor whiteColor].CGColor:ZPMyOrderDetailFontColor.CGColor;
    if ([btn.titleLabel.text isEqualToString:@"男"]) {
        self.model.gender = @"m";
        
    } else {
        self.model.gender = @"f";
    }
}

#pragma mark - 选择退休
- (void)selectRetireEvent:(UIButton *)btn {
    self.yesButton.selected = NO;
    self.noButton.selected = NO;
    btn.selected = YES;
    self.yesButton.backgroundColor = self.yesButton.isSelected?ZPMyOrderDetailValueFontColor:[UIColor whiteColor];
    self.yesButton.layer.borderColor = self.yesButton.isSelected?[UIColor whiteColor].CGColor:ZPMyOrderDetailFontColor.CGColor;
    self.noButton.backgroundColor = self.noButton.isSelected?ZPMyOrderDetailValueFontColor:[UIColor whiteColor];
    self.noButton.layer.borderColor = self.noButton.isSelected?[UIColor whiteColor].CGColor:ZPMyOrderDetailFontColor.CGColor;
    if ([btn.titleLabel.text isEqualToString:@"是"]) {
        self.model.retired = true;
        [self expandRetireView:YES];
    } else {
        self.model.retired = false;
        [self expandRetireView:NO];
    }
    
}

#pragma mark - 选择吸烟
- (void)selChooseSmokeEvent:(UIButton *)btn {
    self.selSmobutton1.selected = NO;
    self.selSmobutton2.selected = NO;
    self.selSmobutton3.selected = NO;
    btn.selected = YES;
    switch (btn.tag) {
        case 10011:
            {
              self.model.smoking = @"是,现在还吸";
            }
            break;
        case 10012:
        {
            self.model.smoking = @"不,过去吸";
        }
            break;
        case 10013:
        {
            self.model.smoking = @"不吸烟";
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 选择饮酒
- (void)selChooseDrinkEvent:(UIButton *)btn {
    self.selDributton1.selected = NO;
    self.selDributton2.selected = NO;
    self.selDributton3.selected = NO;
    self.selDributton4.selected = NO;
    btn.selected = YES;
    switch (btn.tag) {
        case 10021:
        {
            self.model.drinking = @"常喝,现在还在喝";
        }
            break;
        case 10022:
        {
            self.model.drinking = @"从前常喝,现在不喝了";
        }
            break;
        case 10023:
        {
            self.model.drinking = @"偶尔喝";
        }
            break;
        case 10024:
        {
            self.model.drinking = @"不喝酒";
        }
            break;
            
        default:
            break;
    }
}

- (void)textFieldTextChange:(UITextField *)textField {
    if (self.nameTextfield == textField) {
        self.model.name = textField.text;
    }
}

#pragma mark - 提交
- (void)nextAction {
    if (!self.model.name.length) {
        [MBProgressHUD showError:@"请输入姓名或昵称"];
        return;
    }
    /*
    if (!self.professionTextfield.text.length) {
        [MBProgressHUD showError:@"请选择职业"];
        return;
    }
     */
    if (!self.departmentTextfield.text.length) {
        [MBProgressHUD showError:@"请输入部门"];
        return;
    }
    if (!self.positionTextfield.text.length) {
        [MBProgressHUD showError:@"请输入职位"];
        return;
    }
    /*
    if (!self.entryTimeTextfield.text.length) {
        [MBProgressHUD showError:@"请输入入职年限"];
        return;
    }
    if (!self.cultureTextfield.text.length) {
        [MBProgressHUD showError:@"请选择文化程度"];
        return;
    }
    if (!self.marriageTextfield.text.length) {
        [MBProgressHUD showError:@"请选择婚姻状况"];
        return;
    }
    if (!self.livingTextfield.text.length) {
        [MBProgressHUD showError:@"请选择独居情况"];
        return;
    }
    
    if (!self.yesButton.selected && !self.noButton.selected) {
        [MBProgressHUD showError:@"请选择退休选项"];
        return;
    }
    
    if (self.yesButton.selected) {
        for (TYTextStorage *textStorage in self.selRettextContainer.textStorages) {
            if ([textStorage isKindOfClass:[TYViewStorage class]]) {
                TYViewStorage *viewStorage = (TYViewStorage *)textStorage;
                if ([viewStorage.view isKindOfClass:[TExamTextField class]]) {
                    TExamTextField *textField = (TExamTextField *)viewStorage.view;
                    self.model.retiredAge = textField.text;
                }
            }
        }
        if (!self.model.retiredAge.length) {
            [MBProgressHUD showError:@"请输入退休年龄"];
            return;
        }
    }
      */
    if (!self.selSmobutton1.selected && !self.selSmobutton2.selected && !self.selSmobutton3.selected) {
        [MBProgressHUD showError:@"请选择吸烟选项"];
        return;
    }
    if (!self.selDributton1.selected && !self.selDributton2.selected && !self.selDributton3.selected && !self.selDributton4.selected) {
        [MBProgressHUD showError:@"请选择饮酒选项"];
        return;
    }
    
    [self smokeAndDrinkVerify];
    NSDictionary *dict;
    if (self.model.smokingYears == nil) {
        self.model.smokingYears = [NSNull null];
    }
    if (self.model.smokingPerDay == nil) {
        self.model.smokingPerDay = [NSNull null];
    }
    if (self.model.winePerDay == nil) {
        self.model.winePerDay = [NSNull null];
    }
    if (self.model.beerPerDay == nil) {
        self.model.beerPerDay = [NSNull null];
    }
    if (self.model.liquorPerDay == nil) {
        self.model.liquorPerDay = [NSNull null];
    }
    if (self.model.foreignLiquorPerDay == nil) {
        self.model.foreignLiquorPerDay = [NSNull null];
    }
/*
    if (!self.model.retired) {
        
        dict = @{@"id":self.model.ID,@"userId":self.model.userId,@"tel":self.model.tel,@"name":self.model.name,@"gender":self.model.gender,@"birthday":self.model.birthday,@"retired":[NSNumber numberWithBool:self.model.retired],@"smoking":self.model.smoking,@"smokingYears":self.model.smokingYears,@"smokingPerDay":self.model.smokingPerDay,@"drinking":self.model.drinking,@"winePerDay":self.model.winePerDay,@"beerPerDay":self.model.beerPerDay,@"liquorPerDay":self.model.liquorPerDay,@"foreignLiquorPerDay":self.model.foreignLiquorPerDay,@"company":self.model.company,@"department":self.departmentTextfield.text,@"position":self.positionTextfield.text,@"workYears":self.entryTimeTextfield.text,@"education":self.cultureTextfield.text,@"marriage":self.marriageTextfield.text,@"livingSituation":self.livingTextfield.text};
    } else {
        dict = @{@"id":self.model.ID,@"userId":self.model.userId,@"tel":self.model.tel,@"name":self.model.name,@"gender":self.model.gender,@"birthday":self.model.birthday,@"retired":[NSNumber numberWithBool:self.model.retired],@"smoking":self.model.smoking,@"smokingYears":self.model.smokingYears,@"smokingPerDay":self.model.smokingPerDay,@"drinking":self.model.drinking,@"winePerDay":self.model.winePerDay,@"beerPerDay":self.model.beerPerDay,@"liquorPerDay":self.model.liquorPerDay,@"foreignLiquorPerDay":self.model.foreignLiquorPerDay,@"retiredAge":self.model.retiredAge,@"company":self.model.company,@"department":self.departmentTextfield.text,@"position":self.positionTextfield.text,@"workYears":self.entryTimeTextfield.text,@"education":self.cultureTextfield.text,@"marriage":self.marriageTextfield.text,@"livingSituation":self.livingTextfield.text};
    }*/
    if (!self.model.company) {
        self.model.company = @"";
    }
    dict = @{@"id":self.model.ID,@"userId":self.model.userId,@"tel":self.model.tel,@"name":self.model.name,@"gender":self.model.gender,@"birthday":self.model.birthday,@"retired":@"",@"smoking":self.model.smoking,@"smokingYears":self.model.smokingYears,@"smokingPerDay":self.model.smokingPerDay,@"drinking":self.model.drinking,@"winePerDay":self.model.winePerDay,@"beerPerDay":self.model.beerPerDay,@"liquorPerDay":self.model.liquorPerDay,@"foreignLiquorPerDay":self.model.foreignLiquorPerDay,@"company":self.model.company,@"department":self.departmentTextfield.text,@"position":self.positionTextfield.text,@"workYears":@"",@"education":@"",@"marriage":@"",@"livingSituation":@""};
    ZPLog(@"提交的数据%@",dict);
    [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"psychologicalAssessment" parameters:dict progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            ZPRootWebViewController *mentalManageControl = [[ZPRootWebViewController alloc] init];
            mentalManageControl.titleString = @"身心健康评估";
            mentalManageControl.url = [response objectForKey:@"data"];
            mentalManageControl.initCloseBtn = YES;
            mentalManageControl.isPsyAssessPage = YES;
            [self.navigationController pushViewController:mentalManageControl animated:YES];
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPPsychologicalAssessController class]];
    
    
}

- (void)smokeAndDrinkVerify {
    if ([self.model.smoking isEqualToString:@"是,现在还吸"]) {
        [self getSmokeLabelModelData:self.selSmotextContainer1];
        
//        if (!self.model.smokingPerDay.length || !self.model.smokingYears.length) {
//            [MBProgressHUD showError:@"请填入吸烟数据"];
//            return;
//        }
    } else  if ([self.model.smoking isEqualToString:@"不,过去吸"]) {
        [self getSmokeLabelModelData:self.selSmotextContainer2];
        
//        if (!self.model.smokingPerDay.length || !self.model.smokingYears.length) {
//            [MBProgressHUD showError:@"请填入吸烟数据"];
//            return;
//        }
    }
    
    if ([self.model.drinking isEqualToString:@"常喝,现在还在喝"]) {
        [self getDrinkLabelModelData:self.selDritextContainer1];
        
//        if (!self.model.beerPerDay.length || !self.model.liquorPerDay.length || !self.model.winePerDay.length || !self.model.foreignLiquorPerDay.length) {
//            [MBProgressHUD showError:@"请填入饮酒数据"];
//            return;
//        }
    } else  if ([self.model.drinking isEqualToString:@"从前常喝,现在不喝了"]) {
        [self getDrinkLabelModelData:self.selDritextContainer2];
        
//        if (!self.model.beerPerDay.length || !self.model.liquorPerDay.length || !self.model.winePerDay.length || !self.model.foreignLiquorPerDay.length) {
//            [MBProgressHUD showError:@"请填入饮酒数据"];
//            return;
//        }
    } else  if ([self.model.drinking isEqualToString:@"偶尔喝"]) {
        [self getDrinkLabelModelData:self.selDritextContainer3];
        
//        if (!self.model.beerPerDay.length || !self.model.liquorPerDay.length || !self.model.winePerDay.length || !self.model.foreignLiquorPerDay.length) {
//            [MBProgressHUD showError:@"请填入饮酒数据"];
//            return;
//        }
    }
    
}

- (void)getSmokeLabelModelData:(TYTextContainer *)texContainer {
    for (TYTextStorage *textStorage in texContainer.textStorages) {
        if ([textStorage isKindOfClass:[TYViewStorage class]]) {
            TYViewStorage *viewStorage = (TYViewStorage *)textStorage;
            if ([viewStorage.view isKindOfClass:[TExamTextField class]]) {
                TExamTextField *textField = (TExamTextField *)viewStorage.view;
                switch (viewStorage.tag) {
                    case 1000:
                    {
                        self.model.smokingPerDay = textField.text;
                    }
                        break;
                    case 1001:
                    {
                        self.model.smokingYears = textField.text;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
}


- (void)getDrinkLabelModelData:(TYTextContainer *)texContainer {
    for (TYTextStorage *textStorage in texContainer.textStorages) {
        if ([textStorage isKindOfClass:[TYViewStorage class]]) {
            TYViewStorage *viewStorage = (TYViewStorage *)textStorage;
            if ([viewStorage.view isKindOfClass:[TExamTextField class]]) {
                TExamTextField *textField = (TExamTextField *)viewStorage.view;
                switch (viewStorage.tag) {
                    case 1000:
                    {
                        self.model.beerPerDay = textField.text;
                    }
                        break;
                    case 1001:
                    {
                        self.model.liquorPerDay = textField.text;
                    }
                        break;
                    case 1002:
                    {
                        self.model.winePerDay = textField.text;
                    }
                        break;
                    case 1003:
                    {
                        self.model.foreignLiquorPerDay = textField.text;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
    }
}

#pragma mark - pickview代理方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickView == pickerView) {
        self.pickViewData = @[@"工人",@"职员",@"医务",@"农民工",@"教师",@"学生",@"行政",@"科技",@"文体",@"军人",@"个体",@"农民",@"家务",@"其他"];
    } else  if (self.pickView1 == pickerView) {
//        self.pickViewData = @[@"本科以上",@"本科",@"大专",@"技校",@"高中",@"中校",@"中专",@"初中",@"小学",@"文盲"];
        self.pickViewData = @[@"博士及以上",@"硕士",@"本科",@"大专",@"中专",@"高中"];
    } else if (self.pickView2== pickerView) {
        self.pickViewData = @[@"已婚",@"未婚",@"分居",@"离婚",@"丧偶"];
    }else  if (self.pickView3== pickerView) {
        self.pickViewData = @[@"独居",@"与配偶居住",@"与子女居住",@"与配偶子女居住",@"其他"];
    }
    return self.pickViewData.count;
}

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickViewData[row];
}

//选中某行后回调的方法，获得选中结果
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if (self.professionTextfield.isFirstResponder) {
//        self.professionTextfield.text = self.pickViewData[row];
//    } else
    if (self.cultureTextfield.isFirstResponder) {
        self.cultureTextfield.text = self.pickViewData[row];
    } else if (self.marriageTextfield.isFirstResponder) {
        self.marriageTextfield.text = self.pickViewData[row];
    }else  if (self.livingTextfield.isFirstResponder) {
        self.livingTextfield.text = self.pickViewData[row];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!textField.text.length) {
        if (self.cultureTextfield.isFirstResponder) {
            self.cultureTextfield.text = @"博士及以上";
        } else if (self.marriageTextfield.isFirstResponder) {
            self.marriageTextfield.text =@"已婚";
        }else  if (self.livingTextfield.isFirstResponder) {
            self.livingTextfield.text = @"独居";
        }
    }
}

#pragma mark - pickView toolbar上的方法
- (void)hiddenPickView {
    [self.view endEditing:YES];
}
#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = RGB_242_242_242;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)backView1 {
    if (!_backView1) {
        _backView1 = [UIView new];
        _backView1.backgroundColor = [UIColor whiteColor];
        _backView1.userInteractionEnabled = YES;
    }
    return _backView1;
}

- (UIView *)backView2 {
    if (!_backView2) {
        _backView2 = [UIView new];
        _backView2.backgroundColor = [UIColor whiteColor];
        _backView2.userInteractionEnabled = YES;
    }
    return _backView2;
}

- (UIView *)backView3 {
    if (!_backView3) {
        _backView3 = [UIView new];
        _backView3.backgroundColor = [UIColor whiteColor];
        _backView3.userInteractionEnabled = YES;
    }
    return _backView3;
}

- (UIView *)backView4 {
    if (!_backView4) {
        _backView4 = [UIView new];
        _backView4.backgroundColor = [UIColor whiteColor];
        _backView4.userInteractionEnabled = YES;
    }
    return _backView4;
}

- (UIView *)backView5 {
    if (!_backView5) {
        _backView5 = [UIView new];
        _backView5.backgroundColor = [UIColor whiteColor];
        _backView5.userInteractionEnabled = YES;
    }
    return _backView5;
}

- (UIView *)backView6 {
    if (!_backView6) {
        _backView6 = [UIView new];
        _backView6.backgroundColor = [UIColor whiteColor];
        _backView6.userInteractionEnabled = YES;
    }
    return _backView6;
}

- (UIView *)backView7 {
    if (!_backView7) {
        _backView7 = [UIView new];
        _backView7.backgroundColor = [UIColor whiteColor];
        _backView7.userInteractionEnabled = YES;
    }
    return _backView7;
}

- (UIView *)newbackView1 {
    if (!_newbackView1) {
        _newbackView1 = [UIView new];
        _newbackView1.backgroundColor = [UIColor whiteColor];
        _newbackView1.userInteractionEnabled = YES;
    }
    return _newbackView1;
}

- (UIView *)newbackView2 {
    if (!_newbackView2) {
        _newbackView2 = [UIView new];
        _newbackView2.backgroundColor = [UIColor whiteColor];
        _newbackView2.userInteractionEnabled = YES;
    }
    return _newbackView2;
}

- (UIView *)newbackView3 {
    if (!_newbackView3) {
        _newbackView3 = [UIView new];
        _newbackView3.backgroundColor = [UIColor whiteColor];
        _newbackView3.userInteractionEnabled = YES;
    }
    return _newbackView3;
}

- (UIView *)newbackView4 {
    if (!_newbackView4) {
        _newbackView4 = [UIView new];
        _newbackView4.backgroundColor = [UIColor whiteColor];
        _newbackView4.userInteractionEnabled = YES;
    }
    return _newbackView4;
}

- (UIView *)newbackView5 {
    if (!_newbackView5) {
        _newbackView5 = [UIView new];
        _newbackView5.backgroundColor = [UIColor whiteColor];
        _newbackView5.userInteractionEnabled = YES;
    }
    return _newbackView5;
}

- (UIView *)newbackView6 {
    if (!_newbackView6) {
        _newbackView6 = [UIView new];
        _newbackView6.backgroundColor = [UIColor whiteColor];
        _newbackView6.userInteractionEnabled = YES;
    }
    return _newbackView6;
}

- (UIView *)newbackView7 {
    if (!_newbackView7) {
        _newbackView7 = [UIView new];
        _newbackView7.backgroundColor = [UIColor whiteColor];
        _newbackView7.userInteractionEnabled = YES;
    }
    return _newbackView7;
}

- (UILabel *)nameLeftName {
    if (!_nameLeftName) {
        _nameLeftName = [UILabel new];
        _nameLeftName.textColor = ZPMyOrderDetailFontColor;
        _nameLeftName.font = [UIFont systemFontOfSize:14];
        _nameLeftName.backgroundColor = [UIColor whiteColor];
        _nameLeftName.text = @"姓名或昵称";
       
    }
    return _nameLeftName;
}

- (UILabel *)genderLeftName {
    if (!_genderLeftName) {
        _genderLeftName = [UILabel new];
        _genderLeftName.textColor = ZPMyOrderDetailFontColor;
        _genderLeftName.font = [UIFont systemFontOfSize:14];
        _genderLeftName.backgroundColor = [UIColor whiteColor];
        _genderLeftName.text = @"性别";

    }
    return _genderLeftName;
}
- (UILabel *)birthLeftName {
    if (!_birthLeftName) {
        _birthLeftName = [UILabel new];
        _birthLeftName.textColor = ZPMyOrderDetailFontColor;
        _birthLeftName.font = [UIFont systemFontOfSize:14];
        _birthLeftName.backgroundColor = [UIColor whiteColor];

        _birthLeftName.text = @"出生日期";
      
    }
    return _birthLeftName;
}
- (UILabel *)companyLeftName {
    if (!_companyLeftName) {
        _companyLeftName = [UILabel new];
        _companyLeftName.textColor = ZPMyOrderDetailFontColor;
        _companyLeftName.font = [UIFont systemFontOfSize:14];
        _companyLeftName.backgroundColor = [UIColor whiteColor];
    
        _companyLeftName.text = @"公司名称";
       
    }
    return _companyLeftName;
}
- (UILabel *)retireLeftName {
    if (!_retireLeftName) {
        _retireLeftName = [UILabel new];
        _retireLeftName.textColor = ZPMyOrderDetailFontColor;
        _retireLeftName.font = [UIFont systemFontOfSize:14];
        _retireLeftName.backgroundColor = [UIColor whiteColor];
     
        _retireLeftName.text = @"是否退休";
    }
    return _retireLeftName;
}
- (UILabel *)smokeLeftName {
    if (!_smokeLeftName) {
        _smokeLeftName = [UILabel new];
        _smokeLeftName.textColor = ZPMyOrderDetailFontColor;
        _smokeLeftName.font = [UIFont systemFontOfSize:14];
        _smokeLeftName.backgroundColor = [UIColor whiteColor];
       
        _smokeLeftName.text = @"您吸烟吗";
    }
    return _smokeLeftName;
}

- (UILabel *)drinkLeftName {
    if (!_drinkLeftName) {
        _drinkLeftName = [UILabel new];
        _drinkLeftName.textColor = ZPMyOrderDetailFontColor;
        _drinkLeftName.font = [UIFont systemFontOfSize:14];
        _drinkLeftName.backgroundColor = [UIColor whiteColor];
       
        _drinkLeftName.text = @"您饮酒吗";
    }
    return _drinkLeftName;
}

- (UILabel *)professionLeftName {
    if (!_professionLeftName) {
        _professionLeftName = [UILabel new];
        _professionLeftName.textColor = ZPMyOrderDetailFontColor;
        _professionLeftName.font = [UIFont systemFontOfSize:14];
        _professionLeftName.backgroundColor = [UIColor whiteColor];
        _professionLeftName.text = @"职业";
    }
    return _professionLeftName;
}

- (UILabel *)departmentLeftName {
    if (!_departmentLeftName) {
        _departmentLeftName = [UILabel new];
        _departmentLeftName.textColor = ZPMyOrderDetailFontColor;
        _departmentLeftName.font = [UIFont systemFontOfSize:14];
        _departmentLeftName.backgroundColor = [UIColor whiteColor];
        _departmentLeftName.text = @"部门";
    }
    return _departmentLeftName;
}


- (UILabel *)positionLeftName {
    if (!_positionLeftName) {
        _positionLeftName = [UILabel new];
        _positionLeftName.textColor = ZPMyOrderDetailFontColor;
        _positionLeftName.font = [UIFont systemFontOfSize:14];
        _positionLeftName.backgroundColor = [UIColor whiteColor];
        _positionLeftName.text = @"职位";
    }
    return _positionLeftName;
}

- (UILabel *)entryTimeLeftName {
    if (!_entryTimeLeftName) {
        _entryTimeLeftName = [UILabel new];
        _entryTimeLeftName.textColor = ZPMyOrderDetailFontColor;
        _entryTimeLeftName.font = [UIFont systemFontOfSize:14];
        _entryTimeLeftName.backgroundColor = [UIColor whiteColor];
        _entryTimeLeftName.text = @"入职年限";
    }
    return _entryTimeLeftName;
}

- (UILabel *)cultureLeftName {
    if (!_cultureLeftName) {
        _cultureLeftName = [UILabel new];
        _cultureLeftName.textColor = ZPMyOrderDetailFontColor;
        _cultureLeftName.font = [UIFont systemFontOfSize:14];
        _cultureLeftName.backgroundColor = [UIColor whiteColor];
        _cultureLeftName.text = @"文化程度";
    }
    return _cultureLeftName;
}

- (UILabel *)marriageLeftName {
    if (!_marriageLeftName) {
        _marriageLeftName = [UILabel new];
        _marriageLeftName.textColor = ZPMyOrderDetailFontColor;
        _marriageLeftName.font = [UIFont systemFontOfSize:14];
        _marriageLeftName.backgroundColor = [UIColor whiteColor];
        _marriageLeftName.text = @"婚姻状况";
    }
    return _marriageLeftName;
}

- (UILabel *)livingLeftName {
    if (!_livingLeftName) {
        _livingLeftName = [UILabel new];
        _livingLeftName.textColor = ZPMyOrderDetailFontColor;
        _livingLeftName.font = [UIFont systemFontOfSize:14];
        _livingLeftName.backgroundColor = [UIColor whiteColor];
        _livingLeftName.text = @"居住情况";
    }
    return _livingLeftName;
}

- (UITextField *)nameTextfield {
    if (!_nameTextfield) {
        _nameTextfield = [UITextField new];
        _nameTextfield.textColor = ZPMyOrderDetailFontColor;
        _nameTextfield.font = [UIFont systemFontOfSize:14];
        _nameTextfield.textAlignment = NSTextAlignmentRight;
        [_nameTextfield addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        _nameTextfield.placeholder = @"请输入姓名或昵称";
    }
    return _nameTextfield;
}

- (UIButton *)mButton {
    if (!_mButton) {
        _mButton = [UIButton new];
        _mButton.layer.borderWidth = 0.5;
        _mButton.layer.borderColor = RGB(204, 204, 204).CGColor;
        _mButton.layer.cornerRadius = 5;
        _mButton.layer.masksToBounds = YES;
        [_mButton setBackgroundColor:[UIColor whiteColor]];
        _mButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_mButton setTitle:@"男" forState:UIControlStateNormal];
        [_mButton setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        [_mButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_mButton addTarget:self action:@selector(selectGenderEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mButton;
}

- (UIButton *)fButton {
    if (!_fButton) {
        _fButton = [UIButton new];
        _fButton.layer.borderWidth = 0.5;
        _fButton.layer.borderColor = RGB(204, 204, 204).CGColor;
        _fButton.layer.cornerRadius = 5;
        _fButton.layer.masksToBounds = YES;
        [_fButton setBackgroundColor:[UIColor whiteColor]];
        _fButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_fButton setTitle:@"女" forState:UIControlStateNormal];
        [_fButton setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        [_fButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_fButton addTarget:self action:@selector(selectGenderEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fButton;
}

- (UITextField *)birthTextfield {
    if (!_birthTextfield) {
        _birthTextfield = [UITextField new];
        _birthTextfield.textColor = ZPMyOrderDetailFontColor;
        _birthTextfield.font = [UIFont systemFontOfSize:14];
        _birthTextfield.textAlignment = NSTextAlignmentRight;
        _birthTextfield.inputView = self.datePicker;
    }
    return _birthTextfield;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker setMaximumDate:[NSDate date]];
        [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (UIButton *)yesButton {
    if (!_yesButton) {
        _yesButton = [UIButton new];
        _yesButton.layer.borderWidth = 0.5;
        _yesButton.layer.borderColor = RGB(204, 204, 204).CGColor;
        _yesButton.layer.cornerRadius = 5;
        _yesButton.layer.masksToBounds = YES;
        _yesButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_yesButton setTitle:@"是" forState:UIControlStateNormal];
        [_yesButton setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        [_yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_yesButton addTarget:self action:@selector(selectRetireEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yesButton;
}

- (UIButton *)noButton {
    if (!_noButton) {
        _noButton = [UIButton new];
        _noButton.layer.borderWidth = 0.5;
        _noButton.layer.borderColor = RGB(204, 204, 204).CGColor;
        _noButton.layer.cornerRadius = 5;
        _noButton.layer.masksToBounds = YES;
        _noButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_noButton setTitle:@"否" forState:UIControlStateNormal];
        [_noButton setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        [_noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_noButton addTarget:self action:@selector(selectRetireEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noButton;
}


- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [UILabel new];
        _companyLabel.textColor = ZPMyOrderDetailFontColor;
        _companyLabel.font = [UIFont systemFontOfSize:14];
        _companyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _companyLabel;
}

- (UIButton *)selSmokeButton {
    if (!_selSmokeButton) {
        _selSmokeButton = [UIButton new];
        [_selSmokeButton setTitle:@"请选择" forState:UIControlStateNormal];
        [_selSmokeButton setTitle:@"" forState:UIControlStateSelected];
        [_selSmokeButton setTitleColor:ZPMyOrderDeleteBorderColor forState:UIControlStateNormal];
        [_selSmokeButton addTarget:self action:@selector(expandSmokeView:) forControlEvents:UIControlEventTouchUpInside];
        _selSmokeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_selSmokeButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [_selSmokeButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateSelected];
    }
    return _selSmokeButton;
}

- (UIButton *)selDrinkButton {
    if (!_selDrinkButton) {
        _selDrinkButton = [UIButton new];
        [_selDrinkButton setTitle:@"请选择" forState:UIControlStateNormal];
         [_selDrinkButton setTitle:@"" forState:UIControlStateSelected];
        [_selDrinkButton setTitleColor:ZPMyOrderDeleteBorderColor forState:UIControlStateNormal];
        [_selDrinkButton addTarget:self action:@selector(expandDrinkView:) forControlEvents:UIControlEventTouchUpInside];
        _selDrinkButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_selDrinkButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [_selDrinkButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateSelected];
    }
    return _selDrinkButton;
}

- (UIButton *)selSmobutton1 {
    if (!_selSmobutton1) {
        _selSmobutton1 = [UIButton new];
        [_selSmobutton1 setTitle:@"是,现在还吸" forState:UIControlStateNormal];
        [_selSmobutton1 setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
         [_selSmobutton1 setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
        [_selSmobutton1 setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        _selSmobutton1.titleLabel.font = [UIFont systemFontOfSize:14];
        _selSmobutton1.tag = 10011;
        [_selSmobutton1 addTarget:self action:@selector(selChooseSmokeEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selSmobutton1;
}

- (UIButton *)selSmobutton2 {
    if (!_selSmobutton2) {
        _selSmobutton2 = [UIButton new];
        [_selSmobutton2 setTitle:@"不,过去吸" forState:UIControlStateNormal];
        [_selSmobutton2 setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
        [_selSmobutton2 setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
        [_selSmobutton2 setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        _selSmobutton2.titleLabel.font = [UIFont systemFontOfSize:14];
        _selSmobutton2.tag = 10012;
        [_selSmobutton2 addTarget:self action:@selector(selChooseSmokeEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selSmobutton2;
}

- (UIButton *)selSmobutton3 {
    if (!_selSmobutton3) {
        _selSmobutton3 = [UIButton new];
        [_selSmobutton3 setTitle:@"不吸烟" forState:UIControlStateNormal];
        [_selSmobutton3 setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
        [_selSmobutton3 setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
        [_selSmobutton3 setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        _selSmobutton3.titleLabel.font = [UIFont systemFontOfSize:14];
        _selSmobutton3.tag = 10013;
        [_selSmobutton3 addTarget:self action:@selector(selChooseSmokeEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selSmobutton3;
}

- (UIButton *)selDributton1 {
    if (!_selDributton1) {
        _selDributton1 = [UIButton new];
        [_selDributton1 setTitle:@"常喝,现在还在喝" forState:UIControlStateNormal];
        [_selDributton1 setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
        [_selDributton1 setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
        [_selDributton1 setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        _selDributton1.titleLabel.font = [UIFont systemFontOfSize:14];
        _selDributton1.tag = 10021;
        [_selDributton1 addTarget:self action:@selector(selChooseDrinkEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selDributton1;
}

- (UIButton *)selDributton2 {
    if (!_selDributton2) {
        _selDributton2 = [UIButton new];
        [_selDributton2 setTitle:@"从前常喝,现在不喝了" forState:UIControlStateNormal];
        [_selDributton2 setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
        [_selDributton2 setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
        [_selDributton2 setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        _selDributton2.titleLabel.font = [UIFont systemFontOfSize:14];
        _selDributton2.tag = 10022;
        [_selDributton2 addTarget:self action:@selector(selChooseDrinkEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selDributton2;
}

- (UIButton *)selDributton3 {
    if (!_selDributton3) {
        _selDributton3 = [UIButton new];
        [_selDributton3 setTitle:@"偶尔喝" forState:UIControlStateNormal];
        [_selDributton3 setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
        [_selDributton3 setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
        [_selDributton3 setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        _selDributton3.titleLabel.font = [UIFont systemFontOfSize:14];
        _selDributton3.tag = 10023;
        [_selDributton3 addTarget:self action:@selector(selChooseDrinkEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selDributton3;
}

- (UIButton *)selDributton4 {
    if (!_selDributton4) {
        _selDributton4 = [UIButton new];
        [_selDributton4 setTitle:@"不喝酒" forState:UIControlStateNormal];
        [_selDributton4 setImage:[UIImage imageNamed:@"common_noselected_icon"] forState:UIControlStateNormal];
        [_selDributton4 setImage:[UIImage imageNamed:@"common_selected_icon"] forState:UIControlStateSelected];
        [_selDributton4 setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        _selDributton4.titleLabel.font = [UIFont systemFontOfSize:14];
        _selDributton4.tag = 10024;
        [_selDributton4 addTarget:self action:@selector(selChooseDrinkEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selDributton4;
}


- (UIButton *)resultSmobutton {
    if (!_resultSmobutton) {
        _resultSmobutton = [UIButton new];
        [_resultSmobutton setTitle:@"" forState:UIControlStateNormal];
        [_resultSmobutton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [_resultSmobutton setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        _resultSmobutton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _resultSmobutton;
}

- (UIButton *)resultDributton {
    if (!_resultDributton) {
        _resultDributton = [UIButton new];
        [_resultDributton setTitle:@"" forState:UIControlStateNormal];
        [_resultDributton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
        [_resultDributton setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
        _resultDributton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _resultDributton;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        _nextBtn.backgroundColor = ZPMyOrderDetailValueFontColor;
        [_nextBtn setTitle:@"填好了开始答题" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}



- (UITextField *)professionTextfield {
    if (!_professionTextfield) {
        _professionTextfield = [UITextField new];
        _professionTextfield.textColor = ZPMyOrderDetailFontColor;
        _professionTextfield.font = [UIFont systemFontOfSize:14];
        _professionTextfield.textAlignment = NSTextAlignmentRight;
        _professionTextfield.inputView = self.pickView;
        _professionTextfield.delegate = self;
        UIToolbar *toolbar=[[UIToolbar alloc]init];
        toolbar.translucent = NO;
        toolbar.barTintColor= RGB(78,178,255);
        toolbar.tintColor = [UIColor whiteColor];
        toolbar.frame=CGRectMake(0, 0, kSCREEN_WIDTH, 44);
      
        UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenPickView)];
        UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenPickView)];
        toolbar.items = @[item1, item2, item3];
        _professionTextfield.inputAccessoryView = toolbar;

    }
    return _professionTextfield;
}

- (NSArray *)pickViewData {
    if (!_pickViewData) {
        _pickViewData = @[@"工人",@"职员",@"医务",@"农民工",@"教师",@"学生",@"行政",@"科技",@"文体",@"军人",@"个体",@"农民",@"家务",@"其他"];
    }
    return _pickViewData;
}


- (UITextField *)departmentTextfield {
    if (!_departmentTextfield) {
        _departmentTextfield = [UITextField new];
        _departmentTextfield.textColor = ZPMyOrderDetailFontColor;
        _departmentTextfield.font = [UIFont systemFontOfSize:14];
        _departmentTextfield.placeholder = @"请输入部门";
        _departmentTextfield.textAlignment = NSTextAlignmentRight;
        [_departmentTextfield addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _departmentTextfield;
}

- (UITextField *)positionTextfield {
    if (!_positionTextfield) {
        _positionTextfield = [UITextField new];
        _positionTextfield.textColor = ZPMyOrderDetailFontColor;
        _positionTextfield.font = [UIFont systemFontOfSize:14];
        _positionTextfield.placeholder = @"请输入职位";
        _positionTextfield.textAlignment = NSTextAlignmentRight;
        [_positionTextfield addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _positionTextfield;
}

- (UITextField *)entryTimeTextfield {
    if (!_entryTimeTextfield) {
        _entryTimeTextfield = [UITextField new];
        _entryTimeTextfield.textColor = ZPMyOrderDetailFontColor;
        _entryTimeTextfield.font = [UIFont systemFontOfSize:14];
        _entryTimeTextfield.placeholder = @"请输入入职年限";
        _entryTimeTextfield.keyboardType = UIKeyboardTypeNumberPad;
        _entryTimeTextfield.textAlignment = NSTextAlignmentRight;
        [_entryTimeTextfield addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _entryTimeTextfield;
}

- (UITextField *)cultureTextfield {
    if (!_cultureTextfield) {
        _cultureTextfield = [UITextField new];
        _cultureTextfield.textColor = ZPMyOrderDetailFontColor;
        _cultureTextfield.font = [UIFont systemFontOfSize:14];
        _cultureTextfield.textAlignment = NSTextAlignmentRight;
        _cultureTextfield.inputView = self.pickView1;
        _cultureTextfield.delegate = self;
        _cultureTextfield.placeholder = @"请选择文化程度";
        UIToolbar *toolbar=[[UIToolbar alloc]init];
        toolbar.translucent = NO;
        toolbar.barTintColor= RGB(78,178,255);
        toolbar.tintColor = [UIColor whiteColor];
        toolbar.frame=CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        
        UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenPickView)];
        UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenPickView)];
        toolbar.items = @[item1, item2, item3];
        _cultureTextfield.inputAccessoryView = toolbar;
    }
    return _cultureTextfield;
}

- (UITextField *)marriageTextfield {
    if (!_marriageTextfield) {
        _marriageTextfield = [UITextField new];
        _marriageTextfield.textColor = ZPMyOrderDetailFontColor;
        _marriageTextfield.font = [UIFont systemFontOfSize:14];
        _marriageTextfield.textAlignment = NSTextAlignmentRight;
        _marriageTextfield.inputView = self.pickView2;
        _marriageTextfield.placeholder = @"请选择婚姻状况";
        _marriageTextfield.delegate = self;
        UIToolbar *toolbar=[[UIToolbar alloc]init];
        toolbar.translucent = NO;
        toolbar.barTintColor= RGB(78,178,255);
        toolbar.tintColor = [UIColor whiteColor];
        toolbar.frame=CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        
        UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenPickView)];
        UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenPickView)];
        toolbar.items = @[item1, item2, item3];
        _marriageTextfield.inputAccessoryView = toolbar;
    }
    return _marriageTextfield;
}

- (UITextField *)livingTextfield {
    if (!_livingTextfield) {
        _livingTextfield = [UITextField new];
        _livingTextfield.textColor = ZPMyOrderDetailFontColor;
        _livingTextfield.font = [UIFont systemFontOfSize:14];
        _livingTextfield.textAlignment = NSTextAlignmentRight;
        _livingTextfield.inputView = self.pickView3;
        _livingTextfield.placeholder = @"请选择居住情况";
          _livingTextfield.delegate = self;
        UIToolbar *toolbar=[[UIToolbar alloc]init];
        toolbar.translucent = NO;
        toolbar.barTintColor= RGB(78,178,255);
        toolbar.tintColor = [UIColor whiteColor];
        toolbar.frame=CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        
        UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenPickView)];
        UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(hiddenPickView)];
        toolbar.items = @[item1, item2, item3];
        _livingTextfield.inputAccessoryView = toolbar;
    }
    return _livingTextfield;
}


- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] init];
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (UIPickerView *)pickView1 {
    if (!_pickView1) {
        _pickView1 = [[UIPickerView alloc] init];
        _pickView1.backgroundColor = [UIColor whiteColor];
        _pickView1.delegate = self;
        _pickView1.dataSource = self;
    }
    return _pickView1;
}

- (UIPickerView *)pickView2 {
    if (!_pickView2) {
        _pickView2 = [[UIPickerView alloc] init];
        _pickView2.backgroundColor = [UIColor whiteColor];
        _pickView2.delegate = self;
        _pickView2.dataSource = self;
    }
    return _pickView2;
}

- (UIPickerView *)pickView3 {
    if (!_pickView3) {
        _pickView3 = [[UIPickerView alloc] init];
        _pickView3.backgroundColor = [UIColor whiteColor];
        _pickView3.delegate = self;
        _pickView3.dataSource = self;
    }
    return _pickView3;
}
@end
