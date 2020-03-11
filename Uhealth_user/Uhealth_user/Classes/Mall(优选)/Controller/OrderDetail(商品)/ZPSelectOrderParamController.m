//
//  ZPSelectOrderParamController.m
//  ZPealth
//
//  Created by Biao Geng on 2018/10/23.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#import "ZPSelectOrderParamController.h"
/* model */
#import "ZPSpecificationsModel.h"
#import "XYAnimator.h"
#import "ZPCommodity.h"
#import "ZPFeatureContentModel.h"
#import "ZPCommodityItemModel.h"
/* view */
#import "DCCollectionHeaderLayout.h"
#import "ZPFeatureItemCell.h"
#import "ZPFeatureHeaderView.h"
#import "ZPFeatureItemNumCell.h"
/* controller */
#import "ZPCheckOutBillController.h"
#import "ZPMyShoppingCartController.h"
@interface ZPSelectOrderParamController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HorizontalCollectionLayoutDelegate>
@property (nonatomic,strong) UITableView *tableView;
/* 商品详情图 */
@property (nonatomic,strong) UIImageView *iconView;
/* 商品价格 */
@property (nonatomic,strong) UILabel *priceLabel;
/* 商品属性 */
@property (nonatomic,strong) UILabel *featureLabel;
/* 属性主界面 */
@property (nonatomic,strong) UICollectionView *collectionView;
/* 底部功能栏 */
@property (nonatomic,strong) UIView *bottomView;

/* 过滤后的商品小项数组 */
@property (nonatomic,strong) NSMutableArray *commodityArray;


/* 每个规格的商品小项的价格和库存 */
@property (nonatomic,strong) NSMutableArray *commodityItemList;
/* 后台给的规格的数组 */
@property (nonatomic,strong) NSMutableArray *attributes;
@end

