//
//  PO3ViewController.h
//  testCommicationMode
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface PO3ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *ResultData;

// 历史数据
- (IBAction)commandPO3HistoryDataCount:(id)sender;

// 查询电量
- (IBAction)commandQueryBatteryInfo:(id)sender;

// 恢复出厂设置
- (IBAction)commandResetDeviceResult:(id)sender;

// 同步时间和实时测量
- (IBAction)commandPO3SyncTimeResult:(id)sender;

// 断开连接
- (IBAction)commandEndPO3DisConnect:(id)sender;


@end

