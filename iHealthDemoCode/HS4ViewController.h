//
//  HS4ViewController.h
//  testCommicationMode
//
//  Created by Mac on 15/12/10.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <UIKit/UIKit.h>


@class User;

@interface HS4ViewController : UIViewController{
    
    User *currentUser;
}
@property (weak, nonatomic) IBOutlet UITextView *ResultData;

// 开始记忆传输
- (IBAction)commandTransferMemorryData:(id)sender;

// 启动在线测量
- (IBAction)commandMeasureWeight:(id)sender;

// 结束测量或结束传输数据
- (IBAction)commandEndCurrentConnection:(id)sender;

@end
