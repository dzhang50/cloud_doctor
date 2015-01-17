//
//  ViewController.m
//  clouddoctorapp
//
//  Created by Peter Kim on 1/16/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "CDMainViewController.h"
#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <Bolts/Bolts.h>

#import "PulsingHaloLayer.h"
#import "MultiplePulsingHaloLayer.h"

@interface CDMainViewController ()

//@property (strong, nonatomic) SKRecognizer* voiceSearch;

@property (nonatomic, strong) BLE              *bleShield;

@property CWStatusBarNotification            *statusBarNotification;
@property (nonatomic, weak) PulsingHaloLayer *halo;

@property UIColor *CDRed;
@property UIColor *CDGreen;
@property UIColor *CDOrange;

@end

@implementation CDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bleShield = [[BLE alloc] init];
    [self.bleShield controlSetup];
    self.bleShield.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.CDGreen = [UIColor colorWithRed:32.0/255.0
                                   green:202.0/255.0
                                    blue:35.0/255.0
                                   alpha:1.0];
    
    self.CDRed = [UIColor colorWithRed:202.0/255.0
                                 green:35.0/255.0
                                  blue:32.0/255.0
                                 alpha:1.0];
    
    self.halo = [PulsingHaloLayer layer];
    self.halo.position = self.statusLabel.center;
    self.halo.radius = 125.0f;
    self.halo.animationDuration = 1.5f;
    self.halo.pulseInterval = -0.5f;
    self.halo.backgroundColor = self.CDGreen.CGColor;
    [self.view.layer addSublayer:self.halo];
    
    self.statusBarNotification = [CWStatusBarNotification new];
    self.statusBarNotification.notificationLabelBackgroundColor = self.CDRed;
    self.statusBarNotification.notificationLabelTextColor = [UIColor whiteColor];
    
    [self.statusBarNotification displayNotificationWithMessage:@"Cloud Doctor is at your service!" forDuration:3.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BLEDelegate

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"%@", s);
}

- (void) readRSSITimer:(NSTimer *)timer
{
    [self.bleShield readRSSI];
}

- (void) bleDidDisconnect
{
    NSLog(@"bleDidDisconnect");
}

-(void) bleDidConnect
{
    NSLog(@"bleDidConnect");
}

#pragma mark - SKRecognizerDelegate

//- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer {
//    
//}
//
//- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer {
//    
//}
//
//- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results {
//    
//}

@end
