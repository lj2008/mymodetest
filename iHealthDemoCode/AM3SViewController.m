//
//  AM3SViewController.m
//  testCommicationMode
//
//  Created by Mac on 15/12/7.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AM3SViewController.h"
#import "AM3S.h"
#import "AM3SController.h"
#import "AM3SController.h"
#import "BasicCommunicationObject.h"
@interface AM3SViewController ()

@end

@implementation AM3SViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 注册AM3S设备接入消息和AM3S断开连接消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForAM3S:) name:DeviceConnect object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForAM3S:) name:DeviceDisconnect object:nil];
    // APP端与AM3S的通信底层部分进行初始化
    [AM3SController shareIHAM3SController];
    // 进行AM3S扫描
    [BasicCommunicationObject basicCommunicationObject];
    [[BasicCommunicationObject basicCommunicationObject] startSearchBTLEDevice:BtleType_AM3S];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - AM3S
// AM3S断开测量连接(注册消息)
-(void)DeviceDisConnectForAM3S:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}

/*
 AM3S创建测量连接(注册消息)_暂时设置用户信息
 */
-(void)DeviceConnectForAM3S:(NSNotification *)tempNoti{
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 配置个人信息(单位、目标)
        // 设置AM3S用户信息
        AM3SUser *userinfo = [[AM3SUser alloc]init];
        // 用户生日
        userinfo.ageDate = [NSDate date];
        // 用户性别
        userinfo.sexNumber = AM3SGender_Male;
        // 用户身高
        userinfo.heightNumber = @175;
        // 用户体重
        userinfo.weightNumber = @55;
        // 用户基础代谢率
        userinfo.bmr = @100;
        // AM显示总距离单位(不知道参数类型)
        // NSString *amunit = AM3SKmUnit_mile;
        // 用户目标步数
        NSNumber *amGoal = @100000;
        
//        [bpInstance commandAM3SSetUserInfo:userinfo unit:AM3SKmUnit_mile goal:amGoal finishSetBMRDisposeBlock:^(BOOL resetSuc) {
//            // 配置个人信息
//            if (resetSuc == YES) {
//                // 配置个人信息成功
//                NSLog(@"配置个人信息成功");
//                self.ResultData.text = @"配置个人信息成功";
//            }else{
//                // 配置个人信息失败
//                NSLog(@"配置个人信息失败");
//                self.ResultData.text = @"配置个人信息失败";
//                
//            }
//        } disposeErrorBlock:^(AM3SErrorID errorID) {
//            // 返回通讯错误id
//            NSLog(@"your AM3S error id:%d",errorID);
//            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
//        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}



// 设置随机数
- (IBAction)commandAM3SSetRandom:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置随机数
        [bpInstance commandAM3SSetRandomBlock:^(BOOL resetSuc) {
            // 收到设置随机数确认
            // 设置随机数
            if (resetSuc == YES) {
                NSLog(@"设置随机数成功");
                self.ResultData.text = @"设置随机数成功";
            }else{
                NSLog(@"设置随机数失败");
                self.ResultData.text = @"设置随机数失败";
            }
            
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误id
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 同步时间(包含查询和设置MD5)
- (IBAction)commandAM3SSyncTimeResult:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3SSyncTimeResultBlock:^(BOOL resetSuc) {
            // 收到同步时间确认
            // 同步时间
            if (resetSuc == YES) {
                NSLog(@"同步时间成功");
                self.ResultData.text = @"同步时间成功";
            }else{
                NSLog(@"同步时间失败");
                self.ResultData.text = @"同步时间失败";
            }
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 查询区域时间格式
- (IBAction)commandQueryTimeNation:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3SQueryTimeFormatAndNation:^(AM3STimeFormatAndNation timeFormatAndNation) {
            // 查询区域时间格式
            NSLog(@"查询区域时间格式结果:%u",timeFormatAndNation);
            self.ResultData.text = [NSString stringWithFormat:@"查询区域时间格式结果:%u",timeFormatAndNation];
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
    
}

// 设置区域时间格式
// 收到设置区域时间格式确认
- (IBAction)commandAM3SFinishSetTimeFormat:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3SFinishSetTimeFormat:^(BOOL timeFormatAndNationSetting) {
            // 收到设置区域时间格式确认
            // 设置区域时间格式成功与否
            if (timeFormatAndNationSetting == YES) {
                NSLog(@"设置区域时间格式成功");
                self.ResultData.text = @"设置区域时间格式成功";
            }else{
                NSLog(@"设置区域时间格式失败");
                self.ResultData.text = @"设置区域时间格式失败";
            }
            
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 绑定用户(下发用户ID)
- (IBAction)commandAM3SSetUserID:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 绑定用户(下发用户ID)
        // 用户唯一标示
        NSNumber *userid =@123456;
        [bpInstance commandAM3SSetUserID:userid finishResultBlock:^(BOOL resetSuc) {
            // 收到设置用户ID确认
            if (resetSuc == YES) {
                // 用户绑定成功
                NSLog(@"用户绑定成功");
                self.ResultData.text = @"用户绑定成功";
            }else{
                // 用户绑定失败
                NSLog(@"用户绑定失败");
                self.ResultData.text = @"用户绑定失败";
            }
            
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误id
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 配置个人信息(单位、目标等)
- (IBAction)commandAM3SSetUserInfo:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        
        // 配置个人信息(单位、目标)
        // 设置AM3S用户信息
        /*
         NSDate *ageDate;出生日期
         NSNumber *sexNumber;0女1男
         NSNumber *heightNumber;身高
         NSNumber *weightNumber;体重
         NSNumber *bmr;基础代谢率
         */
        AM3SUser *userinfo = [[AM3SUser alloc]init];
        // 用户生日
        userinfo.ageDate = [NSDate date];
        // 用户性别
        userinfo.sexNumber = AM3SGender_Male;
        // 用户身高
        userinfo.heightNumber = @175;
        // 用户体重
        userinfo.weightNumber = @55;
        // 用户基础代谢率
        userinfo.bmr = @100;
        // AM显示总距离单位
        // AM3SKmUnit_mile,
        // AM3SKmUnit_km
        // 用户目标步数
        // 运动目标 1-60000
        NSNumber *amGoal = @50000;
        
        [bpInstance commandAM3SSetUserInfo:userinfo unit:AM3SKmUnit_mile goal:amGoal finishSetBMRDisposeBlock:^(BOOL resetSuc) {
            // 配置个人信息
            if (resetSuc == YES) {
                // 收到配置个人信息确认
                // 配置个人信息成功
                NSLog(@"配置个人信息成功");
                self.ResultData.text = @"配置个人信息成功";
            }else{
                // 配置个人信息失败
                NSLog(@"配置个人信息失败");
                self.ResultData.text = @"配置个人信息失败";
                
            }
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误id
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 查询用户ID
- (IBAction)getAM3SUserID:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 查询用户ID
        // TO:设备UUID
        NSString *toWhat = bpInstance.currentUUID;
        [bpInstance getAM3SUserID:^(unsigned int userID) {
            // 查询用户ID结果
            NSLog(@"查询用户ID结果:%d",userID);
            self.ResultData.text = [NSString stringWithFormat:@"查询用户ID结果:%d",userID];
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误id
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        } To:toWhat];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 设置BMR(下位机1.0.2版本以后才可以调这个方法)
- (IBAction)commandAM3SSetBMR:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置用户基础代谢率
        NSNumber *amBMR = @98;
        
        [bpInstance commandAM3SSetBMR:amBMR finishSetBMRResultBlock:^(BOOL resetSuc) {
            // BMR返回值
            if (resetSuc == YES) {
                // 收到BMR确认
                // 设置BMR成功
                NSLog(@"设置BMR成功");
                self.ResultData.text = @"设置BMR成功";
            }else{
                // 设置BMR失败
                NSLog(@"设置BMR失败");
                self.ResultData.text = @"设置BMR失败";
                
            }
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误id
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
    
}

// 同步运动 睡眠 实时运动
- (IBAction)commandAM3SStartSyncActiveData:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3SStartSyncActiveData:^(NSDictionary *startDataDictionary) {
            // 开始传输活动数据
            /*
             Dic(@"StartActiveHistoryDateYear",@"StartActiveHistoryDateMonth",@"StartActiveHistoryDateDay",@"StepSize",@"TimeInterval",@"StartActiveHistoryTotoalNum")
             */
            // 开始上传运动数据，包含属性：StartActiveHistoryDate、StepSize、StartActiveHistoryTotoalNum
            // StartActiveHistoryDate：运动开始时间，yyyy-MM-dd.
            // StepSize：步长，单位 cm。
            // StartActiveHistoryTotoalNum：记录总条数。
            NSLog(@"开始上传运动数据:%@",startDataDictionary);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%@",startDataDictionary];
            
        } activeHistoryData:^(NSArray *historyDataArray) {
            // 运动历史数据
            // array(dic)
            // 运动记录，包含属性：AMDate、AMCalorie、AMStepNum。
            // AMDate：运动时间， NSDate.
            // AMCalorie:当前时间总卡路里。
            // AMStepNum：当前时间总步数。
            NSLog(@"运动记录数据为:%@",historyDataArray);
            self.ResultData.text = [NSString stringWithFormat:@"运动记录数据为:%@",historyDataArray];
            
        } activeFinishTransmission:^{
            // 运动传输结束
            NSLog(@"运动数据上传完成");
            self.ResultData.text = @"运动数据上传完成";
            
        } startSyncAM3SSleepData:^(NSDictionary *startDataDictionary) {
            // 开始传输睡眠数据
            /*
             Dic（SleepActiveHistoryDateYear，SleepActiveHistoryDateMonth，SleepActiveHistoryDateDay，SleepActiveHistoryDateHour，SleepActiveHistoryDateMinute，SleepActiveHistoryDateSeconds，TimeInterval，StartActiveHistoryTotoalNum）
             */
            /*
             startSleepTransmission：开始上传睡眠，包含属性：SleepActiveHistoryDate、StartActiveHistoryTotoalNum。
             SleepActiveHistoryDate：睡眠开始时间，yyyy-MM-dd HH:mm:ss.
             StartActiveHistoryTotoalNum: 记录总条数.
             */
            NSLog(@"开始上传睡眠数据:%@",startDataDictionary);
            self.ResultData.text = [NSString stringWithFormat:@"开始上传睡眠数据:%@",startDataDictionary];
        } sleepHistoryData:^(NSArray *historyDataArray) {
            // 睡眠历史数据
            // 睡眠记录，包含属性：AMDate、SleepData。
            // AMDate：睡眠时间， NSDate.
            // SleepData:睡眠等级，0 清醒， 1浅睡， 2深睡。
            NSLog(@"睡眠记录数据为:%@",historyDataArray);
            self.ResultData.text = [NSString stringWithFormat:@"睡眠记录数据为:%@",historyDataArray];
        } sleepFinishTransmission:^{
            // 睡眠传输结束
            NSLog(@"睡眠数据上传完成");
            self.ResultData.text = @"睡眠数据上传完成";
        } currentActiveInfo:^(NSDictionary *activeDictionary) {
            // 增加查询当前运动信息;@"Step",@"Calories"
            /*
             当天最新总卡路里和总步数，包含属性：Step、Calories。
             Step：当前总步数。
             Calories：当前总卡路里。
             */
            NSLog(@"当天最新总卡路里和总步数为:%@",activeDictionary);
            self.ResultData.text = [NSString stringWithFormat:@"当天最新总卡路里和总步数为:%@",activeDictionary];
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    
    }
}

// 恢复出厂设置
- (IBAction)commandResetDeviceResult:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 调用恢复出厂设置接口
        [bpInstance commandAM3SResetDeviceDisposeResultBlock:^(BOOL resetSuc) {
            if (resetSuc == YES) {
                NSLog(@"恢复出厂设置成功");
                self.ResultData.text = @"恢复出厂设置成功";
            }else{
                NSLog(@"恢复出厂设置失败");
                self.ResultData.text = @"恢复出厂设置失败";
            }
            // 返回通讯错误id
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 查询总的闹钟信息
- (IBAction)commandQueryAlarmAlarmData:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3SQueryAlarmInfoDisposeTotoalAlarmData:^(NSMutableArray *totoalAlarmArray) {
            // 查询总的闹钟信息
            NSLog(@"查询总的闹钟信息为:%@",totoalAlarmArray);
            self.ResultData.text = [NSString stringWithFormat:@"查询总的闹钟信息为:%@",totoalAlarmArray];
            
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 设置闹钟
- (IBAction)commandSetAlarmWithDictionary:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置闹钟提醒信息
        //  alarmDic：闹钟信息，包含属性：AlarmId、Time、IsRepeat、Switch、（Sun、Mon、Tue、Wed、Thu、Fri、Sat
        // E.G.示例
       //  NSDictionary *tempClockDic = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"AlarmId",@1,@"Sun",@"17:45",@"Time",@1,@"IsRepeat",@1,@"Switch",nil];
        
        NSDictionary *alarminfo = [NSDictionary dictionaryWithObjectsAndKeys:@3,@"AlarmId",@1,@"Sun",@"17:30",@"Time",@1,@"IsRepeat",@1,@"Switch",nil];
        
        [bpInstance commandAM3SSetAlarmWithAlarmDictionary:alarminfo disposeResultBlock:^(BOOL resetSuc) {
            // 收到设置闹钟确认
            if (resetSuc == YES) {
                NSLog(@"设置闹钟各参数成功");
                self.ResultData.text = @"设置闹钟各参数成功";
            }else{
                NSLog(@"设置闹钟各参数失败");
                self.ResultData.text = @"设置闹钟各参数失败";
            }
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 删除闹钟
- (IBAction)commandAM3SDeleteAlarmID:(id)sender {
        // 初始化AM3S控制类
        AM3SController *controller = [AM3SController shareIHAM3SController];
        // 接收到 AM3SConnectNoti消息后，获取控制类实例
        NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
        // 有设备存在的时候
        if (bpDeviceArray.count) {
            // 创建AM3S实例调用通讯相关接口
            AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
            // 删除闹钟ID
            // alarmID：闹钟id，范围：1、2、3
            NSNumber *deleteAlarmID = @3;
            [bpInstance commandAM3SDeleteAlarmID:deleteAlarmID disposeResultBlock:^(BOOL resetSuc) {
                // 收到删除闹钟确认
                if (resetSuc == YES) {
                    NSLog(@"删除闹钟成功");
                    self.ResultData.text = @"删除闹钟成功";
                }else{
                    NSLog(@"删除闹钟失败");
                    self.ResultData.text = @"删除闹钟失败";
                }
            } disposeErrorBlock:^(AM3SErrorID errorID) {
                // 返回通讯错误ID
                NSLog(@"your AM3S error id:%d",errorID);
                self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
            }];
        }else{
            // 没有设备存在的时候
            NSLog(@"log...");
            self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
        }
}

// 查询提醒
- (IBAction)commandAM3SDisposeQueryReminder:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3SDisposeQueryReminder:^(NSArray *remindInfo) {
            // 收到提醒信息确认
            // 返回提醒信息
            // remindInfo：提醒数组，包含属性：Time、Switch。
            // Time：提醒时长，格式HH:mm, 即提醒间隔为(HH*60+mm)分钟。
            // Switch：提醒开关，True 打开， False 关闭。
            NSLog(@"查询到的提醒信息结果为:%@",remindInfo);
            self.ResultData.text = [NSString stringWithFormat:@"查询到的提醒信息结果为:%@",remindInfo];
            
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 设置提醒
- (IBAction)commandSetReminderWithDictionary:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置提醒信息
        // Dic（ReminderID，Time，Switch
        // 提醒信息，包含属性：Time、Switch。
           NSDictionary *setreminderinfo = [NSDictionary dictionaryWithObjectsAndKeys:@"00:01",@"Time",@0,@"Switch",nil];
        [bpInstance commandAM3SSetReminderWithReminderDictionary:setreminderinfo disposeResultBlock:^(BOOL resetSuc) {
            // 收到设置提醒确认
            if (resetSuc == YES) {
                NSLog(@"设置提醒各参数成功");
                self.ResultData.text = @"设置提醒各参数成功";
            }else{
                NSLog(@"设置提醒各参数失败");
                self.ResultData.text = @"设置提醒各参数失败";
            }
            
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 查询状态，电量
- (IBAction)commandQueryStateInfo:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3SQueryDisposeStateInfo:^(QueryAM3SState queryState) {
            // 收到状态确认
            /*
             AM3SState_wrist,//手腕
             AM3SState_waist,//腰
             AM3SState_sleep//睡眠
             */
            // 查询AM状态
            NSLog(@"查询AM状态为:%u",queryState);
            self.ResultData.text = [NSString stringWithFormat:@"查询AM状态为:%u",queryState];
            
        } disposeBattery:^(NSNumber *battery) {
            // 查询AM电量  1--100
            NSLog(@"查询AM电量为:%@",battery);
            self.ResultData.text = [NSString stringWithFormat:@"查询AM电量为:%@",battery];
            
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
       
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 断开连接
- (IBAction)commandAM3SDisconnect:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置TO参数
        // UUID
        NSString *towhat = bpInstance.currentUUID;
        [bpInstance commandAM3SDisconnectDisposeBlock:^(BOOL resetSuc) {
            // 收到断开确认
            if (resetSuc == YES) {
                NSLog(@"断开连接成功");
                self.ResultData.text = @"断开连接成功";
            }else{
                NSLog(@"断开连接失败");
                self.ResultData.text = @"断开连接失败";
            }
        } DisposeErrorBlock:^(AM3SErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        } To:towhat];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 查询歩距(对文档 什么都没返回)
- (IBAction)commandAM3SQueryStep:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 查询歩距
        [bpInstance commandAM3SQueryStep:^(NSNumber *normalStepLength, NSNumber *fastStepLength, NSNumber *slowStepLength) {
            // 返回正常步距、快步走步距、慢步走步距
            NSLog(@"正常行走歩距为:%@",normalStepLength);
            self.ResultData.text = [NSString stringWithFormat:@"正常行走歩距为:%@",normalStepLength];
            NSLog(@"快速行走歩距为:%@",fastStepLength);
            self.ResultData.text = [NSString stringWithFormat:@"快速行走歩距为:%@",fastStepLength];
            NSLog(@"慢速行走歩距为:%@",slowStepLength);
            self.ResultData.text = [NSString stringWithFormat:@"慢速行走歩距为:%@",slowStepLength];
            
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 查询用户信息
- (IBAction)commandAM3SQueryUserInfo:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 查询用户信息
        [bpInstance commandAM3SQueryUserInfo:^(NSDictionary *userInfo) {
            // 查询用户信息结果
            NSLog(@"查询到得用户信息结果为:%@",userInfo);
            self.ResultData.text = [NSString stringWithFormat:@"查询到得用户信息结果为:%@",userInfo];
        } DisposeErrorBlock:^(AM3SErrorID errorID) {
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 上传AM3S报表数据 阶段性报告
- (IBAction)commandAM3SSetSyncsportCount:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 上传AM3S报表数据
        [bpInstance commandAM3SSetSyncsportCount:^(NSNumber *sportCount) {
            // 查询用户信息结果
            NSLog(@"查询到总的报表条数为:%@",sportCount);
            self.ResultData.text = [NSString stringWithFormat:@"查询到总的报表条数为:%@",sportCount];
        } disposeMeasureData:^(NSArray *measureDataArray) {
            /*
             阶段性数据
             报表数据，包含ReportStage_Swimming、ReportStage_Work_out、ReportStage_Sleep_summary、ReportStage_Activeminute,目前仅支持ReportStage_Work_out、ReportStage_Sleep_summar
             */
            NSLog(@"查询到的报表数据为:%@",measureDataArray);
            self.ResultData.text = [NSString stringWithFormat:@"查询到的报表数据为:%@",measureDataArray];
        } disposeFinishMeasure:^(BOOL resetSuc) {
            // 结束上传
            if (resetSuc == YES) {
                NSLog(@"上传AM3S报表数据成功");
                self.ResultData.text = @"上传AM3S报表数据成功";
            }else{
                NSLog(@"上传AM3S报表数据失败");
                self.ResultData.text = @"上传AM3S报表数据失败";
            }
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
       
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 设置歩距(对文档设置失败)
- (IBAction)commandAM3SSetStep:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置正常歩距值
        NSNumber * normalstep =@18 ;
        // 设置快步走歩距值
         NSNumber * faststep =@28 ;
        // 设置慢步走歩距值
         NSNumber * slowstep =@8 ;
        [bpInstance commandAM3SSetStep:normalstep fastStepLength:faststep slowStepLength:slowstep resultBlock:^(BOOL resetSuc) {
            if (resetSuc == YES) {
                NSLog(@"设置三种步距值成功");
                self.ResultData.text = @"设置三种步距值成功";
            }else{
                NSLog(@"设置三种步距值失败");
                self.ResultData.text = @"设置三种步距值失败";
            }
            
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            NSLog(@"your AM3S error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}


// 以下方法不用暂时
//// 设置Activeminitues功能状态(对文档，此方法现在报错 id=0)
//- (IBAction)commandAM3SSetActiveminitues:(id)sender {
//    // 初始化AM3S控制类
//    AM3SController *controller = [AM3SController shareIHAM3SController];
//    // 接收到 AM3SConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建AM3S实例调用通讯相关接口
//        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 设置Activeminitues功能状态
//        // 具体返回值意义不知
//        BOOL minituesActive = YES;
//   
//        [bpInstance commandAM3SSetActiveminitues:minituesActive resultBlock:^(BOOL resetSuc) {
//            if (resetSuc == YES) {
//                NSLog(@"设置Activeminitues功能状态成功");
//                self.ResultData.text = @"设置Activeminitues功能状态成功";
//            }else{
//                NSLog(@"设置Activeminitues功能状态失败");
//                self.ResultData.text = @"设置Activeminitues功能状态失败";
//            }
//
//        } disposeErrorBlock:^(AM3SErrorID errorID) {
//            NSLog(@"your AM3S error id:%d",errorID);
//            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
//        }];
//        
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//    
//}
//
//// 设置图片格式
//- (IBAction)commandAM3SSetPicture:(id)sender {
//    // 初始化AM3S控制类
//    AM3SController *controller = [AM3SController shareIHAM3SController];
//    // 接收到 AM3SConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建AM3S实例调用通讯相关接口
//        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 设置图片格式
//        // 第一套Picture_one
//        // 第二套Picture_two
//        // 不知道设置什么类型
//        // AM3SPicture *pictureFormat =Picture_one;
//        
//        [bpInstance commandAM3SSetPicture:Picture_one resultBlock:^(BOOL resetSuc) {
//            if (resetSuc == YES) {
//                NSLog(@"设置图片格式成功");
//                self.ResultData.text = @"设置图片格式成功";
//            }else{
//                NSLog(@"设置图片格式失败");
//                self.ResultData.text = @"设置图片格式失败";
//            }
//        } disposeErrorBlock:^(AM3SErrorID errorID) {
//            NSLog(@"your AM3S error id:%d",errorID);
//            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
//        }];
//           }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//}
//
//
//// 查询Activeminitues功能状态(对文档 your AM3S error id:0)
//- (IBAction)commandAM3SQueryActiveminitues:(id)sender {
//    // 初始化AM3S控制类
//    AM3SController *controller = [AM3SController shareIHAM3SController];
//    // 接收到 AM3SConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建AM3S实例调用通讯相关接口
//        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 查询Activeminitues功能状态
//        [bpInstance commandAM3SQueryActiveminitues:^(BOOL resetSuc) {
//            // BOOL值不知道什么意思
//            if (resetSuc == YES) {
//                NSLog(@"Activeminitues功能状态打开");
//                self.ResultData.text = @"Activeminitues功能状态打开";
//            }else{
//                NSLog(@"Activeminitues功能状态关闭");
//                self.ResultData.text = @"Activeminitues功能状态关闭";
//            }
//            
//        } disposeErrorBlock:^(AM3SErrorID errorID) {
//            NSLog(@"your AM3S error id:%d",errorID);
//            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
//        }];
//       
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//
//}
//
//
//// 查询图片格式
//- (IBAction)commandAM3SQueryPicture:(id)sender {
//    // 初始化AM3S控制类
//    AM3SController *controller = [AM3SController shareIHAM3SController];
//    // 接收到 AM3SConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建AM3S实例调用通讯相关接口
//        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 查询图片格式
//        [bpInstance commandAM3SQueryPicture:^(AM3SPicture picture) {
//            NSLog(@"查询图片格式为:%u",picture);
//            self.ResultData.text = [NSString stringWithFormat:@"查询图片格式为:%u",picture];
//        } disposeErrorBlock:^(AM3SErrorID errorID) {
//            NSLog(@"your AM3S error id:%d",errorID);
//            self.ResultData.text = [NSString stringWithFormat:@"your AM3S error id:%d",errorID];
//        }];
//        
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//}


// 设置AM状态(对文档 通信错误)
- (IBAction)commandAM3SSetState:(id)sender {
    // 初始化AM3S控制类
    AM3SController *controller = [AM3SController shareIHAM3SController];
    // 接收到 AM3SConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3SInstace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3S实例调用通讯相关接口
        AM3S *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置AM状态 AM 状态，State_wrist 手腕，State_waist 腰
        /*
         AM3SActive_State =0,//运动
         AM3SSleep_State =1,//睡眠
         AM3SFly_State =2, //飞行
         AM3SWorkout_State=4, //workout
         AM3SSwimming_State=5, //游泳
         */
        // 一系列不知道怎么使用 tydef enum
        
        //AM3SActiveState *amState = AM3SActive_State;
        
        [bpInstance commandAM3SSetState:AM3SSleep_State disposeBlock:^(BOOL resetSuc) {
            if (resetSuc == YES) {
                // 收到设置状态确认
                NSLog(@"设置AM状态成功");
                self.ResultData.text = @"设置AM状态成功";
            }else{
                NSLog(@"设置AM状态失败");
                self.ResultData.text = @"设置AM状态失败";
            }
        } disposeErrorBlock:^(AM3SErrorID errorID) {
            // 没有设备存在的时候
            NSLog(@"log...");
            self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}
@end