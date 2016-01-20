//
//  POViewController.m
//  iHealthDemoCode
//
//  Created by zhiwei jing on 14-9-23.
//  Copyright (c) 2014年 zhiwei jing. All rights reserved.
//

#import "POViewController.h"
#import "PO3Controller.h"
#import "PO3.h"
#import "BasicCommunicationObject.h"
@interface POViewController ()

@end

@implementation POViewController

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForPO3:) name:DeviceConnect object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForPO3:) name:DeviceDisconnect object:nil];
    [PO3Controller shareIHPO3Controller];
    [BasicCommunicationObject basicCommunicationObject];
    [[BasicCommunicationObject basicCommunicationObject] startSearchBTLEDevice:BtleType_PO3];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DeviceConnectForPO3:(NSNotification*)info
{
    PO3Controller *po3Controller = [PO3Controller shareIHPO3Controller];
    NSArray *po3Array = [po3Controller getAllCurrentPO3Instace];
    
    if(po3Array.count>0)
    {
        PO3 *po3Instance = [po3Array objectAtIndex:0];
        NSLog(@"成功=====================");
    }
}



- (IBAction)ScanPO3:(UIButton*)sender {
    
    PO3Controller *po3Controller = [PO3Controller shareIHPO3Controller];
    NSArray *po3Array = [po3Controller getAllCurrentPO3Instace];
    
    PO3 *po3Instance;
    if(po3Array.count>0)
    {
        po3Instance = [po3Array objectAtIndex:0];
    }
    
    
    switch (sender.tag)
    {
        case 0:
        {
            NSLog(@"在线");
            [po3Instance commandPO3SyncTimeResultBlock:^(BOOL resetSuc) {
                
            } StartMeasureBlock:^(BOOL resetSuc) {
                
            } MeasuringDataBlock:^(NSDictionary *measureDataDic) {
                NSLog(@"measureDataDic---%@",measureDataDic);

            } FinishMeasure:^(BOOL resetSuc) {
                NSLog(@"finishData---%d",resetSuc);

            } DisposeErrorBlock:^(PO3ErrorID errorID) {
                NSLog(@"errorID---%d",errorID);
                
            }];
        }
            break;
        case 1:
        {
            NSLog(@"离线");
            
            [po3Instance commandPO3PO3StartHistoryDataCountBlock:^(NSNumber *dataCount) {
                NSLog(@"dataCount---%d",[dataCount intValue]);
            } progressDataBlock:^(NSNumber *progress) {
                NSLog(@"progress---%@",progress);

            } historyDataBlock:^(NSDictionary *historyDataDic) {
                NSLog(@"startData---%@",historyDataDic);

            } historyWaveData:^(NSDictionary *historywaveHistoryDataDic) {
                NSLog(@"historyDataDic---%@",historywaveHistoryDataDic);

            } finishHistoryDataBlock:^(BOOL resetSuc) {
                NSLog(@"finishData---%d",resetSuc);

            } DisposeErrorBlock:^(PO3ErrorID errorID) {
                NSLog(@"errorID---%d",errorID);

            }];
        }
            break;
        case 2:
        {
            NSLog(@"电量");
            [po3Instance commandQueryBatteryInfo:^(NSNumber *battery) {
                NSLog(@"battery---%d",battery.intValue);

            } DisposeErrorBlock:^(PO3ErrorID errorID) {
                NSLog(@"errorID---%d",errorID);

            }];
        }
            break;
        case 3:
        {
            NSLog(@"出厂");
            [po3Instance commandResetDeviceDisposeResultBlock:^(BOOL resetSuc) {
                
            } DisposeErrorBlock:^(PO3ErrorID errorID) {
                
            }];
        }
            break;
        case 4:
        {
            NSLog(@"时间");
            
        }
            break;
        case 5:
        {
            NSLog(@"断开");
            
            [po3Instance commandEndPO3CurrentDisConnect:^(BOOL resetSuc) {
                NSLog(@"duan==%d",resetSuc);
            } DisposeErrorBlock:^(PO3ErrorID errorID) {
                NSLog(@"errorID---%d",errorID);

            }];
        }
            break;
            
        default:
            break;
    }
    
    
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
