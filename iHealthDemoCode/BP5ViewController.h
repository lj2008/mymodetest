//
//  BP5ViewController.h
//  testCommicationMode
//
//  Created by Mac on 15/12/4.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BP5Controller.h"

@interface BP5ViewController : UIViewController

// 获取下位机功能信息，并同步时间
- (IBAction)commandFounctionPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *ResultData;

// 该方法用于设置下位机的离线记录开关
- (IBAction)commandSetOfflinePressed:(id)sender;

// 获取下位机的电量
- (IBAction)commandEnergyPressed:(id)sender;

// 该方法用于启动血压开始测量，并返回测量过程血压值、小波数据、血压测量结果等信息
- (IBAction)commandStartMeasurePressed:(id)sender;

// 该方法用于获取下位机的离线数据，返回内容包括离线记录条数、上传进度，以及详细离线记录的数组
- (IBAction)commandBatchUpload:(id)sender;

// 该方法用于向下位机发送停止测量指令，并返回是否成功
- (IBAction)stopBPMeassurePressed:(id)sender;

@end
