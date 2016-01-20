//
//  BP3ViewController.m
//  testCommicationMode
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BP3ViewController.h"
#import "BP3.h"
#import "BP3Controller.h"
#import "BP3LController.h"

@interface BP3ViewController ()

@end

@implementation BP3ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 注册BP3设备接入消息,调用DeviceConnectForBP3方法创建测量连接
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForBP3:) name:@"BP3DeviceDidConnected" object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBP3:) name:@"BP3DeviceDisConnected" object:nil];
    [BP3Controller shareBP3Controller];
    // 不初始化无法连接
    [BasicCommunicationObject basicCommunicationObject];
}
// 启动测量
/*
 传入参数：
 userID、clientID、clientSecret、disposeAuthenticationBlock，见BP3说明。
 Pressure：测量过程中的压力值，单位mmHg.
 Xiaobo：测量过程中的小波数据集合，有心跳
 xiaoboNoHeart: 测量过程中的小波数据集合，无心跳
 result：测量结果，包括收缩压、舒张压、心率、是否心率不齐四个参数。
 相应key：SYS、DIA、heartRate、irregular
 */
- (IBAction)commandStartMeasure:(id)sender {
    // 初始化BP3控制类
    BP3Controller *controller = [BP3Controller shareBP3Controller];
    // 接收到 BP3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentBP3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BP3实例调用通讯相关接口
        BP3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 创建测量连接
        [bpInstance commandStartMeasure:^(NSArray *pressureArr) {
            // 测量过程中的压力值，单位mmHg
            NSLog(@"Pressure:%@",pressureArr);
            self.ResultData.text = [NSString stringWithFormat:@"Pressure :%@",pressureArr];
        } xiaoboWithHeart:^(NSArray *xiaoboArr) {
            // 测量过程中的小波数据集合，有心跳
            
        } xiaoboNoHeart:^(NSArray *xiaoboArr) {
            // 测量过程中的小波数据集合，无心跳
        } result:^(NSDictionary *dic) {
            // 测量结果，包括收缩压、舒张压、心率、是否心率不齐四个参数。
            // 相应key：SYS、DIA、heartRate、irregular
            NSLog(@"your Result dic:%@",dic);
            self.ResultData.text = [NSString stringWithFormat:@"your Result dic:%@",dic];
        } errorBlock:^(BP3DeviceError error) {
            NSLog(@"your measure pressure error id:%d",error);
            self.ResultData.text = [NSString stringWithFormat:@"your measure pressure error id:%d",error];
            
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device                                  cc   :date:%@",[NSDate date]];
    }
    
}

// 停止测量功能
/*
 返回参数：
 result：成功返回YES,失败返回 NO.
 */
- (IBAction)stopBPMeasure:(id)sender {
    // 初始化BP3控制类
    BP3Controller *controller = [BP3Controller shareBP3Controller];
    // 接收到 BP3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentBP3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BP3实例调用通讯相关口
        BP3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance stopBPMeassure:^(BOOL result) {
            
            NSLog(@"停止测量中");
            self.ResultData.text =@"停止测量中";
        } ErrorBlock:^(BP3DeviceError error) {
            NSLog(@"your measure pressure error id:%d",error);
            self.ResultData.text = [NSString stringWithFormat:@"your error id:%d",error];
            
        }];
        
    }else{
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 查询电池电量功能
/*
 energyValue：返回电池电量百分比，如80代表80%
 */
- (IBAction)commandEnergy:(id)sender {
    // 初始化BP3控制类
    BP3Controller *controller = [BP3Controller shareBP3Controller];
    // 接收到 BP3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentBP3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BP3实例调用通讯相关接口
        BP3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandEnergy:^(NSNumber *energyValue) {
            NSLog(@"设备电池电量为:%@",energyValue);
            self.ResultData.text = [NSString stringWithFormat:@"设备电池电量为:%@",energyValue];
        } errorBlock:^(BP3DeviceError error) {
            NSLog(@"error id:%d",error);
            self.ResultData.text = [NSString stringWithFormat:@"your measure pressure error id:%d",error];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}
@end