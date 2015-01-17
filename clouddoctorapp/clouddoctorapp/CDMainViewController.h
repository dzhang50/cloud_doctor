//
//  ViewController.h
//  clouddoctorapp
//
//  Created by Peter Kim on 1/16/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreBluetooth;
@import QuartzCore;

#import "CWStatusBarNotification.h"

#define POLARH7_HRM_DEVICE_INFO_SERVICE_UUID @"placeholder";
#define POLARH7_HRM_DEVICE_INFO_SERVICE_UUID @"placeholder";

@interface CDMainViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>




@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral     *blendMicroPeripheral;

@end

