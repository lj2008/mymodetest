//
//  AM3ViewController.m
//  testCommicationMode
//
//  Created by Mac on 15/12/15.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AM3ViewController.h"
#import "AM3.h"
#import "AM3Controller.h"
#import "BasicCommunicationObject.h"
@interface AM3ViewController ()

@end

@implementation AM3ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
            // 保存用户ID FOR TEST
            CommUser*myUser=[CommUser shareCommUser];
            myUser.cloudSerialNumber=@654321;
            currentUser =myUser;

    // 注册AM3设备接入消息和AM3断开连接消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForAM3:) name:DeviceConnect object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForAM3:) name:DeviceDisconnect object:nil];
    // APP端与AM3的通信底层部分进行初始化
    [AM3Controller shareIHAM3Controller];
    [BasicCommunicationObject basicCommunicationObject];
    
    // 进行AM3扫描
    [[BasicCommunicationObject basicCommunicationObject] startSearchBTLEDevice:BtleType_AM3];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - AM3
// AM3断开测量连接(注册消息)
-(void)DeviceDisConnectForAM3:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}

/*
 AM3创建测量连接(注册消息)_暂时设置用户信息
 */
-(void)DeviceConnectForAM3:(NSNotification *)tempNoti{

    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
//        // 保存用户ID FOR TEST
//        CommUser*myUser=[CommUser shareCommUser];
//        myUser.cloudSerialNumber=@654321;
//        currentUser =myUser;
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 同步时间
- (IBAction)commandAM3yncTimeResult:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3SyncTimeResultBlock:^(BOOL resetSuc) {
            // 收到同步时间确认
            // 同步时间
            if (resetSuc == YES) {
                NSLog(@"同步时间成功");
                self.ResultData.text = @"同步时间成功";
            }else{
                NSLog(@"同步时间失败");
                self.ResultData.text = @"同步时间失败";
            }
        } disposeErrorBlock:^(AMErrorID errorID) {
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 查询区域时间格式(下位机1.1.9版本以后才可以调这个方法)
- (IBAction)commandQueryTimeNation:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3QueryTimeFormatAndNation:^(AM3TimeFormatAndNation timeFormatAndNation) {
            // 查询区域时间格式
            /*
             AM3TimeFormat_hh,//12
             AM3TimeFormat_HH,//24
             AM3TimeFormat_NoEuropeAndhh,//非欧洲12小时
             AM3TimeFormat_EuropeAndhh,//欧洲12小时
             AM3TimeFormat_NoEuropeAndHH,//非欧洲24小时
             AM3TimeFormat_EuropeAndHH,//欧洲24小时
             */
            NSLog(@"查询区域时间格式结果:%u",timeFormatAndNation);
            self.ResultData.text = [NSString stringWithFormat:@"查询区域时间格式结果:%u",timeFormatAndNation];
        } disposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 设置区域时间格式(下位机1.1.9版本以后才可以调这个方法)
- (IBAction)commandAM3FinishSetTimeFormat:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3FinishSetTimeFormat:^(BOOL timeFormatAndNationSetting) {
            // 收到设置区域时间格式确认
            // 设置区域时间格式成功与否
            if (timeFormatAndNationSetting == YES) {
                NSLog(@"设置区域时间格式成功");
                self.ResultData.text = @"设置区域时间格式成功";
            }else{
                NSLog(@"设置区域时间格式失败");
                self.ResultData.text = @"设置区域时间格式失败";
            }
            
        } disposeErrorBlock:^(AMErrorID errorID) {
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 绑定用户(下发用户ID)
- (IBAction)commandAM3etUserID:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 绑定用户(下发用户ID)
        // 用户唯一标示
        NSNumber *userid =@654321;
        
        // 保存用户id
        CommUser*myUser=[CommUser shareCommUser];
        myUser.cloudSerialNumber=userid;
        currentUser =myUser;
        
        [bpInstance commandAM3SetUserID:userid finishResultBlock:^(BOOL resetSuc) {
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
            
        } disposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误id
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

    
}

// 查询用户ID
- (IBAction)getAM3UserID:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 查询用户ID
        // TO:设备UUID
        NSString *toWhat = bpInstance.currentUUID;
        [bpInstance getAM3UserID:^(unsigned int userID) {
            // 查询用户ID结果
            NSLog(@"查询用户ID结果:%d",userID);
            self.ResultData.text = [NSString stringWithFormat:@"查询用户ID结果:%d",userID];
        } disposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误id
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        } To:toWhat];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 配置个人信息
- (IBAction)commandAM3etUserInfo:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        
        // 配置个人信息(单位、目标)
        // 设置AM3用户信息
        /*
         NSDate *ageDate;出生日期
         NSNumber *sexNumber;0女1男
         NSNumber *heightNumber;身高
         NSNumber *weightNumber;体重
         NSNumber *bmr;基础代谢率
         */
        AM3User *userinfo = [[AM3User alloc]init];
        // 用户生日
        userinfo.ageDate = [NSDate date];
        // 用户性别
        userinfo.sexNumber = AM3Gender_Male;
        // 用户身高
        userinfo.heightNumber = @175;
        // 用户体重
        userinfo.weightNumber = @55;
        // 用户基础代谢率
        userinfo.bmr = @100;
        // AM显示总距离单位
        // AM3KmUnit_mile,
        // AM3KmUnit_km
        // 用户目标步数
        // 运动目标 1-60000
        NSNumber *amGoal = @50000;

        [bpInstance commandAM3SetUserinfo:userinfo unit:AM3StateUnit_mile goal:amGoal finishSetBMRDisposeBlock:^(BOOL resetSuc) {
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
        } disposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误id
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

   }

// 设置BMR(下位机1.0.2版本以后才可以调这个方法)
- (IBAction)commandAM3etBMR:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置用户基础代谢率
        NSNumber *amBMR = @98;
        
        [bpInstance commandAM3SetBMR:amBMR finishSetBMRResultBlock:^(BOOL resetSuc) {
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
        } disposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误id
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 同步运动 睡眠 实时运动
- (IBAction)commandAM3tartSyncActiveData:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3StartSyncActiveData:^(NSDictionary *startActiveDataDictionary) {
            // 开始传输活动数据
            /*
             Dic(@"StartActiveHistoryDateYear",@"StartActiveHistoryDateMonth",@"StartActiveHistoryDateDay",@"StepSize",@"TimeInterval",@"StartActiveHistoryTotoalNum")
             */
            // 开始上传运动数据，包含属性：StartActiveHistoryDate、StepSize、StartActiveHistoryTotoalNum
            // StartActiveHistoryDate：运动开始时间，yyyy-MM-dd.
            // StepSize：步长，单位 cm。
            // StartActiveHistoryTotoalNum：记录总条数。
            NSLog(@"开始上传运动数据:%@",startActiveDataDictionary);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%@",startActiveDataDictionary];
        } activeHistoryData:^(NSArray *activehistoryDataArray) {
            // 运动历史数据
            // array(dic)
            // 运动记录，包含属性：AMDate、AMCalorie、AMStepNum。
            // AMDate：运动时间， NSDate.
            // AMCalorie:当前时间总卡路里。
            // AMStepNum：当前时间总步数。
            NSLog(@"运动记录数据为:%@",activehistoryDataArray);
            self.ResultData.text = [NSString stringWithFormat:@"运动记录数据为:%@",activehistoryDataArray];
        } activeFinishTransmission:^{
            // 运动传输结束
            NSLog(@"运动数据上传完成");
            self.ResultData.text = @"运动数据上传完成";
        } startSyncSleepData:^(NSDictionary *startSleepDataDictionary) {
            // 开始传输睡眠数据
            /*
             Dic（SleepActiveHistoryDateYear，SleepActiveHistoryDateMonth，SleepActiveHistoryDateDay，SleepActiveHistoryDateHour，SleepActiveHistoryDateMinute，SleepActiveHistoryDateSeconds，TimeInterval，StartActiveHistoryTotoalNum）
             */
            /*
             startSleepTransmission：开始上传睡眠，包含属性：SleepActiveHistoryDate、StartActiveHistoryTotoalNum。
             SleepActiveHistoryDate：睡眠开始时间，yyyy-MM-dd HH:mm:ss.
             StartActiveHistoryTotoalNum: 记录总条数.
             */
            NSLog(@"开始上传睡眠数据:%@",startSleepDataDictionary);
            self.ResultData.text = [NSString stringWithFormat:@"开始上传睡眠数据:%@",startSleepDataDictionary];
            
        } sleepHistoryData:^(NSArray *sleephistoryDataArray) {
            // 睡眠历史数据
            // 睡眠记录，包含属性：AMDate、SleepData。
            // AMDate：睡眠时间， NSDate.
            // SleepData:睡眠等级，0 清醒， 1浅睡， 2深睡。
            NSLog(@"睡眠记录数据为:%@",sleephistoryDataArray);
            self.ResultData.text = [NSString stringWithFormat:@"睡眠记录数据为:%@",sleephistoryDataArray];
        } sleepFinishTransmission:^{
            // 睡眠传输结束
            NSLog(@"睡眠数据上传完成");
            self.ResultData.text = @"睡眠数据上传完成";
        } currentActiveInfo:^(NSDictionary *CurrentActiveDictionary) {
            // 增加查询当前运动信息;@"Step",@"Calories"
            /*
             当天最新总卡路里和总步数，包含属性：Step、Calories。
             Step：当前总步数。
             Calories：当前总卡路里。
             */
            NSLog(@"当天最新总卡路里和总步数为:%@",CurrentActiveDictionary);
            self.ResultData.text = [NSString stringWithFormat:@"当天最新总卡路里和总步数为:%@",CurrentActiveDictionary];
        } disposeErrorBlock:^(AMErrorID errorID) {
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
       
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
        
    }

}

// 恢复出厂设置
- (IBAction)commandResetDeviceResult:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 调用恢复出厂设置接口
        [bpInstance commandAM3ResetDeviceDisposeResultBlock:^(BOOL resetSuc) {
            if (resetSuc == YES) {
                NSLog(@"恢复出厂设置成功");
                self.ResultData.text = @"恢复出厂设置成功";
            }else{
                NSLog(@"恢复出厂设置失败");
                self.ResultData.text = @"恢复出厂设置失败";
            }
            // 返回通讯错误id
        } disposeErrorBlock:^(AMErrorID errorID) {
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 查询总的闹钟信息
- (IBAction)commandQueryAlarmAlarmData:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3QueryAlarmInfoDisposeTotoalAlarmData:^(NSMutableArray *totoalAlarmArray) {
            // 查询总的闹钟信息
            NSLog(@"查询总的闹钟信息为:%@",totoalAlarmArray);
            self.ResultData.text = [NSString stringWithFormat:@"查询总的闹钟信息为:%@",totoalAlarmArray];
            
        } disposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 设置闹钟
- (IBAction)commandSetAlarmWithDictionary:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置闹钟提醒信息
        //  alarmDic：闹钟信息，包含属性：AlarmId、Time、IsRepeat、Switch、（Sun、Mon、Tue、Wed、Thu、Fri、Sat
        // E.G.示例
        //  NSDictionary *tempClockDic = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"AlarmId",@1,@"Sun",@"17:45",@"Time",@1,@"IsRepeat",@1,@"Switch",nil];
        
        NSDictionary *alarminfo = [NSDictionary dictionaryWithObjectsAndKeys:@3,@"AlarmId",@1,@"Sun",@"17:30",@"Time",@1,@"IsRepeat",@1,@"Switch",nil];
        
        [bpInstance commandAM3SetAlarmWithAlarmDictionary:alarminfo disposeResultBlock:^(BOOL resetSuc) {
            // 收到设置闹钟确认
            if (resetSuc == YES) {
                NSLog(@"设置闹钟各参数成功");
                self.ResultData.text = @"设置闹钟各参数成功";
            }else{
                NSLog(@"设置闹钟各参数失败");
                self.ResultData.text = @"设置闹钟各参数失败";
            }
        } disposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 删除闹钟
- (IBAction)commandAM3DeleteAlarmID:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 删除闹钟ID
        // alarmID：闹钟id，范围：1、2、3
        NSNumber *deleteAlarmID = @3;
        [bpInstance commandAM3DeleteAlarmID:deleteAlarmID disposeResultBlock:^(BOOL resetSuc) {
            // 收到删除闹钟确认
            if (resetSuc == YES) {
                NSLog(@"删除闹钟成功");
                self.ResultData.text = @"删除闹钟成功";
            }else{
                NSLog(@"删除闹钟失败");
                self.ResultData.text = @"删除闹钟失败";
            }
        } disposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 查询提醒
- (IBAction)commandAM3DisposeQueryReminder:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3QueryReminder:^(NSArray *remindInfoArray) {
            // 收到提醒信息确认
            // 返回提醒信息
            // remindInfoArray：提醒数组，包含属性：Time、Switch。
            // Time：提醒时长，格式HH:mm, 即提醒间隔为(HH*60+mm)分钟。
            // Switch：提醒开关，True 打开， False 关闭。
            NSLog(@"查询到的提醒信息结果为:%@",remindInfoArray);
            self.ResultData.text = [NSString stringWithFormat:@"查询到的提醒信息结果为:%@",remindInfoArray];
        } disposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];

    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 设置提醒
- (IBAction)commandSetReminderWithDictionary:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置提醒信息
        // Dic（ReminderID，Time，Switch
        // 提醒信息，包含属性：Time、Switch。
        NSDictionary *setreminderinfo = [NSDictionary dictionaryWithObjectsAndKeys:@"00:01",@"Time",@0,@"Switch",nil];
        [bpInstance commandAM3SetReminderWithReminderDictionary:setreminderinfo disposeResultBlock:^(BOOL resetSuc) {
            // 收到设置提醒确认
            if (resetSuc == YES) {
                NSLog(@"设置提醒各参数成功");
                self.ResultData.text = @"设置提醒各参数成功";
            }else{
                NSLog(@"设置提醒各参数失败");
                self.ResultData.text = @"设置提醒各参数失败";
            }
            
        } disposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

// 查询状态，电量
- (IBAction)commandQueryStateInfo:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandAM3QueryStateInfo:^(AM3QueryState queryState) {
            // 收到状态确认
            /*
             AM3State_wrist,//手腕
             AM3State_waist,//腰
             AM3State_sleep//睡眠
             */
            // 查询AM状态
            NSLog(@"查询AM状态为:%u",queryState);
            self.ResultData.text = [NSString stringWithFormat:@"查询AM状态为:%u",queryState];
        } disposeBattery:^(NSNumber *battery) {
            // 查询AM电量  1--100
            NSLog(@"查询AM电量为:%@",battery);
            self.ResultData.text = [NSString stringWithFormat:@"查询AM电量为:%@",battery];
        } disposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
    
}

// 设置状态
- (IBAction)commandAM3etState:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置AM状态 AM 状态，State_wrist 手腕，State_waist 腰
        /*
         AM3Sleep_State,//睡眠
         AM3Active_State,//运动
         AM3Fly_State, //飞行
         Drive_State,
         */
        // 一系列不知道怎么使用 tydef enum
        
        //AM3ActiveState *amState = AM3Active_State;
        [bpInstance commandAM3SetState:AM3Active_State disposeBlock:^(BOOL resetSuc) {
            if (resetSuc == YES) {
                // 收到设置状态确认
                NSLog(@"设置AM状态成功");
                self.ResultData.text = @"设置AM状态成功";
            }else{
                NSLog(@"设置AM状态失败");
                self.ResultData.text = @"设置AM状态失败";
            }
        } DisposeErrorBlock:^(AMErrorID errorID) {
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

// 查询用户信息
- (IBAction)commandQueryUserInfo:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 查询用户信息
        [bpInstance commandAM3QueryUserInfo:^(NSDictionary *userInfo) {
            // 查询用户信息结果
            NSLog(@"查询到得用户信息结果为:%@",userInfo);
            self.ResultData.text = [NSString stringWithFormat:@"查询到得用户信息结果为:%@",userInfo];
        } DisposeErrorBlock:^(AMErrorID errorID) {
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

// 断开连接
- (IBAction)commandAM3Disconnect:(id)sender {
    // 初始化AM3控制类
    AM3Controller *controller = [AM3Controller shareIHAM3Controller];
    // 接收到 AM3ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentAM3Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建AM3实例调用通讯相关接口
        AM3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 设置TO参数
        // UUID
        NSString *towhat = bpInstance.currentUUID;
        [bpInstance commandAM3DisconnectDisposeBlock:^(BOOL resetSuc) {
            // 收到断开确认
            if (resetSuc == YES) {
                NSLog(@"断开连接成功");
                self.ResultData.text = @"断开连接成功";
            }else{
                NSLog(@"断开连接失败");
                self.ResultData.text = @"断开连接失败";
            }
        } DisposeErrorBlock:^(AMErrorID errorID) {
            // 返回通讯错误ID
            NSLog(@"your AM3 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your AM3 error id:%d",errorID];
        } To:towhat];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}
@end

