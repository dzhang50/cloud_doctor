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

- (void)setNormalMode
{
    [UIView animateWithDuration:0.5f animations:^{
        [self.statusLabel setAlpha:1.0f];
        [self.microphoneImageView setAlpha:0.0];
        [self.uploadImageView setAlpha:0.0];
        self.halo.backgroundColor = self.CDGreen.CGColor;
        self.halo.radius = 125.0f;
        self.submitButton.alpha = 0.0f;
    }];
    
    [UIView transitionWithView:self.statusLabel duration:0.25f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.statusLabel.text = @"all vitals normal";
    } completion:nil];
}

- (void)setAlertMode
{
    [UIView animateWithDuration:0.5f animations:^{
        [self.statusLabel setAlpha:1.0f];
        [self.microphoneImageView setAlpha:0.0];
        self.halo.backgroundColor = self.CDRed.CGColor;
        self.halo.radius = 150.0f;
        self.submitButton.alpha = 1.0f;
    }];
    
    [UIView transitionWithView:self.statusLabel duration:0.25f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.statusLabel.text = @"VITALS ALERT";
    } completion:nil];
}

- (void)setListeningMode
{
    [UIView animateWithDuration:0.5f animations:^{
        [self.statusLabel setAlpha:0.0f];
        [self.microphoneImageView setAlpha:1.0];
        self.halo.backgroundColor = self.CDBlue.CGColor;
        self.halo.radius = 125.0f;
    }];
    
    [UIView transitionWithView:self.submitButton.titleLabel duration:0.25f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.submitButton setTitle:@"Done" forState:UIControlStateNormal];
    } completion:nil];
}

- (void)setWaitingMode
{
    [UIView animateWithDuration:0.5f animations:^{
        [self.statusLabel setAlpha:0.0f];
        [self.microphoneImageView setAlpha:0.0];
        [self.uploadImageView setAlpha:1.0f];
        [self.submitButton setAlpha:0.0f];
        self.halo.backgroundColor = self.CDYellow.CGColor;
        self.halo.radius = 125.0f;
    }];
    
    [UIView transitionWithView:self.submitButton.titleLabel duration:0.25f options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
    } completion:nil];
}

@end
