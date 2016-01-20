//
//  HS5ViewController.h
//  testCommicationMode
//
//  Created by Mac on 15/12/10.
//  Copyright © 2015年 zhiwei jing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommUser;

@interface HS5ViewController : UIViewController{
    
    CommUser *currentUser;
}
@property (weak, nonatomic) IBOutlet UITextView *ResultData;

/*建立HS5用户管理连接*/
- (IBAction)commandCreateUserConnect:(id)sender;

/*更新用户信息*/
- (IBAction)commandModifyUserPosition:(id)sender;

/*创建用户*/
- (IBAction)commandCreateUserPosition:(id)sender;

/*创建记忆上传连接*/
- (IBAction)commandcreateUploadConnect:(id)sender;

/* 断开此次连接 */
- (IBAction)commandEndCurrentConnect:(id)sender;

/*创建测量连接*/
- (IBAction)commandCreateMeasure:(id)sender;

/*从秤中删除用户*/
- (IBAction)commandDelteUserID:(id)sender;

///*移动秤中用户位置*/
//- (IBAction)commandChangeUserPosition:(id)sender;
//
///*设置HS5的名称*/
//- (IBAction)commandSetScaleName:(id)sender;
//
///*设置HS5密码*/
//- (IBAction)commandSetScalePassWord:(id)sender;
//
///*获取秤的超级用户密码*/
//- (IBAction)commandGetScalePassword:(id)sender;
//
///*设置服务器地址*/
//- (IBAction)commandSetServerAdress:(id)sender;


@end
