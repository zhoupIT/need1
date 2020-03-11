//
//  ZPArticleCommentListHeaderView.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPArticleCommentListHeaderView.h"
#import "ZPHealthWindModel.h"
#import "ZPHealthNewsModel.h"
@interface ZPArticleCommentListHeaderView()
{
    UILabel *_titleLabel;//标题
    UILabel *_authorLabel;//作者
    UILabel *_timeLabel;//时间
    UIButton *_pageviewsBtn;//浏览量
    UIView *_lineView;//线
    UILabel *_commentsNumLabel;//全部评论数量
    UIButton *_sortBtn;//排序
}
@end
@implementation ZPArticleCommentListHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAll];
    }
    return self;
}

- (void)initAll {
    _titleLabel = [UILabel new];
    _authorLabel = [UILabel new];
    _timeLabel = [UILabel new];
    _pageviewsBtn = [UIButton new];
    _lineView = [UIView new];
    _commentsNumLabel = [UILabel new];
    _sortBtn  =[UIButton new];
    [self sd_addSubviews:@[_titleLabel,_authorLabel,_timeLabel,_pageviewsBtn,_lineView,_commentsNumLabel,_sortBtn]];
    _titleLabel.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .autoHeightRatio(0);
    _titleLabel.textColor = RGB_74_74_74;
    _titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:15];
    
    
    _authorLabel.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(_titleLabel, 15)
    .autoHeightRatio(0);
    [_authorLabel setSingleLineAutoResizeWithMaxWidth:100];
    _authorLabel.textColor = RGB_170_170_170;
    _authorLabel.font = [UIFont fontWithName:ZPPFSCLight size:12];
    
    
    _timeLabel.sd_layout
    .centerYEqualToView(_authorLabel)
    .leftSpaceToView(_authorLabel, 15)
    .autoHeightRatio(0);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:150];
    _timeLabel.textColor = RGB_170_170_170;
    _timeLabel.font = [UIFont fontWithName:ZPPFSCLight size:12];
    
    _pageviewsBtn.sd_layout
    .rightSpaceToView(self, 15)
    .topSpaceToView(_titleLabel, 15)
    .heightIs(20);
    _pageviewsBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 2.5, 0, 0);
    _pageviewsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2.5);
    [_pageviewsBtn setImage:[UIImage imageNamed:@"healthNews_eye_icon"] forState:UIControlStateNormal];
    _pageviewsBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:12];
    [_pageviewsBtn setTitleColor:RGB_170_170_170 forState:UIControlStateNormal];
    
    _lineView.sd_layout
    .topSpaceToView(_pageviewsBtn, 15)
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .heightIs(1);
    _lineView.backgroundColor = RGB(204,204,204);
    
    _commentsNumLabel.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(_lineView, 15)
    .autoHeightRatio(0);
    [_commentsNumLabel setSingleLineAutoResizeWithMaxWidth:200];
    _commentsNumLabel.textColor = RGB_74_74_74;
    _commentsNumLabel.font = [UIFont fontWithName:ZPPFSCRegular size:12];
    _commentsNumLabel.text = @"全部评论(0)";
    
    _sortBtn.sd_layout
    .rightSpaceToView(self, 15)
    .widthIs(55)
    .heightIs(16)
    .topSpaceToView(_lineView, 15);
    _sortBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 2.5, 0, 0);
    _sortBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2.5);
    _sortBtn.titleLabel.font = [UIFont fontWithName:ZPPFSCRegular size:10];
    [_sortBtn setTitle:@"按热度" forState:UIControlStateNormal];
    [_sortBtn setTitleColor:RGB_78_178_255 forState:UIControlStateNormal];
    [_sortBtn setImage:[UIImage imageNamed:@"index_articleSort_icon"] forState:UIControlStateNormal];
    [_sortBtn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setupAutoHeightWithBottomView:_commentsNumLabel bottomMargin:10];
    
    
    WEAK_SELF(weakSelf);
    [self setDidFinishAutoLayoutBlock:^(CGRect rect) {
        if (weakSelf) {
            if (weakSelf.updateHeightBlock) weakSelf.updateHeightBlock(weakSelf);
        }
    }];
}

- (void)setModel:(ZPHealthWindModel *)model {
    _model = model;
    _titleLabel.text = model.title;
    _authorLabel.text = model.author;
    _timeLabel.text = model.createDate;
    CGSize size = MULTILINE_TEXTSIZE(model.pageviews,[UIFont fontWithName:ZPPFSCRegular size:12] , CGSizeMake(MAXFLOAT, 10));
    _pageviewsBtn.sd_layout.widthIs(size.width+20+5);
    [_pageviewsBtn setTitle:model.pageviews forState:UIControlStateNormal];
    _commentsNumLabel.text = [NSString stringWithFormat:@"全部评论(%@)",model.toatalCommentsCount];
}


- (void)setHealthNewsModel:(ZPHealthNewsModel *)healthNewsModel {
    _healthNewsModel = healthNewsModel;
    _titleLabel.text = healthNewsModel.title;
    _authorLabel.text = healthNewsModel.author;
    _timeLabel.text = healthNewsModel.createDate;
    CGSize size = MULTILINE_TEXTSIZE(healthNewsModel.pageviews,[UIFont fontWithName:ZPPFSCRegular size:12] , CGSizeMake(MAXFLOAT, 10));
    _pageviewsBtn.sd_layout.widthIs(size.width+20+5);
    [_pageviewsBtn setTitle:healthNewsModel.pageviews forState:UIControlStateNormal];
    _commentsNumLabel.text = [NSString stringWithFormat:@"全部评论(%@)",healthNewsModel.toatalCommentsCount];
}

- (void)popAction:(UIButton *)btn {
    if (self.popBlock) {
        self.popBlock(btn);
    }
}

@end
