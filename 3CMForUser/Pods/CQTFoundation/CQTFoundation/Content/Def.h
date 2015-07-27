/*
 *  Def.h
 *  CQTComment
 *
 *  Created by sky on 12-2-14.
 *  Copyright 2012 CQTimes.cn. All rights reserved.
 *
 */


//detail
typedef enum {
	
	CQTDetailTypeFromSingle,
	CQTDetailTypeFromList
	
}CQTdetailType;

//recomment formate
typedef enum {
	
	CQTTopTypeImageAndText,
	CQTTopTypeSingleImage
	
}CQTTopType;




//App & About us
#define kIDaAppId4EHome                    @"688066510" //EHome
#define kBundleId4EHome                    @"com.CQT.Member"

//
#define kIDaAppIdNew                       @"913513510" //NewIda
//#define kIDaAppIdNew                       @"688091524" //NewIda
#define kBundleId4Ida                      @"com.CQT.Ida"

#define kBundleIdentifier                  (NSString*)[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:(NSString*)kCFBundleIdentifierKey]
#define kIDaAppID                          [kBundleIdentifier isEqualToString:kBundleId4Ida]?kIDaAppIdNew:kIDaAppId4EHome
#define kAppWeiMenHuURLSchema              @"cqtimes.news"
#define kMyNewsAppID                       @""  //我的新闻ID
#define kAppAppStoreURLFormat              @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8"
#define kAppAppStoreCommentFormat          @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"
#define kServiceTellNO                     @"96128"
#define kAddress                           @"重庆时报"
#define kEmail                             @"mid@cqt.cc"

//
#define kTitle4AbountUs                     @"关于我们"
#define kSmallImage                         @"_small"
#define kBigImage                           @"big|"
#define kDefaultUserId                    @""
#define kDefaultMemberCardId                @"0"
#define kDefaultUserName                    @"用户名字未知"
#define kAppInfoKey                         @"appInfo"
#define kAppRecommendMailSuject             @"发邮件"
#define kMachineTypeiPhone                  @"iPhone"
#define kDefaultArea                        @""
#define kCurrentCity                        @"重庆市"
#define kConfirmTitle                       @"确 认"


#define kAlertNoAddress  @"您还没有选择收货地址哦,点击’确 定‘去选择地址"
#define kAppName                            [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"CFBundleDisplayName"]]


#define kHttpCheck(url) \
if (url != nil) {\
   url = ([url rangeOfString:@"http://"].location == NSNotFound)?[NSString stringWithFormat:@"%@%@",@"http://",url]:url;\
}\
else {\
   url = @"http://";\
}\



//
#define kSignIningTitle             @"登录中..."
#define kSignInSuccessTitle         @"登录成功"
#define kSignInFailedTitle          @"登录失败"
#define kCommentingTitle            @"发送评论..."
#define kCommentSuccessTitle        @"评论成功"
#define kCommentFailedTitle         @"评论失败"
#define kDeleteStatusingTitle       @"正在删除..."
#define kDeleteStatusFailedTitle    @"删除失败"
#define kDeleteStatusSucessTitle    @"删除成功"
#define kLoadingTitle               @"加载中...."
#define kLoadFinishTitle            @"加载成功"
#define kLoadFailedTitle            @"加载失败"
#define kLoadNOResult               @"没有加载到数据"
#define kAppRecommendTitle          @"快去下载时报\"爱达\"吧，下载地址: %@"


//
#define kMaxCategory                        6
#define kExpectHotNewsCount                 6
#define kNotFirstWatchActivityListKey       @"firstWatchActivityListKey"


#define kInvalidNumber                   1
#define kHttpStatusCode200               200
#define kStartPage                       1
#define kDelayToLoad                     .8f
#define kTestCounts                      10
#define kActivityItemHeight              228
#define kMinMessageId                    @"0"
#define kLatestMsgIdKey                  @"latestMsgId"
#define kMaxMessageCount                 100
#define kLastMemberCardIdKey             @"lastMemberCardId"
#define kWishCounts                      5
#define kFirstShareStatusNoNickNameKey   @"firstShareStatusNoNickName"


#define kPriceFormat                              @"¥ %@ / %@"
#define kMoneyFormat                              @"¥ %@"
#define kFMoneyFormat                             @"¥ %.2f"
              

//
#define kDot                        @"."
#define exeLog(string, b)		    CQTDebugLog(@"%@%@",string, b?@"成功":@"失败")
#define kInvalidUserId              0LL
#define kHttpPrevfix                @"http://"
#define kIOSSystemVersion           [[[UIDevice currentDevice] systemVersion] floatValue]
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kCounts4Page                10
#define PAGE(N, NumberOfOfPage)    (N%NumberOfOfPage==0)?N/NumberOfOfPage:N/NumberOfOfPage+1
#define ROW(N, NumberOfOfRow)      (N%NumberOfOfRow==0)?N/NumberOfOfRow:N/NumberOfOfRow+1


//Notification

#define kNotificationtimerUpdatedKey @"kNotificationtimerUpdatedKey"
#define kNotificationViewDeceleratingKey @"kNotificationViewDeceleratingKey"
#define kCanDoAnimationKey   @"canDoAnimation"


#define kNotificationUserCurrentAddressInfoChanged                   @"userCurrentAddressInfoChanged"
#define kNotificationUserInfoChanged                                 @"userInfoChanged"
#define kNotificationUserSignIn                                      @"userSignIn"
#define kNotificationUserSignOut                                     @"userSignOut"
#define kNotificationNeworkStatusChanged                             @"networkStatusChanged"
#define kNotificationDownloadFinished                                @"downloadFinished"
#define kNotificationMessageChanged                                  @"messageChanged"
#define kNotificationStoreUserChanged                                @"storeUserChanged"
#define kDownloadURLKey                                              @"downlaodUrl"
#define kDownloadStateKey                                            @"downlaodState"
#define kDownloadStateOK                                             1
#define kDownLoadSeparator                                           @"|"
#define kNotificationStautsChanged                                   @"stautsChanged"
#define kNotificationCommentChanged                                  @"commentChanged"

//feedback
#define kFeedbackSuccessTitle     @"提交成功"
#define kFeedbackFailedTitle      @"提交失败"
#define kFeedbackingTitle         @"提交中..."

///////////////////////
//Mebers Square
#define kStatusStateNoraml          1
#define kStatusStateForbidden       2
#define kStatusStateDeleted         3
#define kCategoryImages   [NSArray arrayWithObjects:@"com_square_all", nil]


//
#define kColor4HomeNav             HEX_RGBA(0xE31969,1.)
#define kColor4ReservNav           HEX_RGBA(0xF54700,1.)
#define kColor4BookmarkNav         HEX_RGBA(0xEF9E01,1.)
#define kColor4MyIdaNav            [UIColor colorWithRed:111.f/255.f green:187.f/255.f  blue:13.f/255.f alpha:.8f]
#define kColor4MoreNav             HEX_RGBA(0x10C7DC,1.)
#define kColor4InnerNav            HEX_RGBA(0xFFFFFF,1.f)

#define kColor4Hilighted           [UIColor colorWithRed:225.f/255.f green:66.f/255.f  blue:0.f/255.f alpha:1.f]


#define kStoreUserNameKey           @"username"
#define kStoreUserInfoKey           @"storeUserInfo"








