//
//  ViewController.m
//  clouddoctorapp
//
//  Created by Peter Kim on 1/16/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDMainViewController+Animations.h"

#import "CDDeliveryOperationController.h"

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <Bolts/Bolts.h>

#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface CDMainViewController ()

@property (strong, nonatomic) SKRecognizer* voiceSearch;

@property (nonatomic, readwrite, strong) CPTXYGraph *ecgGraph;

@property (nonatomic, strong) BLE *bleShield;
@property CWStatusBarNotification *statusBarNotification;

@property BOOL inAlertMode;

@end

const unsigned char SpeechKitApplicationKey[] = {
0xa8, 0xc7, 0x4b, 0xe7, 0x20, 0x9d, 0xc3, 0x09, 0x4a, 0xb3, 0xef, 0x24, 0x03, 0xb0, 0x56, 0x3d, 0x8d, 0x6e, 0xbc, 0x60, 0xdb, 0x90, 0x7d, 0x80, 0xe3, 0xe0, 0xaf, 0x67, 0x07, 0x65, 0xa2, 0xaf, 0x2c, 0xed, 0x97, 0x4c, 0x8a, 0x5a, 0x55, 0xd5, 0x0d, 0x44, 0xf9, 0x11, 0xf4, 0x4f, 0x4e, 0x82, 0xbd, 0x0a, 0xe2, 0x99, 0x9a, 0x60, 0x19, 0x7d, 0x40, 0xc8, 0xe4, 0x47, 0x2d, 0x86, 0xf6, 0x5a
};

@implementation CDMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.CDGreen = [UIColor colorWithRed:32.0/255.0
                                   green:202.0/255.0
                                    blue:35.0/255.0
                                   alpha:1.0];
    
    self.CDRed = [UIColor colorWithRed:202.0/255.0
                                 green:35.0/255.0
                                  blue:32.0/255.0
                                 alpha:1.0];
    
    self.CDBlue = [UIColor colorWithRed:35.0/255.0
                                  green:32.0/255.0
                                   blue:202.0/255.0
                                  alpha:1.0];
    
    self.CDYellow = [UIColor colorWithRed:255.0/255.0
                                    green:211.0/255.0
                                     blue:0.0
                                    alpha:1.0];
    
    self.CDOrange = [UIColor colorWithRed:255.0/255.0
                                    green:131.0/255.0
                                     blue:0.0/255.0
                                    alpha:1.0];
    
    if (!self.halo) {
        self.halo = [PulsingHaloLayer layer];
    }
    
    self.halo.position = self.statusLabel.center;
    self.halo.radius = 125.0f;
    self.halo.animationDuration = 1.5f;
    self.halo.pulseInterval = -0.5f;
    self.halo.backgroundColor = self.CDGreen.CGColor;
    [self.view.layer addSublayer:self.halo];
    
    self.bleShield = [[BLE alloc] init];
    [self.bleShield controlSetup];
    self.bleShield.delegate = self;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setupSpeechKitConnection];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateLabelsWithFakeData)
                                   userInfo:nil
                                    repeats:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(simulateFakeAlert)
                                   userInfo:nil
                                    repeats:NO];
    
    [self setUpECGGraph];
    
    self.statusBarNotification = [CWStatusBarNotification new];
    self.statusBarNotification.notificationLabelBackgroundColor = [UIColor whiteColor];
    self.statusBarNotification.notificationLabelTextColor = self.CDRed;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.statusBarNotification displayNotificationWithMessage:@"💉 Dr.Cloud is at your service! 💊" forDuration:3.0f];
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if (appDelegate.inDeliveryMode) {
        [self.statusBarNotification displayNotificationWithMessage:@"Order Placed! :)" forDuration:2.0f];
        [self setDeliveryMode];
        
        [NSTimer scheduledTimerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(checkDeliveryStatus)
                                       userInfo:nil
                                        repeats:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Test 

- (void)updateLabelsWithFakeData
{
    [self updateLabel:self.hearbeatLabel WithText:[NSString stringWithFormat:@"%d bpm", rand() % (0 - 125) + 0]];
    [self updateLabel:self.temperatureLabel WithText:[NSString stringWithFormat:@"%d°F", rand() % (0 - 125) + 0]];
    [self updateLabel:self.oxygenLabel WithText:[NSString stringWithFormat:@"%d%%", rand() % (0 - 100) + 0]];
    [self updateLabel:self.carbonDioxideLabel WithText:[NSString stringWithFormat:@"%d%%", rand() % (0 - 100) + 0]];
    
    [self.ecgGraph reloadData];
}

- (void)simulateFakeAlert
{
    self.inAlertMode = YES;
    [self setAlertMode];
}

#pragma mark - Delivery

- (void)checkDeliveryStatus
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [[CDDeliveryOperationController getDeliveryUpdate:appDelegate.deliveryID] continueWithSuccessBlock:^id(BFTask *task) {
        NSDictionary *response = (NSDictionary *) task.result;
        [self updateLabel:self.statusLabel WithText:[response objectForKey:@"status"]];
    
        if ([response objectForKey:@"dropoff_eta"] != (id)[NSNull null] ) {
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
            NSDate *date = [formatter dateFromString:[response objectForKey:@"dropoff_eta"]];
            
            [formatter setTimeZone: [NSTimeZone systemTimeZone]];
            [formatter setDateFormat:@"h:mm a"];
            NSString *stringFromDate = [formatter stringFromDate:date];

            [self updateLabel:self.etaLabel WithText:stringFromDate];
        }

        if ([response objectForKey:@"courier"] != (id)[NSNull null] ) {
            NSDictionary *courier = (NSDictionary *) [response objectForKey:@"courier"];
            NSString *courierImageURL = [courier objectForKey:@"img_href"];
            [self.courierImageView sd_setImageWithURL:[NSURL URLWithString:courierImageURL] placeholderImage:[UIImage imageNamed:@"courier"]];
            [self updateLabel:self.courierNameLabel WithText:[courier objectForKey:@"name"]];
        }
        
        return nil;
    }];
}

#pragma mark - CorePlot

- (void)setUpECGGraph
{
    if (!self.ecgGraph) {
        CPTXYGraph *newGraph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
        //CPTTheme *theme      = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
        //[newGraph applyTheme:theme];
        self.ecgGraph = newGraph;
        self.ecgGraph.axisSet = nil;
        
        newGraph.paddingTop    = 0.0;
        newGraph.paddingBottom = 0.0;
        newGraph.paddingLeft   = 0.0;
        newGraph.paddingRight  = 0.0;
        
        CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] initWithFrame:newGraph.bounds];
        
        CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
        lineStyle.lineWidth              = 1.0;
        lineStyle.lineColor              = [CPTColor colorWithCGColor:self.CDRed.CGColor];
        dataSourceLinePlot.dataLineStyle = lineStyle;
        
        dataSourceLinePlot.dataSource = self;
        [newGraph addPlot:dataSourceLinePlot];
    }
    
    CPTXYGraph *theGraph = self.ecgGraph;
    self.ecgGraphHostingView.hostedGraph = theGraph;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)theGraph.defaultPlotSpace;
    
    NSDecimalNumber *high   = [NSDecimalNumber numberWithInt:100];
    NSDecimalNumber *low    = [NSDecimalNumber numberWithInt:0];
    NSDecimalNumber *length = [high decimalNumberBySubtracting:low];
    
    NSLog(@"high = %@, low = %@, length = %@", high, low, length);
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromUnsignedInteger(10)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:low.decimalValue length:length.decimalValue];
    
    [theGraph reloadData];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 10;
}


