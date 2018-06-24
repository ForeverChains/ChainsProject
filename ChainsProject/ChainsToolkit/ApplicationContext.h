//
//  ApplicationContext.h
//  NanShaProject
//
//  Created by 马腾飞 on 16/4/4.
//  Copyright © 2016年 chains. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"


@interface ApplicationContext : NSObject

@property (strong, nonatomic) User *currentUser;
@property (nonatomic, strong) CLLocation *location;

+ (ApplicationContext *)sharedInstance;


@property (strong, nonatomic) GCDAsyncSocket *tcpSocket;
@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket;

- (void)sendTCPInstructWithData:(NSString *)dataStr timeout:(NSTimeInterval)timeout tag:(long)tag;
- (void)sendUDPInstructWithData:(NSString *)dataStr port:(uint16_t)port host:(NSString *)host tag:(long)tag;


@property (strong, nonatomic) Owner *owner;
@property (assign, nonatomic) BOOL beOnline;//是否已经上架
@property (copy, nonatomic) void(^blockGiveUpLogin)(void);

@end
