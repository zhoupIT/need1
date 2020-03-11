//
//  ZPCarbinServiceCell.m
//  ZPealth
//
//  Created by Biao Geng on 2018/9/13.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPCarbinServiceCell.h"
#import "ZPCabinDetailModel.h"
#import "ZPCarbinServiceSubCell.h"
@interface ZPCarbinServiceCell()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
}
@property (nonatomic,strong) NSArray *cabinServiceList;
@end
@implementation ZPCarbinServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *contentView = self.contentView;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell的尺寸(行距,列距)
    layout.minimumLineSpacing = ZPWidth(15);
    layout.minimumInteritemSpacing = ZPWidth(15);
    layout.sectionInset = UIEdgeInsetsMake(0, ZPWidth(15), 0, ZPWidth(15));
    // 设置cell的宽度
    //ZPWidth(165)
    layout.itemSize = CGSizeMake(ZPWidth(90), ZPWidth(120));
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 15);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [contentView addSubview:_collectionView];
    _collectionView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.alwaysBounceHorizontal = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[ZPCarbinServiceSubCell class] forCellWithReuseIdentifier:NSStringFromClass([ZPCarbinServiceSubCell class])];
}

- (void)setModel:(ZPCabinDetailModel *)model {
    _model = model;
    self.cabinServiceList = model.cabinServiceList;
    [_collectionView reloadData];
}

#pragma mark - collectionView数据源和代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cabinServiceList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZPCarbinServiceSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZPCarbinServiceSubCell class]) forIndexPath:indexPath];
    cell.model = self.cabinServiceList[indexPath.row];
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

- (NSArray *)cabinServiceList {
    if (!_cabinServiceList) {
        _cabinServiceList = [NSArray array];
    }
    return _cabinServiceList;
}

@end