@implementation ZPSelectOrderParamController {
    XYAnimator * _myAnimator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

- (void)initAll {
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.featurestr = @"已选:";
    
    [self.view sd_addSubviews:@[self.iconView,self.priceLabel,self.featureLabel]];
    self.iconView.sd_layout
    .topSpaceToView(self.view, ZPHeight(15))
    .leftSpaceToView(self.view, ZPWidth(15))
    .heightIs(ZPWidth(90))
    .widthIs(ZPWidth(90));
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.commodity.coverImage] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
    
    self.priceLabel.sd_layout
    .leftSpaceToView(self.iconView, ZPWidth(15))
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, ZPHeight(25))
    .autoHeightRatio(0);
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.commodity.presentPrice];
    
    self.featureLabel.sd_layout
    .topSpaceToView(self.priceLabel, ZPHeight(10))
    .leftEqualToView(self.priceLabel)
    .rightSpaceToView(self.view, 0)
    .bottomEqualToView(self.iconView);
    
    [self.view addSubview:self.bottomView];
    self.bottomView.sd_layout
    .heightIs(IS_IPhoneX?84:50)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout
    .topSpaceToView(self.iconView, ZPHeight(15))
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.bottomView, 0);
    
    [self.collectionView reloadData];
    
    //将商品信息中关于attribute和option的信息存储到attributes中
    //将商品小项的信息存储到commodityItemList中
    self.attributes = [NSMutableArray arrayWithArray:self.commodity.specifications.specifications];
    self.commodityItemList = [NSMutableArray arrayWithArray:self.commodity.specifications.commodityItem];
    
    /* 如果已经选择了属性 则显示最新的价格 */
    if (self.selCommodityItemModel) {
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.selCommodityItemModel.presentPrice];
        for (NSString *key in self.selCommodityItemModel.attached.allKeys) {
            ZPLog(@"key: %@ value: %@", key, self.selCommodityItemModel.attached[key]);
            
            if (![self.featurestr isEqualToString:@"已选:"]) {
                self.featurestr = [self.featurestr stringByAppendingString:@";"];
            }
            self.featurestr = [self.featurestr stringByAppendingString:self.selCommodityItemModel.attached[key]];
        }
        self.featureLabel.text = self.featurestr;
        if (!self.selCommodityItemModel.img || !self.selCommodityItemModel.img.length) {
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.commodity.coverImage] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
        } else {
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.selCommodityItemModel.img] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
        }
    } else {
        
        for (NSString *key in self.choosedOptionMap.allKeys) {
            if (![self.featurestr isEqualToString:@"已选:"]) {
                self.featurestr = [self.featurestr stringByAppendingString:@";"];
            }
            self.featurestr = [self.featurestr stringByAppendingString:self.choosedOptionMap[key]];
        }
        //设置已选的属性
        self.featureLabel.text = self.featurestr;
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.featureAttr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    ZPSpecificationsModel *model = self.featureAttr[section];
    return model.attrvalue.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPFeatureItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ZPFeatureItemCell class]) forIndexPath:indexPath];
    ZPSpecificationsModel *model = self.featureAttr[indexPath.section];
    cell.contentModel = model.attrvalue[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //当前行 的属性名 和  属性名的多种规格的组合
    ZPSpecificationsModel *selSpecificationsModel = self.featureAttr[indexPath.section];
    //当前行的 属性名(包含规格的选择状态 可点击的状态 规格的名字)
    ZPFeatureContentModel *selFeatureContentModel = selSpecificationsModel.attrvalue[indexPath.row];
    ZPLog(@"选择的属性名:%@,规格名:%@",selSpecificationsModel.attrname,selFeatureContentModel.infoName);
    //先判断按钮是否可以点击
    if (!selFeatureContentModel.isDisableSelect) {
        self.selCommodityItemModel = nil;
        [self clickWithAttribute:selSpecificationsModel.attrname andWithOption:selFeatureContentModel.infoName andWithFeatureContentModel:selFeatureContentModel];
        self.featureAttr = [NSArray arrayWithArray:self.attributes];
        [collectionView reloadData];
        
        self.featurestr = @"已选:";
        
        int i = 0;
        for (NSString *key in self.choosedOptionMap.allKeys) {
            if (![self.featurestr isEqualToString:@"已选:"]) {
                self.featurestr = [self.featurestr stringByAppendingString:@";"];
            }
            self.featurestr = [self.featurestr stringByAppendingString:self.choosedOptionMap[key]];
            i++;
        }
        
        
        //设置已选的属性
        self.featureLabel.text = self.featurestr;
        
        if (i == self.featureAttr.count) {
            //当选择全了规格后  找出对应的规格的模型
            for (ZPCommodityItemModel *commodityItemModel in self.commodityItemList) {
                //获取出对应的规格
                NSDictionary *attached = commodityItemModel.attached;
                //规格的每一项的对比
                int x = 0;
                for (NSString *key in attached) {
                    //                    ZPLog(@"test key: %@ value: %@", key, attached[key]);
                    NSString *value = self.choosedOptionMap[key];
                    if ([value isEqualToString:attached[key]]) {
                        x++;
                    }
                }
                if (x == i) {
                    self.selCommodityItemModel = commodityItemModel;
                }
            }

        }
        
        //设置价格
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",self.selCommodityItemModel?self.selCommodityItemModel.presentPrice:self.commodity.presentPrice];
        //如果选择完所有的属性 回调显示出所有的属性
        if (self.selCommodityItemModel && self.selectAttachBlock) {
            if (!self.selCommodityItemModel.img || !self.selCommodityItemModel.img.length) {
                [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.commodity.coverImage] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
            } else {
                //设置显示图片
                [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.selCommodityItemModel.img] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
            }
        } else {
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.commodity.coverImage] placeholderImage:[UIImage imageNamed:@"common_placeholder_icon"]];
        }
        self.selectAttachBlock(self.selCommodityItemModel,self.featurestr,self.choosedOptionMap);
    }
}

