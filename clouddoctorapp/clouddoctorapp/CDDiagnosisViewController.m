//
//  CDDiagnosisViewController.m
//  clouddoctorapp
//
//  Created by Peter Kim on 1/17/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "CDDiagnosisViewController.h"

#import "CWStatusBarNotification.h"

@interface CDDiagnosisViewController ()

@property CWStatusBarNotification *statusBarNotification;

@end

@implementation CDDiagnosisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    self.statusBarNotification = [CWStatusBarNotification new];
    self.statusBarNotification.notificationLabelBackgroundColor = [UIColor whiteColor];
    self.statusBarNotification.notificationLabelTextColor = [UIColor colorWithRed:202.0/255.0
                                                                            green:35.0/255.0
                                                                             blue:32.0/255.0
                                                                            alpha:1.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.statusBarNotification displayNotificationWithMessage:@"💉 Thanks for using Dr.Cloud! 💊" forDuration:3.0f];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
