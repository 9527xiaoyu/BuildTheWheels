//
//  AKAPointionButton.h
//  AKASwitchButtonDemo
//
//  Created by 4AM_Xiao on 2019/11/6.
//  Copyright © 2019 com.ios. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,ButtonSizeType) {
    ButtonSizeTypeSmaller= 1<<0,
    ButtonSizeTypeMedium,
    ButtonSizeTypeBiger,
};

@interface AKAPointionButton : UIButton
@property(nonatomic, assign) ButtonSizeType sizeType;
@end

NS_ASSUME_NONNULL_END
