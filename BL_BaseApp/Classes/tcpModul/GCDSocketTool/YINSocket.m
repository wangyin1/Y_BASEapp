//
//  YINSocket.m
//  BL_BaseApp
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "YINSocket.h"

@interface YINSocket ()<GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate>

@property(nonatomic,strong)GCDAsyncSocket *tcpService;


@property(nonatomic,strong)dispatch_source_t   beatTimer;
@property(nonatomic,copy)NSString  *ipStr;
@property(nonatomic,copy)NSString  *portStr;
@property(nonatomic,strong)GCDAsyncSocket *tcpClient;

@property(nonatomic,strong)GCDAsyncUdpSocket *udp;

@property(nonatomic,copy)YINSocketEventBlock  eventBlock;

@property(nonatomic,assign)NSInteger  connectCount;
@property(nonatomic,assign)NSInteger  count;

@property(nonatomic,strong)NSMutableArray<GCDAsyncSocket *>   *tcpClients;
@end

@implementation YINSocket

- (void)dealloc
{
    [self close];
    _tcpClient.delegate = nil;
    _tcpService.delegate = nil;
    _udp.delegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //客户机数组
        self.tcpClients = @[].mutableCopy;
        //断开自动重连次数
        self.autoConnect = 5;
    }
    return self;
}


- (void)setAutoConnect:(NSInteger)autoConnect{
    _autoConnect = autoConnect;
    _connectCount = autoConnect;
}



- (dispatch_source_t)beatTimer
{
    if (!_beatTimer) {
        weakify(self)
        _beatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_beatTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_beatTimer, ^{
            _count+=1;
            if ( ![weak_self tcpConnectToHost:weak_self.ipStr onPort:weak_self.portStr eventBlock:weak_self.eventBlock]&&_count==5) {
                if (weak_self.eventBlock) {
                    weak_self.eventBlock(YINSocketEventConnectError, _tcpClient, @"断开与服务器的连接");
                }
            }
        });
    }
    return _beatTimer;
}

- (void)doAdutoConnect{
    _count=0;
    dispatch_resume(self.beatTimer);
}

- (void)close{
    
    if (self.tcpClient) {
        _connectCount = 0;
        [self.tcpClient disconnect];
    }
    if (self.tcpService) {
        [self.tcpService disconnect];
    }
    if (self.udp) {
        [self.udp close];
    }
}


- (void)tcpCloseTcpClient:(GCDAsyncSocket *)client{
    if (client) {
        [client disconnect];
    }else{
        [self.tcpService disconnect];
    }
}

//初始化一个tcp客户机管理工具
+ (instancetype)tcpSocket{
    YINSocket *tool = [[YINSocket alloc] init];
    tool.tcpClient = [[GCDAsyncSocket alloc] initWithDelegate:tool delegateQueue:dispatch_get_main_queue()];
    return tool;
}

//初始化一个服务机管理工具
+ (instancetype)tcpSocketService{
    YINSocket *tool = [[YINSocket alloc] init];
    tool.tcpService = [[GCDAsyncSocket alloc] initWithDelegate:tool delegateQueue:dispatch_get_main_queue()];
    return tool;
}

//初始化一个udpSocket管理工具
+ (instancetype)udpSocket{
    YINSocket *tool = [[YINSocket alloc] init];
    tool.udp = [[GCDAsyncUdpSocket alloc] initWithDelegate:tool delegateQueue:dispatch_get_main_queue()];
    return tool;
}

