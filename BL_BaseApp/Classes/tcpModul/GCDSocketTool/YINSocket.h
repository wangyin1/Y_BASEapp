//
//  YINSocket.h
//  BL_BaseApp
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"

typedef enum : NSUInteger {
    YINSocketEventConnectSucceed,//连接成功 / 有新的客户机连接
    YINSocketEventConnectError,//断开连接 / 有客户机断开连接
    YINSocketEventRecive,//收到消息
} YINSocketEventStatus;


typedef void(^YINSocketEventBlock)(YINSocketEventStatus status,id socket,NSString *message);



@interface YINSocket : NSObject

//客户机主动断开 tcp udp通用
- (void)close;

//---------------tcp 面向连接的socket---------------

//初始化一个客户端 app开发一般只需要socket客户端
+ (instancetype)tcpSocket;

//设置断开自动重连次数 默认为5 如果五次连接都失败，则触发YINSocketEventConnectError
@property(nonatomic,assign)NSInteger   autoConnect;

//连接服务端 host可以是网络解析地址，不需要传port。如果是ip需要传host和port
- (BOOL)tcpConnectToHost:(NSString *)host onPort:(NSString *)port eventBlock:(YINSocketEventBlock)block;

//向服务端发送消息
- (void)tcpSendToService:(NSString *)str;


//初始化一个服务端 一些特殊的p2p需求 要用app作为服务端
+ (instancetype)tcpSocketService;

//已连接自己的所有客户端
@property(nonatomic,strong,readonly)NSMutableArray<GCDAsyncSocket *>   *tcpClients;

//服务端开启一个端口用于监听事件
- (BOOL)tcpAcceptOnPort:(NSString *)port eventBlock:(YINSocketEventBlock)block;

//服务端向客户机发送消息，clinet为nil为广播
- (void)tcpSendDataString:(NSString *)str toClient:(GCDAsyncSocket *)client;

//服务端主动断开客户机 nil为断开所有连接
- (void)tcpCloseTcpClient:(GCDAsyncSocket *)client;






//---------------udp 非连接的socket 也可以连接---------------
+ (instancetype)udpSocket;

//开启端口 可以接收udp消息
- (BOOL)udpBindOnPort:(NSString *)port eventBlock:(YINSocketEventBlock)block;

//向ip发送消息 ip要加端口号
- (void)udpSendDataStr:(NSString *)str toIP:(NSString *)ip;

//连接一个地址。如果连接，则只能发送和接收此地址的消息 一般情况使用udp都是非连接
- (BOOL)udpConnectToHost:(NSString *)host onPort:(NSString *)port;


//
//加入一个组 发送消息时组内所有成员都能收到消息 需要传一个ip不需要端口
//- (BOOL)udpJoinGroup:(NSString *)ip;
@end
