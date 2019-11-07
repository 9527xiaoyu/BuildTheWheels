//
//  AKAPointionButton.m
//  AKASwitchButtonDemo
//
//  Created by 4AM_Xiao on 2019/11/6.
//  Copyright © 2019 com.ios. All rights reserved.
//

#import "AKAPointionButton.h"

@implementation AKAPointionButton
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event]) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat radius = 44.0;
    if (self.sizeType == ButtonSizeTypeMedium) {
        radius = 60.0;
    }else if(self.sizeType == ButtonSizeTypeBiger){
        radius = 80.0;
    }
    CGFloat widthDelta = MAX(radius - bounds.size.width, 0);
    CGFloat heightDelta = MAX(radius - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
