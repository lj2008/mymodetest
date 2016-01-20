//
//  BP3LViewController.h
//  testCommicationMode
//
//  Created by Mac on 15/12/7.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BP3LViewController : UIViewController

// 获取下位机功能信息，并同步时间
- (IBAction)commandFounctionPressed:(id)sender;

// 用于返回下位机的剩余电量的百分比，NSNumber类型，即，当值为80，表示剩余80%的电量
- (IBAction)commanfEnergy:(id)sender;

// 该方法用于开启血压测量，并返回测量过程血压值、小波数据、血压测量结果等信息
- (IBAction)commandStartMeasurePressed:(id)sender;

// 该方法用于向下位机发送停止测量指令，并返回是否成功
- (IBAction)stopBPMeasure:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *ResultData;

@end
