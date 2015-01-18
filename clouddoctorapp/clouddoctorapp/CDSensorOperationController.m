//
//  SensorOperationController.m
//  clouddoctorapp
//
//  Created by Peter Kim on 1/17/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "CDSensorOperationController.h"
#import "AFNetworking/AFNetworking.h"

NSString * const BACKEND_BASE_URL = @"http://doctor-jarvis.appspot.com/clouddoctor?action=diag";

@implementation CDSensorOperationController

+ (BFTask *)getDiagnosisWithSensorData:(NSMutableDictionary *)sensorData
                           andSymptoms:(NSString *)symptoms
{
    BFTaskCompletionSource *getDiagnosisPromise = [BFTaskCompletionSource taskCompletionSource];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
    
    NSString *requestURI = [NSString stringWithFormat:@"%@&temp=%@&resprate=%@&heartrate=%@&query=%@",
                            BACKEND_BASE_URL,
                            [sensorData objectForKey:@"temp"],
                            [sensorData objectForKey:@"resprate"],
                            [sensorData objectForKey:@"heartrate"],
                            [symptoms stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [manager GET:requestURI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [getDiagnosisPromise setResult:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [getDiagnosisPromise setError:error];
    }];
    
    return getDiagnosisPromise.task;
}

@end
