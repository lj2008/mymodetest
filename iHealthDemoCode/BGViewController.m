//
//  BGViewController.m
//  iHealthDemoCode
//
//  Created by zhiwei jing on 14-9-23.
//  Copyright (c) 2014年 zhiwei jing. All rights reserved.
//

#import "BGViewController.h"
#import "BG5Controller.h"
#import "BG3Controller.h"
#import "AudioBasicCommunication.h"
#import "NewAudioBasicCommunication.h"
#import "BG5.h"
#import "MacroFile.h"

@interface BGViewController ()

@end

@implementation BGViewController


static bool isHeadIn=NO;
//触发的监听事件

void audioRouteChangeListenerCallback (void *inUserData, AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize,const void *inPropertyValue ) {
    
    // ensure that this callback was invoked for a route change
    
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    
    {
        
        // Determines the reason for the route change, to ensure that it is not
        
        //      because of a category change.
        
        CFDictionaryRef routeChangeDictionary = (CFDictionaryRef)inPropertyValue;
        
        
        
        CFNumberRef routeChangeReasonRef = (CFNumberRef)CFDictionaryGetValue (routeChangeDictionary, CFSTR (kAudioSession_AudioRouteChangeKey_Reason) );
        
        SInt32 routeChangeReason;
        
        CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
        
        
        
        if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
            
            //Handle Headset Unplugged
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"没有耳机！");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBG1DisConnented" object:nil];
                
                isHeadIn=NO;
                
            });
            
        } else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable)
        {
            
            //Handle Headset plugged in
            if(isHeadIn==NO)
            {
                isHeadIn=YES;
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
                    
                    __block BOOL bCanRecord = YES;
                    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
                        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                            if (granted) {
                                bCanRecord = YES;
                            }
                            else {
                                bCanRecord = NO;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"\"iGluco\" would like to access the microphone. To enable access go to:iPhone Settings > Privacy > Microphone > iGluco > set to On", @"")
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                      otherButtonTitles:nil]  show];
                                    double delayInSeconds = 0.1 ;
                                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"MicrophoneDisableBG1RemoveAllHub" object:nil userInfo:nil];
                                    });
                                    
                                });
                            }
                        }];
                    }
                    
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NewRIOInterface *rioRef = [NewRIOInterface sharedInstance];
                    [rioRef setSampleRate:44100];//44100
                    [rioRef setFrequency:294];//294
                    [rioRef initializeAudioSession];
                    
                    [NewAudioBasicCommunication NewBG1CommunicationObject];
                    
                    NSLog(@"有耳机！");
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewBG1Connented" object:nil];
                    
                    double delayInSeconds = 20;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        isHeadIn=NO;
                        
                    });
                    
                });
                
            }
        }
        
    }
    
    
}




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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForBG1:) name:@"BG1authenticationOk" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBG1:) name:BG1DisConnectNoti object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForBG3:) name:BG3ConnectNoti object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBG3:) name:BG3DisConnectNoti object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceConnectForBG5:) name:DeviceConnect object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(DeviceDisConnectForBG5:) name:DeviceDisconnect object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NewRIOInterface *rioRef = [NewRIOInterface sharedInstance];
        [rioRef setSampleRate:44100];//44100
        [rioRef setFrequency:294];//294
        [rioRef initializeAudioSession];
        
        [NewAudioBasicCommunication NewBG1CommunicationObject];
        
    });
    //监听耳机事件
    
    [[AVAudioSession sharedInstance] setDelegate:self];
    
    
    // Use this code instead to allow the app sound to continue to play when the screen is locked.
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    
    // Registers the audio route change listener callback function
    
    AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange,audioRouteChangeListenerCallback, (__bridge void *)(self));

    
    [BG5Controller shareIHBg5Controller];
    [BG3Controller shareIHBg3Controller];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DeviceConnectForBG1:(NSNotification *)tempNoti{
    
  [[AudioBasicCommunication bg1CommunicationObject] solveEncodeContent:CodeStr validDate:@"15-11-18" remainNum:@25];
   
}

-(void)DeviceDisConnectForBG1:(NSNotification *)tempNoti{
    
}

-(void)DeviceConnectForBG3:(NSNotification *)tempNoti{
//    _tipTextView.text = [[tempNoti userInfo]description];
//    BG3 *bgInstance = [[BG3Controller shareIHBg3Controller]getCurrentBG3Instace];
//    
//    if(bgInstance != nil){
//        [bgInstance commandCreateBG3TestModel:BGMeasureMode_Blood CodeString:CodeStr UserID:YourUserName clientID:SDKKey clientSecret:SDKSecret Authentication:^(UserAuthenResult result) {
//            _tipTextView.text = [NSString stringWithFormat:@"%@\n UserAuthenResult:%d",_tipTextView.text,result];
//        } DisposeBGSendCodeBlock:^(BOOL sendOk) {
//            _tipTextView.text = [NSString stringWithFormat:@"%@\n sendOk:%d",_tipTextView.text,sendOk];
//        } DisposeBGStripInBlock:^(BOOL stripIn) {
//            _tipTextView.text = [NSString stringWithFormat:@"%@\n stripIn:%d",_tipTextView.text,stripIn];
//        } DisposeBGBloodBlock:^(BOOL blood) {
//            _tipTextView.text = [NSString stringWithFormat:@"%@\n blood:%d",_tipTextView.text,blood];
//        } DisposeBGResultBlock:^(NSNumber *result) {
//            _tipTextView.text = [NSString stringWithFormat:@"%@\n result:%@",_tipTextView.text,result];
//        } DisposeBGErrorBlock:^(NSNumber *errorID) {
//            _tipTextView.text = [NSString stringWithFormat:@"%@\n errorID:%@",_tipTextView.text,errorID];
//        }];
//    }
//    else{
//        _tipTextView.text = @"Invalidate BG3 Info";
//    }
}

