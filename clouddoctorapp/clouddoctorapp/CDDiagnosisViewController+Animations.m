//
//  CDDiagnosisViewController+Animations.m
//  clouddoctorapp
//
//  Created by Peter Kim on 1/17/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "CDDiagnosisViewController+Animations.h"

@implementation CDDiagnosisViewController (Animations)

- (void)setDeliveryFee:(NSString *)deliveryFee
       andDeliveryTime:(NSString *)deliveryTime
{
    self.deliveryFeeLabel.text = [NSString stringWithFormat:@"$%@", [deliveryFee substringToIndex:1]];
    self.deliveryTimeLabel.text = [NSString stringWithFormat:@"%@m", deliveryTime];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.deliveryFeeLabel.alpha = 1.0;
        self.deliveryTimeLabel.alpha = 1.0;
    }];
}

@end
