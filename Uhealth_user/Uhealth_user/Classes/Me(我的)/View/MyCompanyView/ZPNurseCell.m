//
//  ZPNurseCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPNurseCell.h"
#import "ZPCabinDetailModel.h"
#import "ZPNurseSubCell.h"
@interface ZPNurseCell()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIImageView *_backgroundIcon;
    UIImageView *_companyIcon;
    UICollectionView *_collectionView;
}
@property (nonatomic,strong) NSArray *nurseList;
@end
@implementation ZPNurseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UIView *contentView = self.contentView;
    
    _backgroundIcon = [UIImageView new];
    _companyIcon = [UIImageView new];
    [contentView sd_addSubviews:@[_backgroundIcon]];
    _backgroundIcon.sd_layout
    .topSpaceToView(contentView, 0)
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .heightIs(ZPHeight(150));
    _backgroundIcon.image = [UIImage imageNamed:@"me_cabinback_icon"];
    
    [_backgroundIcon addSubview:_companyIcon];
    _companyIcon.sd_layout
    .rightSpaceToView(_backgroundIcon, ZPWidth(22))
    .topSpaceToView(_backgroundIcon, ZPHeight(22))
    .heightIs(ZPHeight(50))
    .widthIs(ZPWidth(90));
    _companyIcon.contentMode = UIViewContentModeScaleAspectFill;
    _companyIcon.clipsToBounds = YES;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell的尺寸(行距,列距)
    layout.minimumLineSpacing = ZPWidth(15);
    layout.minimumInteritemSpacing = ZPWidth(15);
    layout.sectionInset = UIEdgeInsetsMake(0, ZPWidth(15), 4, ZPWidth(15));
    // 设置cell的宽度
    //ZPWidth(165)
    layout.itemSize = CGSizeMake(kSCREEN_WIDTH-ZPWidth(15)*2, ZPHeight(154));
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 15);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [contentView addSubview:_collectionView];
    
    _collectionView.sd_layout
    .topSpaceToView(_backgroundIcon, -ZPHeight(64))
    .leftSpaceToView(contentView, 0)
    .rightSpaceToView(contentView, 0)
    .bottomSpaceToView(contentView, 0);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[ZPNurseSubCell class] forCellWithReuseIdentifier:NSStringFromClass([ZPNurseSubCell class])];
}

- (void)setModel:(ZPCabinDetailModel *)model {
    _model = model;
    [_companyIcon sd_setImageWithURL:[NSURL URLWithString:model.healthCabinLogo]];
    self.nurseList = model.nurseList;
    [_collectionView reloadData];
}

#pragma mark - collectionView数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nurseList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZPNurseSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZPNurseSubCell class]) forIndexPath:indexPath];
    cell.model = self.nurseList[indexPath.row];
    cell.contactNurseBlock = ^(ZPNurseModel *model) {
        if (self.contactNurseBlock) {
            self.contactNurseBlock(model);
        }
    };
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //    ZPAdvisoryChannelModel *model = self.channelDatas[indexPath.row];
    //    if ([model.channelStatus.name isEqualToString:@"NORMAL"]) {
    //        ZPAuthorityCenterController *authorityCenterControl = [[ZPAuthorityCenterController alloc] init];
    //        authorityCenterControl.channelModel = model;
    //        [self.navigationController pushViewController:authorityCenterControl animated:YES];
    //    } else {
    //        [LEEAlert alert].config
    //        .LeeTitle(@"提醒")
    //        .LeeContent(model.channelStatus.text)
    //        .LeeAction(@"确认", ^{
    //        })
    //        .LeeClickBackgroundClose(YES)
    //        .LeeShow();
    //    }
}

- (NSArray *)nurseList {
    if (!_nurseList) {
        _nurseList = [NSArray array];
    }
    return _nurseList;
}

@end
