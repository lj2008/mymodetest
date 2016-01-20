//
//  BP3LViewController.m
//  testCommicationMode
//
//  Created by Mac on 15/12/7.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BP3LViewController.h"
#import "BP3LController.h"
#import "BP3L.h"
@interface BP3LViewController ()
@end
@implementation BP3LViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     //注册BP3L设备接入消息,调用DeviceConnectForBP3L方法创建测量连接
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForBP3L:) name:@"BP3LDeviceDidConnected" object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBP3L:) name:@"BP3LDeviceDisConnected" object:nil];
    [BP3LController shareBP3LController];
    // 不初始化无法连接
   // [BasicCommunicationObject basicCommunicationObject];
    // FORBP3L
    // 获取BP3LController实例,并对通信底层进行初始化
        [[BasicCommunicationObject basicCommunicationObject] startSearchBTLEDevice:BtleType_BP3L];
}

#pragma mark - BP3L
// BP3L断开测量连接(注册消息调bp3L断开连接方法)
-(void)DeviceDisConnectForBP3L:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}
// BP3L创建测量连接(注册消息调bp3L连接方法)
-(void)DeviceConnectForBP3L:(NSNotification *)tempNoti{
    // 初始化BP3L控制类
    BP3LController *controller = [BP3LController shareBP3LController];
    // 接收到 BP3LConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentBP3LInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建bp3L实例调用通讯相关接口
        BP3L *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 创建测量连接
        [bpInstance commandStartMeasure:^(NSArray *pressureArr) {
            // 测量过程中的压力值，单位mmHg
            NSLog(@"Pressure:%@",pressureArr);
            self.ResultData.text = [NSString stringWithFormat:@"Pressure :%@",pressureArr];        } xiaoboWithHeart:^(NSArray *xiaoboArr) {
            // 测量过程中的小波数据集合，有心跳
                
        } xiaoboNoHeart:^(NSArray *xiaoboArr) {
             // 测量过程中的小波数据集合，无心跳
            
        } result:^(NSDictionary *dic) {
            // 测量结果，包括收缩压、舒张压、心率、是否心率不齐四个参数。
            // 相应key：SYS、DIA、heartRate、irregular
            NSLog(@"your Result dic:%@",dic);
            self.ResultData.text = [NSString stringWithFormat:@"your Result dic:%@",dic];
        } errorBlock:^(BP3LDeviceError error) {
            NSLog(@"your measure pressure error id:%d",error);
            self.ResultData.text = [NSString stringWithFormat:@"your measure pressure error id:%d",error];
        }];
       
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
  
}

// 获取下位机功能信息，并同步时间
/*
 BP5、BP7是否支持蓝牙回连和离线测量，及蓝牙回连、离线测量功能是否打开。对应的key为：haveBlue、haveOffline、blueOpen、offlineOpen。
 True为真，False为假。
 */
