//
//  ApplicationContext.m
//  NanShaProject
//
//  Created by 马腾飞 on 16/4/4.
//  Copyright © 2016年 chains. All rights reserved.
//

#import "ApplicationContext.h"

#define TCP_HOST @"172.17.19.31"
#define TCP_PORT  30101

@implementation ApplicationContext

static ApplicationContext *sharedInstance = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

+ (ApplicationContext *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ApplicationContext alloc] init];
    });
    
    return sharedInstance;
}



#pragma mark - TCPSocket
- (GCDAsyncSocket *)tcpSocket
{
    if (!_tcpSocket)
    {
        _tcpSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        _tcpSocket.delegate = self;
    }
    return _tcpSocket;
}

- (void)sendTCPInstructWithData:(NSString *)dataStr timeout:(NSTimeInterval)timeout tag:(long)tag
{
    if (self.tcpSocket.isDisconnected)
    {
        NSError *error = nil;
        [_tcpSocket connectToHost:TCP_HOST onPort:TCP_PORT withTimeout:-1 error:&error];
        if (error!=nil) {
            NSLog(@"TCP 连接失败：%@",error);
        }else{
            NSLog(@"TCP 连接成功");
        }
    }
    [self.tcpSocket writeData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:timeout tag:tag];
    //如果不需要长连接请根据实际情况断开连接！！！
    [self.tcpSocket disconnectAfterWriting];
}

#pragma mark - AsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"TCP willDisconnectWithError");
    if (err) {
        NSLog(@"错误报告：%@",err);
    }else{
        NSLog(@"连接工作正常");
    }
    _tcpSocket = nil;
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"%@ didAcceptNewSocket:%@",sock,newSocket);
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"TCP didConnectToHost:%@ port:%d",host,port);
    NSData *writeData = [@"connected\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:writeData withTimeout:-1 tag:0];
    [sock readDataWithTimeout:0.5 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length])];
    NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    if(msg)
    {
        NSLog(@"TCP didReadData:%@",msg);
    }
    else
    {
        NSLog(@"TCP didReadDataFailed");
    }
    [sock readDataWithTimeout:-1 tag:0]; //一直监听网络
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"TCP didWriteDataWithTag:%ld",tag);
}

#pragma mark - UDPSocket
- (GCDAsyncUdpSocket *)udpSocket
{
    if (!_udpSocket)
    {
        //创建一个后台队列 等待接收数据
        dispatch_queue_t udpQueue = dispatch_queue_create("UDP queue", NULL);
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:udpQueue];
        NSError *error = nil;
        if (error!=nil)
        {
            NSLog(@"UDP连接失败：%@",error);
        }
        else
        {
            NSLog(@"UDP连接成功");
        }
        
        if (![_udpSocket bindToPort:2002 error:&error])//绑定本机端口号
        {
            NSLog(@"UDP Error starting server (bind): %@", error);
        }
        if (![_udpSocket enableBroadcast:YES error:&error])
        {
            NSLog(@"UDP Error enableBroadcast (bind): %@", error);
        }
        if (![_udpSocket beginReceiving:&error])
        {
            [_udpSocket close];
            NSLog(@"UDP Error starting server (recv): %@", error);
        }
    }
    return _udpSocket;
}



- (void)sendUDPInstructWithData:(NSString *)dataStr port:(uint16_t)port host:(NSString *)host tag:(long)tag
{
    [self.udpSocket sendData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] toHost:host port:port withTimeout:-1 tag:tag];
}

#pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address
{
    NSError *error = nil;
    NSLog(@"UDP Message didConnectToAddress: %@",[[NSString alloc]initWithData:address encoding:NSUTF8StringEncoding]);
    [_udpSocket beginReceiving:&error];
    // [sock readDataWithTimeout:-1 tag:0];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    NSLog(@"UDP Message didNotConnect: %@",error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"UDP Message didNotSendDataWithTag: %@",error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"UDP filterContext is %@",filterContext);
    NSLog(@"UDP Message didReceiveData :[%@:%d] %@",ip ,port, s);
    // [sock sendData:data toAddress:address withTimeout:-1 tag:0]; //一直监听
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"UDP Message didSendDataWithTag:%ld",tag);
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"UDP Message withError: %@",error);
}

@end
