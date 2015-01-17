//
//  CDMainViewController+Animations.h
//  clouddoctorapp
//
//  Created by Peter Kim on 1/17/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "CDMainViewController.h"

@interface CDMainViewController (Animations)

- (void)updateLabel:(UILabel *)label
           WithText:(NSString *)newText;

- (void)activateListeningMode;
- (void)deactivateListeningMode;

@end
