//
//  AKASuspensionView.h
//  AKASuspensionButtonDemo
//
//  Created by 4AM_Xiao on 2019/11/7.
//  Copyright © 2019 com.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,SuspensionType){
    SuspensionTypeNone = 0,
    SuspensionTypeLeft,
    SuspensionTypeRight,
};

typedef void(^suspensBlock)(NSString *url);

@interface AKASuspensionView : UIView

@property (nonatomic, copy) suspensBlock block;

+ (void)showSuspension;
+ (void)showWithSuspensionType:(SuspensionType)type;
+ (void)showWithSuspensionType:(SuspensionType)type Block:(suspensBlock)block;

+ (void)removeSuspension;

@end

NS_ASSUME_NONNULL_END
