//
//  CDDiagnosisViewController.h
//  clouddoctorapp
//
//  Created by Peter Kim on 1/17/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDDiagnosisViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *orderMedicationButton;

- (IBAction)handleOrderMedication:(id)sender;

@end
