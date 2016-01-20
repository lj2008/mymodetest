//
//  BG1ViewController.h
//  testCommicationMode
//
//  Created by Mac on 15/12/14.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CodeStr @"024C565F4C5614322D1200A02F3485B6F314378BACD619011F72003608A9"
@interface BG1ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *ResultData;

// 获取BG1是否连接的信息，并在连接完成后返回IDPS信息
- (IBAction)commandCreateConnect:(id)sender;

// BG1连接完成后发送CODE，并返回CODE发送结果以及测量过程中的插条，滴血，血糖结果，及错误ID
- (IBAction)commandCreateBGtestWithCode:(id)sender;

@end
