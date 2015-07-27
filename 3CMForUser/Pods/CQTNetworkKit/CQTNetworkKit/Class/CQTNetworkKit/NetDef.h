/*
 *  NetDef.h
 *  CQTMemberCenter
 *
 *  Created by sky on 12-2-14.
 *  Copyright 2012 CQTimes.cn. All rights reserved.
 *
 */

#define kiPhone                     @"iPhone"  
#define kPhoneUDIDKey               @"phoneid"
#define kPhoneTypeKey               @"phonetype"
#define kUserAreaKey                @"area"
#define kNetDef                     @""
#define kOriginImageKey             @"filename"
#define kMinThumbImageKey           @"min_thumb_url"
#define kBigThumbImagekey           @"big_thumb_url"

#define kAppInfoDataKey             @"kAPP_ONLINE_INFO_DATAKey"//ituns数据key.
#define kAppNativeDateKey           @"kAPP_NATIVE_DATAKey"//本地数据key.
//API
#define kServerURL               @"http://sy.cqtimes.cn/index.php?g=mobile"
#define kServerURL1              @"http://sy.cqtimes.cn/"
#define kRequestStatusCodeOK1    @"1"
#define kRequestStatusCodeOK4UploadToken   @"0"
#define kRequestOK               1
#define kRequestStatus_1        -1
#define kRequestStatusError     -2
#define kRequestCodeKey         @"resultcode"
#define kStatusKey              @"status"
#define kRequestMsgKey          @"msg"
#define kRequestStatusKey       @"requeststatus"
#define kRequestResultKey       @"requestResult"
#define kRequestURLKey          @"requestURL"
#define kRequestActionKey       @"requestAction"
#define kInfoKey                @"list"
#define kInfoActivityKey        @"result.hd"
#define kInfoListKey            @"result.list"
#define kUserInfoKey            @"userInfo"

///
#define kUserAPI                @"&m=user"
#define kActivityAPI            @"&m=hd"
#define kServiceAPI             @"&m=service"
#define kSquareAPI              @"&m=forum"
#define kAPINumKey              @"port"
#define kWatchActivityDetailAPINum  @"16"


//
#define kUIdKey                  @"uid"


//AppInappstore
#define kWhereIsAppInAppstoreServer          @"http://itunes.apple.com/"
#define kWhereIsAppInAppstoreMethod          @"lookup?"
#define kWhereIsAppInAppstorePara            @"id=%@"
#define kWhereIsAppInAppstoreResultCountKey  @"resultCount"
#define kWhereIsAppInAppstoreResultsKey      @"results"
#define kWhereIsAppInAppstoreAppURLKey       @"trackViewUrl"
#define kWhereIsAppInAppstoreAction         [NSString stringWithFormat:@"%@%@%@",kWhereIsAppInAppstoreServer,kWhereIsAppInAppstoreMethod, kWhereIsAppInAppstorePara]


#define kAlertHasNewVerson  @"有新版本啦"
//UploadToken


//SignIn
#define kUploadTokenPara                              @""
#define kUploadTokenMethod                            @"getToken.php"
#define kUploadTokenAction                            [NSString stringWithFormat:@"%@%@%@%@",kServerURL1, @"", kUploadTokenMethod, kUploadTokenPara]

//MyMessage
#define kMessageIdKey                            @"id"
#define kMessageServiceIdKey                     @"s_id"
#define kMessageActivityIdKey                    @"h_id"
#define kMessageActivityNameKey                  @"h_name"
#define kMessageReceiveMemberIdKey               @"m_id"
#define kMessageReceiveMemberCardIdKey           @"cardid"
#define kMessageContentKey                       @"mes"
#define kMessageTimekey                          @"time"
#define kFetchMyMessageMTD                       @"&a=message"
#define kFetchMyMessagePara                      @"&m_cardid=%@&id=%@"
#define kMessageIsReadKey                        @"read"
#define kMessageReadTag                          1
#define kMessageUnReadTag                        0
#define kFetchMyMessageAction                   [NSString stringWithFormat:@"%@%@%@%@",kServerURL, kUserAPI, kFetchMyMessageMTD, kFetchMyMessagePara]
//userInfo
#define kMemberIdKey                                      @"m_id"
#define kMemberCardIdKey                                  @"m_cardid"
#define kMemberIconKey                                    @"m_pic"
#define kMemberRealNameKey                                @"m_name"
#define kMemberTellKey                                    @"m_tel"
#define kMemberQQKey                                      @"m_qq"
#define kMemberEmailKey                                   @"m_email"
#define kMemberIdentifierKey                              @"m_idc"
#define kMemberAddressKey                                 @"m_addres"
#define kMemberAgeKey                                     @"m_age"
#define kMemberSexKey                                     @"m_sex"
#define kMemberMessageCountsKey                           @"m_mes"
#define kMemberProfessionKey                              @"m_profession"
#define kMemeberYWMKey                                    @"m_ywm"
#define kMemberCreditsKey                                 @"m_point"
#define kMemberAccountBalanceKey                          @"m_CardValue"
#define kMemberNickNameKey                                @"m_nickname"
#define kMemberTitleKey                                   @"member_title"
#define kMemberValueKey                                   @"member_value"
#define kMemberCityKey                                    @"City"
#define kMemberAreaIdKey                                  @"id"
#define kMemberAreaNameKey                                @"name"
#define kMemberNeedCompleteUserInfoKey                    @"login_first"

