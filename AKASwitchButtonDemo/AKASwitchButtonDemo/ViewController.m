//
//  ViewController.m
//  AKASwitchButtonDemo
//
//  Created by 4AM_Xiao on 2019/11/6.
//  Copyright © 2019 com.ios. All rights reserved.
//

#import "ViewController.h"
#import "AKASwitchButton/AKASwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    AKASwitch *switchBtn = [[AKASwitch alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    switchBtn.center = self.view.center;
    switchBtn.isEnable = YES;
    switchBtn.isOn = YES;
    switchBtn.isBoundsEnable = YES;
    [self.view addSubview:switchBtn];
}


@end
