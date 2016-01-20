//
//  BPViewController.m
//  iHealthDemoCode
//
//  Created by zhiwei jing on 14-9-23.
//  Copyright (c) 2014年 zhiwei jing. All rights reserved.
//

#import "BPViewController.h"
#import "BP3Controller.h"
#import "BP5Controller.h"
#import "BP7Controller.h"
#import "BP3LController.h"
#import "BP5.h"

@interface BPViewController ()

@end

@implementation BPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForBP3:) name:@"BP3DeviceDidConnected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBP3:) name:@"BP3DeviceDisConnected" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForBP5:) name:@"BP5DeviceDidConnected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBP5:) name:@"BP3DeviceDisConnected" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForBP7:) name:@"BP7DeviceDidConnected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBP7:) name:@"BP7DeviceDisConnected" object:nil];
 
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Devicetestdata:) name:@"testData" object:nil];
////
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForBP3L:) name:@"BP3LDeviceDidConnected" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBP3L:) name:@"BP3LDidDisConnect" object:nil];
//

//    
//    //ABI Noti(Contains Arm and Leg)
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForABI:) name:ABIConnectNoti object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForABI:) name:ABIDisConnectNoti object:nil];
//    //ABI Noti(Contains Arm only)
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForArm:) name:ArmConnectNoti object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForArm:) name:ArmDisConnectNoti object:nil];
    
    [BP3Controller shareBP3Controller];
    [BP5Controller shareBP5Controller];
    [BP7Controller shareBP7Controller];
//    [ABIController shareABIController];
    [BP3LController shareBP3LController];
    
    [BasicCommunicationObject basicCommunicationObject];
    
//    [[BasicCommunicationObject basicCommunicationObject] startSearchBTLEDevice:BtleType_BP3L];
}
-(void)Devicetestdata:(NSNotification *)tempNoti{

     _tipTextView.text =[NSString stringWithFormat:@"testData:%@",[tempNoti userInfo]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - BP3
-(void)DeviceConnectForBP3:(NSNotification *)tempNoti{
    BP3Controller *controller = [BP3Controller shareBP3Controller];
    NSArray *bpDeviceArray = [controller getAllCurrentBP3Instace];
    
     _tipTextView.text =@" _tipTextView.text";
    
    _tipTextView.text =[NSString stringWithFormat:@"---tempDic:%@ :%@",[tempNoti userInfo],[bpDeviceArray objectAtIndex:0]];
    if(bpDeviceArray.count){
        BP3 *bpInstance = [bpDeviceArray objectAtIndex:0];
        
        [bpInstance commandStartMeasure:^(NSArray *pressureArr) {
            
             _tipTextView.text = [NSString stringWithFormat:@"pressureArr%@",pressureArr];
            
        } xiaoboWithHeart:^(NSArray *xiaoboArr) {
            
        } xiaoboNoHeart:^(NSArray *xiaoboArr) {
            
        } result:^(NSDictionary *dic) {
            
            NSLog(@"dic:%@",dic);
            _tipTextView.text = [NSString stringWithFormat:@"result:%@",dic];
            
        } errorBlock:^(BP3DeviceError error) {
            
            _tipTextView.text = [NSString stringWithFormat:@"error:%d",error];
            
        }];
        
    }
    else{
        NSLog(@"log...");
        _tipTextView.text = [NSString stringWithFormat:@"date:%@",[NSDate date]];
    }
    
}

-(void)DeviceDisConnectForBP3:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}

#pragma mark - BP3L
-(void)DeviceConnectForBP3L:(NSNotification *)tempNoti{
    BP3LController *controller = [BP3LController shareBP3LController];
    NSArray *bpDeviceArray = [controller getAllCurrentBP3LInstace];
    if(bpDeviceArray.count){
        BP3L *bpInstance = [bpDeviceArray objectAtIndex:0];
        
        if (![bpInstance.serialNumber isEqualToString:@"20C38FECC54C"]) {
            return;
        }
        [bpInstance commandStartMeasure:^(NSArray *pressureArr) {
            
             _tipTextView.text = [NSString stringWithFormat:@"pressureArr%@",pressureArr];
            
        } xiaoboWithHeart:^(NSArray *xiaoboArr) {
            
            NSLog(@"xiaoboArr:%@",xiaoboArr);
            
        } xiaoboNoHeart:^(NSArray *xiaoboArr) {
            
            NSLog(@"xiaoboArr:%@",xiaoboArr);
            
        } result:^(NSDictionary *dic) {
            
            NSLog(@"dic:%@",dic);
            _tipTextView.text = [NSString stringWithFormat:@"result:%@",dic];
            
        } errorBlock:^(BP3LDeviceError error) {
            
            _tipTextView.text = [NSString stringWithFormat:@"error:%d",error];
            
        }];
        
       
    }
    else{
        NSLog(@"log...");
        _tipTextView.text = [NSString stringWithFormat:@"date:%@",[NSDate date]];
    }
    
}

-(void)DeviceDisConnectForBP3L:(NSNotification *)tempNoti{
    NSLog(@"BP3Linfo:%@",[tempNoti userInfo]);
}



#pragma mark - BP5
-(void)DeviceConnectForBP5:(NSNotification *)tempNoti{
    BP5Controller *controller = [BP5Controller shareBP5Controller];
    NSArray *bpDeviceArray = [controller getAllCurrentBP5Instace];
    if(bpDeviceArray.count){
        BP5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        //@"jing@30.com"
        
        [bpInstance commandStartMeasure:^(NSArray *pressureArr) {

            _tipTextView.text = [NSString stringWithFormat:@"pressureArr%@",pressureArr];
        } xiaoboWithHeart:^(NSArray *xiaoboArr) {
            
        } xiaoboNoHeart:^(NSArray *xiaoboArr) {
            
        } result:^(NSDictionary *dic) {
            NSLog(@"dic:%@",dic);
            _tipTextView.text = [NSString stringWithFormat:@"result:%@",dic];

        } errorBlock:^(BP7DeviceError error) {
            NSLog(@"error:%d",error);
            _tipTextView.text = [NSString stringWithFormat:@"error:%d",error];

        }];
        
    }
    else{
        NSLog(@"log...");
        _tipTextView.text = [NSString stringWithFormat:@"date:%@",[NSDate date]];
    }
    
}

-(void)DeviceDisConnectForBP5:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}

