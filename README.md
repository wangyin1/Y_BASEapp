# Y_BASEapp
iOS 快速开发框架，整理了常用的第三方，加入了自己在各个经历过的项目中总结的catergroy和控件。基本的工程配置已完成。只需要在pch文件和接口路径文件中做简单的配置即可使用。已有登录和第一次启动判断。


WLayOut  （瀑布流layout）
@protocol WVerticalLayOutDelegate <NSObject>


/**
返回列数

@param layout

@return
*/
- (NSInteger)VerticalLayOutnumberOfMaxNumCols:(WLayOut *)layout;


/**
返回每个元素的高度

@param layout
@param row    元素位置

@return
*/
- (CGFloat)VerticalLayOut:(WLayOut *)layout HeightForRow:(NSInteger)row;



/**
返回间距

@param layout

@return
*/
- (CGFloat)VerticalLayOutPixelSpacing:(WLayOut *)layout;

@end

－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
BLJSPatchManager (基于jspatch的热修复框架封装)
+ (instancetype)shareManager;

/**
*  设置补丁远程下载地址 每个版本url不同
*
*  @param url
*/
+ (void)setPatchUrl:(NSString *)url;

//下载补丁并使用 需要后台支持
+ (void)start;

//当前app版本的补丁文件地址url
+ (NSURL *)patchFileURL;

－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
BLChoseImagesControl（快速选择图片,自带弹出控件，支持多选）
/**
*  选择图片带选择器
*
*  @param maxCount 最多几张
*  @param block    回调图片数组
*  @param dismiss
*/
+ (void)showChoseImagesAlertWithMaxCount:(NSInteger)maxCount GetImagesBlock:(BLGetImagesBlock)block DissmissBlock:(void (^)())dismiss;

－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
BLWebViewController（wkwebview网页控制器，自带进度条，已控制返回按钮事件，父类是YINWebViewController）
/**
IMYWebView 实体类，包含wkwebview  里面很多控制方法
*/
@property (nonatomic , strong) IMYWebView *WebView;

/**
进度条颜色
*/
@property (nonatomic , strong) UIColor *ProgressColor;;

/**
网络地址或者本地资源地址
*/
@property (nonatomic)NSURL* url;

/**
用url初始化

@param url url地址

@return
*/
-(instancetype)initWithUrl:(NSString *)url;

/**
用html字符串初始化

@param html html字符串
@param url  baseurl

@return
*/
-(instancetype)initWithHtml:(NSString *)html BaseUrl:(NSString *)url;

/**
用本地资源初始化

@param fileURL 资源路径

@return
*/
- (instancetype)initWithSoruceFile:(NSURL *)fileURL;

/**
加载url

@param url url
*/
- (void)loadUrl:(NSString *)url;

/**
加载一段html

@param hString html字符串
@param url     baseurl
*/
-(void)LoadH5String:(NSString *)hString BaseUrl:(NSString *)url;


@property(nonatomic,copy)WEBLoadFinishBlock     loadFinsh;

/**
加载完成

@param loadFinsh
*/
- (void)setLoadFinsh:(WEBLoadFinishBlock)loadFinsh;


－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
XHLaunchAd（启动广告页）

/**
*  广告点击事件回调
*/
@property(nonatomic,copy)XHLaunchAdClickBlock clickBlock;

/**
*  广告frame
*/
@property (nonatomic, assign) CGRect adFrame;

/**
*  是否影藏'倒计时/跳过'按钮(默认显示)
*/
@property (nonatomic ,assign) BOOL hideSkip;

/**
*  初始化启动页广告
*
*  @param frame    广告frame
*  @param duration 广告停留时间
*
*  @return 启动页广告
*/
- (instancetype)initWithFrame:(CGRect)frame andDuration:(NSInteger)duration;

/**
*  设置广告图片urlString
*
*  @param imgUrlString   图片urlString
*  @param options        缓存机制(默认:XHWebImageDefault)
*  @param completedBlock 异步加载图片完成回调
*/
-(void)imgUrlString:(NSString *)imgUrlString options:(XHWebImageOptions)options completed:(XHWebImageCompletionBlock)completedBlock;
- (void)addInWindow;

－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

HttpTool（基于afnetworking网络请求封装，带缓存处理，可根据具体的需求，无网时显示历史请求数据）

/**
*  总的请求，包含cache
*
*  @param cacheType   缓存的类型
*  @param requestType  请求类型
*  @param params 请求的参数
*  @param oldData 返回历史数据的回调
*  @param success 请求成功后的回调
*  @param failure 请求失败后的回调
*/
+ (void)requestHttpWithCacheType:(HttpCacheType)cacheType requestType:(HttpRequestType)requestType  url:(NSString *)url params:(NSDictionary *)params OldDataBlock:(successBlock)oldData success:(successBlock)success failure:(void (^)(NSError *))failure;


+ (void)clearAllLocalHttpCache:(clearHttpCacheBlock)block;/**<清除所有本地http缓存*/


－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

JPUSHService+Tool（对极光推送sdk进行了处理，使用户使用更加简单明了，完全不需要参考极光文档，只需要使用JPUSHService+Tool就可以集成）

@class JPUSHService;

@protocol JPUSHServiceToolDelegate <NSObject>
//用户点击通知时
- (void)jpushtool_TapNotification:(NSDictionary *)userInfo;

//在前台时收到通知 是否显示消息框
- (BOOL)jpushtool_ShowNotificationActiveReceiveNotification:(NSDictionary *)userInfo;

@end



@interface JPUSHService (Tool)


/**
启动sdk 适配ios8-ios10 并且回调注册成功的registrationID

@param option
@param appkey
@param isProduction      是否正式环境
@param delegate
@param completionHandler 注册成功回调
*/
+ (void)startWithOption:(NSDictionary *)option Appkey:(NSString *)appkey ApsForProduction:(BOOL)isProduction Delegete:(id<JPUSHServiceToolDelegate>)delegate registrationIDCompletionHandler:(void (^)(int, NSString *))completionHandler;


/**
该方法用在启动app时判断是否有远程通知信息，如果有，会执行用户点击通知协议
进入app调用 在didFinishLaunchingWithOptions方法的最后调用 《固定写》

@param option app信息字典
*/
+ (void)jpushToolEnterAPPWithOption:(NSDictionary *)option;

#pragma mark ios8以上 ios10 以下系统 通知相关处理
+ (void)application:(UIApplication *)application didReceiveNotificationUnderIOS10:(NSDictionary *)userInfo;

@end

