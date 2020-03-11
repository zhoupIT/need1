//
//  ZPArticleCommentListController.m
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/7.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPArticleCommentListController.h"

/* view */
#import "ZPArticleCommentListCell.h"
#import "ZPArticleCommentListHeaderView.h"
/* 模型 */
#import "ZPArticleCommentModel.h"
#import "ZPHealthNewsModel.h"
#import "ZPHealthWindModel.h"
/* 第三方 */
#import "CLBottomCommentView.h"
#import "PopoverView.h"
static CGFloat const kBottomViewHeight = 46.0;
@interface ZPArticleCommentListController ()<UITableViewDelegate,UITableViewDataSource,CLBottomCommentViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) ZPArticleCommentListHeaderView *headerView;
@property (nonatomic,assign) CGRect rect;
@property (nonatomic, strong) CLBottomCommentView *bottomView;
//排序
@property (nonatomic,assign) ZPArticleCommentsOrderByType orderByType;

@end

@implementation ZPArticleCommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initAll {
    self.title = @"评论";
    [self.view sd_addSubviews:@[self.tableView,self.bottomView]];
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 50, 0));
    [self.bottomView hiddenCommentAndShareView];
    self.headerView = [[ZPArticleCommentListHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    if (self.articleType == ZPArticleTypeWind) {
        self.headerView.model = self.healthWindModel;
    } else {
        self.headerView.healthNewsModel = self.healthNewsModel;
    }
    [self.tableView setTableHeaderView:  self.headerView];
}

- (void)initData {
    WEAK_SELF(weakSelf);
    //默认排序  热度排序
    self.orderByType = ZPArticleOrderByTypeLike;
    self.headerView.updateHeightBlock = ^(ZPArticleCommentListHeaderView *view) {
        if (!weakSelf) return ;
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView setTableHeaderView: view];
        [weakSelf.tableView endUpdates];
    };
    
    self.headerView.popBlock = ^(UIButton *btn) {
        PopoverView *popoverView = [PopoverView popoverView];
        if (weakSelf.orderByType == ZPArticleOrderByTypeTime) {
            popoverView.selStr  = @"按时间";
        } else {
            popoverView.selStr  = @"按热度";
        }
        popoverView.showShade = YES; // 显示阴影背景
        popoverView.arrowStyle = PopoverViewArrowStyleTriangle;
        PopoverAction *action1 = [PopoverAction actionWithTitle:@"按热度" handler:^(PopoverAction *action) {
            if (weakSelf.orderByType != ZPArticleOrderByTypeLike) {
                weakSelf.orderByType = ZPArticleOrderByTypeLike;
                [btn setTitle:@"按热度" forState:UIControlStateNormal];
                [weakSelf.tableView.mj_header beginRefreshing];
            }
            
        }];
        PopoverAction *action2 = [PopoverAction actionWithTitle:@"按时间" handler:^(PopoverAction *action) {
            if (weakSelf.orderByType != ZPArticleOrderByTypeTime) {
                weakSelf.orderByType = ZPArticleOrderByTypeTime;
                [btn setTitle:@"按时间" forState:UIControlStateNormal];
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        }];
        [popoverView showToView:btn withActions:@[action1,action2]];
        
    };
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
    [self setupRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setupRefresh {
    __weak typeof(self) weakSelf = self;
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSString *articleCommentOrderBy = @"COMMENT_TIME_DESC";
        if (weakSelf.orderByType == ZPArticleOrderByTypeTime) {
            articleCommentOrderBy = @"COMMENT_TIME_DESC";
        } else {
            articleCommentOrderBy = @"LIKE_COUNT_DESC";
        }
        
        NSString *articleType = @"HEALTH_DIRECTION";
        NSString *articleId;
        if (weakSelf.articleType == ZPArticleTypeWind) {
            articleType = @"HEALTH_DIRECTION";
            articleId = self.healthWindModel.directionId;
        } else {
            articleType = @"HEALTH_INFORMATION";
            articleId = self.healthNewsModel.informationId;
        }
        
        
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"article/comment" parameters:@{@"articleId":articleId,@"articleType":articleType,@"articleCommentOrderBy":articleCommentOrderBy} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            [tableView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                if (weakSelf.articleType == ZPArticleTypeWind) {
                    weakSelf.healthWindModel.toatalCommentsCount = [[response objectForKey:@"pageInfo"] objectForKey:@"totalCount"];
                    weakSelf.headerView.model = weakSelf.healthWindModel;
                } else {
                    weakSelf.healthNewsModel.toatalCommentsCount = [[response objectForKey:@"pageInfo"] objectForKey:@"totalCount"];
                    weakSelf.headerView.healthNewsModel = weakSelf.healthNewsModel;
                }
                self.datas = [ZPArticleCommentModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                [tableView reloadData];
                [tableView.mj_footer resetNoMoreData];
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_header endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPArticleCommentListController class]];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSString *articleCommentOrderBy = @"COMMENT_TIME_DESC";
        if (weakSelf.orderByType == ZPArticleOrderByTypeTime) {
            articleCommentOrderBy = @"COMMENT_TIME_DESC";
        } else {
            articleCommentOrderBy = @"LIKE_COUNT_DESC";
        }
        NSString *articleType = @"HEALTH_DIRECTION";
        NSString *articleId;
        if (weakSelf.articleType == ZPArticleTypeWind) {
            articleType = @"HEALTH_DIRECTION";
            articleId = self.healthWindModel.directionId;
        } else {
            articleType = @"HEALTH_INFORMATION";
            articleId = self.healthNewsModel.informationId;
        }
        [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWith:@"article/comment" parameters:@{@"offset":[NSNumber numberWithInteger:self.datas.count],@"articleId":articleId,@"articleType":articleType,@"articleCommentOrderBy":articleCommentOrderBy} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                NSArray *arrays = [ZPArticleCommentModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"data"]];
                if (!arrays.count) {
                    [tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [weakSelf.datas addObjectsFromArray:arrays];
                    [tableView reloadData];
                    
                }
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
            
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            // 结束刷新
            [tableView.mj_footer endRefreshing];
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPArticleCommentListController class]];
    }];
    
}