-(id)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = @0;
    
    if ( fieldEnum == CPTScatterPlotFieldX ) {
        num = @(index);
    }
    else if ( fieldEnum == CPTScatterPlotFieldY ) {
        num = @(rand() % (0 - 100) + 0);
    }
    
    return num;
}

#pragma mark - BLEDelegate

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSLog(@"%@", s);
}

- (void) readRSSITimer:(NSTimer *)timer
{
    [self.bleShield readRSSI];
}

- (void) bleDidDisconnect
{
    NSLog(@"bleDidDisconnect");
}

-(void) bleDidConnect
{
    NSLog(@"bleDidConnect");
    [self.bleShield write:[@"G" dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark - SKRecognizerDelegate

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    NSLog(@"didBeginRecording");
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"didFinishRecording");
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"didFinishWithResults");
    long numOfResults = [results.results count];
    
    if (numOfResults > 0) {
        // update the text of text field with best result from SpeechKit
        NSLog(@"%@", [results results]);
        self.symptomsTextView.text = [results firstResult];
        self.symptomsTextView.textAlignment = NSTextAlignmentCenter;
        self.symptomsTextView.font = [UIFont fontWithName:@"Avenir-Light" size:11.0f];
    }
}

-(void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    
}

#pragma mark - UIButton

- (IBAction)handleSubmitSymptoms:(id)sender {
    
    if (self.inAlertMode) {
        [self.statusBarNotification displayNotificationWithMessage:@"🎤 Listening 🎤" completion:nil];
        self.inAlertMode = NO;
        [self setListeningMode];
        
        self.voiceSearch = [[SKRecognizer alloc] initWithType:SKDictationRecognizerType
                                                    detection:SKNoEndOfSpeechDetection
                                                     language:@"en_US"
                                                     delegate:self];
    } else {
        [self.statusBarNotification dismissNotification];
        
        if (self.voiceSearch) {
            [self.voiceSearch stopRecording];
            //[self.voiceSearch cancel];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.statusBarNotification displayNotificationWithMessage:@"🚀 Diagnosing 🚀" completion:nil];
        });
        [self setWaitingMode];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.statusBarNotification dismissNotification];
            [self performSegueWithIdentifier:@"MainToDiagnosis" sender:self];
            [self setNormalMode];
        });
    }
}

@end
