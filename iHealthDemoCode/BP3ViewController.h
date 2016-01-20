//
//  BP3ViewController.h
//  testCommicationMode
//
//  Created by Mac on 15/12/8.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BP7Controller.h"
@interface BP3ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *ResultData;

// 启动测量
- (IBAction)commandStartMeasure:(id)sender;

// 停止测量
- (IBAction)stopBPMeasure:(id)sender;

// 查询电池电量
- (IBAction)commandEnergy:(id)sender;

@end
