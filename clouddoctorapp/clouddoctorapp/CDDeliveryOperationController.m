//
//  DeliveryOperationController.m
//  clouddoctorapp
//
//  Created by Peter Kim on 1/17/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "CDDeliveryOperationController.h"
#import "AFNetworking/AFNetworking.h"

#import "AppDelegate.h"

@implementation CDDeliveryOperationController

NSString * const UPENN_ADDRESS = @"3330 Walnut Street, Philadelphia, PA 19104";
NSString * const CVS_ADDRESS = @"3401 Walnut Street Philadelphia, PA 19104";
NSString * const POSTMATES_API_DEV_KEY = @"887be7dd-2292-44fa-963c-a371b32e1cc3";
NSString * const POSTMATES_API_PROD_KEY = @"0af3d0f1-0b6b-4146-a046-45542626c6b5";
NSString * const POSTMATES_API_BASE_URL = @"https://api.postmates.com/v1/";
NSString * const POSTMATES_API_CUSTOMER_ID = @"cus_J_LfHamn2SN7nV";

+ (BFTask *)getDeliveryQuote
{
    BFTaskCompletionSource *getDeliveryQuotePromise = [BFTaskCompletionSource taskCompletionSource];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:POSTMATES_API_DEV_KEY password:@""];
    
    NSString *requestURI = [NSString stringWithFormat:@"%@customers/%@/delivery_quotes", POSTMATES_API_BASE_URL, POSTMATES_API_CUSTOMER_ID];
    NSDictionary *params = @{@"pickup_address": CVS_ADDRESS, @"dropoff_address": UPENN_ADDRESS};
    [manager POST:requestURI parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [getDeliveryQuotePromise setResult:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [getDeliveryQuotePromise setError:error];
    }];
    
    return getDeliveryQuotePromise.task;
}

+ (BFTask *)scheduleDelivery:(NSString *)quoteID
                   withNotes:(NSString *)notes
{
    BFTaskCompletionSource *scheduleDeliveryPromise = [BFTaskCompletionSource taskCompletionSource];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:POSTMATES_API_DEV_KEY password:@""];
    
    NSString *requestURI = [NSString stringWithFormat:@"%@customers/%@/deliveries", POSTMATES_API_BASE_URL, POSTMATES_API_CUSTOMER_ID];
    NSDictionary *params = @{@"manifest": CVS_ADDRESS,
                             @"pickup_name": @"CVS Pharmacy",
                             @"pickup_address": CVS_ADDRESS,
                             @"pickup_phone_number": @"555-555-5555",
                             @"pickup_notes": notes,
                             @"dropoff_name": @"Peter Kim",
                             @"dropoff_address": UPENN_ADDRESS,
                             @"dropoff_phone_number": @"510-557-8964",
                             @"quote_id": quoteID
                             };
    
    [manager POST:requestURI parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *response = (NSDictionary *) responseObject;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.inDeliveryMode = YES;
        appDelegate.deliveryID = [response objectForKey:@"id"];
        [scheduleDeliveryPromise setResult:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [scheduleDeliveryPromise setError:error];
    }];

    return scheduleDeliveryPromise.task;
}

+ (BFTask *)getDeliveryUpdate:(NSString *)deliveryID
{
    BFTaskCompletionSource *getDeliveryUpdatePromise = [BFTaskCompletionSource taskCompletionSource];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:POSTMATES_API_DEV_KEY password:@""];
    
    NSString *requestURI = [NSString stringWithFormat:@"%@customers/%@/deliveries/%@", POSTMATES_API_BASE_URL, POSTMATES_API_CUSTOMER_ID, deliveryID];
    
    [manager GET:requestURI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [getDeliveryUpdatePromise setResult:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [getDeliveryUpdatePromise setError:error];
    }];
    
    return getDeliveryUpdatePromise.task;
}


@end
