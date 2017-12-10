//
//  Network.h
//  XPSixHeLottery
//
//  Created by iMac on 2017/8/16.
//  Copyright © 2017年 eirc. All rights reserved.
//

#ifndef Network_h
#define Network_h

#define NETWORK_STATE 1  //1是正式环境 0是测试环境

#define kMainToken @"4d2cbce9-4338-415e-8343-7c9e67dae7ef"

#define AppUpdateCode           @"d60a197a6585d6d0b3b48fddf6008d11"   //检测新版本更新code
#define AppUpdatePeramters      @{@"code":AppUpdateCode}

#define AppKey                  @"5a23be4af29d987740000301"           //友盟appKey
#define AppSecret               @"lesszpiri6iroomanhytywvrp4me6nny"  //友盟app 秘钥

#define COMPANYPARA             @{@"app_id":@"1258070698"}            //appID
#define CacheKey                @"ACPCacheKey"
#define UserID                  @"UserID"
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH   [UIScreen mainScreen].bounds.size.width
#define StringFormat(string, args...)       [NSString stringWithFormat:string, args]
#define Log_ResponseObject      NSLog(@"%@",[responseObject mj_JSONString])

#define miPhone5    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//#define RACObserve(TARGET, KEYPATH) \
//({ \
//_Pragma("clang diagnostic push") \
//_Pragma("clang diagnostic ignored \"-Wreceiver-is-weak\"") \
//__weak id target_ = (TARGET); \
//[target_ rac_valuesForKeyPath:@keypath(TARGET, KEYPATH) observer:self]; \
//_Pragma("clang diagnostic pop") \
//})

#define BaseHttpUrl   NETWORK_STATE ?  [[YYCache cacheWithName:CacheKey] objectForKey:@"serviceHost"]:@"http://172.16.5.105:8080"// @"http://172.16.1.67:8080"http://172.16.5.105:8080 @"http://172.16.2.175:8080"//@"http://169.56.130.24:8098"

#define BaseUrl(url)  [NSString stringWithFormat:@"%@%@",BaseHttpUrl,url]

#define AppNetwork              @"http://119.9.107.44:9999/getDomainMapper"                    //请求动态域名
#define AppUpdateInvalidUrl     @"http://119.9.107.44:9999/updateDomainMapper"                 //上传失效域名
#define AppCheckHostAvailable   @"/user/homepage/checkDomainName"                              //握手
#define AppUpdateUrl            @"https://tpfw.083075.com/system/getAppLastChange"             //检测新版本更新
#define AppInitialize           @"/user/homepage/getLotteryInitialization"                     //app初始化信息接口
#define AppHttpDNS              @"http://47.74.19.250:9888/dns/queryDNS?uri=acp58.com"         //app初始化HttpDNS

#define HomepageUrl      @"/index/mobile/getIndexSecond"                       //首页
#define OpenAPPAdvList   @"/user/homepage/queryAdvertisementList"              //引导页
#define ActionsList      @"/activity/mobile/getActivityList"                   //活动列表
//开奖
#define AllLotteryList   @"/index/mobile/getLotteryList"                       //彩种列表
#define LotteryList      @"/lottery/mobile/queryLotteryListByProId"            //开奖
#define LotteryTypeList  @"/lottery/mobile/queryLotteryTypeList"               //彩票类型
#define LotteryHistroy   @"/lottery/mobile/queryLotteryHistory"                //彩票开奖历史
#define LotteryRefresh   @"/index/mobile/getIndexLotteryDetail"                //单彩种刷新
//社区论坛
#define CommunityList    @"/community/mobile/getCommunityList"                 //论坛列表
#define BBSPersonal      @"/community/mobile/getUserCommunityDetail"           //论坛个人页面
#define PerCommunityList @"/community/mobile/getUserCommunityList"             //个人论坛列表
#define BSSDetail        @"/community/mobile/getCommunityDetail"               //论坛帖子详情
#define DelectPublish    @"/community/mobile/removeCommunity"                  //删除帖子
#define LikePublish      @"/community/mobile/addFavorite"                      //关注帖子
#define CollectPublish   @"/community/mobile/addCollection"                    //收藏帖子
#define FansList         @"/community/mobile/getFansList"                      //粉丝列表
#define AddComment       @"/community/mobile/addReturnMessage"                 //评论帖子
#define AddPublish       @"/community/mobile/addCommunity"                     //发布帖子
//社区关注
#define RemoveConcerned  @"/community/mobile/removeConcerned"                  //取消关注
#define AddConcerned     @"/community/mobile/addConcerned"                     //增加关注
#define RecommendConList @"/community/mobile/getRecommendConcernedList"        //推荐关注列表
#define ConcernedList    @"/community/mobile/getConcernedList"                 //关注列表
//个人页面
#define UserPartnerList  @"/user/mobile/userPartner"                           //合作伙伴列表
#define RecommendedList  @"/user/mobile/userToDayRecommend"                    //推荐列表
#define IntegralDetail   @"/user/points/queryUserRecentlyPoints"                //积分详情
#define IntegralInfor    @"/point/user/queryPointUserInfo"                     //积分余额查询
#define UserRegist       @"/user/mobile/registerApp"                           //注册
#define UserLogin        @"/user/mobile/loginApp"                              //登录
#define ModifyPerInfor   @"/user/mobile/modifyUser"                            //修改个人信息
#define UploadPerImage   @"/user/mobile/userUploadImage"                       //上传头像
//安全中心
#define IDBinding        @"/user/mobile/modifyUser"                            //身份绑定 (跟修改个人信息是一样的)
#define PhoneBinding     @"/user/mobile/registerApp"                           //手机绑定
#define ModifyPassword   @"/user/mobile/modifyUserCipher"                      //修改密码
//签到
#define SignInList       @"/user/points/queryUserMonthSignIn"                  //签到列表
#define SignInAction     @"/user/points/addUserPoints"                         //签到
#define CheckIntegral    @"/user/points/queryUserPoints"                       //查看积分
//新闻
#define NewsTypeList     @"/consult/mobile/queryNewConsultType"                //新闻分类列表
#define NewsList         @"/consult/mobile/queryNewConsultList"                //新闻列表
#define NewsDetail       @"/consult/mobile/queryNewConsultDetail"              //新闻详情
//走势
#define LotteryHisList   @"/lottery/award/pc/getLotteryOpenAwardHistoryList"   //走势图
#define LotTrendsList    @"/lottery/mobile/getLotteryGameList"                 //走势图的title列表
//发现
#define NewsClass        @"/consult/mobile/queryNovicePulpit"                  //新手讲堂
#define NewsClassDetail  @"/consult/mobile/queryNovicePulpitDetail"            //新手讲堂详情
#define AwardsColumn     @"/consult/mobile/queryAwardsColumn"                  //大奖专栏
#define AwardsDetail     @"/consult/mobile/queryAwardsColumnDetail"            //大奖专栏详情

#endif /* Network_h */
