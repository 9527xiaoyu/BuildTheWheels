//
//  ViewController.m
//  AKASuspensionButtonDemo
//
//  Created by 4AM_Xiao on 2019/11/7.
//  Copyright © 2019 com.ios. All rights reserved.
//

#import "ViewController.h"
#import "AKASuspensionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AKASuspensionView showSuspension];
    });
    
}


@end
