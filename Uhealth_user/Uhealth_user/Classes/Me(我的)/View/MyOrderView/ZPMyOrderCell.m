//
//  ZPMyOrderCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/4/12.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPMyOrderCell.h"
#import "ZPOrderModel.h"
#import "ZPOrderItemModel.h"
#import "ZPMyOrderSubCell.h"

@interface ZPMyOrderCell()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UILabel *orderNameLabel;
@property (strong, nonatomic) UILabel *orderStatusLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic,strong) UILabel *freightTipLabel;
@property (nonatomic,strong) UILabel *presentPriceLabel;
@property (nonatomic,strong) UILabel *tipLabel;//合计
@property (nonatomic,strong) UILabel *numLabel;

@property (nonatomic,strong) UIView *lineView;

@property (strong, nonatomic) UIButton *confirmGetOrderBtn;
@property (strong, nonatomic) UIButton *deleteOrderBtn;


//-----------------------------------------------tableview
@property (nonatomic,strong) NSMutableArray *datas;
@end
@implementation ZPMyOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *contentView = self.contentView;
    self.orderNameLabel = [UILabel new];
    self.orderNameLabel.textColor = ZPMyOrderDetailFontColor;
    self.orderNameLabel.font = [UIFont systemFontOfSize:13];
    
    self.orderStatusLabel = [UILabel new];
    self.orderStatusLabel.textColor = RGB(78, 178, 255);
    self.orderStatusLabel.font = [UIFont systemFontOfSize:13];
    self.orderStatusLabel.textAlignment =NSTextAlignmentRight;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = RGB(249, 249, 249);
    
    self.freightTipLabel = [UILabel new];
    self.freightTipLabel.textColor =ZPMyOrderDetailFontColor;
    self.freightTipLabel.font = [UIFont systemFontOfSize:12];
    self.freightTipLabel.textAlignment = NSTextAlignmentRight;
    
    self.presentPriceLabel = [UILabel new];
    self.presentPriceLabel.textColor = ZPMyOrderBorderColor;
    self.presentPriceLabel.font = [UIFont systemFontOfSize:15];
    self.presentPriceLabel.textAlignment = NSTextAlignmentRight;
    
    self.tipLabel = [UILabel new];
    self.tipLabel.textColor = ZPMyOrderDetailFontColor;
    self.tipLabel.font = [UIFont systemFontOfSize:12];
    self.tipLabel.text = @"合计:";
    
    self.numLabel = [UILabel new];
    self.numLabel.textAlignment = NSTextAlignmentRight;
    self.numLabel.textColor = ZPMyOrderDetailFontColor;
    self.numLabel.font = [UIFont systemFontOfSize:12];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = RGB_242_242_242;
    
    self.confirmGetOrderBtn = [UIButton new];
    [self.confirmGetOrderBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.confirmGetOrderBtn setTitleColor:ZPMyOrderBorderColor forState:UIControlStateNormal];
    self.confirmGetOrderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.confirmGetOrderBtn.layer.borderWidth = 0.5;
    self.confirmGetOrderBtn.layer.masksToBounds = YES;
    self.confirmGetOrderBtn.layer.borderColor = ZPMyOrderBorderColor.CGColor;
    self.confirmGetOrderBtn.layer.cornerRadius = 5;
    [self.confirmGetOrderBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteOrderBtn = [UIButton new];
    [self.deleteOrderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.deleteOrderBtn setTitleColor:ZPMyOrderDetailFontColor forState:UIControlStateNormal];
    self.deleteOrderBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.deleteOrderBtn.layer.borderWidth = 0.5;
    self.deleteOrderBtn.layer.masksToBounds = YES;
    self.deleteOrderBtn.layer.borderColor = ZPMyOrderDetailFontColor.CGColor;
    self.deleteOrderBtn.layer.cornerRadius = 5;
    [self.deleteOrderBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView sd_addSubviews:@[self.orderNameLabel,self.orderStatusLabel,self.tableView,self.freightTipLabel,self.presentPriceLabel,self.tipLabel,self.numLabel,self.lineView,self.confirmGetOrderBtn,self.deleteOrderBtn]];
    
    
    
    self.orderStatusLabel.sd_layout
    .rightSpaceToView(contentView, 13)
    .heightIs(13)
    .topSpaceToView(contentView, 13);
    [self.orderStatusLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.orderNameLabel.sd_layout
    .leftSpaceToView(contentView, 15)
    .heightIs(13)
    .topSpaceToView(contentView, 13)
    .rightSpaceToView(self.orderStatusLabel, 10);
    
    self.tableView.sd_layout
    .topSpaceToView(self.orderStatusLabel, 15)
    .leftEqualToView(contentView)
    .rightEqualToView(contentView);
    
    self.freightTipLabel.sd_layout
    .rightSpaceToView(contentView, 15)
    .heightIs(12)
    .topSpaceToView(self.tableView, 15);
    [self.freightTipLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.presentPriceLabel.sd_layout
    .rightSpaceToView(self.freightTipLabel, 9)
    .heightIs(15)
    .bottomEqualToView(self.freightTipLabel);
    [self.presentPriceLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.tipLabel.sd_layout
    .rightSpaceToView(self.presentPriceLabel, 9)
    .heightIs(12)
    .bottomEqualToView(self.freightTipLabel);
    [self.tipLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    self.numLabel.sd_layout
    .rightSpaceToView(self.tipLabel, 20)
    .heightIs(12)
    .bottomEqualToView(self.tipLabel);
    [self.numLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    self.lineView.sd_layout
    .topSpaceToView(self.freightTipLabel, 14)
    .heightIs(1)
    .leftEqualToView(contentView)
    .rightEqualToView(contentView);
    
    self.confirmGetOrderBtn.sd_layout
    .rightSpaceToView(contentView, 15)
    .heightIs(26)
    .widthIs(68)
    .topSpaceToView(self.lineView, 7);
    
    self.deleteOrderBtn.sd_layout
    .rightSpaceToView(self.confirmGetOrderBtn, 8)
    .heightIs(26)
    .widthIs(68)
    .topSpaceToView(self.lineView, 7);
    
}

- (void)deleteAction:(UIButton *)btn {
    if (self.deleteActionBlock) {
        self.deleteActionBlock(btn);
    }
}

- (void)payAction:(UIButton *)btn {
    if (self.payActionBlock) {
        self.payActionBlock(btn);
    }
}

- (void)setModel:(ZPOrderModel *)model {
    _model = model;
    self.orderNameLabel.text = model.orderType.code == 1010?@"绿通服务": @"优选商城";
    self.orderStatusLabel.text = model.orderStatus.text;
    self.datas = model.orderItems.copy;
    self.tableView.sd_layout
    .heightIs(model.orderItems.count*100);
    [self.tableView reloadData];
    
    self.freightTipLabel.text = [NSString stringWithFormat:@"(含运费：¥%@)",model.logisticsFee];
    self.presentPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.orderAmountTotal];
    self.numLabel.text = [NSString stringWithFormat:@"共%@件商品",model.commodityCount];
    if ([model.orderStatus.name isEqualToString:@"NON_PAYMENT"]) {
        //待付款
        self.confirmGetOrderBtn.hidden = NO;
        self.deleteOrderBtn.hidden = NO;
        [self.confirmGetOrderBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [self setupAutoHeightWithBottomViewsArray:@[self.confirmGetOrderBtn] bottomMargin:7];
    } else if ([model.orderStatus.name isEqualToString:@"NON_SEND"]) {
        //待发货
        self.deleteOrderBtn.hidden = YES;
        self.confirmGetOrderBtn.hidden = YES;
        [self setupAutoHeightWithBottomViewsArray:@[self.lineView] bottomMargin:0];
    }else if ([model.orderStatus.name isEqualToString:@"NON_RECIEVE"]) {
        //待收货
        self.deleteOrderBtn.hidden = NO;
        self.confirmGetOrderBtn.hidden = NO;
        
        [self.deleteOrderBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [self.confirmGetOrderBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [self setupAutoHeightWithBottomViewsArray:@[self.confirmGetOrderBtn] bottomMargin:7];
    }else if ([model.orderStatus.name isEqualToString:@"CANCELED_CANC"]) {
        //已关闭
        self.deleteOrderBtn.hidden = YES;
        self.confirmGetOrderBtn.hidden = YES;
        
        [self setupAutoHeightWithBottomViewsArray:@[self.lineView] bottomMargin:0];
    }else if ([model.orderStatus.name isEqualToString:@"NON_EVALUATED"]) {
        //待评价
        self.deleteOrderBtn.hidden = NO;
        self.confirmGetOrderBtn.hidden = NO;
        
        [self.confirmGetOrderBtn setTitle:@"评价" forState:UIControlStateNormal];
        [self.deleteOrderBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self setupAutoHeightWithBottomViewsArray:@[self.confirmGetOrderBtn] bottomMargin:7];
    }else if ([model.orderStatus.name isEqualToString:@"OFF_THE_STOCKS"]) {
        //已完成
        self.deleteOrderBtn.hidden = YES;
        self.confirmGetOrderBtn.hidden = YES;
        
        [self setupAutoHeightWithBottomViewsArray:@[self.lineView] bottomMargin:0];
    }else {
        //已完成
        self.deleteOrderBtn.hidden = YES;
        self.confirmGetOrderBtn.hidden = YES;
        
        [self setupAutoHeightWithBottomViewsArray:@[self.lineView] bottomMargin:0];
    }

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
    
    return self.datas.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPMyOrderSubCell *cell = [ZPMyOrderSubCell cellWithTabelView:tableView];
    cell.model = self.datas[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectBlock) {
        self.didSelectBlock();
    }
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
