//
//  HS3ViewController.h
//  testCommicationMode
//
//  Created by Mac on 15/12/10.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

//
//  HSViewController.h
//  iHealthDemoCode
//
//  Created by zhiwei jing on 14-9-23.
//  Copyright (c) 2014年 zhiwei jing. All rights reserved.
//

#import <UIKit/UIKit.h>


@class User;

@interface HS3ViewController : UIViewController{
    
    User *currentUser;
}
@property (weak, nonatomic) IBOutlet UITextView *ResultData;

/* 初始化秤的初始设置（建立通道 收到时间 收到序列号 同步时间）*/
- (IBAction)commandInitMeasureWeightID:(id)sender;

/* 关闭回连开关 */
- (IBAction)commandTurnOffBTConnect:(id)sender;

/* 打开回连开关 */
- (IBAction)commandTurnOnBTConnect:(id)sender;

//*ihealth 3.0专用方法，流程已经更改*//
/* 历史数据（询问未上传数据条数  传输历史数据）*/
- (IBAction)commandInitMeasureWeightID3:(id)sender;

/* 开始测量*/
- (IBAction)commandMeasureStableWeight:(id)sender;

@end

