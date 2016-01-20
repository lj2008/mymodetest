//
//  PO3ViewController.m
//  testCommicationMode
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PO3ViewController.h"
#import "PO3Controller.h"
#import "PO3.h"
#import "BasicCommunicationObject.h"
@interface PO3ViewController ()

@end

@implementation PO3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForPO3:) name:@"PO3DeviceDidConnected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForPO3:) name:@"PO3DeviceDisConnected" object:nil];
    [PO3Controller shareIHPO3Controller];
    [BasicCommunicationObject basicCommunicationObject];
    [[BasicCommunicationObject basicCommunicationObject] startSearchBTLEDevice:BtleType_PO3];
}
#pragma mark - PO3
// PO3断开测量连接(注册消息)
-(void)DeviceDisConnectForPO3:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}

/*
 PO3创建测量连接(注册消息)
 */
-(void)DeviceConnectForPO3:(NSNotification *)tempNoti{
    // 初始化PO3控制类
    PO3Controller *controller = [PO3Controller shareIHPO3Controller];
    // 接收到 PO3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentPO3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建PO3实例调用通讯相关接口
        PO3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 实时测量
        [bpInstance commandPO3SyncTimeResultBlock:^(BOOL resetSuc) {
            // 收到同步时间确认
            if (resetSuc == YES) {
                NSLog(@"收到同步时间确认");
                self.ResultData.text = @"收到同步时间确认";
            }else{
                NSLog(@"收到同步时间确认失败");
                self.ResultData.text = @"收到同步时间确认失败";
            }
            
        } StartMeasureBlock:^(BOOL resetSuc) {
            // 开始传输数据
            if (resetSuc == YES) {
                NSLog(@"开始传输数据成功");
                self.ResultData.text = @"开始传输数据成功";
            }else{
                NSLog(@"开始传输数据失败");
                self.ResultData.text = @"开始传输数据失败";
            }
            
        } MeasuringDataBlock:^(NSDictionary *measureDataDic) {
            // 正在接受数据
            // 返回血氧值，脉率、脉搏强度、PI，相应key：spo2、bpm、wave、PI
            NSLog(@"返回血氧值：%@",measureDataDic);
            self.ResultData.text = [NSString stringWithFormat:@"返回血氧值:%@",measureDataDic];
        } FinishMeasure:^(BOOL resetSuc) {
            // 结束测量确认
            // 测量成功完成
            // 测量成功完成
            if (resetSuc == YES) {
                NSLog(@"测量完成成功");
                self.ResultData.text = @"测量完成成功";
            }else{
                // 测试未成功完成
                NSLog(@"测量完成失败");
                self.ResultData.text = @"测量完成失败";
            }

        } DisposeErrorBlock:^(PO3ErrorID errorID) {
            NSLog(@"your measure PO3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your measure PO3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}
// 获取历史数据
- (IBAction)commandPO3HistoryDataCount:(id)sender {
    // 初始化PO3控制类
    PO3Controller *controller = [PO3Controller shareIHPO3Controller];
    // 接收到 PO3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentPO3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建PO3实例调用通讯相关接口
        PO3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 实时测量
        [bpInstance commandPO3PO3StartHistoryDataCountBlock:^(NSNumber *dataCount) {
            // 上传离线数据条数
            // 条数（下位机一般不对，所以上位机不用这个）
            NSLog(@"上传离线数据条数为:%@",dataCount);
            self.ResultData.text = [NSString stringWithFormat:@"上传离线数据条数为:%@",dataCount];
            
        } progressDataBlock:^(NSNumber *progress) {
            // 上传数据进度百分比
            NSLog(@"上传数据进度百分比:%@",progress);
            self.ResultData.text = [NSString stringWithFormat:@"上传数据进度百分比:%@",progress];
            
        } historyDataBlock:^(NSDictionary *historyDataDic) {
            // 返回测量时间、血氧值，脉率，脉搏强度，相应key：date、spo2、bpm、wave
            // Dic（order，spo2，bpm，wave，date）
            NSLog(@"返回血氧历史数据结果为：%@",historyDataDic);
            self.ResultData.text = [NSString stringWithFormat:@"返回血氧历史数据结果为:%@",historyDataDic];
            
        } historyWaveData:^(NSDictionary *historywaveHistoryDataDic) {
            // 历史小波
            // Dic（order，wave）
            // 返回脉搏强度值
            NSLog(@"返回脉搏强度值为:%@",historywaveHistoryDataDic);
            self.ResultData.text = [NSString stringWithFormat:@"返回脉搏强度值为:%@",historywaveHistoryDataDic];
            
        } finishHistoryDataBlock:^(BOOL resetSuc) {
            // 结束上传
            // 结束传输数据成功与否
            if (resetSuc == YES) {
                NSLog(@"结束传输数据成功");
                self.ResultData.text = @"结束传输数据成功";
            }else{
                // 结束传输数据失败
                NSLog(@"结束传输数据失败");
                self.ResultData.text = @"结束传输数据失败";
            }

        } DisposeErrorBlock:^(PO3ErrorID errorID) {
            NSLog(@"your PO3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your PO3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}
// 查询电量
- (IBAction)commandQueryBatteryInfo:(id)sender {
    // 初始化PO3控制类
    PO3Controller *controller = [PO3Controller shareIHPO3Controller];
    // 接收到 PO3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentPO3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建PO3实例调用通讯相关接口
        PO3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 查询电量
        [bpInstance commandQueryBatteryInfo:^(NSNumber *battery) {
            // 查询电量值
            NSLog(@"血氧设备电量值为:%@",battery);
            self.ResultData.text = [NSString stringWithFormat:@"血氧设备电量值为:%@",battery];
        } DisposeErrorBlock:^(PO3ErrorID errorID) {
            NSLog(@"your PO3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your PO3 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 恢复出厂设置
- (IBAction)commandResetDeviceResult:(id)sender {
    // 初始化PO3控制类
    PO3Controller *controller = [PO3Controller shareIHPO3Controller];
    // 接收到 PO3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentPO3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建PO3实例调用通讯相关接口
        PO3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 恢复出厂设置
        [bpInstance commandResetDeviceDisposeResultBlock:^(BOOL resetSuc) {
            // 收到恢复出厂设置确认
            // 恢复出厂设置成功与否
            if (resetSuc == YES) {
                NSLog(@"恢复出厂设置成功");
                self.ResultData.text = @"恢复出厂设置成功";
            }else{
                // 恢复出厂设置失败
                NSLog(@"恢复出厂设置失败");
                self.ResultData.text = @"恢复出厂设置失败";
            }
        } DisposeErrorBlock:^(PO3ErrorID errorID) {
            NSLog(@"your PO3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your PO3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 同步时间和实时测量

- (IBAction)commandPO3SyncTimeResult:(id)sender {
    // 初始化PO3控制类
    PO3Controller *controller = [PO3Controller shareIHPO3Controller];
    // 接收到 PO3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentPO3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建PO3实例调用通讯相关接口
        PO3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 实时测量
        [bpInstance commandPO3SyncTimeResultBlock:^(BOOL resetSuc) {
            // 收到同步时间确认
            if (resetSuc == YES) {
                NSLog(@"收到同步时间确认");
                self.ResultData.text = @"收到同步时间确认";
            }else{
                NSLog(@"收到同步时间确认失败");
                self.ResultData.text = @"收到同步时间确认失败";
            }
            
        } StartMeasureBlock:^(BOOL resetSuc) {
            // 收到准备接受数据确认
            // 开始传输数据
            if (resetSuc == YES) {
                NSLog(@"开始传输数据成功");
                self.ResultData.text = @"开始传输数据成功";
            }else{
                NSLog(@"开始传输数据失败");
                self.ResultData.text = @"开始传输数据失败";
            }
            
        } MeasuringDataBlock:^(NSDictionary *measureDataDic) {
            // 正在接受数据
            // 返回血氧值，脉率、脉搏强度、PI，相应key：spo2、bpm、wave、PI
            // Dic（spo2，bpm，height，wave，PI）
            NSLog(@"返回血氧值：%@",measureDataDic);
            self.ResultData.text = [NSString stringWithFormat:@"返回血氧值:%@",measureDataDic];
        } FinishMeasure:^(BOOL resetSuc) {
            // 结束测量确认
            // 测量成功完成
            if (resetSuc == YES) {
                NSLog(@"测量完成成功");
                self.ResultData.text = @"测量完成成功";
            }else{
                // 测试未成功完成
                NSLog(@"测量完成失败");
                self.ResultData.text = @"测量完成失败";
            }
            
        } DisposeErrorBlock:^(PO3ErrorID errorID) {
            NSLog(@"your measure PO3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your measure PO3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}
// 断开连接
- (IBAction)commandEndPO3DisConnect:(id)sender {
    // 初始化PO3控制类
    PO3Controller *controller = [PO3Controller shareIHPO3Controller];
    // 接收到 PO3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentPO3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建PO3实例调用通讯相关接口
        PO3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 断开连接
        [bpInstance commandEndPO3CurrentDisConnect:^(BOOL resetSuc) {
            // 收到断开设置确认
            // 断开设备成功
            if (resetSuc == YES) {
                NSLog(@"断开设备成功");
                self.ResultData.text = @"y断开设备成功";
            }else{
                // 断开设备失败
                NSLog(@"断开设备失败");
                self.ResultData.text = @"断开设备失败";
            }
        } DisposeErrorBlock:^(PO3ErrorID errorID) {
            NSLog(@"your measure PO3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your measure PO3 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}
@end