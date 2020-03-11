//
//  ZPHelpCenterController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPHelpCenterController.h"

/* 控制器 */
#import "ZPRootWebViewController.h"

@interface ZPHelpCenterController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UIButton *callBtn;
@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *data;

@end

@implementation ZPHelpCenterController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)initAll {

    [self.view addSubview:self.imageView];
    
    self.imageView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view, 0)
    .heightIs(ZPHeight(170));
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.imageView, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    [self.imageView addSubview:self.backBtn];
    
    self.backBtn.sd_layout
    .leftSpaceToView(self.imageView, 20)
    .topSpaceToView(self.imageView, IS_IPhoneX?54:30)
    .heightIs(22)
    .widthIs(22);
    
    [self.imageView sd_addSubviews:@[self.titleLabel,self.timeLabel,self.phoneLabel,self.callBtn]];
    self.titleLabel.sd_layout
    .centerYEqualToView(self.backBtn)
    .heightIs(17)
    .centerXEqualToView(self.imageView);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.timeLabel.sd_layout
    .leftSpaceToView(self.imageView, 15)
    .rightSpaceToView(self.imageView, 15)
    .heightIs(12)
    .topSpaceToView(self.titleLabel, ZPHeight(20));
    
    self.phoneLabel.sd_layout
    .leftSpaceToView(self.imageView, 15)
    .rightSpaceToView(self.imageView, 15)
    .heightIs(12)
    .topSpaceToView(self.timeLabel,ZPHeight(15));
    
    self.callBtn.sd_layout
    .topSpaceToView(self.phoneLabel, ZPHeight(15))
    .widthIs(ZPWidth(78))
    .heightIs(ZPHeight(25))
    .centerXEqualToView(self.imageView);
}

- (void)initData {
    
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

/* 拨打电话 */
- (void)callAction {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",hotLineNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
}

#pragma mark - -tableView的数据源方法
/**
 *  返回组数(默认为1组)
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

/**
 *  返回每组的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"app";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = RGB_74_74_74;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsZero;
    }
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        ZPRootWebViewController *webControl= [[ZPRootWebViewController alloc] init];
        webControl.localHtml = YES;
        webControl.titleString = @"绿通服务流程";
        [self.navigationController pushViewController:webControl animated:YES];
    } else {
        ZPRootWebViewController *webControl= [[ZPRootWebViewController alloc] init];
        webControl.url = indexPath.row == 0?greenIntroduceImage:greenRuleImage;
        webControl.titleString = indexPath.row == 0?@"绿通产品介绍":@"绿通服务细则";
        [self.navigationController pushViewController:webControl animated:YES];
    }
}


#pragma mark - -懒加载
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"common_back_icon"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"common_background_icon"];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"帮助中心";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.text = @"绿通人工服务时间：工作日7:30 — 19:00";
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)phoneLabel {
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.text = @"电话：400-656-0320";
        _phoneLabel.textColor = [UIColor whiteColor];
        _phoneLabel.font = [UIFont systemFontOfSize:12];
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneLabel;
}

- (UIButton *)callBtn {
    if (!_callBtn) {
        _callBtn = [UIButton new];
        [_callBtn setTitle:@"立即咨询" forState:UIControlStateNormal];
        [_callBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _callBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _callBtn.layer.cornerRadius = 5;
        _callBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _callBtn.layer.borderWidth = 1;
        _callBtn.layer.masksToBounds = YES;
        [_callBtn addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}

- (NSArray *)data {
    if (!_data) {
        _data = @[@"1. 绿通产品介绍",@"2. 绿通服务细则",@"3. 绿通服务流程"];
    }
    return _data;
}

@end
