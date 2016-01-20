//
//  AM3ViewController.h
//  testCommicationMode
//
//  Created by Mac on 15/12/15.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//


#import <UIKit/UIKit.h>

@class CommUser;
@interface AM3ViewController : UIViewController{
    
    CommUser *currentUser;
}


// 同步时间
- (IBAction)commandAM3yncTimeResult:(id)sender;

// 查询区域时间格式(下位机1.1.9版本以后才可以调这个方法)
- (IBAction)commandQueryTimeNation:(id)sender;

// 设置区域时间格式(下位机1.1.9版本以后才可以调这个方法)
- (IBAction)commandAM3FinishSetTimeFormat:(id)sender;

// 绑定用户(下发用户ID)
- (IBAction)commandAM3etUserID:(id)sender;

// 查询用户ID
- (IBAction)getAM3UserID:(id)sender;

// 配置个人信息
- (IBAction)commandAM3etUserInfo:(id)sender;

// 设置BMR(下位机1.0.2版本以后才可以调这个方法)
- (IBAction)commandAM3etBMR:(id)sender;

// 同步运动 睡眠 实时运动
- (IBAction)commandAM3tartSyncActiveData:(id)sender;

// 恢复出厂设置
- (IBAction)commandResetDeviceResult:(id)sender;

// 查询总的闹钟信息
- (IBAction)commandQueryAlarmAlarmData:(id)sender;

// 设置闹钟
- (IBAction)commandSetAlarmWithDictionary:(id)sender;

// 删除闹钟
- (IBAction)commandAM3DeleteAlarmID:(id)sender;

// 查询提醒
- (IBAction)commandAM3DisposeQueryReminder:(id)sender;

// 设置提醒
- (IBAction)commandSetReminderWithDictionary:(id)sender;

// 查询状态，电量
- (IBAction)commandQueryStateInfo:(id)sender;

// 设置状态
- (IBAction)commandAM3etState:(id)sender;

// 查询用户信息
- (IBAction)commandQueryUserInfo:(id)sender;

// 断开连接
- (IBAction)commandAM3Disconnect:(id)sender;

// 返回结果
@property (weak, nonatomic) IBOutlet UITextView *ResultData;

@end
