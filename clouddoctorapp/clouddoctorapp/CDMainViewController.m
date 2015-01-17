//
//  ViewController.m
//  clouddoctorapp
//
//  Created by Peter Kim on 1/16/15.
//  Copyright (c) 2015 Cloud Doctor. All rights reserved.
//

#import "CDMainViewController.h"
#import "AppDelegate.h"

#import "PulsingHaloLayer.h"
#import "MultiplePulsingHaloLayer.h"

@interface CDMainViewController ()

@property CWStatusBarNotification *statusBarNotification;
@property (nonatomic, weak) PulsingHaloLayer *halo;

@end

@implementation CDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIColor *cloudDoctorGreen = [UIColor colorWithRed:32.0/255.0
                                                green:202.0/255.0
                                                 blue:35.0/255.0
                                                alpha:1.0];
    
    UIColor *cloudDoctorRed = [UIColor colorWithRed:202.0/255.0
                                              green:35.0/255.0
                                               blue:32.0/255.0
                                              alpha:1.0];
    
    self.halo = [PulsingHaloLayer layer];
    self.halo.position = self.statusLabel.center;
    self.halo.radius = 125.0f;
    self.halo.animationDuration = 1.5f;
    self.halo.pulseInterval = -0.5f;
    self.halo.backgroundColor = cloudDoctorGreen.CGColor;
    [self.view.layer addSublayer:self.halo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
}

#pragma mark - CBPerpipheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

#pragma mark - CBCharacteristic helpers



@end