#pragma mark - BP7
-(void)DeviceConnectForBP7:(NSNotification *)tempNoti{
    BP7Controller *controller = [BP7Controller shareBP7Controller];
    NSArray *bpDeviceArray = [controller getAllCurrentBP7Instace];
    if(bpDeviceArray.count){
        BP7 *bpInstance = [bpDeviceArray objectAtIndex:0];
        
        [bpInstance commandStartGetAngle:^(NSDictionary *dic) {
            [bpInstance commandStartMeasure:^(NSArray *pressureArr) {
                _tipTextView.text = [NSString stringWithFormat:@"pressureArr%@",pressureArr];
                
            } xiaoboWithHeart:^(NSArray *xiaoboArr) {
                
            } xiaoboNoHeart:^(NSArray *xiaoboArr) {
                
            } result:^(NSDictionary *dic) {
                _tipTextView.text = [NSString stringWithFormat:@"result:%@",dic];
                NSLog(@"dic:%@",dic);
            } errorBlock:^(BP7DeviceError error) {
                NSLog(@"error:%d",error);
            }];

        } errorBlock:^(BP7DeviceError error) {
            
        }];
        
            }
    else{
        NSLog(@"log...");
        _tipTextView.text = [NSString stringWithFormat:@"date:%@",[NSDate date]];
    }
    
}

-(void)DeviceDisConnectForBP7:(NSNotification *)tempNoti{
    NSLog(@"info:%@",[tempNoti userInfo]);
}


#pragma mark - ABI
-(void)DeviceConnectForABI:(NSNotification *)tempNoti{
//    ABI *abiInstance = [[ABIController shareABIController]getCurrentABIInstace];
//    //Detect CurrentABIInstace
//    if (abiInstance != nil) {
//        
////        [abiInstance commandQueryEnergy:^(NSNumber *energyValue) {
////            NSLog(@"energyValue:%d",energyValue.integerValue);
////        } leg:^(NSNumber *energyValue) {
////            NSLog(@"energyValue:%d",energyValue.integerValue);
////        } errorBlock:^(BPDeviceError error) {
////            
////        }];
////        
////        return;
//        
//        [abiInstance commandStartMeasureWithUser:YourUserName clientID:SDKKey clientSecret:SDKSecret Authentication:^(UserAuthenResult result) {
//            _tipTextView.text = [NSString stringWithFormat:@"Authentication Result:%d",result];
//            NSLog(@"Authentication Result:%d",result);
//        } armPressure:^(NSArray *pressureArr) {
//            NSLog(@"armPressure:%@",pressureArr);
//        } legPressure:^(NSArray *pressureArr) {
//            NSLog(@"legPressure:%@",pressureArr);
//        } armXiaoboWithHeart:^(NSArray *xiaoboArr) {
//            NSLog(@"armXiaoboWithHeart:%@",xiaoboArr);
//        } legXiaoboWithHeart:^(NSArray *xiaoboArr) {
//            NSLog(@"legXiaoboWithHeart:%@",xiaoboArr);
//        } armXiaoboNoHeart:^(NSArray *xiaoboArr) {
//            NSLog(@"armXiaoboNoHeart:%@",xiaoboArr);
//        } legXiaoboNoHeart:^(NSArray *xiaoboArr) {
//            NSLog(@"legXiaoboNoHeart:%@",xiaoboArr);
//        } armResult:^(NSDictionary *dic) {
//            _tipTextView.text = [NSString stringWithFormat:@"armResult:%@",dic];
//            NSLog(@"armResult:%@",dic);
//        } legResult:^(NSDictionary *dic) {
//            _tipTextView.text = [NSString stringWithFormat:@"legResult:%@",dic];
//            NSLog(@"legResult:%@",dic);
//        } errorBlock:^(BPDeviceError error) {
//            
//        }];
//    }
    
}

