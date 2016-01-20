//
//  BG5ViewController.m
//  testCommicationMode
//
//  Created by Mac on 15/12/9.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BG5ViewController.h"
#import "BG5.h"
#import "BG5Controller.h"
#import "AudioBasicCommunication.h"
#import "NewAudioBasicCommunication.h"
#import "BasicCommunicationObject.h"
@interface BG5ViewController ()

@end

@implementation BG5ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册Bg5设备接入消息和BG5断开连接消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForBG5:) name:DeviceConnect object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBG5:) name:DeviceDisconnect object:nil];
    // APP端与BG5的通信底层部分进行初始化
    [BG5Controller shareIHBg5Controller];
    // 不初始化无法连接
    [BasicCommunicationObject basicCommunicationObject];
    
}
#pragma mark - BG5
// BG5断开测量连接(注册消息调BG5断开连接方法)
-(void)DeviceDisConnectForBG5:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}

/*
 BG5创建测量连接(注册消息调BG5创建连接方法)
 */
-(void)DeviceConnectForBG5:(NSNotification *)tempNoti{
    // 初始化BG5控制类
    BG5Controller *controller = [BG5Controller shareIHBg5Controller];
    // 接收到 BG5ConnectNoti消息后，获取控制类实例，获得连接的所有BG5对象
    NSArray *bpDeviceArray = [controller getAllCurrentBG5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BG5实例调用通讯相关接口
        BG5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置BG5单位和时间，并返回bottleID
        // 设置下位机所用单位，分为两种：@"mg/dL"和@"mmol/L"。
        NSString  *unitState = @"mg/dL";
        // 暂未使用参数
        NSString *BG5UserID = @"11111";
        [bpInstance commandInitBG5SetUnit:unitState  BGUserID:BG5UserID DisposeBG5BottleID:^(NSNumber *bottleID) {
            // 返回下位机上传的BottleID
            NSLog(@"BottleID:%@",bottleID);
            self.ResultData.text = [NSString stringWithFormat:@"BottleID:%@",bottleID];
        } DisposeErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG5 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG5 error id:%@",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 获取下位机离线历史记录，并返回历史记录条数和详细记录。
- (IBAction)commandTransferMemorryData:(id)sender {
    // 初始化BG5控制类
    BG5Controller *controller = [BG5Controller shareIHBg5Controller];
    // 接收到 BG5ConnectNoti消息后，获取控制类实例，获得连接的所有BG5对象
    NSArray *bpDeviceArray = [controller getAllCurrentBG5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BG5实例调用通讯相关接口
        BG5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandTransferMemorryData:^(NSNumber *dataCount) {
            // 返回下位机中历史记录的数量
            NSLog(@"BG5离线数据总条数:%@",dataCount);
            self.ResultData.text = [NSString stringWithFormat:@"BG5离线数据总条数:%@",dataCount];
            
        } DisposeBG5HistoryData:^(NSDictionary *historyDataDic) {
            // 返回下位机上传的全部历史记录
            NSLog(@"BG5全部历史记录数据为:%@",historyDataDic);
            self.ResultData.text = [NSString stringWithFormat:@"BG5全部历史记录数据为:%@",historyDataDic];
            
        } DisposeErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG5 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG5 error id:%@",errorID];
        }];
    }else{
        
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}
// 删除下位机中的离线历史记录
- (IBAction)commandDeleteMemorryData:(id)sender {
    // 初始化BG5控制类
    BG5Controller *controller = [BG5Controller shareIHBg5Controller];
    // 接收到 BG5ConnectNoti消息后，获取控制类实例，获得连接的所有BG5对象
    NSArray *bpDeviceArray = [controller getAllCurrentBG5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BG5实例调用通讯相关接口
        BG5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandDeleteMemorryData:^(BOOL deleteOk) {
            // 返回是否成功删除离线历史记录，YES表示删除成功
            if (deleteOk == YES) {
                NSLog(@"成功删除离线历史记录");
                self.ResultData.text = @"成功删除离线历史记录";
            }else{
                NSLog(@"删除离线历史记录失败");
                self.ResultData.text = @"删除离线历史记录失败";
            }
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 该方法用于定期发送保持连接指令，保证上位机与下位机蓝牙模块处于连接状态。该方法需要定期调用，每调一次只发送一遍指令。
- (IBAction)commandKeepConnect:(id)sender {
    // 初始化BG5控制类
    BG5Controller *controller = [BG5Controller shareIHBg5Controller];
    // 接收到 BG5ConnectNoti消息后，获取控制类实例，获得连接的所有BG5对象
    NSArray *bpDeviceArray = [controller getAllCurrentBG5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BG5实例调用通讯相关接口
        BG5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandKeepConnect:^(BOOL sendOk) {
            if (sendOk == YES) {
                NSLog(@"发送保持连接指令成功");
                self.ResultData.text = @"发送保持连接指令成功";
            }else{
                NSLog(@"发送保持连接指令失败");
                self.ResultData.text = @"发送保持连接指令失败";
            }
            
        } DisposeErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG5 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG5 error id:%@",errorID];

        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 给下位机设置单位和时间，并返回bottleID
- (IBAction)commandInitBG5SetUnit:(id)sender {
    // 初始化BG5控制类
    BG5Controller *controller = [BG5Controller shareIHBg5Controller];
    // 接收到 BG5ConnectNoti消息后，获取控制类实例，获得连接的所有BG5对象
    NSArray *bpDeviceArray = [controller getAllCurrentBG5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BG5实例调用通讯相关接口
        BG5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置BG5单位和时间，并返回bottleID
        // 设置下位机所用单位，分为两种：@"mg/dL"和@"mmol/L"。
        NSString  *unitState = @"mmol/L";
        // 暂未使用参数
        NSString *BG5UserID = @"11111";
        [bpInstance commandInitBG5SetUnit:unitState  BGUserID:BG5UserID DisposeBG5BottleID:^(NSNumber *bottleID) {
            // 返回下位机上传的BottleID
            NSLog(@"Your BottleID:%@",bottleID);
            self.ResultData.text = [NSString stringWithFormat:@"Your BottleID:%@",bottleID];
        } DisposeErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG5 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG5 error id:%@",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 获取下位机中保存的CODE
- (IBAction)commandReadBG5CodeDic:(id)sender {
    // 初始化BG5控制类
    BG5Controller *controller = [BG5Controller shareIHBg5Controller];
    // 接收到 BG5ConnectNoti消息后，获取控制类实例，获得连接的所有BG5对象
    NSArray *bpDeviceArray = [controller getAllCurrentBG5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BG5实例调用通讯相关接口
        BG5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandReadBG5CodeDic:^(NSDictionary *codeDic) {
            // 返回下位机保存的CODE
            NSLog(@"下位机保存的CODE为:%@",codeDic);
            self.ResultData.text = [NSString stringWithFormat:@"下位机保存的CODE为:%@",codeDic];
            
        } DisposeErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG5 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG5 error id:%@",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 向下位机发送BottleID并返回发送结果
- (IBAction)commandSendBottleID:(id)sender {
    // 初始化BG5控制类
    BG5Controller *controller = [BG5Controller shareIHBg5Controller];
    // 接收到 BG5ConnectNoti消息后，获取控制类实例，获得连接的所有BG5对象
    NSArray *bpDeviceArray = [controller getAllCurrentBG5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BG5实例调用通讯相关接口
        BG5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 从扫描到的CODE中获取的BottleID
        NSDictionary *codeDic = [bpInstance codeStripStrAnalysis:CodeStr];
        NSNumber *testBottleID = [codeDic valueForKey:@"BottleID"];

        [bpInstance commandSendBottleID:testBottleID DisposeBG5SendBottleIDBlock:^(BOOL sendOk) {
            // 返回BottleID是否发送成功。YES表示发送成功，NO表示发送失败
            if (sendOk == YES) {
                NSLog(@"BottleID发送成功");
                self.ResultData.text = @"BottleID发送成功";
            }else{
                NSLog(@"BottleID发送失败");
                self.ResultData.text = @"BottleID发送失败";
            }
            
        } DisposeErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG5 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG5 error id:%@",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 将CODE字符串、有效期和剩余条数发送给下位机，并设置下位机的开机模式
- (IBAction)commandSendBG5CodeString:(id)sender {
    // 初始化BG5控制类
    BG5Controller *controller = [BG5Controller shareIHBg5Controller];
    // 接收到 BG5ConnectNoti消息后，获取控制类实例，获得连接的所有BG5对象
    NSArray *bpDeviceArray = [controller getAllCurrentBG5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BG5实例调用通讯相关接口
        BG5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 扫描试瓶上的二维码所得到的CODE字符串(CodeStr)
        // 扫描试瓶上的二维码进行解析
            NSDictionary *codeDic = [bpInstance codeStripStrAnalysis:CodeStr];
        // 有效截止日期
        NSDate *yourValidDate = [codeDic valueForKey:@"DueDate"];
        // 当前试瓶中试纸的剩余条数
        NSNumber *yourRemainNub = [codeDic valueForKey:@"StripNum"];
        //设定时间格式
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];        [dateFormat setTimeZone:[NSTimeZone defaultTimeZone]];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        NSString *validDateString=[dateFormat stringFromDate: yourValidDate];
        
        
        [bpInstance commandSendBG5CodeString:CodeStr
                                   validDate:validDateString remainNum:yourRemainNub DisposeBG5SendCodeBlock:^(BOOL sendOk) {
            // 返回CODE是否发送成功
                                       if (sendOk == YES
                                           ) {
                                           NSLog(@"CODE发送成功");
                                           self.ResultData.text = @"CODE发送成功";
                                       }else{
                                           NSLog(@"CODE发送失败");
                                           self.ResultData.text = @"CODE发送失败";
                                       }
        } DisposeBG5StartModel:^(NSNumber *model) {
            // 返回下位机的开机模式
            if ([model intValue] == 1) {
                NSLog(@"当前开机模式为插条开机");
                self.ResultData.text = [NSString stringWithFormat:@"当前开机模式为插条开机"];
            }else if([model intValue] == 2){
                NSLog(@"当前开机模式为电源键开机");
                self.ResultData.text = [NSString stringWithFormat:@"当前开机模式为电源键开机"];
            }
            
            
        } DisposeErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG5 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG5 error id:%@",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 插条开机模式下的开始测量方法，调用之后能够返回测量过程中的插条，滴血，血糖结果，测量模式，以及错误ID
- (IBAction)commandCreateBGtestStripIn:(id)sender {
    // 初始化BG5控制类
    BG5Controller *controller = [BG5Controller shareIHBg5Controller];
    // 接收到 BG5ConnectNoti消息后，获取控制类实例，获得连接的所有BG5对象
    NSArray *bpDeviceArray = [controller getAllCurrentBG5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BG5实例调用通讯相关接口
        BG5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandCreateBGtestStripInBlock:^(BOOL stripIn) {
            // 返回下位机发送试条插入指令
            NSLog(@"试条已插入BG5");
            self.ResultData.text = @"试条已插入BG5";
        } DisposeBGBloodBlock:^(BOOL blood) {
            // 返回下位机发送滴血指令
            NSLog(@"试条已滴血");
            self.ResultData.text = @"试条已滴血";
            
        } DisposeBGResultBlock:^(NSNumber *result) {
            // 返回下位机发送血糖结果
            NSLog(@"下位机发送血糖结果:%@",result);
            self.ResultData.text = [NSString stringWithFormat:@"下位机发送血糖结果:%@",result];
            
        } DisposeBGStripOutBlock:^(BOOL stripOut) {
            // 下位机发送试条拔出指令
            NSLog(@"试条已拔出");
            self.ResultData.text = @"试条已拔出";
        } DisposeBG5TestModelBlock:^(NSNumber *model) {
            // 返回当前测量模式，包含一个NSNumber类型的值，@1表示MEASURE_MODE_NORMAL，即血糖测量模式；@2表示MEASURE_MODE_LIQUID，即质控液测量模式
            if ([model intValue] == 1) {
                NSLog(@"当前测量模式:MEASURE_MODE_NORMAL，即血糖测量模式");
                self.ResultData.text = [NSString stringWithFormat:@"当前测量模式:MEASURE_MODE_NORMAL，即血糖测量模式"];
            }else if([model intValue] == 2){
                NSLog(@"当前测量模式:MEASURE_MODE_LIQUID，即质控液测量模式");
                self.ResultData.text = [NSString stringWithFormat:@"MEASURE_MODE_LIQUID，即质控液测量模式"];
            }
        } DisposeBG5ErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG5 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG5 error id:%@",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
        
}

// 电源键开机模式下的开始测量方法，调用之后能够返回测量过程中的插条，滴血，血糖结果，测量模式，以及错误I
- (IBAction)commandCreateBGtestModel:(id)sender {
    // 初始化BG5控制类
    BG5Controller *controller = [BG5Controller shareIHBg5Controller];
    // 接收到 BG5ConnectNoti消息后，获取控制类实例，获得连接的所有BG5对象
    NSArray *bpDeviceArray = [controller getAllCurrentBG5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BG5实例调用通讯相关接口
        BG5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 当前测量模式，NSNumber类型，@1表示MEASURE_MODE_NORMAL，即血糖测量模式；@2表示MEASURE_MODE_LIQUID，即质控液测量模式
        NSNumber *testMode = @1 ;
        // 当前用户的ID
        NSString *userid =@"123456" ;
        
        [bpInstance commandCreateBGtestModel:testMode BGUserID:userid DisposeBGStripInBlock:^(BOOL stripIn) {
            // 返回下位机发送试条插入指令
            NSLog(@"试条已插入BG5");
            self.ResultData.text = @"试条已插入BG5";
        } DisposeBGBloodBlock:^(BOOL blood) {
            // 返回下位机发送滴血指令
            NSLog(@"试条已滴血");
            self.ResultData.text = @"试条已滴血";
        } DisposeBG5ResultBlock:^(NSNumber *result) {
            // 返回下位机发送血糖结果
            NSLog(@"下位机发送血糖结果:%@",result);
            self.ResultData.text = [NSString stringWithFormat:@"下位机发送血糖结果:%@",result];
        } DisposeBG5StripOutBlock:^(BOOL stripOut) {
            // 下位机发送试条拔出指令
            NSLog(@"试条已拔出");
            self.ResultData.text = @"试条已拔出";
        } DisposeBG5TestModelBlock:^(NSNumber *model) {
            // 返回当前测量模式，包含一个NSNumber类型的值，@1表示MEASURE_MODE_NORMAL，即血糖测量模式；@2表示MEASURE_MODE_LIQUID，即质控液测量模式
            if ([model intValue] == 1) {
                NSLog(@"当前测量模式:MEASURE_MODE_NORMAL，即血糖测量模式");
                self.ResultData.text = [NSString stringWithFormat:@"当前测量模式:MEASURE_MODE_NORMAL，即血糖测量模式"];
            }else if([model intValue] == 2){
                NSLog(@"当前测量模式:MEASURE_MODE_LIQUID，即质控液测量模式");
                self.ResultData.text = [NSString stringWithFormat:@"MEASURE_MODE_LIQUID，即质控液测量模式"];
            }
        } DisposeBG5ErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG5 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG5 error id:%@",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
    
}

// 获取下位机的电量
- (IBAction)commandQueryBattery:(id)sender {
    // 初始化BG5控制类
    BG5Controller *controller = [BG5Controller shareIHBg5Controller];
    // 接收到 BG5ConnectNoti消息后，获取控制类实例，获得连接的所有BG5对象
    NSArray *bpDeviceArray = [controller getAllCurrentBG5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建BG5实例调用通讯相关接口
        BG5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandQueryBattery:^(NSNumber *energy) {
            // 返回下位机的剩余电量的百分比
            NSLog(@"BG5剩余电量的百分比为:%@",energy);
            self.ResultData.text = [NSString stringWithFormat:@"BG5剩余电量的百分比为:%@",energy];
        } DisposeErrorBlock:^(NSNumber *errorID) {
            // 返回通信过程中出现错误的ID
            NSLog(@"your BG5 error id:%@",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your BG5 error id:%@",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}
@end