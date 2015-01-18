//
//  DeliveryOperationController.m
//  clouddoctorapp
//
//  Created by Peter Kim on 1/17/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "DeliveryOperationController.h"
#import "AFNetworking/AFNetworking.h"

@implementation DeliveryOperationController

NSString * const UPENN_ADDRESS = @"3330 Walnut Street, Philadelphia, PA 19104";
NSString * const CVS_ADDRESS = @"3401 Walnut Street Philadelphia, PA 19104";
NSString * const POSTMATES_API_DEV_KEY = @"887be7dd-2292-44fa-963c-a371b32e1cc3";
NSString * const POSTMATES_API_PROD_KEY = @"0af3d0f1-0b6b-4146-a046-45542626c6b5";
NSString * const POSTMATES_API_BASE_URL = @"https://api.postmates.com/v1/";
NSString * const POSTMATES_API_CUSTOMER_ID = @"cus_J_LfHamn2SN7nV";

+ (BFTask *)getDeliveryQuote
{
    NSLog(@"getting delivery quote");
    
    BFTaskCompletionSource *getDeliveryQuotePromise = [BFTaskCompletionSource taskCompletionSource];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:POSTMATES_API_DEV_KEY password:@""];
    
    NSString *requestURI = [NSString stringWithFormat:@"%@customers/%@/delivery_quotes", POSTMATES_API_BASE_URL, POSTMATES_API_CUSTOMER_ID];
    NSDictionary *params = @{@"pickup_address": CVS_ADDRESS, @"dropoff_address": UPENN_ADDRESS};
    [manager POST:requestURI parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    return getDeliveryQuotePromise.task;
}
    

@end