-(void)DeviceDisConnectForABI:(NSNotification *)tempNoti{
    NSLog(@"DeviceDisConnectForABI:%@",[tempNoti userInfo]);
}

#pragma mark - Arm
-(void)DeviceConnectForArm:(NSNotification *)tempNoti{
//    ABI *abiInstance = [[ABIController shareABIController]getCurrentArmInstance];
//    //Detect CurrentArmInstance
//    if (abiInstance != nil) {
//        //query battery if need
////        [abiInstance commandQueryEnergy:^(NSNumber *energyValue) {
////            NSLog(@"energyValue:%d",energyValue.integerValue);
////        } errorBlock:^(BPDeviceError error) {
////            NSLog(@"BPDeviceError%d",error);
////        }];
//        [abiInstance commandStartMeasureWithUser:YourUserName clientID:SDKKey clientSecret:SDKSecret Authentication:^(UserAuthenResult result) {
//            _tipTextView.text = [NSString stringWithFormat:@"Authentication Result:%d",result];
//            NSLog(@"Authentication Result:%d",result);
//            //Stop ArmMeasure if need
////            [self performSelector:@selector(stopArmMeasure) withObject:nil afterDelay:10];
//        } armPressure:^(NSArray *pressureArr) {
//            NSLog(@"armPressure:%@",pressureArr);
//        } armXiaoboWithHeart:^(NSArray *xiaoboArr) {
//             NSLog(@"armXiaoboWithHeart:%@",xiaoboArr);
//        } armXiaoboNoHeart:^(NSArray *xiaoboArr) {
//            NSLog(@"armXiaoboNoHeart:%@",xiaoboArr);
//        } armResult:^(NSDictionary *dic) {
//            _tipTextView.text = [NSString stringWithFormat:@"armResult:%@",dic];
//            NSLog(@"armResult:%@",dic);
//        } errorBlock:^(BPDeviceError error) {
//            NSLog(@"BPDeviceError:%d",error);
//        }];
//    }
}

-(void)stopArmMeasure{
//    ABI *abiInstance = [[ABIController shareABIController]getCurrentArmInstance];
//    //Detect CurrentArmInstance
//    if (abiInstance != nil) {
//        [abiInstance stopABIArmMeassureBlock:^(BOOL result) {
//            NSLog(@"stopABIArmMeassureBlock:%d",result);
//        } errorBlock:^(BPDeviceError error) {
//            NSLog(@"BPDeviceError:%d",error);
//        }];
//    }
}
-(void)DeviceDisConnectForArm:(NSNotification *)tempNoti{
    NSLog(@"DeviceDisConnectForArm:%@",[tempNoti userInfo]);
}



- (IBAction)spressed:(id)sender {
    // 初始化BP7控制类
    BP5Controller *controller = [BP5Controller shareBP5Controller];
    // 接收到 BP5ConnectNoti消息后，获取控制类实例
    NSArray *bpDeviceArray = [controller getAllCurrentBP5Instace];
    // 有设备存在的时候
    if (bpDeviceArray.count) {
        // 创建bp7实例调用通讯相关接口
        BP5 *bpInstance = [bpDeviceArray objectAtIndex:0];
        [bpInstance commandEnergy:^(NSNumber *energyValue) {
            NSLog(@"设备电池电量为:%@",energyValue);
            _tipTextView.text = [NSString stringWithFormat:@"设备电池电量为:%@",energyValue];
        } errorBlock:^(BP7DeviceError error) {
            NSLog(@"error id:%d",error);
            _tipTextView.text = [NSString stringWithFormat:@"your measure pressure error id:%d",error];
        }];
    }else{
        // 没有设备存在的时候
        NSLog(@"log...");
        _tipTextView.text = [NSString stringWithFormat:@"there is no device:date:%@",[NSDate date]];
    }

}
@end