/**
 *
 * @param attribute
 *            属性，比如颜色，比如容量等
 *
 * @param option
 *            属性对应的选项，比如黑、白或者比如100ml、1000ml等
 */
- (void)clickWithAttribute:(NSString *)attribute andWithOption:(NSString *)option andWithFeatureContentModel:(ZPFeatureContentModel *)selFeatureContentModel{
    // 判断点击对应的attribute是否已经被勾选，如果已经被勾选且被勾选的option和此次传入的option一致，则认为是取消勾选，否则则认为是勾选
    if (![self.choosedOptionMap objectForKey:attribute] || ![[self.choosedOptionMap objectForKey:attribute] isEqualToString:option] ) {
        [self.choosedOptionMap setValue:option forKey:attribute];
        //查找同层级是否有高亮的  如果有先置灰
        for (ZPSpecificationsModel *model in self.attributes) {
            if ([model.attrname isEqualToString:attribute]) {
                for (ZPFeatureContentModel *contentModel in model.attrvalue) {
                    contentModel.isSelect = NO;
                }
            }
        }
        selFeatureContentModel.isSelect = YES;
    } else {
        [self.choosedOptionMap removeObjectForKey:attribute];
        selFeatureContentModel.isSelect = NO;
    }
    
    // 点击完毕后应该重新刷新所有选项
    [self refreshOptions];
}

// 刷新选项
- (void)refreshOptions {
    // 遍历每一个属性
    for (ZPSpecificationsModel *specificationsModel in self.attributes) {
        // 遍历每一个属性的每一个选项
        for (ZPFeatureContentModel *featureContentModel in specificationsModel.attrvalue) {
            [self refreshOptionWithAttribute:specificationsModel.attrname andWithOption:featureContentModel.infoName andWithModel:featureContentModel];
        }
    }
}

// 刷新指定的选型
- (void)refreshOptionWithAttribute:(NSString *)attribute andWithOption:(NSString *)option andWithModel:(ZPFeatureContentModel *)featureContentModel {
    // copy 基准筛选条件，切记不可直接在choosedOptionMap进行修改
    NSMutableDictionary *criteria = [NSMutableDictionary dictionaryWithDictionary:self.choosedOptionMap];
    // 增加（覆盖）塞选条件
    [criteria setValue:option forKey:attribute];
    // 调用方法,确认本option是否可以被选择，如果可以被选择（数组长度不为0），则可以点击，否则不可以点击
    if ( [[self getCommodityItemByCriteriaWithDict:criteria] count] > 0) {
        // TODO 按钮可点击
        featureContentModel.isDisableSelect = NO;
    } else {
        // TODO 按钮不可点击
        featureContentModel.isDisableSelect = YES;
        featureContentModel.isSelect = NO;
    }
}

// 传入筛选条件，判断出符合条件并且库存不为0的商品小项
- (NSMutableArray *)getCommodityItemByCriteriaWithDict:(NSDictionary *)criteria {
//    List<CommodityItemVO> commodityItemVOs = new ArrayList<>();
    NSMutableArray *commodityItemVOs = [NSMutableArray array];
    
    // 遍历整个商品小项
    
    for (ZPCommodityItemModel *model in self.commodityItemList) {
        NSDictionary *params = model.attached;
        BOOL paramIsOk = true;
        // 判断是否每一个属性都符合筛选条件
        for (NSString *key in criteria.allKeys) {
            if (![params[key] isEqualToString:criteria[key]]) {
                paramIsOk = false;
            }
        }
        // 如果符合，则判断库存是否为0，如果大于零，加入列表
        if (paramIsOk && [model.stock integerValue] > 0) {
            [commodityItemVOs addObject:model];
        }
    }
    return commodityItemVOs;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ZPFeatureHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ZPFeatureHeaderView class]) forIndexPath:indexPath];
    ZPSpecificationsModel *model = self.featureAttr[indexPath.section];
    headerView.title = model.attrname;
    return headerView;
}

- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    ZPSpecificationsModel *model = self.featureAttr[indexPath.section];
    ZPFeatureContentModel *contentModel = model.attrvalue[indexPath.row];
    return contentModel.infoName;
}


#pragma mark - privite
//添加到购物车
- (void)addAction {
    if (!self.selCommodityItemModel) {
        [MBProgressHUD showError:@"请选择商品属性!"];
        return;
    }
    if (self.addToCartActionBlock) {
        self.addToCartActionBlock(self.selCommodityItemModel);
    }
}

//立刻购买
- (void)buyAction {
    if (!self.selCommodityItemModel) {
        [MBProgressHUD showError:@"请选择商品属性!"];
        return;
    }
    NSArray *array = [NSArray arrayWithObject:self.commodity];

    if (self.buyActionBlock) {
        self.buyActionBlock(array,self.selCommodityItemModel);
    }
}

//我的购物车
- (void)myCart {
    if (self.cartBlock) {
        self.cartBlock();
    }
}

//收藏
- (void)star {
    [MBProgressHUD showError:@"功能开发中..."];
}

//退出登录
- (void)logout {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNeedSignIn object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSStringFromClass([ZPSelectOrderParamController class]) object:nil];
    
}

- (void)clearLoginInfo {
    if ([[NSFileManager defaultManager] fileExistsAtPath:ZPUserInfoPATH]) {
        [[NSFileManager defaultManager] removeItemAtPath:ZPUserInfoPATH error:nil];
    }
    if ([[kUSER_DEFAULT objectForKey:@"_IDENTIY_KEY_"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"_IDENTIY_KEY_"];
        [kUSER_DEFAULT synchronize];
        NSArray *cookiesArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie *cookie in cookiesArray) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    if ([[kUSER_DEFAULT objectForKey:@"stepsUpdateTime"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"stepsUpdateTime"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"lectureToken"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"lectureToken"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"accId"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"accId"];
        [kUSER_DEFAULT synchronize];
    }
    if ([[kUSER_DEFAULT objectForKey:@"token"] length]) {
        [kUSER_DEFAULT removeObjectForKey:@"token"];
        [kUSER_DEFAULT synchronize];
    }
    [ZPNetWorkManager destroyInstance];
}

#pragma mark - LazyLoad
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        DCCollectionHeaderLayout *layout = [DCCollectionHeaderLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        //自定义layout初始化
        layout.delegate = self;
        layout.lineSpacing = 8.0;
        layout.interitemSpacing = 10;
        layout.headerViewHeight = 35;
        layout.footerViewHeight = 5;
        layout.itemInset = UIEdgeInsetsMake(0, 10, 0, 10);
        layout.itemHeight = 25;
        layout.labelFont = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(12)];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[ZPFeatureItemCell class] forCellWithReuseIdentifier:NSStringFromClass([ZPFeatureItemCell class])];//cell
        [_collectionView registerClass:[ZPFeatureHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ZPFeatureHeaderView class])]; //头部
         [_collectionView registerClass:[ZPFeatureItemNumCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([ZPFeatureItemNumCell class])]; //尾部
//        [_collectionView registerClass:[ZPFeatureItemNumCell class] forCellWithReuseIdentifier:NSStringFromClass([ZPFeatureItemNumCell class])];
    }
    return _collectionView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.borderColor = ZPMyOrderDeleteBorderColor.CGColor;
        _iconView.layer.cornerRadius = 5;
        _iconView.layer.borderWidth = 1;
    }
    return _iconView;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.textColor = RGB(255, 150, 0);
        _priceLabel.font = [UIFont fontWithName:ZPPFSCRegular size:ZPFontSize(18)];
    }
    return _priceLabel;
}

- (UILabel *)featureLabel {
    if (!_featureLabel) {
        _featureLabel = [UILabel new];
        _featureLabel.textColor = ZPMyOrderDetailFontColor;
        _featureLabel.font = [UIFont fontWithName:ZPPFSCLight size:ZPFontSize(12)];
        _featureLabel.text = @"已选:";
    }
    return _featureLabel;
}