-(void)DeviceDisConnectForBG3:(NSNotification *)tempNoti{
    
}

-(void)DeviceConnectForBG5:(NSNotification *)tempNoti{
    
    NSDictionary *infoDic = [tempNoti userInfo];
    NSString *uuidString = [infoDic objectForKey:IDPS_ID];
    NSString *serialNumber = [infoDic objectForKey:IDPS_SerialNumber];
    NSString *firmwareVersion=[infoDic objectForKey:IDPS_FirmwareVersion];
    //    NSString *DeviceName=[infoDic valueForKey:IDPS_Name];
    NSString *protocol = [infoDic valueForKey:IDPS_ProtocolString];
    if (![protocol isEqualToString:BG5_Protocol]) {
        return;
    }
    
    
    BG5Controller *bgController = [BG5Controller shareIHBg5Controller];
    NSArray *bgArray = [bgController getAllCurrentBG5Instace];
    
    if(bgArray.count>0){
        BG5 *bgInstance = [bgArray objectAtIndex:0];
        
        NSDictionary *codeDic = [bgInstance codeStripStrAnalysis:CodeStr];
        NSNumber *yourBottle = [codeDic valueForKey:@"BottleID"];
        
        [bgInstance commandInitBG5SetUnit:@"mmol/L" BGUserID:@"11111" DisposeBG5BottleID:^(NSNumber *bottleID) {
            
            [bgInstance commandReadBG5CodeDic:^(NSDictionary *codeDic) {
              
                NSLog(@"codeDic:%@",codeDic);
                [self commandSendCode:bgInstance];
                
                
            } DisposeErrorBlock:^(NSNumber *errorID) {
                
                 NSLog(@"errorID:%@",errorID);
                
            }];
            
        } DisposeErrorBlock:^(NSNumber *errorID) {
            
             NSLog(@"errorID:%@",errorID);
            
        }];
        
    }
}

-(void)DeviceDisConnectForBG5:(NSNotification *)tempNoti{
    
}

-(void)commandSendCode:(BG5 *)bgInstance{
    NSDictionary *codeDic = [bgInstance codeStripStrAnalysis:CodeStr];
    NSNumber *yourBottle = [codeDic valueForKey:@"BottleID"];
    NSDate *yourValidDate = [codeDic valueForKey:@"DueDate"];
    NSNumber *yourRemainNub = [codeDic valueForKey:@"StripNum"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    [dateFormat setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSString *locationString=[dateFormat stringFromDate: yourValidDate];

    
    
    [bgInstance commandSendBG5CodeString:CodeStr validDate:locationString remainNum:yourRemainNub DisposeBG5SendCodeBlock:^(BOOL sendOk) {
        NSLog(@"send code success");
        
    } DisposeBG5StartModel:^(NSNumber *model) {
        
         NSLog(@"BGOpenMode:%@",model);
        
        if ([model intValue]==2) {
            [bgInstance commandCreateBGtestModel:@1 BGUserID:@"123456" DisposeBGStripInBlock:^(BOOL stripIn) {
                
                NSLog(@"stripIn");
                
            } DisposeBGBloodBlock:^(BOOL blood) {
                
                NSLog(@"blood");
                
            } DisposeBG5ResultBlock:^(NSNumber *result) {
                
                 NSLog(@"result:%@",result);
                
            } DisposeBG5StripOutBlock:^(BOOL stripOut) {
                
            } DisposeBG5TestModelBlock:^(NSNumber *model) {
                
            } DisposeBG5ErrorBlock:^(NSNumber *errorID) {
                
                 NSLog(@"errorID:%@",errorID);
                
            }];
        }else{
        
            [bgInstance commandCreateBGtestStripInBlock:^(BOOL stripIn) {
                
                 NSLog(@"stripIn");
                
            } DisposeBGBloodBlock:^(BOOL blood) {
                
                NSLog(@"blood");
                
            } DisposeBGResultBlock:^(NSNumber *result) {
                
                 NSLog(@"result:%@",result);
                
            } DisposeBGStripOutBlock:^(BOOL stripOut) {
                
            } DisposeBG5TestModelBlock:^(NSNumber *model) {
                
            } DisposeBG5ErrorBlock:^(NSNumber *errorID) {
                
                NSLog(@"errorID:%@",errorID);
                
            }];
        
        
        }
    } DisposeErrorBlock:^(NSNumber *errorID) {
        
    }];
    

}


- (IBAction)getBG5Memory:(id)sender {
    BG5Controller *bgController = [BG5Controller shareIHBg5Controller];
    NSArray *bgArray = [bgController getAllCurrentBG5Instace];
    
    if(bgArray.count>0){
        BG5 *bgInstance = [bgArray objectAtIndex:0];
        
        [bgInstance commandTransferMemorryData:^(NSNumber *dataCount) {
            
             NSLog(@"dataCount:%@",dataCount);
            
        } DisposeBG5HistoryData:^(NSDictionary *historyDataDic) {
            
             NSLog(@"historyDataDic:%@",historyDataDic);
            
        } DisposeErrorBlock:^(NSNumber *errorID) {
            
             NSLog(@"errorID:%@",errorID);
            
        }];
        
    }
}

@end
