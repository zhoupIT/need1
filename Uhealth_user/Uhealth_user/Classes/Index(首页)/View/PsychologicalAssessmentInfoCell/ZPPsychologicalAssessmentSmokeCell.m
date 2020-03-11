//
//  ZPPsychologicalAssessmentSmokeCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/6/11.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPPsychologicalAssessmentSmokeCell.h"
#import "ZPPsySelectTypeCell.h"
#import "ZPDrinkModel.h"
@interface ZPPsychologicalAssessmentSmokeCell()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_titleLabel;
    UIButton *_arrowBtn;
    UITableView *_tableView;
    NSMutableArray *_data;
    ZPPsySelectTypeCell *_cell;
}

@end

@implementation ZPPsychologicalAssessmentSmokeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layoutMargins = UIEdgeInsetsZero;
    self.separatorInset = UIEdgeInsetsZero;
    UIView *contentView = self.contentView;
    _titleLabel = [UILabel new];
    _arrowBtn = [UIButton new];
    _data = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        ZPDrinkModel *model = [[ZPDrinkModel alloc] init];
        switch (i) {
            case 0:
            {
                model.name = @"是，现在还吸";
                model.isSel = NO;
            }
                break;
            case 1:
            {
                model.name = @"不，过去吸";
                model.isSel = NO;
            }
                break;
            case 2:
            {
                model.name = @"不吸烟";
                model.isSel = NO;
            }
                break;
            
            default:
                break;
        }
        [_data addObject:model];
    }
//    _data = @[@"是，现在还吸",@"不，过去吸",@"不吸烟"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [contentView sd_addSubviews:@[_titleLabel,_arrowBtn,_tableView]];
    _titleLabel.sd_layout
    .leftSpaceToView(contentView, 16)
    .heightIs(13)
    .topSpaceToView(contentView, 18);
    [_titleLabel setSingleLineAutoResizeWithMaxWidth:65];
    _titleLabel.textColor = ZPMyOrderDetailFontColor;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.text = @"";
    
    _tableView.sd_layout
    .leftSpaceToView(contentView, 16)
    .topSpaceToView(_titleLabel, 18)
    .rightSpaceToView(contentView, 16)
    .heightIs(3*70);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[ZPPsySelectTypeCell class] forCellReuseIdentifier:NSStringFromClass([ZPPsySelectTypeCell class])];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    _titleLabel.text = titleStr;
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
    
    return _data.count;
}

/**
 *  返回每行cell的内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPPsySelectTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPPsySelectTypeCell class])];
    cell.cellTitleStr = self.titleStr;
    ZPDrinkModel *model = _data[indexPath.row];
    cell.titleStr = model.name;
    cell.isSel = model.isSel;
    cell.updateSelBlock = ^(UIButton *btn) {
        for (ZPDrinkModel *model in _data) {
            model.isSel = NO;
        }
        model.isSel = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSmokeSel object:@{@"name":model.name}];
        [_tableView reloadData];
    };
    _cell = cell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

@end
