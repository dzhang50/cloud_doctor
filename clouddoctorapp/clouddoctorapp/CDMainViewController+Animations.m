//
//  CDMainViewController+Animations.m
//  clouddoctorapp
//
//  Created by Peter Kim on 1/17/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "CDMainViewController+Animations.h"

@implementation CDMainViewController (Animations)

- (void)updateLabel:(UILabel *)label
           WithText:(NSString *)newText
{
    [UIView transitionWithView:label duration:0.25f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        label.text = newText;
    } completion:nil];
}

@end
