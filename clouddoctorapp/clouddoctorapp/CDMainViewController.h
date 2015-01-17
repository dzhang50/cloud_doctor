//
//  ViewController.h
//  clouddoctorapp
//
//  Created by Peter Kim on 1/16/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

//#import <SpeechKit/SpeechKit.h>

@import CoreBluetooth;
@import QuartzCore;

#import "CWStatusBarNotification.h"

#define RBL_SERVICE_UUID @"713d0000-503e-4c75-ba94-3148f18d941e";

@interface CDMainViewController : UIViewController <BLEDelegate>

@property (weak, nonatomic) IBOutlet UILabel *hearbeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *ecgLabel;
@property (weak, nonatomic) IBOutlet UILabel *oxygenLabel;
@property (weak, nonatomic) IBOutlet UILabel *carbonDioxideLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

