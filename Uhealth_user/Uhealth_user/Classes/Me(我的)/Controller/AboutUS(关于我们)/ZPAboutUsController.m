//
//  ZPAboutUsController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/3/21.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPAboutUsController.h"
#import "ZPVersionController.h"
#import "ZPAdviceController.h"
@interface ZPAboutUsController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *companybtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;
@end

@implementation ZPAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.titleArray = @[@"版本信息",@"客服电话",@"评价建议",@"小屋医生信息及介绍"];
}

- (void)setupUI {
    self.title = @"关于我们";
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
    
    return 3;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"app";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = RGB(74, 74, 74);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.separatorInset = UIEdgeInsetsZero;
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            ZPVersionController *versionControl = [[ZPVersionController alloc] init];
            [self.navigationController pushViewController:versionControl animated:YES];
        }
            break;
        case 1:
        {
            __weak typeof(self) weakSelf = self;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 16)];
            titleLabel.textColor = RGB(74, 74, 74);
            titleLabel.text = @"小优健康客服电话";
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            
            UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 115, 13)];
            numLabel.textColor = RGB(74, 74, 74);
            numLabel.text = @"400-656-0320";
            numLabel.font = [UIFont systemFontOfSize:16];
            
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 145, 14)];
            contentLabel.textColor = RGB(153, 153, 153);
            contentLabel.text = @"工作时间:9:00-19:00";
            contentLabel.font = [UIFont systemFontOfSize:14];
            [LEEAlert alert].config
            .LeeAddCustomView(^(LEECustomView *custom) {
                custom.view = titleLabel;
                custom.positionType = LEECustomViewPositionTypeCenter;
            })
            .LeeItemInsets(UIEdgeInsetsMake(22, 10, 0, 10))
            .LeeAddCustomView(^(LEECustomView *custom) {
                custom.view = numLabel;
                custom.positionType = LEECustomViewPositionTypeCenter;
            })
            .LeeItemInsets(UIEdgeInsetsMake(15, 10, 10, 10)) // 想为哪一项设置间距范围 直接在其后面设置即可 ()
            .LeeAddCustomView(^(LEECustomView *custom) {
                custom.view = contentLabel;
                custom.positionType = LEECustomViewPositionTypeCenter;
            })
            .LeeItemInsets(UIEdgeInsetsMake(10, 10, 10, 10)) // 这个间距范围就是对content设置的
            .LeeAction(@"取消", nil)
            .LeeCancelAction(@"拨打", ^{
                
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",numLabel.text];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [weakSelf.view addSubview:callWebview];
            })
            .LeeShow();
        }
            break;
        case 2:
        {
            ZPAdviceController *adviceControl = [[ZPAdviceController alloc] init];
            [self.navigationController pushViewController:adviceControl animated:YES];
        }
            
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}
@end
