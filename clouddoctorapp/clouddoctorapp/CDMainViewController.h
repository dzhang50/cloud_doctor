//
//  ViewController.h
//  clouddoctorapp
//
//  Created by Peter Kim on 1/16/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"
#import "PulsingHaloLayer.h"

#import "CorePlot-CocoaTouch.h"
#import <SpeechKit/SpeechKit.h>

@import CoreBluetooth;
@import QuartzCore;

#import "CWStatusBarNotification.h"

@interface CDMainViewController : UIViewController <BLEDelegate, CPTPlotDataSource, SpeechKitDelegate, SKRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UILabel *hearbeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *ecgLabel;
@property (weak, nonatomic) IBOutlet UILabel *oxygenLabel;
@property (weak, nonatomic) IBOutlet UILabel *carbonDioxideLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *microphoneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;

@property (weak, nonatomic) IBOutlet CPTGraphHostingView *ecgGraphHostingView;

@property (weak, nonatomic) IBOutlet UITextView *symptomsTextView;

@property (nonatomic, weak) PulsingHaloLayer *halo;

@property UIColor *CDRed;
@property UIColor *CDGreen;
@property UIColor *CDBlue;
@property UIColor *CDYellow;

- (IBAction)handleSubmitSymptoms:(id)sender;

@end