/* 结束上次的刷新 */
- (void)endLastRefresh {
    [self.tableView.mj_header endRefreshing];
}

/* 刷新界面 */
- (void)refreshPage {
    [self.tableView.mj_header beginRefreshing];
}

//通过banner传递来的iD来获取数据
- (void)getDataFromID:(NSString *)ID {
    WEAK_SELF(weakSelf);
    NSString *url = self.articleType == ZPArticleTypeNews?@"/api/article/health/information/":@"/api/article/health/direction/";
    [[ZPNetWorkTool sharedZPNetWorkTool] GETRequestWithUrlString:[NSString stringWithFormat:@"%@%@",url,self.bannerAim] parameters:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id response) {
        if ([[response objectForKey:@"code"] integerValue]  == 200) {
            if (self.articleType == ZPArticleTypeNews) {
                weakSelf.healthNewsModel = [ZPHealthNewsModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                weakSelf.headerView.healthNewsModel = weakSelf.healthNewsModel;
            } else {
                weakSelf.healthWindModel = [ZPHealthWindModel mj_objectWithKeyValues:[response objectForKey:@"data"]];
                weakSelf.headerView.model = weakSelf.healthWindModel;
            }
            
        } else {
            [MBProgressHUD showError:[response objectForKey:@"message"]];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
    } className:[ZPArticleCommentListController class]];
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
    ZPArticleCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZPArticleCommentListCell class])];
    ZPArticleCommentModel *model = self.datas[indexPath.row];
    cell.model = model;
    cell.likeBlock = ^(UIButton *btn){
        
        [[ZPNetWorkTool sharedZPNetWorkTool] POSTRequestWith:@"comment/like" parameters:@{@"commentId":model.commentId} progress:^(NSProgress *progress) {
            
        } success:^(NSURLSessionDataTask *task, id response) {
            if ([[response objectForKey:@"code"] integerValue]  == 200) {
                if ([model.articleCommentLikeState.name isEqualToString:@"LIKE"]) {
                    model.articleCommentLikeState.name = @"DISLIKE";
                } else {
                    model.articleCommentLikeState.name = @"LIKE";
                }
                model.likeCounts = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            } else {
                [MBProgressHUD showError:[response objectForKey:@"message"]];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD showError:error.localizedDescription];
        } className:[ZPArticleCommentListController class]];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPArticleCommentModel *model = self.datas[indexPath.row];
    return [tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[ZPArticleCommentListCell class] contentViewWidth:kSCREEN_WIDTH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - CLBottomCommentViewDelegate
- (void)cl_textViewDidChange:(CLTextView *)textView {
    if (textView.commentTextView.text.length > 0) {
        //        NSString *originalString = [NSString stringWithFormat:@"[草稿]%@",textView.commentTextView.text];
        //        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:originalString];
        //        [attriString addAttributes:@{NSForegroundColorAttributeName: kColorNavigationBar} range:NSMakeRange(0, 4)];
        //        [attriString addAttributes:@{NSForegroundColorAttributeName: kColorTextMain} range:NSMakeRange(4, attriString.length - 4)];
        //
        //        self.bottomView.editTextField.attributedText = attriString;
    }
}

- (void)cl_textViewDidEndEditing:(CLTextView *)textView {
    if (textView.commentTextView.text.length) {
        [MBProgressHUD showMessage:@"发送中"];
        WEAK_SELF(weakSelf);
        NSString *articleId;
        NSString *articleType;
        if (self.articleType == ZPArticleTypeWind) {
            articleId = self.healthWindModel.directionId;
            articleType = @"HEALTH_DIRECTION";
        } else {
            articleId = self.healthNewsModel.informationId;
            articleType = @"HEALTH_INFORMATION";
        }
        [[ZPNetWork sharedZPNetWork] requestWithUrl:@"/api/article/comment" andHTTPMethod:@"PUT" andDict:@{@"articleId":articleId,@"articleType":articleType,@"commentContent":textView.commentTextView.text} success:^(NSDictionary *response) {
            ZPUserModel *usermodel = [NSKeyedUnarchiver unarchiveObjectWithFile:ZPUserInfoPATH];
            ZPArticleCommentModel *model = [[ZPArticleCommentModel alloc] init];
            model.commentId = [[response objectForKey:@"data"] objectForKey:@"commentId"];
            model.commentContent = textView.commentTextView.text;
            model.commentTime = [[response objectForKey:@"data"] objectForKey:@"commentTime"];
            model.likeCounts = @"0";
            model.isNewComment = YES;
            model.customerPortrait = usermodel.portrait;
            model.customerName = usermodel.nickName;
            
            if (weakSelf.articleType == ZPArticleTypeWind) {
                NSInteger num = [weakSelf.healthWindModel.toatalCommentsCount integerValue];
                num++;
                weakSelf.healthWindModel.toatalCommentsCount = [NSString stringWithFormat:@"%ld",num];
                weakSelf.headerView.model = weakSelf.healthWindModel;
            } else {
                NSInteger num = [weakSelf.healthNewsModel.toatalCommentsCount integerValue];
                num++;
                weakSelf.healthNewsModel.toatalCommentsCount = [NSString stringWithFormat:@"%ld",num];
                weakSelf.headerView.healthNewsModel = weakSelf.healthNewsModel;
            }
            
            [weakSelf.datas insertObject:model atIndex:0];
            [weakSelf.tableView reloadData];
            [weakSelf.bottomView clearComment];
            [MBProgressHUD showSuccess:@"评论成功!"];
            //            weakSelf.orderByType = ZPOrderByTypeTime;
            //            [weakSelf.tableView.mj_header beginRefreshing];
        } failed:^(NSError *error) {
            
        } withClassName:NSStringFromClass([ZPArticleCommentListController class])];
    }
    
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[ZPArticleCommentListCell class] forCellReuseIdentifier:NSStringFromClass([ZPArticleCommentListCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (CLBottomCommentView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[CLBottomCommentView alloc] initWithFrame:CGRectMake(0, cl_ScreenHeight - kBottomViewHeight-kSafeAreaTopHeight, cl_ScreenWidth, kBottomViewHeight)];
        _bottomView.delegate = self;
        _bottomView.clTextView.delegate = self;
        
    }
    return _bottomView;
}

@end
