//
//  ZPEnumHeader.h
//  Uhealth_user
//
//  Created by Biao Geng on 2018/11/5.
//  Copyright © 2018年 Peng Zhou. All rights reserved.
//

#ifndef ZPEnumHeader_h
#define ZPEnumHeader_h
typedef NS_ENUM(NSInteger, AFNStatus) {
    AFStatusUnknown          = -1,
    AFStatusNotReachable     = 0,
    AFReachableViaWWAN = 1,
    AFReachableViaWiFi = 2,
};

typedef NS_ENUM (NSInteger,ZPArticleEnterStatusType) {
    ZPArticleEnterStatusTypeNormal,//正常路径
    ZPArticleEnterStatusTypeBanner,//banner图
    ZPArticleEnterStatusTypeNoti//通知
};

typedef NS_ENUM (NSInteger,ZPOrderEnterStatusType) {
    ZPOrderEnterStatusTypeNormal,//正常路径
    ZPOrderEnterStatusTypeBanner,//banner图
    ZPOrderEnterStatusTypeNoti//通知
};

typedef NS_ENUM (NSInteger,ZPArticleType) {
    ZPArticleTypeNews,//文章->资讯
    ZPArticleTypeWind,//文章->风向
};

typedef NS_ENUM (NSInteger,ZPArticleCommentsOrderByType) {
    ZPArticleOrderByTypeTime,//文章评论时间排序
    ZPArticleOrderByTypeLike,//文章评论点赞数排序
};

typedef NS_ENUM (NSInteger,ZPConsultDoctorType) {
    ZPConsultDoctorTypeConsulting,//心理咨询
    ZPConsultDoctorTypeHealthAdvisory,//健康咨询
};

typedef NS_ENUM (NSInteger,ZPGreenChannelSelEnterStatusType) {
    ZPGreenChannelSelEnterStatusTypeCity,//选择城市
    ZPGreenChannelSelEnterStatusTypeService//选择服务
};

typedef NS_ENUM (NSInteger,ZPOrderDetailsCellType) {
    /// 商店
    ZPOrderDetailsCellType_shop = 1,
    /// 商品
    ZPOrderDetailsCellType_goods ,
    /// 输入数量
    ZPOrderDetailsCellType_inputNums,
    /// 配送方式
    ZPOrderDetailsCellType_delivery,
    /// 配送时间
    ZPOrderDetailsCellType_time,
    /// 运费险
    ZPOrderDetailsCellType_insurance,
    /// 留言
    ZPOrderDetailsCellType_message
};//cell的类型

typedef NS_ENUM (NSInteger,ZPOrderStatusType) {
    ZPOrderStatusTypeAll,
    ZPOrderStatusTypeNON_PAYMENT,
    ZPOrderStatusTypeNON_SEND,
    ZPOrderStatusTypeNON_RECIEVE,
    ZPOrderStatusTypeNON_EVALUATED
};//订单状态

typedef NS_ENUM (NSInteger,ZPAddressType) {
    ZPAddressTypeAdd,//添加地址
    ZPAddressTypeEdit//编辑地址
};//地址页面

typedef NS_ENUM (NSInteger,ZPCheckOutBillType) {
    ZPCheckOutBillTypeFromCart,//购物车_>确认订单
    ZPCheckOutBillTypeFromOrderDetail//商品详情_>确认订单
};//确认订单 页面

typedef NS_ENUM (NSInteger,ZPCheckOutResultType) {
    ZPCheckOutResultTypeFromCart,//购物车_>
    ZPCheckOutResultTypeFromOrderDetail,//商品详情_>
    ZPCheckOutResultTypeFromMyOrder,//我的订单_>
   ZPCheckOutResultTypeFromGreenPath//绿通_>
};//支付结果 页面

typedef NS_ENUM (NSInteger,ZPMsgActionType) {
    ZPMsgActionTypeByOpenApp = 1010,//打开APP
    ZPMsgActionTypeByOpenAppPage = 1020,//打开APP指定页面
    ZPMsgActionTypeByOpenUrl = 1030,//打开网页(Url)
};//推送消息的操作

typedef NS_ENUM (NSInteger,ZPActionType) {
    ZPActionTypeDirection = 1020,//健康风向文章
    ZPActionTypeInformation = 1030,//健康资讯文章
    ZPActionTypeCommodity = 1040,//商品
    ZPActionTypeLink = 1050,//链接
    ZPActionTypeLectureRoom = 1060,//在线讲堂
};//打开网页(URL)的类型

typedef NS_ENUM (NSInteger,ZPMsgActionOpenAppointedPageType) {
    ZPMsgActionOpenAppointedPageAssessmentType = 1010,//心理测评
    ZPMsgActionOpenAppointedPageEvaluationType = 1020,//生理测评
    ZPMsgActionOpenAppointedPageExaminationType = 1030,//症状自查
    ZPMsgActionOpenAppointedPageAdvisoryType = 1040,//身心咨询
    ZPMsgActionOpenAppointedPageLiveLectureType = 1050,//直播讲堂
    ZPMsgActionOpenAppointedPageMyArchivesType = 1060,//我的档案
    ZPMsgActionOpenAppointedPageHealthConsultationType = 1070,//健康咨询
    ZPMsgActionOpenAppointedPageMicroecologicalCenterType = 1080,//微生态中心
    ZPMsgActionOpenAppointedPageShppingMallType = 1090,//优选商城
    ZPMsgActionOpenAppointedPageNonPaymentType = 1100,//待支付
    ZPMsgActionOpenAppointedPageNonSendType = 1110,//待发货
    ZPMsgActionOpenAppointedPageNonReceieveType = 1120,//待收货
    ZPMsgActionOpenAppointedPageNonEvaluatedType = 1130,//待评价
    ZPMsgActionOpenAppointedPageWalkingType = 1140,//健步走
    ZPMsgActionOpenAppointedPageHealthSelftestType = 1150,//健康自测
    ZPMsgActionOpenAppointedPageMyServiceType = 1160,//我的服务
};//打开App指定页面的类型
#endif /* ZPEnumHeader_h */
