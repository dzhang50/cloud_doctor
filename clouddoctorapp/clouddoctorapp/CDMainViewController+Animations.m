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

- (void)activateListeningMode
{
    [UIView animateWithDuration:0.5f animations:^{
        [self.statusLabel setAlpha:0.0f];
        [self.microphoneImageView setAlpha:1.0];
        self.halo.backgroundColor = self.CDBlue.CGColor;
    }];
}

- (void)deactivateListeningMode
{
    [UIView animateWithDuration:0.5f animations:^{
        [self.statusLabel setAlpha:1.0f];
        [self.microphoneImageView setAlpha:0.0];
        self.halo.backgroundColor = self.CDGreen.CGColor;
    }];
}

@end
