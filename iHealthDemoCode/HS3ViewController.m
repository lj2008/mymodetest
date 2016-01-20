//
//  HS3ViewController.m
//  testCommicationMode
//
//  Created by Mac on 15/12/10.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import "HS3ViewController.h"
#import "CommUser.h"
#import "HS3Controller.h"
#import "BasicCommunicationObject.h"
@interface HS3ViewController ()

@end

@implementation HS3ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForHS3:) name:DeviceConnect object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForHS3:) name:DeviceDisconnect object:nil];

    [HS3Controller shareIHHs3Controller];
    [[BasicCommunicationObject basicCommunicationObject]startAllBtleDevice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - HS3
// HS3断开测量连接(注册消息)
-(void)DeviceDisConnectForHS3:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}

/*
 HS3创建测量连接(注册消息)
 */
-(void)DeviceConnectForHS3:(NSNotification *)tempNoti{
    // 初始化HS3控制类
    HS3Controller *controller = [HS3Controller shareIHHs3Controller];
    // 接收到 HS3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS3实例调用通讯相关接口
        HS3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 暂不处理
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

/* 初始化秤的初始设置（建立通道 收到时间 收到序列号 同步时间）ios 多合一V3.0未用*/
- (IBAction)commandInitMeasureWeightID:(id)sender {
    // 初始化HS3控制类
    HS3Controller *controller = [HS3Controller shareIHHs3Controller];
    // 接收到 HS3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS3实例调用通讯相关接口
        HS3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 初始化秤的初始设置
        [bpInstance commandInitMeasureWeightID:^(NSString *weightID) {
            // 应该为返回称ID
            NSLog(@"返回HS3称ID为:%@",weightID);
            self.ResultData.text = [NSString stringWithFormat:@"返回HS3称ID为:%@",weightID];
            
        } FinishInit:^{
            NSLog(@"HS3称初始化完成");
            
        } DisposeErrorBlock:^(HS3DeviceError errorID) {
            // 返回HS3通讯错误代码
            NSLog(@"your HS3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

/* 开始测量 */
- (IBAction)commandMeasureStableWeight:(id)sender {
    // 初始化HS3控制类
    HS3Controller *controller = [HS3Controller shareIHHs3Controller];
    // 接收到 HS3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS3实例调用通讯相关接口
        HS3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 开始测量
        [bpInstance commandMeasureStableWeight:^(NSDictionary *StableWeight) {
            // 稳定体重，单位Kg
            NSLog(@"HS3测量的稳定体重为%@",StableWeight);
            self.ResultData.text = [NSString stringWithFormat:@"HS3测量的稳定体重为%@",StableWeight];
        } DisposeErrorBlock:^(HS3DeviceError errorID) {
            // 返回HS3通讯错误代码
            NSLog(@"your HS3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS3 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

/* 关闭回连开关 */
- (IBAction)commandTurnOffBTConnect:(id)sender {
    // 初始化HS3控制类
    HS3Controller *controller = [HS3Controller shareIHHs3Controller];
    // 接收到 HS3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS3实例调用通讯相关接口
        HS3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 关闭回连开关
        [bpInstance commandTurnOffBTConnectAutoResult:^(BOOL resetSuc) {
            if (resetSuc == YES) {
                NSLog(@"HS3关闭回连开关成功");
                self.ResultData.text = @"HS3关闭回连开关成功";
            }else{
                NSLog(@"HS3关闭回连开关失败");
                self.ResultData.text = @"HS3关闭回连开关失败";
            }
        } DisposeErrorBlock:^(HS3DeviceError errorID) {
            // 返回HS3通讯错误代码
            NSLog(@"your HS3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

/* 打开回连开关 */
- (IBAction)commandTurnOnBTConnect:(id)sender {
    // 初始化HS3控制类
    HS3Controller *controller = [HS3Controller shareIHHs3Controller];
    // 接收到 HS3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS3实例调用通讯相关接口
        HS3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 打开回连开关
        [bpInstance commandTurnOnBTConnectAutoResult:^(BOOL resetSuc) {
            if (resetSuc == YES) {
                NSLog(@"HS3打开回连开关成功");
                self.ResultData.text = @"HS3打开回连开关成功";
            }else{
                NSLog(@"HS3打开回连开关失败");
                self.ResultData.text = @"HS3打开回连开关失败";
            }
        } DisposeErrorBlock:^(HS3DeviceError errorID) {
            // 返回HS3通讯错误代码
            NSLog(@"your HS3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS3 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

/* 上传历史数据（询问未上传数据条数  传输历史数据）V3.0用*/
- (IBAction)commandInitMeasureWeightID3:(id)sender {
    // 初始化HS3控制类
    HS3Controller *controller = [HS3Controller shareIHHs3Controller];
    // 接收到 HS3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS3实例调用通讯相关接口
        HS3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 上传历史数据
        [bpInstance commandInitMeasureWeightID:^(NSString *weightID) {
              // 此返回参数未用
             // 上传历史数据称ID
            NSLog(@"上传历史数据称ID为:%@",weightID);
            self.ResultData.text = [NSString stringWithFormat:@"上传历史数据称ID:%@",weightID];
            
        } TransferMemorryData:^(BOOL startTransmission) {
            // 开始记忆传输，成功Yes，失败No
            if (startTransmission == YES) {
                NSLog(@"HS3开始上传历史数据成功");
            }else{
                NSLog(@"HS3开始上传历史数据失败");
            }
            
        } UploadDataNum:^(NSNumber *uploadDataNum) {
            // 记忆总条数，0～200
            NSLog(@"上传历史数据总条数为:%@",uploadDataNum);
            self.ResultData.text = [NSString stringWithFormat:@"上传历史数据总条数为为:%@",uploadDataNum];
            
        } DisposeProgress:^(float progress) {
            // 记忆传输进度，0.0～1.0
            NSLog(@"历史数据传输进度为:%f",progress);
            self.ResultData.text = [NSString stringWithFormat:@"历史数据传输进度为:%f",progress];
            
        } MemorryData:^(NSDictionary *historyDataDic) {
            NSLog(@"HS3上传的历史数据为:%@",historyDataDic);
            self.ResultData.text = [NSString stringWithFormat:@"HS3上传的历史数据为:%@",historyDataDic];
            
        } FinishTransmission:^{
            NSLog(@"HS3称上传历史数据结束");
             self.ResultData.text =@"HS3称上传历史数据结束";
            
        } DisposeErrorBlock:^(HS3DeviceError errorID) {
            // 返回HS3通讯错误代码
            NSLog(@"your HS3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
    
}
@end
