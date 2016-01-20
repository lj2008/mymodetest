//
//  AM3SViewController.h
//  testCommicationMode
//
//  Created by Mac on 15/12/7.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AM3SViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *ResultData;

// 设置随机数
- (IBAction)commandAM3SSetRandom:(id)sender;

// 同步时间(包含查询和设置MD5)
- (IBAction)commandAM3SSyncTimeResult:(id)sender;

// 查询区域时间格式
- (IBAction)commandQueryTimeNation:(id)sender;

// 设置区域时间格式
- (IBAction)commandAM3SFinishSetTimeFormat:(id)sender;

// 绑定用户(下发用户ID)
- (IBAction)commandAM3SSetUserID:(id)sender;

// 配置个人信息(单位、目标)
- (IBAction)commandAM3SSetUserInfo:(id)sender;

// 查询用户ID
- (IBAction)getAM3SUserID:(id)sender;

// 设置BMR(下位机1.0.2版本以后才可以调这个方法)
- (IBAction)commandAM3SSetBMR:(id)sender;

// 同步运动 睡眠 实时运动
- (IBAction)commandAM3SStartSyncActiveData:(id)sender;

// 查询总的闹钟信息
- (IBAction)commandQueryAlarmAlarmData:(id)sender;

// 恢复出厂设置
- (IBAction)commandResetDeviceResult:(id)sender;

// 设置闹钟
- (IBAction)commandSetAlarmWithDictionary:(id)sender;

// 删除闹钟
- (IBAction)commandAM3SDeleteAlarmID:(id)sender;

// 查询提醒
- (IBAction)commandAM3SDisposeQueryReminder:(id)sender;

// 设置提醒
- (IBAction)commandSetReminderWithDictionary:(id)sender;

// 查询状态，电量
- (IBAction)commandQueryStateInfo:(id)sender;

// 断开连接
- (IBAction)commandAM3SDisconnect:(id)sender;

// 查询歩距
- (IBAction)commandAM3SQueryStep:(id)sender;

// 查询用户信息
- (IBAction)commandAM3SQueryUserInfo:(id)sender;

// 阶段性报告数据
- (IBAction)commandAM3SSetSyncsportCount:(id)sender;

// 设置歩距
- (IBAction)commandAM3SSetStep:(id)sender;

//// 设置Activeminitues功能状态
//- (IBAction)commandAM3SSetActiveminitues:(id)sender;
//
//// 设置图片格式
//- (IBAction)commandAM3SSetPicture:(id)sender;
//
//// 查询Activeminitues功能状态
//- (IBAction)commandAM3SQueryActiveminitues:(id)sender;
//
//// 查询图片格式
//- (IBAction)commandAM3SQueryPicture:(id)sender;

// 设置状态
- (IBAction)commandAM3SSetState:(id)sender;

@end
