//
//  HS4ViewController.m
//  testCommicationMode
//
//  Created by Mac on 15/12/10.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//
#import "HS4ViewController.h"
#import "CommUser.h"
#import "HS4Controller.h"
#import "HS4.h"
#import "BasicCommunicationObject.h"

@interface HS4ViewController ()

@end

@implementation HS4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForHS4:) name:DeviceConnect object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForHS4:) name:DeviceDisconnect object:nil];
    
    [HS4Controller shareIHHs4Controller];
    [[BasicCommunicationObject basicCommunicationObject]startAllBtleDevice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - HS4
// HS4断开测量连接(注册消息)
-(void)DeviceDisConnectForHS4:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}

/*
 HS4创建测量连接(注册消息)
 */
-(void)DeviceConnectForHS4:(NSNotification *)tempNoti{
    // 初始化HS4控制类
    HS4Controller *controller = [HS4Controller shareIHHs4Controller];
    // 接收到 HS4ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS4Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS4实例调用通讯相关接口
        HS4 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 暂不处理
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}


// 开始记忆传输
- (IBAction)commandTransferMemorryData:(id)sender {
    // 初始化HS4控制类
    HS4Controller *controller = [HS4Controller shareIHHs4Controller];
    // 接收到 HS4ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS4Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS4实例调用通讯相关接口
        HS4 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 开始记忆传输
        [bpInstance commandTransferMemorryData:^(NSDictionary *startDataDictionary) {
            // 开始传输数据
            NSLog(@"startDataDictionary为:%@",startDataDictionary);
            self.ResultData.text = [NSString stringWithFormat:@"startDataDictionary为:%@",startDataDictionary];
            
        } DisposeProgress:^(NSNumber *progress) {
            // 记忆传输进度，0.0～1.0
            NSLog(@"记忆传输进度为:%@",progress);
            self.ResultData.text = [NSString stringWithFormat:@"记忆传输进度为:%@",progress];
            
        } MemorryData:^(NSArray *historyDataArray) {
            // 记忆内容，包括体重（kg）、测量时间，相应key：weight、date
            NSLog(@"记忆内容为:%@",historyDataArray);
            self.ResultData.text = [NSString stringWithFormat:@"记忆内容为为:%@",historyDataArray];
            
        } FinishTransmission:^{
            // 记忆传输结束
            NSLog(@"记忆传输结束");
            self.ResultData.text = @"记忆传输结束";
        } DisposeErrorBlock:^(HS4DeviceError errorID) {
            // 返回HS4通讯错误代码
            NSLog(@"your HS4 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS4 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 启动在线测量
- (IBAction)commandMeasureWeight:(id)sender {
    // 初始化HS4控制类
    HS4Controller *controller = [HS4Controller shareIHHs4Controller];
    // 接收到 HS4ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS4Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS4实例调用通讯相关接口
        HS4 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 启动在线测量
        // 设置体重单位,HS4显示单位，HSUnit_Kg、HSUnit_LB、HSUnit_ST
        // 0 ，1，2
        NSNumber *hs4Weight = @1;
        
        [bpInstance commandMeasureWeight:^(NSNumber *unStableWeight) {
            // 时时体重，单位kg
            NSLog(@"时时体重为:%@",unStableWeight);
            self.ResultData.text = [NSString stringWithFormat:@"时时体重为:%@",unStableWeight];
            
        } StableWeight:^(NSNumber *StableWeight) {
            // 稳定体重，单位kg
            NSLog(@"稳定体重为:%@",StableWeight);
            self.ResultData.text = [NSString stringWithFormat:@"稳定体重为:%@",StableWeight];
            
        } DisposeErrorBlock:^(HS4DeviceError errorID) {
            // 返回HS4通讯错误代码
            NSLog(@"your HS4 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS4 error id:%d",errorID];
        } setUnit:hs4Weight];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 结束测量或结束传输数据
- (IBAction)commandEndCurrentConnection:(id)sender {
    // 初始化HS4控制类
    HS4Controller *controller = [HS4Controller shareIHHs4Controller];
    // 接收到 HS4ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS4Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS4实例调用通讯相关接口
        HS4 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 结束当前连接
        [bpInstance commandEndCurrentConnection:^(BOOL resetSuc) {
            if (resetSuc == YES) {
                NSLog(@"结束测量或结束传输数据成功");
                self.ResultData.text = @"结束测量或结束传输数据成功";
            }else{
                NSLog(@"结束测量或结束传输数据失败");
                self.ResultData.text = @"H结束测量或结束传输数据失败";
            }
        } DisposeErrorBlock:^(HS4DeviceError errorID) {
            // 返回HS4通讯错误代码
            NSLog(@"your HS4 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS4 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}
@end
