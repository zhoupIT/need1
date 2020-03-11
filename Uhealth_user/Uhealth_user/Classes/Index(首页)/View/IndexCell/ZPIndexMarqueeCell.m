//
//  ZPIndexMarqueeCell.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/6.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPIndexMarqueeCell.h"
#import "SDCycleScrollView.h"
#import "ZPIndexMarqueeCustomCell.h"

#import "ZPHealthDynamicModel.h"
@interface ZPIndexMarqueeCell()<SDCycleScrollViewDelegate>
{
    UIImageView *_imgView;
    UIView *_sepLine;
    SDCycleScrollView *_verticalMarquee;//纵向跑马灯
}
@property (nonatomic,strong) NSMutableArray *contentData;
@end
@implementation ZPIndexMarqueeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *contentView = self.contentView;
    _imgView = [UIImageView new];
    _sepLine = [UIView new];
    [contentView sd_addSubviews:@[_imgView,_sepLine]];
    _imgView.sd_layout
    .heightIs(ZPHeight(22.5))
    .leftSpaceToView(contentView, 15)
    .centerYEqualToView(contentView)
    .widthIs(ZPWidth(62.5));
    _imgView.image = [UIImage imageNamed:@"index_dyNews_icon"];
    
    _sepLine.sd_layout
    .leftSpaceToView(_imgView, 10)
    .heightIs(ZPHeight(14))
    .widthIs(1)
    .centerYEqualToView(contentView);
    _sepLine.backgroundColor = RGB_242_242_242;
    
    
    _verticalMarquee = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
    [contentView addSubview:_verticalMarquee];
    _verticalMarquee.sd_layout
    .topSpaceToView(contentView, 0)
    .bottomSpaceToView(contentView, 0)
    .leftSpaceToView(_sepLine, 5)
    .rightSpaceToView(contentView, 0);
    _verticalMarquee.currentPageDotImage = [UIImage imageNamed:@""];
    _verticalMarquee.pageDotImage = [UIImage imageNamed:@""];
    _verticalMarquee.placeholderImage = [UIImage imageWithColor:[UIColor whiteColor]];
    _verticalMarquee.imageURLStringsGroup = @[];
    _verticalMarquee.scrollDirection = UICollectionViewScrollDirectionVertical;
    _verticalMarquee.showPageControl = NO;
    _verticalMarquee.autoScrollTimeInterval = 4;
    _verticalMarquee.backgroundColor = [UIColor whiteColor];
}

- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view
{
    if (view != _verticalMarquee) {
        return nil;
    }
    return [ZPIndexMarqueeCustomCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view
{
    ZPIndexMarqueeCustomCell *myCell = (ZPIndexMarqueeCustomCell *)cell;
    myCell.model = self.data[index];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.didClickBlock) {
        self.didClickBlock(index);
    }
}

- (void)setData:(NSArray *)data {
    _data = data;
    if (data.count) {
        [self.contentData removeAllObjects];
        
        for (ZPHealthDynamicModel *model in data) {
            [self.contentData addObject:model.title];
        }
        
        _verticalMarquee.imageURLStringsGroup = self.contentData;
    }
}

- (NSMutableArray *)contentData {
    if (!_contentData) {
        _contentData = [NSMutableArray array];
    }
    return _contentData;
}

@end
