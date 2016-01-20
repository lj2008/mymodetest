//
//  HSViewController.m
//  iHealthDemoCode
//
//  Created by zhiwei jing on 14-9-23.
//  Copyright (c) 2014年 zhiwei jing. All rights reserved.
//

#import "HSViewController.h"
#import "CommUser.h"
#import "HS3Controller.h"
#import "HS4Controller.h"
#import "HS5Controller.h"
#import "HS4.h"
#import "HS5.h"
@interface HSViewController ()

@end

@implementation HSViewController

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
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForHS3:) name:DeviceConnect object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForHS3:) name:DeviceDisconnect object:nil];
//
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForHS4:) name:DeviceConnect object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForHS4:) name:DeviceDisconnect object:nil];
//
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForHS5:) name:DeviceConnect object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForHS5:) name:HS5DisConnectNoti object:nil];
    [HS3Controller shareIHHs3Controller];
    [HS4Controller shareIHHs4Controller];
    [HS5Controller shareIHHs5Controller];
    [[BasicCommunicationObject basicCommunicationObject]startAllBtleDevice];
    // FOR Test
        [[BasicCommunicationObject basicCommunicationObject]searchScale];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HS3
-(void)DeviceConnectForHS3:(NSNotification *)tempNoti{
    HS3Controller *hsController = [HS3Controller shareIHHs3Controller];
    NSArray *hsArray = [hsController getAllCurrentHS3Instace];
    
    if(hsArray.count>0){
        HS3 *hsInstance = [hsArray objectAtIndex:0];
       
        [hsInstance commandInitMeasureWeightID:^(NSString *weightID) {
            
        } TransferMemorryData:^(BOOL startTransmission) {
            
        } UploadDataNum:^(NSNumber *uploadDataNum) {
            
        } DisposeProgress:^(float progress) {
            
        } MemorryData:^(NSDictionary *historyDataDic) {
            
        } FinishTransmission:^{
        
            [hsInstance commandInitMeasureWeightID:^(NSString *weightID) {
                NSLog(@"%@",weightID);
            } FinishInit:^{
                NSLog(@"hs3成");

            } DisposeErrorBlock:^(HS3DeviceError errorID) {
                
            }];
        } DisposeErrorBlock:^(HS3DeviceError errorID) {
            
            NSLog(@"hs3错误");
        }];
        
        
    }
}
-(void)DeviceDisConnectForHS3:(NSNotification *)tempNoti{
    
    
}
#pragma mark - HS4
-(void)DeviceConnectForHS4:(NSNotification *)tempNoti{
    HS4Controller *hsController = [HS4Controller shareIHHs4Controller];
    NSArray *hsArray = [hsController getAllCurrentHS4Instace];
    
    if(hsArray.count>0){
        HS4 *hsInstance = [hsArray objectAtIndex:0];
        
        
        
        [hsInstance commandMeasureWeight:^(NSNumber *unStableWeight) {
            NSLog(@"unStableWeight:%@",unStableWeight);

        } StableWeight:^(NSNumber *StableWeight) {
            NSLog(@"StableWeight:%@",StableWeight);

        } DisposeErrorBlock:^(HS4DeviceError errorID) {
            NSLog(@"HS4DeviceError:%d",errorID);

        } setUnit:@1];
    }
    
}
- (IBAction)commandUploadHS4MemoryPressed:(id)sender {
    HS4Controller *hsController = [HS4Controller shareIHHs4Controller];
    NSArray *hsArray = [hsController getAllCurrentHS4Instace];
    
    if(hsArray.count>0){
        HS4 *hsInstance = [hsArray objectAtIndex:0];
        
        [hsInstance commandTransferMemorryData:^(NSDictionary *startDataDictionary) {
            NSLog(@"startDataDictionary:%@",startDataDictionary);

        } DisposeProgress:^(NSNumber *progress) {
            NSLog(@"DisposeProgress:%@",progress);

        } MemorryData:^(NSArray *historyDataArray) {
            NSLog(@"MemorryData:%@",historyDataArray);

        } FinishTransmission:^{
            NSLog(@"FinishTransmission");

        } DisposeErrorBlock:^(HS4DeviceError errorID) {
            NSLog(@"HS4DeviceError:%d",errorID);

        }];
    }
}
-(void)DeviceDisConnectForHS4:(NSNotification *)tempNoti{
    
    
}
#pragma mark - HS5
-(void)DeviceConnectForHS5:(NSNotification *)tempNoti{
    HS5Controller *hsController = [HS5Controller shareIHHs5Controller];
    NSArray *hsArray = [hsController getAllCurrentHS5Instace];
    
    NSDictionary *dic=[tempNoti userInfo];
    NSString*pro=[dic objectForKey:IDPS_ProtocolString];
    if (![pro isEqualToString:HS5_Protocol])
    {
        return;
    }

    
    
    if(hsArray.count>0){
        HS5 *hsInstance = [hsArray objectAtIndex:0];
        
        [hsInstance commandCreateUserManageConnect:^(NSArray *userListDataArray) {
            
            
            CommUser*myUser=[CommUser shareCommUser];
            
           NSDictionary*dic= [userListDataArray objectAtIndex:0];
            
            NSNumber*pos=[dic valueForKey:@"position"];
            
            NSNumber*cloudSer=[dic valueForKey:@"serialNumber"];
            
            myUser.cloudSerialNumber=cloudSer;
            
            [hsInstance commandModifyUserPosition:pos DisposeHS5Result:^(BOOL resetSuc) {
//                
//                [hsInstance commandcreateMemoryUploadConnect:^(BOOL resetSuc) {
//                    
//                    
//
//                    
//                } TransferMemorryData:^(BOOL startHS5Transmission) {
//                    
//                } DisposeProgress:^(NSNumber *progress) {
//                    
//                } MemorryData:^(NSDictionary *historyDataDic) {
//                    
//                } FinishTransmission:^(BOOL finishHS5Transmission) {
//                    
//                } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
//                    
//                }];
                
                [hsInstance commandCreateMeasure:^(NSNumber *unStableWeight) {
                    
                } MeasureWeight:^(NSNumber *StableWeight) {
                    
                } ImpedanceType:^(NSNumber *ImpedanceWeight) {
                    
                } BodyCompositionMeasurements:^(NSDictionary *BodyCompositionInforDic) {
                    
                } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
                    
                }];

                
                
                
            } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
                
            }];
            
            
        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
            
        }];
        
        
        
        
