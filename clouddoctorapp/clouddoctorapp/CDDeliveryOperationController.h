//
//  DeliveryOperationController.h
//  clouddoctorapp
//
//  Created by Peter Kim on 1/17/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>

@interface CDDeliveryOperationController : NSObject

+ (BFTask *)getDeliveryQuote;
+ (BFTask *)scheduleDelivery:(NSString *)quoteID
                   withNotes:(NSString *)notes;
+ (BFTask *)getDeliveryUpdate:(NSString *)deliveryID;

@end
