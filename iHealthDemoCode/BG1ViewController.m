//
//  BG1ViewController.m
//  testCommicationMode
//
//  Created by Mac on 15/12/14.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BG1ViewController.h"
#import "BG1Controller.h"
#import "BG1.h"
#import "BG1CommunicationClass.h"

@interface BG1ViewController ()

@end

@implementation BG1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForBG1:) name:BG1ConnectNoti object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBG1:) name:BG1DisConnectNoti object:nil];
//  获取BG1Controller实例，并完成音频底层的初始化
    [BG1Controller shareBG1Controller];
}
#pragma mark - BG1
// BG1断开测量连接(注册消息调BG1断开连接方法)
-(void)DeviceDisConnectForBG1:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}

// BG1创建测量连接(注册消息调BG1创建连接方法)
-(void)DeviceConnectForBG1:(NSNotification *)tempNoti{

}


// 获取BG1是否连接的信息，并在连接完成后返回IDPS信息
- (IBAction)commandCreateConnect:(id)sender {
    // 创建BG1实例
    BG1CommunicationClass *bgInstance  = [BG1CommunicationClass shareBG1CommunicationObject];
    // 有设备存在的时候
    if (bgInstance != nil) {
        [bgInstance commandCreateConnect:^(BOOL result) {
            if (result == true) {
                NSLog(@"BG1连接完成 HAHA");
                self.ResultData.text = @"BG1连接完成 HAHA";
            }
            
        } Authentication:^(BOOL result) {
            // BG1通信认证
            if (result == YES) {
                NSLog(@"BG1通信认证成功");
                self.ResultData.text = @"BG1通信认证成功";
            }else{
                NSLog(@"BG1通信认证失败");
                self.ResultData.text = @"BG1通信认证失败";
            }
        } DisposeBGIDPSBlock:^(NSDictionary *idpsDic) {
            // BG1的IDPS信息
            // { FW = 1305; HD= "13.6.0"; SerialNub = 033d7555ab;
            // StateFlg = 02;}

            NSLog(@"BG1的IDPS信息为:%@",idpsDic);
            self.ResultData.text = [NSString stringWithFormat:@"BG1的IDPS信息为:%@",idpsDic];
            
        } DisposeBGErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG1 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG1 error id:%@",errorID];
        }];
          }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// BG1连接完成后发送CODE，并返回CODE发送结果以及测量过程中的插条，滴血，血糖结果，及错误ID
- (IBAction)commandCreateBGtestWithCode:(id)sender {
    // 创建BG1实例调用通讯相关接口
    BG1CommunicationClass *bgInstance  = [BG1CommunicationClass shareBG1CommunicationObject];
    // 有设备存在的时候
    if (bgInstance != nil) {

        // 扫描试瓶上的二维码所得到的CODE字符串
        NSString *codeStrips = CodeStr;
        [bgInstance commandCreateBGtestWithCode:codeStrips DisposeBGSendCodeBlock:^(BOOL sendOk) {
            // 当Code发送完成时返回
            NSLog(@"Code发送完成");
            self.ResultData.text = @"Code发送完成";
        } DisposeBGStripInBlock:^(BOOL stripIn) {
            // 有下位机发送试条插入指令时返回
            NSLog(@"有试条插入");
            self.ResultData.text = @"有试条插入";
            
        } DisposeBGBloodBlock:^(BOOL blood) {
            // 当下位机发送滴血指令时返回
            NSLog(@"发送滴血指令");
            self.ResultData.text = @"发送滴血指令";
            
        } DisposeBGResultBlock:^(NSNumber *result) {
            // 当下位机发送血糖结果时返回
            NSLog(@"发送血糖结果值为:%@",result);
            self.ResultData.text = [NSString stringWithFormat:@"发送血糖结果值为:%@",result];
            
        } DisposeBGStripOutBlock:^(BOOL stripOut) {
            // 有下位机发送试条拔出指令时返回
            NSLog(@"发送试条拔出指令");
            self.ResultData.text = @"发送试条拔出指令";
            
        } DisposeBGErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG1 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG1 error id:%@",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}
@end
