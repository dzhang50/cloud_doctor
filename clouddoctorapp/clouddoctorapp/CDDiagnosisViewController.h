//
//  CDDiagnosisViewController.h
//  clouddoctorapp
//
//  Created by Peter Kim on 1/17/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDDiagnosisViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *illnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *confidenceLabel;
@property (weak, nonatomic) IBOutlet UITextView *illnessDescription;
@property (weak, nonatomic) IBOutlet UILabel *medicationLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *orderMedicationButton;

- (IBAction)handleOrderMedication:(id)sender;

@end