//SignIn
#define kSignInPara                                       @"&user_name=%@&password=%@"
#define kSignInCMTMethod                                  @"&a=login"
#define kSignInAction                                     [NSString stringWithFormat:@"%@%@%@%@",kServerURL, kUserAPI, kSignInCMTMethod, kSignInPara]

//GetUserInfo
#define kFetchMemberInfoPara                              @"&m_cardid=%@"
#define kFetchMemberInfoMTD                               @"&a=getuserinfo"
#define kFetchMemberInfoAction                            [NSString stringWithFormat:@"%@%@%@%@",kServerURL, kUserAPI, kFetchMemberInfoMTD, kFetchMemberInfoPara]



#define kGetWonderDataAction           [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=ttjx&a=index"]
#define kGetGoodsInfoWonderPDAction    [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=ttjx&a=view"]
#define kApplyGoodsWonderPDAction      [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Ttjx&a=TtjxZj"]
#define kApplyGoodsTypeAction          [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Goods&a=goodsType"]


#define kRegisterAction                [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=reg"]
#define kLoginNameAction               [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=login"]
#define kVerifyUserAction               [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=find"]
#define kEditorUserAction               [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=useredit"]


#define kUploadAvatarAction            [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=upload"]
#define kGetVerifyCodeAction           [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=getvcode"]
#define kcommitVerifyCodeAction        [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=check"]
#define kAddAddressAction              [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=addrs&op=add"]
#define kDeleteAddressAction           [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=addrs&op=del"]
#define kModifyAddressAction           [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=addrs&op=edit"]
#define kGetAddressListAction          [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=addrs&op=list"]
#define kGetVipReseverListAction       [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=vipgoods"]
#define kBindIDaCardAction             [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=card"]
#define kIDaCardCoderAction            [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=bianma"]
#define kBindPhoneAction               [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=edittele"]
#define kBuyIDaCardZunAction           [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=card&op=Issuing@type=1&otype=1"]
#define kBuyIDaCardNormalAction        [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=card&op=Issuing&type=1"]

#define kGetNowSpecialAction           [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Goods&a=nowspecial"]
#define kGetOldSupplyAction            [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Goods&a=goodslist"]
#define kGetGoodsMyPickAction          [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Goods&a=specialPick"]
#define kGetGoodInfoWithIdAction       [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Goods&a=goodsinfo"]
#define kGetSpecialInfoAction          [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Goods&a=specialinfo"]
#define kGetPinMyPickGoodsAction       [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Goods&a=specialPickTouP"]
#define kByGoodsAction                 [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Goods&a=bygoods"]
#define kHomeGalleryAction             [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=index&a=tj"]

#define kGetReseverMilkListAction      [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=dy&a=index&plx=3"]

#define kGetReseverFavouriteAction     [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=dy&a=dylx"]

#define kModifyOrderStatusAction       [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=orderscardstatus"]

#define kGetOrderInfoAction            [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=ordersstatus"]

#define kGetMerchantCatergoryAction    [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=merchant&a=lx"]
#define kGetMerchantInfoAction         [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=merchant&a=view"]

#define kGetOneMilkInfoAction          [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=dy&a=view"]

#define kGetReseverNewsPaperListAction [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=dy&a=index&plx=4"]

#define kGetOneNewsPaperInfoAction     [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=dy&a=view"]

#define kBuyMilkAction                 [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=dy&a=buy"]
#define kBuyNewsPaperAction            [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=dy&a=buy"]

#define kGetMessageUserAction          [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=messages"]

#define kGetRebateListAction           [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=dzfx&a=index"]

#define kCommitRebateListAction        [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=dzfx&a=add"]

#define kGetRebateInfoAction           [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=dzfx&a=view"]


#define kWaitPayAction                 [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=orders&op=1"]
#define kForThrGoodsAction             [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=orders&op=2"]
#define kDeleteGoodsAction             [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=orders&op=3"]
#define kCompleteOrderListAction       [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=orders&op=4"]
#define kConfirmReceivedGoodsAction    [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=orders&op=5"]
#define kBuyGoodsAction                [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Goods&a=bygoods"]

#define kBuyNormalCardAction                [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Goods&a=bygoods&normalcqrd=1"]
#define kNeedCardEntityAction          [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=ordersidacard"]

#define kGetRebateInfoAction           [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=dzfx&a=view"]

#define kAddCollectAction              [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=collect&op=add"]
#define kDelCollectAction              [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=collect&op=del"]
#define kGetCollectListAction          [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=users&a=collect&op=list"]
//
#define kFeedbackAction                [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=Goods&a=usersFeedback"]

//CardedDiscount
#define kFetchStoresAction             [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=merchant&a=index&lx=%@&shequ=%@&p=%d"]
#define kStoreLoginAction              [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=merchant&a=login"]
#define kUploadConsumeAction           [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=merchant&a=sk"]

//
#define kCheckAppVersionAction         [NSString stringWithFormat:@"%@%@",kIDaBaseUrlString,@"c=index&a=shengji"]