- (NSArray *)featureAttr {
    if (!_featureAttr) {
        _featureAttr = [NSArray array];
    }
    return _featureAttr;
}

//重写自定义init方法，给个默认值。防止外部不调用自定义init方法导致弹出控制器后黑屏
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        _myAnimator = [[XYAnimator alloc] initWithCHeight:500 andDimALpha:0.5];
        
        self.transitioningDelegate = _myAnimator;
        
       
    }
    return self;
}

//自定义init方法
- (instancetype)initWithCHeight:(CGFloat)cHeight andDimAlpha:(CGFloat)dimAlpha
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        _myAnimator = [[XYAnimator alloc] initWithCHeight:cHeight andDimALpha:dimAlpha];
        
        self.transitioningDelegate = _myAnimator;
        
       
    }
    return self;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *collectBtn = [UIButton new];
        [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [collectBtn setTitleColor:ZPMyOrderDeleteBorderColor forState:UIControlStateNormal];
        collectBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [collectBtn setImage:[UIImage imageNamed:@"prefer_star"] forState:UIControlStateNormal];
        [collectBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [collectBtn addTarget:self action:@selector(star) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *shopCarBtn = [UIButton new];
        [shopCarBtn setTitle:@"购物车" forState:UIControlStateNormal];
        [shopCarBtn setTitleColor:ZPMyOrderDeleteBorderColor forState:UIControlStateNormal];
        shopCarBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [shopCarBtn setImage:[UIImage imageNamed:@"prefer_addTocar"] forState:UIControlStateNormal];
        [shopCarBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:5];
        [shopCarBtn addTarget:self action:@selector(myCart) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bottomView sd_addSubviews:@[collectBtn,shopCarBtn]];
        collectBtn.sd_layout
        .leftEqualToView(_bottomView)
        .heightIs(50)
        .topEqualToView(_bottomView)
        .widthIs(50);
        
        shopCarBtn.sd_layout
        .leftSpaceToView(collectBtn, 0)
        .heightIs(50)
        .topEqualToView(_bottomView)
        .widthIs(50);
        
        UIButton *addbtn = [UIButton new];
        [_bottomView addSubview:addbtn];
        addbtn.sd_layout
        .leftSpaceToView(shopCarBtn, 0)
        .widthIs((kSCREEN_WIDTH-100)*0.5)
        .heightIs(50)
        .topEqualToView(_bottomView);
        [addbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addbtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [addbtn setBackgroundColor:RGB(255,200,50)];
        addbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [addbtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *buybtn = [UIButton new];
        [_bottomView addSubview:buybtn];
        buybtn.sd_layout
        .leftSpaceToView(addbtn, 0)
        .widthIs((kSCREEN_WIDTH-100)*0.5)
        .heightIs(50)
        .topEqualToView(_bottomView);
        [buybtn setTitle:@"立即购买" forState:UIControlStateNormal];
        [buybtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [buybtn setBackgroundColor:RGB(255, 150, 0)];
        buybtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [buybtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomView;
}

- (NSMutableArray *)selfeatureAttr {
    if (!_selfeatureAttr) {
        _selfeatureAttr = [NSMutableArray array];
    }
    return _selfeatureAttr;
}

- (NSMutableDictionary *)choosedOptionMap {
    if (!_choosedOptionMap) {
        _choosedOptionMap = [NSMutableDictionary dictionary];
    }
    return _choosedOptionMap;
}

- (NSMutableArray *)commodityArray {
    if (!_commodityArray) {
        _commodityArray = [NSMutableArray array];
    }
    return _commodityArray;
}

- (NSMutableArray *)commodityItemList {
    if (!_commodityItemList) {
        _commodityItemList = [NSMutableArray array];
    }
    return _commodityItemList;
}

- (NSMutableArray *)attributes {
    if (!_attributes) {
        _attributes = [NSMutableArray array];
    }
    return _attributes;
}
@end
