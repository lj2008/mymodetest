//
//  HS5ViewController.m
//  testCommicationMode
//
//  Created by Mac on 15/12/10.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import "HS5ViewController.h"
#import "CommUser.h"
#import "HS5Controller.h"
#import "HS5.h"
#import "BasicCommunicationObject.h"

@interface HS5ViewController ()
{
    NSNumber *pos;
    NSNumber *cloudSer;

}
@end

@implementation HS5ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForHS5:) name:DeviceConnect object:nil];
////    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForHS5:) name:DeviceDisconnect object:nil];
    
    [HS5Controller shareIHHs5Controller];
    [[BasicCommunicationObject basicCommunicationObject]searchScale];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - HS5
// HS5断开测量连接(注册消息)
-(void)DeviceDisConnectForHS5:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}

/*
 HS5创建测量连接(注册消息)
 */
-(void)DeviceConnectForHS5:(NSNotification *)tempNoti{
    // 初始化HS5控制类
    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
    // 接收到 HS5ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS5实例调用通讯相关接口
        // HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 暂不处理
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

/*建立HS5用户管理连接*/
- (IBAction)commandCreateUserConnect:(id)sender {
    // 初始化HS5控制类
    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
    // 接收到 HS5ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS5实例调用通讯相关接口
        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 建立HS5用户管理连接
        [bpInstance commandCreateUserManageConnect:^(NSArray *userListDataArray) {
            // HS5中已有用户的信息，包括用户的serialNub、Position（位置）。对应的key：serialNumber、position
            NSLog(@"HS5中已有用户的信息为:%@",userListDataArray);
            self.ResultData.text = [NSString stringWithFormat:@"HS5中已有用户的信息为:%@",userListDataArray];
            
            // 获取用户信息 第一位用户用于测试
            // 有用户的场合
            if(userListDataArray.count ){
               CommUser*myUser=[CommUser shareCommUser];
                NSDictionary*dic= [userListDataArray objectAtIndex:0];
                // 获取position值
                pos=[dic valueForKey:@"position"];
                
                cloudSer=[dic valueForKey:@"serialNumber"];
                
                myUser.cloudSerialNumber=cloudSer;
                currentUser = myUser;
            }
            
            
            
        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
            // 返回HS5通讯错误代码
            NSLog(@"your HS5 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

/* 更新用户信息(确认用户位置) */
- (IBAction)commandModifyUserPosition:(id)sender {
    // 初始化HS5控制类
    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
    // 接收到 HS5ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS5实例调用通讯相关接口
        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 更新用户信息 称中位置
         CommUser*myUser=[CommUser shareCommUser];
        NSNumber *HS5Position  =@3 ;
        myUser.cloudSerialNumber=@121212;
        currentUser =myUser;
        
        [bpInstance commandModifyUserPosition:HS5Position DisposeHS5Result:^(BOOL resetSuc) {
            
                // 在这执行才能获取到HS5Position
                // 创建记忆上传连接
                [bpInstance commandcreateMemoryUploadConnect:^(BOOL resetSuc) {
                    if (resetSuc == YES) {
                        NSLog(@"创建记忆连接成功");
                        self.ResultData.text = @"创建记忆连接成功";
                    }else{
                        NSLog(@"创建记忆连接失败");
                        self.ResultData.text = @"创建记忆连接失败";
                    }
                } TransferMemorryData:^(BOOL startHS5Transmission) {
                    // 开始记忆传输
                    NSLog(@"HS5开始记忆传输");
                    
                } DisposeProgress:^(NSNumber *progress) {
                    // 记忆传输进度，0.0～1.0
                    NSLog(@"记忆传输进度:%@",progress);
                    self.ResultData.text = [NSString stringWithFormat:@"记忆传输进度:%@",progress];
                    
                } MemorryData:^(NSDictionary *historyDataDic) {
                    // 记忆内容
                    /*
                     body info, includes weight(kg), fat content(%), water content(%), muscle content(%), bone mass, visceral fat level, DCI(Kcal). keys: weight, weightFatValue, waterValue, muscleValue, skeletonValue, VFatLevelValue, DCIValue
                     */
                    NSLog(@"记忆数据为:%@",historyDataDic);
                    self.ResultData.text = [NSString stringWithFormat:@"记忆数据为:%@",historyDataDic];
                    
                } FinishTransmission:^(BOOL finishHS5Transmission) {
                    NSLog(@"记忆传输结束");
                    
                } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
                    NSLog(@"your HS5 error id:%d",errorID);
                    self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
                }];
                
            
            if(resetSuc == YES){
                NSLog(@"HS5更新用户信息成功");
                self.ResultData.text = @"HS5更新用户信息成功";
            }else{
                NSLog(@"HS5更新用户信息失败");
                self.ResultData.text = @"HS5更新用户信息失败";
            }
                
        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
            NSLog(@"your HS5 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}

/*创建用户 设置用户到HS5中*/
- (IBAction)commandCreateUserPosition:(id)sender {
    // 初始化HS5控制类
    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
    // 接收到 HS5ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS5实例调用通讯相关接口
        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 创建用户
        // 设置用户位置(0-19)
        CommUser*myUser=[CommUser shareCommUser];
        NSNumber *HS5Position  = @3 ;
        myUser.cloudSerialNumber =@121212;
        currentUser = myUser;
        
        [bpInstance commandCreateUserPosition:HS5Position DisposeHS5Result:^(BOOL resetSuc) {
            if(resetSuc == YES){
                NSLog(@"HS5创建用户信息成功");
                self.ResultData.text = @"HS5创建用户信息成功";
            }else{
                NSLog(@"HS5创建用户信息失败");
                self.ResultData.text = @"HS5创建用户信息失败";
            }
        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
            NSLog(@"your HS5 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
        } ];
        
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

/*创建记忆上传连接*/
- (IBAction)commandcreateUploadConnect:(id)sender {
    // 初始化HS5控制类
    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
    // 接收到 HS5ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
    
    CommUser*myUser=[CommUser shareCommUser];
    NSNumber *HS5Position  =@3 ;
    myUser.cloudSerialNumber=@121212;
    currentUser =myUser;
    // 有设备存在的时候
    if (bpDeviceArray.count && currentUser!=nil) {
        // 创建HS5实例调用通讯相关接口
        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 创建记忆上传连接
        [bpInstance commandcreateMemoryUploadConnect:^(BOOL resetSuc) {
            if (resetSuc == YES) {
                NSLog(@"创建记忆连接成功");
                self.ResultData.text = @"创建记忆连接成功";
            }else{
                NSLog(@"创建记忆连接失败");
                self.ResultData.text = @"创建记忆连接失败";
            }
        } TransferMemorryData:^(BOOL startHS5Transmission) {
            // 开始记忆传输
            NSLog(@"HS5开始记忆传输");
            
        } DisposeProgress:^(NSNumber *progress) {
            // 记忆传输进度，0.0～1.0
            NSLog(@"记忆传输进度:%@",progress);
            self.ResultData.text = [NSString stringWithFormat:@"记忆传输进度:%@",progress];
            
        } MemorryData:^(NSDictionary *historyDataDic) {
            // 记忆内容
            /*
             body info, includes weight(kg), fat content(%), water content(%), muscle content(%), bone mass, visceral fat level, DCI(Kcal). keys: weight, weightFatValue, waterValue, muscleValue, skeletonValue, VFatLevelValue, DCIValue
             */
            NSLog(@"记忆数据为:%@",historyDataDic);
            self.ResultData.text = [NSString stringWithFormat:@"记忆数据为:%@",historyDataDic];
            
        } FinishTransmission:^(BOOL finishHS5Transmission) {
            NSLog(@"记忆传输结束");
            
        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
            NSLog(@"your HS5 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
        }];
      
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

/* 断开此次连接 */
- (IBAction)commandEndCurrentConnect:(id)sender {
    // 初始化HS5控制类
    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
    // 接收到 HS5ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS5实例调用通讯相关接口
        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 断开此次连接
        [bpInstance commandEndCurrentConnect:^(BOOL resetSuc) {
            if (resetSuc == YES) {
                NSLog(@"HS5断开此次连接成功");
                self.ResultData.text = @"HS5断开此次连接成功";
            }else{
                NSLog(@"HS5断开此次连接失败");
                self.ResultData.text = @"HS5断开此次连接失败";
            }
        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
            NSLog(@"your HS5 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

/*创建测量连接*/
- (IBAction)commandCreateMeasure:(id)sender {
    // 初始化HS5控制类
    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
    // 接收到 HS5ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS5实例调用通讯相关接口
        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 创建测量连接
        NSLog(@"设备UUID:%@",bpInstance.currentUUID);
        [bpInstance commandCreateMeasure:^(NSNumber *unStableWeight) {
            // 时时体重，单位kg
            NSLog(@"HS5 时时体重为:%@",unStableWeight);
            self.ResultData.text = [NSString stringWithFormat:@"HS5 时时体重为:%@",unStableWeight];
            
        } MeasureWeight:^(NSNumber *StableWeight) {
            // 稳定体重，单位kg
            NSLog(@"HS5稳定体重为:%@",StableWeight);
            self.ResultData.text = [NSString stringWithFormat:@"HS5稳定体重为:%@",StableWeight];
            
        } ImpedanceType:^(NSNumber *ImpedanceWeight) {
            // 阻抗体重，单位kg
            NSLog(@"HS5阻抗体重为:%@",ImpedanceWeight);
            self.ResultData.text = [NSString stringWithFormat:@"HS5阻抗体重为:%@",ImpedanceWeight];
            
        } BodyCompositionMeasurements:^(NSDictionary *BodyCompositionInforDic) {
            /*
             人体成分信息，包括体重(kg)、脂肪含量(%)、水分含量(%)、肌肉含量(kg)、骨骼含量(kg)、内脏脂肪等级、DCI(Kcal)。对应的key：weight、weightFatValue、waterValue、muscleValue、skeletonValue、VFatLevelValue、DCIValue
             */
            NSLog(@"人体成分信息为:%@",BodyCompositionInforDic);
            self.ResultData.text = [NSString stringWithFormat:@"人体成分信息为:%@",BodyCompositionInforDic];
            
        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
            NSLog(@"your HS5 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

/*从秤中删除用户*/
- (IBAction)commandDelteUserID:(id)sender {
    // 初始化HS5控制类
    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
    // 接收到 HS5ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建HS5实例调用通讯相关接口
        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        // 从秤中删除用户
        // 设置删除用户userSerialNumber(为0的用户)
        NSNumber *HS5userser = cloudSer;
        // 设置删除用户位置
        NSNumber *HS5position = pos;
        
        NSLog(@"设备UUID:%@",bpInstance.currentUUID);
        
        [bpInstance commandDelteUserID:HS5userser AimPosition:HS5position DisposeHS5Result:^(BOOL resetSuc) {
            if (resetSuc == YES) {
                NSLog(@"HS5删除用户成功");
                self.ResultData.text = @"HS5删除用户成功";
            }else{
                NSLog(@"HS5删除用户失败");
                self.ResultData.text = @"HS5删除用户失败";
            }
            
        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
            NSLog(@"your HS5 error id:%d",errorID);
            self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
        }];
        
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }
}

/*移动秤中用户位置 未用*/
//- (IBAction)commandChangeUserPosition:(id)sender {
//    // 初始化HS5控制类
//    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
//    // 接收到 HS5ConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建HS5实例调用通讯相关接口
//        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 移动秤中用户位置 具体参数不知道类型
//        // 当前用户位置
//        NSInteger HS5currposition = 19;
//        // 移动用户位置
//        NSInteger HS5aimposition = 16;
//        // 设置用户SerialNumber
//        NSNumber *HS5SerialNumber = @13600;
//        
//        [bpInstance commandChangeUserPosition:HS5currposition AimPosition:HS5aimposition UserSerialNumber:HS5SerialNumber DisposeHS5Result:^(BOOL resetSuc) {
//            if (resetSuc == YES) {
//                NSLog(@"移动秤中用户位置成功");
//                self.ResultData.text = @"移动秤中用户位置成功";
//            }else{
//                NSLog(@"移动秤中用户位置失败");
//                self.ResultData.text = @"移动秤中用户位置失败";
//            }
//            
//        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
//            NSLog(@"your HS5 error id:%d",errorID);
//            self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
//        }];
//        
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//}

///*设置HS5的名称 未用*/
//- (IBAction)commandSetScaleName:(id)sender {
//    // 初始化HS5控制类
//    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
//    // 接收到 HS5ConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建HS5实例调用通讯相关接口
//        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 设置HS5的名称
//        NSString *HS5scaleName =@"LIAOJUAN";
//        [bpInstance commandSetScaleName:HS5scaleName DisposeHS5Result:^(BOOL resetSuc) {
//            if (resetSuc == YES) {
//                NSLog(@"设置HS5的名称成功");
//                self.ResultData.text = @"设置HS5的名称成功";
//            }else{
//                NSLog(@"设置HS5的名称失败");
//                self.ResultData.text = @"设置HS5的名称失败";
//            }
//        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
//            NSLog(@"your HS5 error id:%d",errorID);
//            self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
//        }];
//        
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//}

///*设置HS5密码(未用)*/
//- (IBAction)commandSetScalePassWord:(id)sender {
//    // 初始化HS5控制类
//    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
//    // 接收到 HS5ConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建HS5实例调用通讯相关接口
//        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 设置HS5密码
//        NSString *HS5pwd =@"123456HAHA";
//        [bpInstance commandSetScalePassWord:HS5pwd DisposeHS5Result:^(BOOL resetSuc) {
//            if (resetSuc == YES) {
//                NSLog(@"设置HS5密码成功");
//                self.ResultData.text = @"设置HS5密码成功";
//            }else{
//                NSLog(@"设置HS5密码失败");
//                self.ResultData.text = @"设置HS5密码失败";
//            }
//        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
//            NSLog(@"your HS5 error id:%d",errorID);
//            self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
//        }];
//        
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//}
//
///*获取秤的超级用户密码(未用)*/
//- (IBAction)commandGetScalePassword:(id)sender {
//    // 初始化HS5控制类
//    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
//    // 接收到 HS5ConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建HS5实例调用通讯相关接口
//        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 获取秤的超级用户密码
//        [bpInstance commandGetScaleSuperPassword:^(NSString *superPassword) {
//            NSLog(@"获取秤的超级用户密码为:%@",superPassword);
//            self.ResultData.text = [NSString stringWithFormat:@"获取秤的超级用户密码为:%@",superPassword];
//        } DisposeHS5Result:^(BOOL resetSuc) {
//            if (resetSuc == YES) {
//                NSLog(@"获取秤的超级用户密码成功");
//                self.ResultData.text = @"获取秤的超级用户密码成功";
//            }else{
//                NSLog(@"获取秤的超级用户密码失败");
//                self.ResultData.text = @"获取秤的超级用户密码失败";
//            }
//        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
//            NSLog(@"your HS5 error id:%d",errorID);
//            self.ResultData.text = [NSString stringWithFormat:@"your HS5 error id:%d",errorID];
//        }];
//        
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//}
//
///*设置服务器地址（未用）*/
//- (IBAction)commandSetServerAdress:(id)sender {
//    // 初始化HS5控制类
//    HS5Controller *controller = [HS5Controller shareIHHs5Controller];
//    // 接收到 HS5ConnectNoti消息后，获取控制类实例
//    NSArray *bpDeviceArray = [controller getAllCurrentHS5Instace];
//    // 有设备存在的时候
//    if (bpDeviceArray.count) {
//        // 创建HS5实例调用通讯相关接口
//        HS5 *bpInstance = [bpDeviceArray objectAtIndex:0];
//        // 设置服务器地址
//        NSString *HS5serverAd =@"1234561234";
//        [bpInstance commandSetServerAdress:HS5serverAd];
//        
//        
//    }else{
//        // 没有设备存在的时候
//        NSLog(@"log...");
//        self.ResultData.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
//    }
//}
@end
