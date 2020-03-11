//
//  QISTwoMenuView.h
//  YYK
//
//  Created by xiexianyu on 1/14/15.
//  Copyright (c) 2015 39.net. All rights reserved.
//

#import <UIKit/UIKit.h>

// cell type
typedef NS_ENUM(NSUInteger, QISCellType){
    QISTextTipCellType = 1,
    QISTextIconCellType,
    QISIconTextCheckCellType,
    QISDoctorCheckCellType,
    QISSelectCityType,
    QISCircleSquareType
};

#ifndef QISFetchDataCompletionHandler
#define QISFetchDataCompletionHandler
typedef void (^QISFetchDataCompletionBlock)(BOOL didSuccess, NSArray *infos, NSUInteger responseCount);
#endif

@protocol QISTwoMenuViewDelegate <NSObject>

@optional
- (void)didSelecteOneLevelItem:(NSDictionary*)info;
- (void)didSelecteTwoLevelItem:(NSDictionary*)info;
// for fetch data of page list
- (void)requestDataWithParamInfo:(NSDictionary*)info
                 completionBlock:(QISFetchDataCompletionBlock)finishFetchBlock;
// for notify will change two level
- (void)willChangeTwoLevelItemForListKey:(NSString*)listKey;
// for handle action
- (void)handleActionWithKey:(NSString*)key withInfo:(NSDictionary*)info;

@end

@interface QISTwoMenuView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<QISTwoMenuViewDelegate> delegate;
@property (nonatomic, assign) QISCellType rightCellType; // default QISTextIconCellType
// default NO, not selected first sub item when switch left item.
@property (nonatomic, assign) BOOL didSelectRight;
// default NO. if set yes, table view will scroll top to show selected item one time, then reset NO.
@property (nonatomic, assign) BOOL isOneScroll;
//
@property (nonatomic, copy, readonly) NSString *listKey;
// table view
@property (nonatomic, strong, readonly) UITableView *oneTableView; // left list
@property (nonatomic, strong, readonly) UITableView *twoTableView; // right list

// selected info
@property (nonatomic, strong, readonly) NSDictionary *selectedLeftInfo;
@property (nonatomic, strong, readonly) NSDictionary *selectedRightInfo;

- (void)setupTwoTableView; // for sub class
// update width of left table view if need
// default width half of view width .
- (void)adjustWidthOfLeftTableView:(CGFloat)leftWidth;

// all level infos,  each item for two level key is two infos.
// default two level key is 'list'. default text key is 'name'.
// default selected first item and unselected sub item.
- (void)setupWithInfos:(NSArray*)infos
           twoLevelKey:(NSString*)twoLevelKey
            oneTextKey:(NSString*)oneTextKey
            twoTextKey:(NSString*)twoTextKey;

- (void)setupWithInfos:(NSArray*)infos
           twoLevelKey:(NSString*)twoLevelKey
            oneTextKey:(NSString*)oneTextKey
            twoTextKey:(NSString*)twoTextKey
     selectedIndexPath:(NSIndexPath*)indexPath;

// when update data
- (void)refreshRightTableView;

@end