//        [hsInstance commandCreateUserManageConnectWithUser:myUser Authentication:^(UserAuthenResult result) {
//            NSLog(@"UserAuthenResult:%d",result);
//        } currentUserSerialNub:^(NSInteger serialNub) {
//            NSLog(@"serialNub:%ld",(long)serialNub);
//            myUser.serialNub = [NSNumber numberWithLong:serialNub];
//            currentUser = myUser;
//        } deviceUserList:^(NSArray *userListDataArray) {
//            NSLog(@"userListDataArray:%@",userListDataArray);
//            
//            //User exist
//            NSMutableArray *positionArray = [[NSMutableArray alloc]init];
//            NSMutableArray *serialNubArray = [[NSMutableArray alloc]init];
//            for (NSDictionary *tempInfo in userListDataArray) {
//                [positionArray addObject:[tempInfo valueForKey:@"position"]];
//                [serialNubArray addObject:[tempInfo valueForKey:@"serialNumber"]];
//            }
//            
//            //Old User
//            if ([serialNubArray containsObject:[NSNumber numberWithInteger:myUser.serialNub.integerValue]]) {
//                //edit user
//                int modifyUserInfo = 0;
//                //no edit
//                if (modifyUserInfo == 0) {
//                    //measure
//                    myUser.height = @160;
//                    [self commandStartMeasure:hsInstance withUser:myUser];
//                }
//                //modify user
//                else if(modifyUserInfo == 1){
//                    myUser.height = @160;
//                    myUser.sex = UserSex_Female;
//                    myUser.birthday = [NSDate dateWithTimeIntervalSince1970:0];
//                    myUser.isAthlete = UserIsAthelete_Yes;
//                    
//                    [hsInstance commandModifyUser:myUser DisposeHS5Result:^(BOOL resetSuc) {
//                        NSLog(@"DisposeHS5Result:%d",resetSuc);
//                        
//                        //measure
//                        [self commandStartMeasure:hsInstance withUser:myUser];
//                        
//                    } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
//                        NSLog(@"HS5DeviceError:%d",errorID);
//                    }];
//                }
//                //del user
//                else if (modifyUserInfo == 2){
//                    [hsInstance commandDelteUser:myUser DisposeHS5Result:^(BOOL resetSuc) {
//                        NSLog(@"DisposeHS5Result:%d",resetSuc);
//                    } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
//                        NSLog(@"HS5DeviceError:%d",errorID);
//                    }];
//                }
//            }
//            //New User
//            else{
//                //validate position:0~19
//                if (userListDataArray.count<20) {
//                    NSMutableArray *validatePositionArray = [[NSMutableArray alloc]init];
//                    for (int i=0; i<20; i++) {
//                        if (![positionArray containsObject:[NSNumber numberWithInt:i]]) {
//                            [validatePositionArray addObject:[NSNumber numberWithInt:i]];
//                        }
//                    }
//                    
//                    myUser.birthday = [NSDate dateWithTimeIntervalSince1970:0];
//                    myUser.sex = UserSex_Male;
//                    myUser.isAthlete = UserIsAthelete_Yes;
//                    myUser.height = @180;
//                    //create user
//                    [hsInstance commandCreateUser:myUser position:[[validatePositionArray objectAtIndex:0]unsignedCharValue]  DisposeHS5Result:^(BOOL resetSuc) {
//                        NSLog(@"DisposeHS5Result:%d",resetSuc);
//                        
//                        //measure
//                        [self commandStartMeasure:hsInstance withUser:myUser];
//                        
//                    } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
//                        NSLog(@"HS5DeviceError:%d",errorID);
//                    }];
//                }
//                
//            }
//            
//            //Yes
//            
//        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
//            NSLog(@"HS5DeviceError:%d",errorID);
//        }];
    }
    
}
- (IBAction)commandUploadHS5MemoryPressed:(id)sender {
    HS5Controller *hsController = [HS5Controller shareIHHs5Controller];
    NSArray *hsArray = [hsController getAllCurrentHS5Instace];
    
    if(hsArray.count>0 && currentUser!=nil){
        HS5 *hsInstance = [hsArray objectAtIndex:0];
        
        [hsInstance commandcreateMemoryUploadConnect:^(BOOL resetSuc) {
            NSLog(@"uploadConnect:%d",resetSuc);

        } TransferMemorryData:^(BOOL startHS5Transmission) {
            NSLog(@"startHS5Transmission:%d",startHS5Transmission);

        } DisposeProgress:^(NSNumber *progress) {
            NSLog(@"DisposeProgress:%@",progress);

        } MemorryData:^(NSDictionary *historyDataDic) {
            NSLog(@"MemorryData:%@",historyDataDic);

        } FinishTransmission:^(BOOL finishHS5Transmission) {
            NSLog(@"FinishTransmission:%d",finishHS5Transmission);

        } Disposehs5ErrorBlock:^(HS5DeviceError errorID) {
            NSLog(@"HS5DeviceError:%d",errorID);

        }];
    }
}


-(void)DeviceDisConnectForHS5:(NSNotification *)tempNoti{
    
    
}

@end