- (IBAction)commandFounctionPressed:(id)sender {
    // 初始化BP3L控制类
    BP3LController *controller = [BP3LController shareBP3LController];
    // 接收到 BP3LConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentBP3LInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建bp3L实例调用通讯相关接口
        BP3L *bpInstance = [bpDeviceArray objectAtIndex:0];
        
        // 返回是否蓝牙自动回连和是否有离线，KEY分别为@"haveBlue"、@"haveOffline"
        [bpInstance commandFounction:^(NSDictionary *dic) {
            // 设备是否支持蓝牙回连
            NSNumber *haveBlue = [dic objectForKey:@"haveBlue"];
            NSString *haveBluemess = nil;
            
            if ([haveBlue isEqualToNumber:@1]) {
                NSLog(@"设备支持蓝牙回连");
                haveBluemess = @"设备支持蓝牙回连";
            }else if([haveBlue isEqualToNumber:@0]){
                NSLog(@"设备不支持蓝牙回连");
                haveBluemess = @"设备不支持蓝牙回连";
            }else{
                NSLog(@"未获取到蓝牙回连值");
                haveBluemess = @"未获取到蓝牙回连值";
            }
            // 设备是否支持离线测量
            NSNumber *haveOffline = [dic objectForKey:@"haveOffline"];
            NSString *haveOfflinemess = nil;
            if ([haveOffline isEqualToNumber:@1]) {
                NSLog(@"设备支持离线测量");
                haveOfflinemess = @"设备支持离线测量";
                
            }else if([haveOffline isEqualToNumber:@0]){
                NSLog(@"设备不支持离线测量");
                haveOfflinemess = @"设备不支持离线测量";
            }else{
                NSLog(@"未获取到离线测量值");
                haveOfflinemess = @"未获取到离线测量值";
            }
            // 设备蓝牙回连功能是否打开
            NSNumber *blueOpen = [dic objectForKey:@"blueOpen"];
            NSString *haveblueOpenmess = nil;
            if ([blueOpen isEqualToNumber:@1]) {
                NSLog(@"设备蓝牙回连功能打开");
                haveblueOpenmess = @"设备蓝牙回连功能打开";
            }else if([blueOpen isEqualToNumber:@0]){
                NSLog(@"设备蓝牙回连功能未打开");
                haveblueOpenmess = @"设备蓝牙回连功能未打开";
            }else{
                NSLog(@"未获取到设备蓝牙回连功能是否打开值");
                haveblueOpenmess = @"未获取到设备蓝牙回连功能是否打开值";
            }
            // 设备蓝牙离线测量功能是否打开
            NSNumber *offlineOpen = [dic objectForKey:@"offlineOpen"];
            NSString *haveofflineOpenmess = nil;
            if ([offlineOpen isEqualToNumber:@1]) {
                NSLog(@"设备离线测量功能打开");
                haveofflineOpenmess = @"设备离线测量功能打开";
                
            }else if([offlineOpen isEqualToNumber:@0]){
                NSLog(@"设备未打开离线测量功能");
                haveofflineOpenmess = @"设备未打开离线测量功能";
                
            }else{
                NSLog(@"未获取到设备离线测量功能打开值");
                haveofflineOpenmess = @"未获取到设备离线测量功能打开值";
            }
            //输出返回设备结果
            self.ResultData.text = [NSString stringWithFormat:@"查询下位机功能结果：%@,%@,%@,%@",haveBluemess,haveOfflinemess,haveblueOpenmess,haveofflineOpenmess];
        } errorBlock:^(BP3LDeviceError error) {
            NSLog(@"your error id:%d",error);
            self.ResultData.text = [NSString stringWithFormat:@"your measure pressure error id:%d",error];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 查询电池电量功能
/*
 energyValue：返回电池电量百分比，如80代表80%
 */
- (IBAction)commanfEnergy:(id)sender {
    // 初始化BP3L控制类
    BP3LController *controller = [BP3LController shareBP3LController];
    // 接收到 BP3LConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentBP3LInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建bp3L实例调用通讯相关接口
        BP3L *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandEnergy:^(NSNumber *energyValue) {
            NSLog(@"设备电池电量为:%@",energyValue);
            self.ResultData.text = [NSString stringWithFormat:@"设备电池电量为:%@",energyValue];
        } errorBlock:^(BP3LDeviceError error) {
            NSLog(@"error id:%d",error);
            self.ResultData.text = [NSString stringWithFormat:@"your measure pressure error id:%d",error];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
    
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
- (IBAction)commandStartMeasurePressed:(id)sender {
    [[BasicCommunicationObject basicCommunicationObject] startSearchBTLEDevice:BtleType_BP3L];
    // 初始化BP3L控制类
    BP3LController *controller = [BP3LController shareBP3LController];
    // 接收到 BP3LConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentBP3LInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建bp3L实例调用通讯相关接口
        BP3L *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 创建测量连接
        [bpInstance commandStartMeasure:^(NSArray *pressureArr) {
            // 测量过程中的压力值，单位mmHg
            NSLog(@"Pressure:%@",pressureArr);
            self.ResultData.text = [NSString stringWithFormat:@"Pressure :%@",pressureArr];        } xiaoboWithHeart:^(NSArray *xiaoboArr) {
                // 测量过程中的小波数据集合，有心跳
                
            } xiaoboNoHeart:^(NSArray *xiaoboArr) {
                // 测量过程中的小波数据集合，无心跳
                
            } result:^(NSDictionary *dic) {
                // 测量结果，包括收缩压、舒张压、心率、是否心率不齐四个参数。
                // 相应KEY分别为：@"SYS"、@"DIA、@"heartRate"、@"xinlvbuqi"
                NSLog(@"your Result dic:%@",dic);
                self.ResultData.text = [NSString stringWithFormat:@"your Result dic:%@",dic];
            } errorBlock:^(BP3LDeviceError error) {
                NSLog(@"your measure pressure error id:%d",error);
                self.ResultData.text = [NSString stringWithFormat:@"your measure pressure error id:%d",error];
            }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
    
}

// 停止测量功能
/*
 返回参数：
 result：成功返回YES,失败返回 NO.
 */
- (IBAction)stopBPMeasure:(id)sender {
    // 初始化BP3L控制类
    BP3LController *controller = [BP3LController shareBP3LController];
    // 接收到 BP3LConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentBP3LInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建bp3L实例调用通讯相关口
        BP3L *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance stopBPMeassureErrorBlock:^{
            NSLog(@"停止测量中");
            self.ResultData.text =@"停止测量中";
            
        } errorBlock:^(BP3LDeviceError error) {
            NSLog(@"your measure pressure error id:%d",error);
            self.ResultData.text = [NSString stringWithFormat:@"your error id:%d",error];
        }];
    }else{
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}


/* BP3L 无此方法
 */
//// 开始获取角度
//- (IBAction)commandStartGetAngle:(id)sender {
//    // 初始化BP3L控制类
//    BP3LController *controller = [BP3LController shareBP3LController];
//    // 接收到 BP3LConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentBP3LInstace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建bp3L实例调用通讯相关接口
//        BP3L *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 开始获取角度
//        [bpInstance commandStartGetAngle:^(NSDictionary *dic) {
//            // 获取角度值
//            // 具体不知道干什么的 todo
//            NSLog(@"your angle dic:%@",dic);
//            self.ResultData.text = [NSString stringWithFormat:@"your angle dic:%@",dic];
//        } errorBlock:^(BP3LDeviceError error) {
//            NSLog(@"error id:%d",error);
//            self.ResultData.text = [NSString stringWithFormat:@"your measure pressure error id:%d",error];
//        }];
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//}
//
////设置离线测量功能(无返回值)
///*
// 传入参数：
// open：True,打开离线测量功能；False,关闭离线测量功能。
// 返回参数：
// blockBuleSet：BP返回的蓝牙回连状态，True打开，False关闭。
// */
//- (IBAction)commandSetOffline:(id)sender {
//    // 初始化BP3L控制类
//    BP3LController *controller = [BP3LController shareBP3LController];
//    // 接收到 BP3LConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentBP3LInstace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建bp3L实例调用通讯相关接口
//        BP3L *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 设置离线测量功能
//        BOOL offlinestate = YES;
//        // 关闭离线测量功能
//        //        BOOL offlinestate = NO;
//        // 无返回值 无法获取设备是否已经设置离线测量
//        [bpInstance commandSetOffline:offlinestate errorBlock:^(BP3LDeviceError error) {
//            NSLog(@"error id:%d",error);
//            self.ResultData.text = [NSString stringWithFormat:@"your measure pressure error id:%d",error];
//        }];
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//}
//// 设置蓝牙回连功能
///*
// BP5、BP7是否支持蓝牙回连和离线测量，及蓝牙回连、离线测量功能是否打开。对应的key为：haveBlue、haveOffline、blueOpen、offlineOpen。
// True为真，False为假。
// */
//- (IBAction)commandSetBlueConnect:(id)sender {
//    // 初始化BP3L控制类
//    BP3LController *controller = [BP3LController shareBP3LController];
//    // 接收到 BP3LConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentBP3LInstace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建bp3L实例调用通讯相关接口
//        BP3L *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 打开蓝牙回连
//        BOOL bluestate = YES;
//        // 关闭蓝牙回连
//        //  BOOL bluestate = NO;
//        [bpInstance commandSetBlueConnect:bluestate respond:^(BOOL isOpen) {
//            if (isOpen == YES) {
//                NSLog(@"BP返回蓝牙回连状态:已打开");
//                self.ResultData.text = @"BP返回蓝牙回连状态:已打开";
//            }else{
//                NSLog(@"BP返回蓝牙回连状态:已关闭");
//                self.ResultData.text = @"BP返回蓝牙回连状态:已关闭";
//            }
//        } errorBlock:^(BP3LDeviceError error) {
//            NSLog(@"your error id:%d",error);
//            self.ResultData.text = [NSString stringWithFormat:@"your measure pressure error id:%d",error];
//        }];
//        
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//}
//
//// 上传离线数据功能
///*
// 返回参数：
// TotalCount：离线数据总条数。
// Progress：离线数据上传百分比，范围0.0-1.0，及0%～100％，100%标示离线数  据传完毕。
// UploadDataArray:离线数据集合，包含测量时间、高压、低压、心率、心律不齐。相应的key为：time、SYS、DIA、heartRate、irregular
// */
//- (IBAction)commandBatchUpload:(id)sender {
//    // 初始化BP3L控制类
//    BP3LController *controller = [BP3LController shareBP3LController];
//    // 接收到 BP3LConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentBP3LInstace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建bp3L实例调用通讯相关接口
//        BP3L *bpInstance = [bpDeviceArray objectAtIndex:0];
//        [bpInstance commandBatchUpload:^(NSNumber *num) {
//            NSLog(@"离线数据总条数:%@",num);
//            self.ResultData.text = [NSString stringWithFormat:@"离线数据总条数:%@",num];
//        } pregress:^(NSNumber *pregress) {
//            NSLog(@"离线数据上传百分比:%@",pregress);
//            self.ResultData.text = [NSString stringWithFormat:@"离线数据上传百分比:%@",pregress];
//        } dataArray:^(NSArray *array) {
//            NSLog(@"%@",[NSString stringWithFormat:@"离线数据集合:%@",array]);
//            self.ResultData.text =[NSString stringWithFormat:@"离线数据集合:%@",array];
//        } errorBlock:^(BP3LDeviceError error) {
//            NSLog(@"your measure pressure error id:%d",error);
//            self.ResultData.text = [NSString stringWithFormat:@"your measure pressure error id:%d",error];
//            
//        }];
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//
//}

@end
