//
//  YINSocketViewController.m
//  BL_BaseApp
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "YINSocketViewController.h"

//自动重连次数
/*******************Socket**************************/

//#define TCP_beatBody  @"beatID"    //心跳标识
//#define TCP_AutoConnectCount  3    //自动重连次数
//#define TCP_BeatDuration  1        //心跳频率
//#define TCP_MaxBeatMissCount   3   //最大心跳丢失数

@interface YINSocketViewController ()<GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate>

@property (weak, nonatomic) IBOutlet UITextView *serviceBOx;
@property (weak, nonatomic) IBOutlet UITextView *clientBox;
@property (weak, nonatomic) IBOutlet UITextField *iptextF;
@property (weak, nonatomic) IBOutlet UITextField *serviceTextF;
@property (weak, nonatomic) IBOutlet UITextField *clientTextF;

//应用统筹服务端
@property(nonatomic,strong)GCDAsyncSocket *serviceClientSocket;

//本机作为服务端
@property(nonatomic,strong)GCDAsyncSocket *appService;

//本机作为服务端udp
@property(nonatomic,strong)GCDAsyncUdpSocket *appUpdService;

//p2p 所有服务端
@property(nonatomic,strong)NSMutableArray *services;

//p2p 所有连接自己的客户
@property(nonatomic,strong)NSMutableArray *clients;


@property(nonatomic,strong)NSMutableArray       *ips;

//心跳控制
//@property(nonatomic,strong)dispatch_source_t    beatTimer;
//@property(nonatomic,assign)NSInteger  senBeatCount;

@end

@implementation YINSocketViewController


- (void)disconnect
{
    //断开连接
    [self.serviceClientSocket disconnect];
//    //关闭心跳定时器
//    dispatch_source_cancel(self.beatTimer);
//    //未接收到服务器心跳次数,置为初始化
//    _senBeatCount = 0;
}


- (void)connect{
    // 2. 与服务器的socket链接起来
    NSError *error = nil;
    BOOL result = [self.serviceClientSocket connectToHost:@"47.97.186.232" onPort:1234 error:&error];

}

- (GCDAsyncSocket *)serviceClientSocket{
    if (!_serviceClientSocket) {
        _serviceClientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _serviceClientSocket;
}

- (GCDAsyncSocket *)appService{
    if (!_appService) {
        _appService = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _appService;
}

- (GCDAsyncUdpSocket *)appUpdService{
    if (!_appUpdService) {
        _appUpdService = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _appUpdService;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iptextF.text = @"14.104.83.175:";
    [self connect];
    self.ips = @[].mutableCopy;
    self.services = @[].mutableCopy;
    self.clients = @[].mutableCopy;
}

#pragma mark - GCDAsyncSocketDelegate
// 链接服务器端成功, 客户端获取地址和端口号
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if ([sock isEqual:self.serviceClientSocket]) {
        NSData *data = [@"getip" dataUsingEncoding:NSUTF8StringEncoding];
        [self.serviceClientSocket writeData:data withTimeout:-1 tag:0];
    }else{
        [self.services addObject:sock];
    }
    [sock readDataWithTimeout:-1 tag:0];
}

//123.147.250.164:59753
//14.104.83.175:47170

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    //    //如果是主动断开连接
    //    if (_connectStatus == SocketConnectStatus_DisconnectByUser) return;
    //置为未连接状态
    //自动重连
    [self connect];
}

//有新的客户端连接自己
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    [MBProgressHUD showSuccess:@"有客户端连接"];
    [self.clients addObject:newSocket];
    [newSocket readDataWithTimeout:-1 tag:0];
}

// 客户端已经获取到内容
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([content containsString:@"ip:"]) {
        //获取到自身ip
        [[[UIAlertView alloc] initWithTitle:@"ip" message:[content componentsSeparatedByString:@":"].mj_JSONString delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
        //以自身端口号开启监听
        if ([self.appService acceptOnPort:[content componentsSeparatedByString:@":"].lastObject.integerValue error:nil]
            ) {
//            [self.appService readDataWithTimeout:-1 tag:0];
            [self.serviceClientSocket writeData:[@"getips" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        }
        [self.appUpdService bindToPort:[content componentsSeparatedByString:@":"].lastObject.integerValue error:nil];
        [self.appUpdService beginReceiving:nil];
    }else if ([content containsString:@"ips:"]){
        //获取到ip列表
        NSMutableArray *arr = [content componentsSeparatedByString:@":"].mutableCopy;
        [arr removeObjectAtIndex:0];
        self.ips = [[arr componentsJoinedByString:@":"] componentsSeparatedByString:@","].mutableCopy;
//        [self.ips enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        }];
    }else if ([content containsString:@"well"]){
        //
        
    }else if ([content containsString:@"cli"]){
        //获取到即将加入的客户ip
        
    }else if([content containsString:@"appService:"]){
        //获取到app服务端发送的消息
        self.clientBox.text = [self.clientBox.text stringByAppendingString:[content substringFromIndex:11]];
    }else if([content containsString:@"appClient:"]){
        //获取到app客户端发送的消息
        self.serviceBOx.text = [self.serviceBOx.text stringByAppendingString:[content substringFromIndex:10]];
    }
    [sock readDataWithTimeout:-1 tag:0];

}

#pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext{
     NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     self.serviceBOx.text = [self.serviceBOx.text stringByAppendingString:[content substringFromIndex:11]];
}




- (IBAction)clientSend:(id)sender {
    [self.appUpdService sendData:[[@"appClient:" stringByAppendingString:self.clientTextF.text] dataUsingEncoding:NSUTF8StringEncoding] toHost:[self.iptextF.text componentsSeparatedByString:@":"].firstObject port:[self.iptextF.text componentsSeparatedByString:@":"].lastObject.integerValue withTimeout:-1 tag:0];
    [self.services enumerateObjectsUsingBlock:^(GCDAsyncSocket * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *data = [[@"appClient:" stringByAppendingString:self.clientTextF.text] dataUsingEncoding:NSUTF8StringEncoding];
        [obj writeData:data withTimeout:-1 tag:0];
    }];
}

- (IBAction)serviceSendAll:(id)sender {
    [self.clients enumerateObjectsUsingBlock:^(GCDAsyncSocket * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *data = [[@"appService:" stringByAppendingString:self.serviceTextF.text] dataUsingEncoding:NSUTF8StringEncoding];
        [obj writeData:data withTimeout:-1 tag:0];
    }];
}



- (IBAction)linkToIP:(id)sender {
    GCDAsyncSocket *service = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [service connectToHost:[self.iptextF.text componentsSeparatedByString:@":"].firstObject onPort:[self.iptextF.text componentsSeparatedByString:@":"].lastObject.integerValue error:nil];
}


@end
