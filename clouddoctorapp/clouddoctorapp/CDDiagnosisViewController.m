//
//  CDDiagnosisViewController.m
//  clouddoctorapp
//
//  Created by Peter Kim on 1/17/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "CDDiagnosisViewController.h"
#import "CDDiagnosisViewController+Animations.h"

#import "DeliveryOperationController.h"
#import "CWStatusBarNotification.h"

@interface CDDiagnosisViewController ()

@property CWStatusBarNotification *statusBarNotification;

@property NSString *deliveryQuoteID;

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
    
    [[DeliveryOperationController getDeliveryQuote] continueWithSuccessBlock:^id(BFTask *task) {
        NSDictionary *response = (NSDictionary *) task.result;
        NSString *deliveryFee = [NSString stringWithFormat:@"%@", [response objectForKey:@"fee"]];
        NSString *deliveryTime = [NSString stringWithFormat:@"%@", [response objectForKey:@"duration"]];
        self.deliveryQuoteID = [response objectForKey:@"id"];

        [self setDeliveryFee:deliveryFee andDeliveryTime:deliveryTime];
        
        return nil;
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.statusBarNotification displayNotificationWithMessage:@"💉 Thanks for using Dr.Cloud! 💊" forDuration:2.0f];
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

- (IBAction)handleOrderMedication:(id)sender {
    [self.statusBarNotification displayNotificationWithMessage:@"Ordering Medication via Postmates!" forDuration:2.0f];
    
    if (self.deliveryQuoteID) {
        [[DeliveryOperationController scheduleDelivery:self.deliveryQuoteID withNotes:@"Tylenol"] continueWithSuccessBlock:^id(BFTask *task) {
            [self.statusBarNotification displayNotificationWithMessage:@"Order Placed! :)" forDuration:2.0f];
            [self.navigationController popViewControllerAnimated:YES];
            return nil;
        }];
    }
    
}
@end
