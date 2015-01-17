//
//  ViewController.m
//  clouddoctorapp
//
//  Created by Peter Kim on 1/16/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDMainViewController+Animations.h"

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <Bolts/Bolts.h>

@interface CDMainViewController ()

//@property (strong, nonatomic) SKRecognizer* voiceSearch;

@property (nonatomic, strong) BLE *bleShield;
@property CWStatusBarNotification *statusBarNotification;

@property BOOL inAlertMode;

@end

@implementation CDMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bleShield = [[BLE alloc] init];
    [self.bleShield controlSetup];
    self.bleShield.delegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateLabelsWithFakeData)
                                   userInfo:nil
                                    repeats:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(simulateFakeAlert)
                                   userInfo:nil
                                    repeats:NO];
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
    
    self.CDBlue = [UIColor colorWithRed:35.0/255.0
                                  green:32.0/255.0
                                   blue:202.0/255.0
                                  alpha:1.0];
    
    self.CDYellow = [UIColor colorWithRed:255.0/255.0
                                    green:211.0/255.0
                                     blue:0.0
                                    alpha:1.0];
    
    if (!self.halo) {
        self.halo = [PulsingHaloLayer layer];
    }
        
    self.halo.position = self.statusLabel.center;
    self.halo.radius = 125.0f;
    self.halo.animationDuration = 1.5f;
    self.halo.pulseInterval = -0.5f;
    self.halo.backgroundColor = self.CDGreen.CGColor;
    [self.view.layer addSublayer:self.halo];
    
    self.statusBarNotification = [CWStatusBarNotification new];
    self.statusBarNotification.notificationLabelBackgroundColor = [UIColor whiteColor];
    self.statusBarNotification.notificationLabelTextColor = self.CDRed;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.statusBarNotification displayNotificationWithMessage:@"Cloud Doctor is at your service!" forDuration:3.0f];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Test 

- (void)updateLabelsWithFakeData
{
    [self updateLabel:self.hearbeatLabel WithText:[NSString stringWithFormat:@"%d bpm", rand() % (0 - 125) + 0]];
    [self updateLabel:self.temperatureLabel WithText:[NSString stringWithFormat:@"%d°F", rand() % (0 - 125) + 0]];
    [self updateLabel:self.ecgLabel WithText:[NSString stringWithFormat:@"%d.5", rand() % (0 - 100) + 0]];
    [self updateLabel:self.oxygenLabel WithText:[NSString stringWithFormat:@"%d%%", rand() % (0 - 100) + 0]];
    [self updateLabel:self.carbonDioxideLabel WithText:[NSString stringWithFormat:@"%d%%", rand() % (0 - 100) + 0]];
}

- (void)simulateFakeAlert
{
    NSLog(@"simulating fake alert");
    self.inAlertMode = YES;
    [self setAlertMode];
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
    [self.bleShield write:[@"G" dataUsingEncoding:NSUTF8StringEncoding]];
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

#pragma mark - UIButton

- (IBAction)handleSubmitSymptoms:(id)sender {
    
    if (self.inAlertMode) {
        NSLog(@"handleSubmitSymptoms");
        [self.statusBarNotification displayNotificationWithMessage:@"Listening..." completion:nil];
        self.inAlertMode = NO;
        [self setListeningMode];
    } else {
        [self.statusBarNotification dismissNotification];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.statusBarNotification displayNotificationWithMessage:@"Diagnosing..." completion:nil];
        });
        [self setWaitingMode];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.statusBarNotification dismissNotification];
            [self performSegueWithIdentifier:@"MainToDiagnosis" sender:self];
            [self setNormalMode];
        });
    }
}

@end
