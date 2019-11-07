//
//  AKASwitch.h
//  AKASwitchButtonDemo
//
//  Created by 4AM_Xiao on 2019/11/6.
//  Copyright © 2019 com.ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "AKAPointionButton.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,SwitchStateType){
    SwitchStateTypeOff = 1<<0,
    SwitchStateTypeOn = 1<<1,
};

@protocol AKASwitchProtocol <NSObject>

- (void)switchCurrentState:(SwitchStateType)currentState;

@end
@interface AKASwitch : UIControl

@property (nonatomic, weak) id<AKASwitchProtocol> delegate;

/**开关状态*/
@property (nonatomic, assign) BOOL isOn;
/**switch是否可用*/
@property (nonatomic, assign) BOOL isEnable;
/**switch是否可反弹*/
@property (nonatomic, assign) BOOL isBoundsEnable;

/**switch打开时背景色*/
@property (nonatomic, strong) UIColor *trackTintOnColor;
/**switch关闭时背景色*/
@property (nonatomic, strong) UIColor *trackTintOffColor;
/**禁用switchd时的背景色*/
@property (nonatomic, strong) UIColor *disenableColor;

//UI
@property (nonatomic, strong) AKAPointionButton *switchThumb;
@property (nonatomic, strong) UIView *track;

- (instancetype)initWithFrame:(CGRect)frame State:(SwitchStateType)stateType;

- (BOOL)getSwitchState;

- (void)setOn:(BOOL)on animated:(BOOL)animated; // does not send action

@end

NS_ASSUME_NONNULL_END
