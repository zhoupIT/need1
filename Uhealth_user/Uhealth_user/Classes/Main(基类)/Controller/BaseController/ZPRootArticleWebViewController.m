//
//  ZPRootArticleWebViewController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPRootArticleWebViewController.h"

#import "ZPUMShare.h"
/* 模型 */
#import "ZPHealthNewsModel.h"
#import "ZPHealthWindModel.h"
/* 第三方 */
#import "CLBottomCommentView.h"
#import "WZLBadgeImport.h"
/* 控制器 */
#import "ZPArticleCommentListController.h"
static CGFloat const kBottomViewHeight = 46.0;
@interface ZPRootArticleWebViewController ()<CLBottomCommentViewDelegate>
@property (nonatomic, strong) CLBottomCommentView *bottomView;
@end

@implementation ZPRootArticleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAllWk];
}

/* 调整界面并请求数据 */
- (void)initAllWk {
    //调整webview的位置
    //46  +44=90
    self.webViewContentInsets = UIEdgeInsetsMake(0, 0,IS_IPhoneX?(kBottomViewHeight+44):kBottomViewHeight , 0);
    [self.view addSubview:self.bottomView];
    self.bottomView.sd_layout
    .heightIs(IS_IPhoneX?(kBottomViewHeight+44):kBottomViewHeight)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    if (self.enterStatusType == ZPArticleEnterStatusTypeBanner) {
        //从banner跳转过来 需要请求评论数量和模型
        [self getDataFromID:self.bannerAim];
    } else {
        NSInteger num = self.articelType == ZPArticleTypeNews? [self.healthNewsModel.commentCount integerValue]: [self.healthWindModel.commentCount integerValue];
        [self.bottomView.commentButton showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //获取评论数目
    [self getCommentNum];
}

/* 获取评论数量 */
- (void)getCommentNum {
    NSString *articleCommentOrderBy = @"COMMENT_TIME_DESC";
    NSString *articleType = self.articelType == ZPArticleTypeNews?@"HEALTH_INFORMATION":@"HEALTH_DIRECTION";
    NSString *articleId = self.articelType == ZPArticleTypeNews?self.healthNewsModel.informationId:self.healthWindModel.directionId;
    WEAK_SELF(weakSelf);
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"article/comment" parameters:@{@"articleId":articleId,@"articleType":articleType,@"articleCommentOrderBy":articleCommentOrderBy} progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            if (self.articelType == ZPArticleTypeNews) {
                weakSelf.healthNewsModel.commentCount = [[response objectForKey:@"pageInfo"] objectForKey:@"totalCount"];
                NSInteger num = [weakSelf.healthNewsModel.commentCount integerValue];
                [weakSelf.bottomView.commentButton showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
            } else {
                weakSelf.healthWindModel.commentCount = [[response objectForKey:@"pageInfo"] objectForKey:@"totalCount"];
                NSInteger num = [weakSelf.healthWindModel.commentCount integerValue];
                [weakSelf.bottomView.commentButton showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
            }
           
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        // 结束刷新
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPRootArticleWebViewController class]];
}


/* 通过banner传递来的iD来获取数据 */
- (void)getDataFromID:(NSString *)ID {
    WEAK_SELF(weakSelf);
    NSString *url = self.articelType == ZPArticleTypeNews? @"/api/article/health/information/":@"/api/article/health/direction/";
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@%@",url,ID] parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            if (self.articelType == ZPArticleTypeNews) {
                 weakSelf.healthNewsModel = [ZPHealthNewsModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            } else {
                 weakSelf.healthWindModel = [ZPHealthWindModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
            }
           
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPRootArticleWebViewController class]];
}

#pragma mark - 分享
- (void)bottomViewDidShare {
    ZPLog(@"分享");
    NSString *articleID = @"";
    if (self.enterStatusType == ZPArticleEnterStatusTypeBanner) {
        articleID = self.bannerAim;
    } else {
        articleID = self.articelType == ZPArticleTypeNews?self.healthNewsModel.informationId:self.healthWindModel.directionId;
    }
    if (self.articelType == ZPArticleTypeNews) {
        [ZPUMShare shareWithTitle:self.healthNewsModel.title withDescr:self.healthNewsModel.introduction withThumImage:self.healthNewsModel.titleImgList.firstObject withMainUrl:newsArticleUrl(articleID) withController:self];
    } else {
        [ZPUMShare shareWithTitle:self.healthWindModel.title withDescr:self.healthWindModel.introduction withThumImage:self.healthWindModel.titleImgList.firstObject withMainUrl:windArticleUrl(articleID) withController:self];
    }
}

- (void)bottomViewDidComment:(UIButton *)markButton {
    ZPLog(@"评论");
    ZPArticleCommentListController *commentListControl = [[ZPArticleCommentListController alloc] init];
    commentListControl.articleType = self.articelType;
    if (self.enterStatusType == ZPArticleEnterStatusTypeBanner) {
        commentListControl.bannerAim = self.bannerAim;
        commentListControl.enterStatusType = ZPArticleEnterStatusTypeBanner;
        if (self.articelType == ZPArticleTypeNews) {
            commentListControl.healthNewsModel = self.healthNewsModel;
        } else {
            commentListControl.healthWindModel = self.healthWindModel;
        }
    } else {
        if (self.articelType == ZPArticleTypeNews) {
            commentListControl.healthNewsModel = self.healthNewsModel;
        } else {
            commentListControl.healthWindModel = self.healthWindModel;
        }
    }
    [self.navigationController pushViewController:commentListControl animated:YES];
}

- (void)cl_textViewDidChange:(CLTextView *)textView {
    if (textView.commentTextView.text.length > 0) {
    }
}

- (void)cl_textViewDidEndEditing:(CLTextView *)textView {
    if (textView.commentTextView.text.length) {
        [MBProgressHUD showMessage:@"发送中"];
        WEAK_SELF(weakSelf);
        NSString *articleId = self.enterStatusType == ZPArticleEnterStatusTypeBanner?self.bannerAim:(self.articelType == ZPArticleTypeNews?self.healthNewsModel.informationId:self.healthWindModel.directionId);
        [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/article/comment" andHTTPMethod:@"PUT" andDict:@{@"articleId":articleId,@"articleType":self.articelType == ZPArticleTypeNews?@"HEALTH_INFORMATION":@"HEALTH_DIRECTION",@"commentContent":textView.commentTextView.text} success:^(NSDictionary *response) {
            [weakSelf.bottomView clearComment];
            [MBProgressHUD showSuccess:@"评论成功!"];
            if (self.articelType == ZPArticleTypeNews) {
                NSInteger num = [weakSelf.healthNewsModel.commentCount integerValue] + 1;
                weakSelf.healthNewsModel.commentCount = [NSString stringWithFormat:@"%ld",num];
                [weakSelf.bottomView.commentButton showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
            } else {
                NSInteger num = [weakSelf.healthWindModel.commentCount integerValue] + 1;
                weakSelf.healthWindModel.commentCount = [NSString stringWithFormat:@"%ld",num];
                [weakSelf.bottomView.commentButton showBadgeWithStyle:WBadgeStyleNumber value:num animationType:WBadgeAnimTypeNone];
            }
            
        } failed:^(NSError *error) {
            
        } withClassName:NSStringFromClass([ZPRootArticleWebViewController class])];
    }
}

#pragma mark - Private Method
- (void)changeMarkButtonState:(UIButton *)sender {
    sender.selected = !sender.selected;
}

#pragma mark - 懒加载
- (CLBottomCommentView *)bottomView {
    if (!_bottomView) {
        _bottomView = [CLBottomCommentView new];
        _bottomView.delegate = self;
        _bottomView.clTextView.delegate = self;
    }
    return _bottomView;
}
@end
