//
//  ZPVersionController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPVersionController.h"

@interface ZPVersionController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *companybtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation ZPVersionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.titleArray = @[@"当前版本"];
}

- (void)setupUI {
    
    self.title = @"版本信息";
    self.view.backgroundColor = RGB(242, 242, 242);
    
    self.topView = [UIView new];
    [self.view addSubview:self.topView];
    self.topView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(182);
    self.topView.backgroundColor = [UIColor whiteColor];
    
    self.companybtn = [UIButton new];
    [self.topView addSubview:self.companybtn];
    self.companybtn.sd_layout
    .centerYEqualToView(self.topView)
    .centerXEqualToView(self.topView)
    .heightIs(120)
    .widthIs(90);
    
    self.companybtn.imageView.sd_layout
    .topEqualToView(self.companybtn)
    .heightIs(90)
    .widthIs(90);
    
    self.companybtn.titleLabel.sd_layout
    .heightIs(16)
    .widthIs(90)
    .bottomEqualToView(self.companybtn);
    
    [self.companybtn setTitle:@"小优健康" forState:UIControlStateNormal];
    [self.companybtn setImage:[UIImage imageNamed:@"appicon"] forState:UIControlStateNormal];
    [self.companybtn setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
    [self.companybtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:17];
    self.companybtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.companybtn.imageView.layer.cornerRadius = 10;
    self.companybtn.imageView.layer.masksToBounds = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .topSpaceToView(self.topView, 12)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 49;
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
    
    return 1;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"app";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.textColor = RGB(74, 74, 74);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsZero;
    }
    UILabel *subTitle = [UILabel new];
    subTitle.text = PRODUCT_VERSION;
    subTitle.textColor = RGB(170, 170, 170);
    subTitle.font = [UIFont systemFontOfSize:15];
    subTitle.textAlignment = NSTextAlignmentRight;
    cell.accessoryView = subTitle;
    
    subTitle.sd_layout
    .rightSpaceToView(cell, 19)
    .heightIs(15)
    .widthIs(50)
    .centerYEqualToView(cell);
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}
@end