//服务端向客户机发送消息，clinet为nil为广播
- (void)tcpSendDataString:(NSString *)str toClient:(GCDAsyncSocket *)client{
    if (self.tcpService) {
        if (client) {
            [client writeData:[str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
        }else{
            
            [self.tcpClients enumerateObjectsUsingBlock:^(GCDAsyncSocket * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj writeData:[str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
            }];
        }
    }
}


//连接
- (BOOL)tcpConnectToHost:(NSString *)host onPort:(NSString *)port eventBlock:(YINSocketEventBlock)block{
    _connectCount = _autoConnect;
    self.ipStr = @"";
    self.portStr = @"";
    if (self.tcpClient) {
        self.ipStr = host;
        self.portStr = port;
        if (block) {
            self.eventBlock = block;
        }
        if ([host containsString:@"http"]) {
            
            return [self.tcpClient connectToUrl:[NSURL URLWithString:host] withTimeout:-1 error:nil];
        }else if (host.length>0&&port.length>0){
            return [self.tcpClient connectToHost:host onPort:port.integerValue error:nil];
        }else{
            return NO;
        }
    }
    return NO;
}

- (BOOL)tcpAcceptOnPort:(NSString *)port eventBlock:(YINSocketEventBlock)block{

    if (self.tcpService) {
        if (block) {
            self.eventBlock = block;
        }
        if (port.length>0) {
            return  [self.tcpService acceptOnPort:port.integerValue error:nil];
        }else{
            return NO;
        }
    }
    return NO;
}

//向服务端发送消息
- (void)tcpSendToService:(NSString *)str{
    if (self.tcpClient) {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [self.tcpClient writeData:data withTimeout:-1 tag:0];
    }
}

#pragma mark - GCDAsyncSocketDelegate
// 链接服务器端成功, 客户端获取地址和端口号
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    dispatch_source_cancel(_beatTimer);
    if (self.eventBlock) {
        self.eventBlock(YINSocketEventConnectSucceed,sock,@"连接服务端成功");
    }
    [sock readDataWithTimeout:-1 tag:0];
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToUrl:(NSURL *)url{
    dispatch_source_cancel(_beatTimer);
    if (self.eventBlock) {
        self.eventBlock(YINSocketEventConnectSucceed,sock,@"连接服务端成功");
    }
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    
    if (_connectCount>0&&self.tcpClient) {
        [self doAdutoConnect];
    }
    if (self.tcpService) {
        if (self.eventBlock) {
            self.eventBlock(YINSocketEventConnectError, sock, @"有客户机断开连接");
        }
        [self.tcpClients removeObject:sock];
    }
}

//有新的客户端连接自己
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    if (self.tcpService) {
        [self.tcpClients addObject:newSocket];
    }
    [newSocket readDataWithTimeout:-1 tag:0];
}

// 已经获取到内容
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (self.eventBlock) {
        self.eventBlock(YINSocketEventRecive, sock, content);
    }
    if (sock==self.tcpClient) {
        //作为客户端收到消息
    }else{
        //作为服务端收到消息
    }
    [sock readDataWithTimeout:-1 tag:0];
}

#pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext{
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (self.eventBlock) {
        self.eventBlock(YINSocketEventRecive, sock, content);
    }
}



//开启端口 可以接收udp消息
- (BOOL)udpBindOnPort:(NSString *)port eventBlock:(YINSocketEventBlock)block{
    if (block) {
        self.eventBlock = block;
    }
    if (self.udp) {
        return  [self.udp bindToPort:port.integerValue error:nil];
    }else{
        return NO;
    }
}

//向ip发送消息
- (void)udpSendDataStr:(NSString *)str toIP:(NSString *)ip{
    if (self.udp) {
        [self.udp sendData:[str dataUsingEncoding:NSUTF8StringEncoding] toHost:[ip componentsSeparatedByString:@":"].firstObject port:[ip componentsSeparatedByString:@":"].lastObject.integerValue withTimeout:-1 tag:0];
    }
}

//连接一个地址。如果连接，则只能发送和接收此地址的消息 一般情况使用udp都是非连接
- (BOOL)udpConnectToHost:(NSString *)host onPort:(NSString *)port{
    if (self.udp) {
        return NO;
    }
    return  [self.udp connectToHost:host onPort:port.integerValue error:nil];
}


@end
