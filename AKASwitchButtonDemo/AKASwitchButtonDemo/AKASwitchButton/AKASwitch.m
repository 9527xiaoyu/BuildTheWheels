//
//  AKASwitch.m
//  AKASwitchButtonDemo
//
//  Created by 4AM_Xiao on 2019/11/6.
//  Copyright © 2019 com.ios. All rights reserved.
//

#import "AKASwitch.h"
#import "Configuration.h"

@implementation AKASwitch
{
    float switchOnPointion;
    float switchOffPointion;
    float boundsFloat;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [self initWithFrame:frame State:SwitchStateTypeOff];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame State:(SwitchStateType)stateType
{
    self.trackTintOnColor = BTWColor(0, 255, 0);
    self.trackTintOffColor = BTWColor(238, 238, 238);
    self.disenableColor = BTWColor(153, 153, 153);
    
    self.isEnable = YES;
    self.isOn = NO;
    self.isBoundsEnable = NO;
    
    CGFloat frameHeight = CGRectGetWidth(frame)*3/5;
    CGRect trackFrame = CGRectZero;
    trackFrame.size.width = CGRectGetWidth(frame);
    trackFrame.size.height = frameHeight;
    trackFrame.origin.x = 0;
    trackFrame.origin.y = 0;
    CGRect thumbFrame = CGRectZero;
    thumbFrame.size = CGSizeMake(frameHeight, frameHeight);
    thumbFrame.origin.x = 0.0;
    thumbFrame.origin.y = 0.0;
    
    
    self.track = [[UIView alloc]initWithFrame:trackFrame];
    self.track.backgroundColor = [UIColor grayColor];
    self.track.layer.cornerRadius = MIN(CGRectGetHeight(self.track.frame), CGRectGetWidth(self.track.frame))/2;
    [self addSubview:self.track];
    
    self.switchThumb = [[AKAPointionButton alloc]initWithFrame:thumbFrame];
    self.switchThumb.backgroundColor = [UIColor whiteColor];
    self.switchThumb.layer.cornerRadius = CGRectGetHeight(self.switchThumb.frame)/2;
    self.switchThumb.layer.shadowOpacity = 0.5;
    self.switchThumb.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.switchThumb.layer.shadowColor = [UIColor blackColor].CGColor;
    self.switchThumb.layer.shadowRadius = 2.0f;
    
    [self.switchThumb addTarget:self action:@selector(onTouchUpOutsideOrCanceled:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
    [self.switchThumb addTarget:self action:@selector(switchThumbTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchThumb addTarget:self action:@selector(onTouchDragInside:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.switchThumb addTarget:self action:@selector(onTouchUpOutsideOrCanceled:withEvent:) forControlEvents:UIControlEventTouchCancel];
    
    [self addSubview:self.switchThumb];

    switchOnPointion = self.frame.size.width - self.switchThumb.frame.size.width;
    switchOffPointion = self.switchThumb.frame.origin.x;
    boundsFloat = 2.0;
    
    switch (stateType) {
        case SwitchStateTypeOn:
        {
            self.isOn = YES;
            CGRect switchFrame = self.switchThumb.frame;
            switchFrame.origin.x = switchOnPointion;
            self.switchThumb.frame = switchFrame;
        }
            break;
        case SwitchStateTypeOff:
        default:
        {
            self.isOn = NO;
        }
            break;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview: newSuperview];
    if (self.isOn) {
        self.track.backgroundColor = self.trackTintOnColor;
        [self switchThumbOnWithNoneAniated];
    }else{
        self.track.backgroundColor = self.trackTintOffColor;
        [self switchThumbOffWithNoneAniated];
    }
    
    if (!self.isEnable) {
        self.track.backgroundColor = self.disenableColor;
        self.switchThumb.backgroundColor = self.disenableColor;
    }
    if (self.isBoundsEnable) {
        boundsFloat = 3.0;
    }else{
        boundsFloat = 0;
    }
}

#pragma mark - setter
-(void)setIsEnable:(BOOL)isEnable
{
    [super setEnabled:isEnable];
    _isEnable = isEnable;
    if (isEnable) {
        self.switchThumb.backgroundColor = [UIColor whiteColor];
        if (self.isOn) {
            self.track.backgroundColor = self.trackTintOnColor;
        }else{
            self.track.backgroundColor = self.trackTintOffColor;
        }
    }else{
        self.track.backgroundColor = self.disenableColor;
        self.switchThumb.backgroundColor = self.disenableColor;
    }
}

#pragma mark - public
- (BOOL)getSwitchState
{
    return self.isOn;
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    if (on) {
        self.track.backgroundColor = self.trackTintOnColor;
    }
    else{
        self.track.backgroundColor = self.trackTintOffColor;
    }
}

- (void)switchThumbOnWithAniated
{
    [UIView animateWithDuration:0.1 delay:0.05 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect switchFrame = self.switchThumb.frame;
        switchFrame.origin.x = self->switchOnPointion+self->boundsFloat;
        self.switchThumb.frame = switchFrame;
        if (self.isEnable) {
          self.track.backgroundColor = self.trackTintOnColor;
        }
        else {
          self.track.backgroundColor = self.disenableColor;
        }
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        if (self.isOn == NO) {
          self.isOn = YES;
          [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        self.isOn = YES;
        
        [UIView animateWithDuration:0.1 animations:^{
            CGRect switchFrame = self.switchThumb.frame;
            switchFrame.origin.x = self->switchOnPointion;
            self.switchThumb.frame = switchFrame;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }];
}

- (void)switchThumbOnWithNoneAniated
{
    self.userInteractionEnabled = NO;
    CGRect switchFrame = self.switchThumb.frame;
    switchFrame.origin.x = switchOnPointion;
    self.switchThumb.frame = switchFrame;
    if (self.isEnable) {
      self.track.backgroundColor = self.trackTintOnColor;
    }
    else {
      self.track.backgroundColor = self.disenableColor;
    }
    if (!self.isOn) {
      self.isOn = YES;
      [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    self.isOn = YES;
    
    self.userInteractionEnabled = YES;
}

- (void)switchThumbOffWithAniated
{
    [UIView animateWithDuration:0.1 delay:0.05 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect switchFrame = self.switchThumb.frame;
        switchFrame.origin.x = self->switchOffPointion-self->boundsFloat;
        self.switchThumb.frame = switchFrame;
        if (self.isEnable) {
          self.track.backgroundColor = self.trackTintOffColor;
        }
        else {
          self.track.backgroundColor = self.disenableColor;
        }
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        if (self.isOn) {
          self.isOn = NO;
          [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        self.isOn = NO;
        
        [UIView animateWithDuration:0.1 animations:^{
            CGRect switchFrame = self.switchThumb.frame;
            switchFrame.origin.x = self->switchOffPointion;
            self.switchThumb.frame = switchFrame;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }];
}

- (void)switchThumbOffWithNoneAniated
{
    self.userInteractionEnabled = NO;
    CGRect switchFrame = self.switchThumb.frame;
    switchFrame.origin.x = switchOffPointion;
    self.switchThumb.frame = switchFrame;
    if (self.isEnable) {
      self.track.backgroundColor = self.trackTintOffColor;
    }
    else {
      self.track.backgroundColor = self.disenableColor;
    }
    if (self.isOn) {
      self.isOn = NO;
      [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    self.isOn = NO;
    
    self.userInteractionEnabled = YES;
}

- (void)changeThumbState
{
  if (self.isOn) {
    [self switchThumbOffWithAniated];
  }
  else {
    [self switchThumbOnWithAniated];
  }
}

#pragma mark - EVENT
- (void)switchThumbTapped: (id)sender
{
  if ([self.delegate respondsToSelector:@selector(switchCurrentState:)]) {
    if (self.isOn) {
      [self.delegate switchCurrentState:SwitchStateTypeOff];
    }
    else{
      [self.delegate switchCurrentState:SwitchStateTypeOn];
    }
  }
  
  [self changeThumbState];
}

- (void)onTouchUpOutsideOrCanceled:(UIButton*)sender withEvent:(UIEvent*)event
{
  UITouch *touch = [[event touchesForView:sender] anyObject];
  CGPoint prevPos = [touch previousLocationInView:sender];
  CGPoint pos = [touch locationInView:sender];
  float dX = pos.x-prevPos.x;
  
  float newXOrigin = sender.frame.origin.x + dX;
  
  if (newXOrigin > (self.frame.size.width - self.switchThumb.frame.size.width)/2) {
    [self switchThumbOnWithAniated];
  }
  else {
    [self switchThumbOffWithAniated];
  }
}

- (void)onTouchDragInside:(UIButton*)sender withEvent:(UIEvent*)event
{
  UITouch *touch = [[event touchesForView:sender] anyObject];
  CGPoint prevPos = [touch previousLocationInView:sender];
  CGPoint pos = [touch locationInView:sender];
  float dX = pos.x-prevPos.x;
  
  CGRect thumbFrame = sender.frame;
  
  thumbFrame.origin.x += dX;
  thumbFrame.origin.x = MIN(thumbFrame.origin.x,switchOnPointion);
  thumbFrame.origin.x = MAX(thumbFrame.origin.x,switchOffPointion);
  
  if(thumbFrame.origin.x != sender.frame.origin.x) {
    sender.frame = thumbFrame;
  }
}
@end
