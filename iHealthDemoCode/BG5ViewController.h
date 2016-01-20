//
//  BG5ViewController.h
//  testCommicationMode
//
//  Created by Mac on 15/12/9.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//
#import <UIKit/UIKit.h>
#define CodeStr @"024C565F4C5614322D1200A02F3485B6F314378BACD619011F72003608A9"
@interface BG5ViewController : UIViewController

// 获取下位机离线历史记录，并返回历史记录条数和详细记录
- (IBAction)commandTransferMemorryData:(id)sender;

// 给下位机设置单位和时间，并返回bottleID
- (IBAction)commandInitBG5SetUnit:(id)sender;

// 删除下位机中的离线历史记录
- (IBAction)commandDeleteMemorryData:(id)sender;

// 该方法用于定期发送保持连接指令，保证上位机与下位机蓝牙模块处于连接状态。该方法需要定期调用，每调一次只发送一遍指令
- (IBAction)commandKeepConnect:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *ResultData;

// 获取下位机中保存的CODE
- (IBAction)commandReadBG5CodeDic:(id)sender;

// 向下位机发送BottleID并返回发送结果
- (IBAction)commandSendBottleID:(id)sender;

// 将CODE字符串、有效期和剩余条数发送给下位机，并设置下位机的开机模式
- (IBAction)commandSendBG5CodeString:(id)sender;

// 插条开机模式下的开始测量方法，调用之后能够返回测量过程中的插条，滴血，血糖结果，测量模式，以及错误ID
- (IBAction)commandCreateBGtestStripIn:(id)sender;

// 电源键开机模式下的开始测量方法，调用之后能够返回测量过程中的插条，滴血，血糖结果，测量模式，以及错误ID
- (IBAction)commandCreateBGtestModel:(id)sender;

// 获取下位机的电量
- (IBAction)commandQueryBattery:(id)sender;

@end
