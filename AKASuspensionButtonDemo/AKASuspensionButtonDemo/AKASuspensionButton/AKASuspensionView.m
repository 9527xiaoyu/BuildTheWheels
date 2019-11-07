//
//  AKASuspensionView.m
//  AKASuspensionButtonDemo
//
//  Created by 4AM_Xiao on 2019/11/7.
//  Copyright © 2019 com.ios. All rights reserved.
//

#import "AKASuspensionView.h"

@implementation AKASuspensionView
{
    CGPoint _originalPoint;
    SuspensionType _type;
    NSString *_url;
}

static AKASuspensionView *_suspensView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Type:(SuspensionType)type Block:(suspensBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _block = block;
        [self initializeUI];
    }
    return self;
}

- (void)initializeUI
{
    //UI
    CGRect frame = self.bounds;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    imgView.backgroundColor = [UIColor blueColor];
    imgView.userInteractionEnabled = YES;
    //TODO:设置图片链接
    [self addSubview:imgView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 60, 20, 20)];
    //TODO:设置点击范围
    cancelBtn.backgroundColor = [UIColor redColor];
    [cancelBtn setImage:nil forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnThouch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [imgView addGestureRecognizer:tap];
    //滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [imgView addGestureRecognizer:pan];
}

#pragma mark - 显示
+ (void)showSuspension
{
    [self showWithSuspensionType:SuspensionTypeNone];
}

+ (void)showWithSuspensionType:(SuspensionType)type
{
    [self showWithSuspensionType:type Block:nil];
}

+ (void)showWithSuspensionType:(SuspensionType)type Block:(suspensBlock)block
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _suspensView = [[AKASuspensionView alloc]initWithFrame:CGRectMake(0, 200, 80, 80) Type:type Block:block];
    });
    if (!_suspensView.superview) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:_suspensView];
        [window bringSubviewToFront:_suspensView];
    }
}

#pragma mark - 移除
+ (void)removeSuspension
{
    [_suspensView removeFromSuperview];
}

#pragma mark - EVENT
//点击事件
- (void)tap:(UITapGestureRecognizer *)tap
{
    if (self.block) {
        self.block(_url);
    }
}

//拖拽事件
- (void)pan:(UIPanGestureRecognizer *)pan
{
    CGPoint currentPosition = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {//开始拖砖
        _originalPoint = currentPosition;
    }else if (pan.state == UIGestureRecognizerStateChanged){//拖拽中
        //偏移量 = 当前-原始
        CGFloat offsetX = currentPosition.x - _originalPoint.x;
        CGFloat offsetY = currentPosition.y - _originalPoint.y;
        
        //中心点
        CGFloat centerX = self.center.x +offsetX;
        CGFloat centerY = self.center.y +offsetY;
        self.center = CGPointMake(centerX, centerY);
        
        //父视图宽高
        CGFloat superHeight = CGRectGetHeight(self.superview.frame);
        CGFloat superWidth = CGRectGetWidth(self.superview.frame);
        
        //自身坐标
        CGFloat selfX = CGRectGetMinX(self.frame);
        CGFloat selfY = CGRectGetMinY(self.frame);
        CGFloat selfW = CGRectGetWidth(self.frame);
        CGFloat selfH = CGRectGetHeight(self.frame);
        
        //判断整体超过左右极限
        if (selfX>superWidth) {
            //右侧越界
            CGFloat centerX = superWidth - selfW/2;
            self.center = CGPointMake(centerX, centerY);
        }else if (selfX < 0){
            //左侧越界
            CGFloat centerX = selfW/2;
            self.center = CGPointMake(centerX, centerY);
        }
        
        CGFloat naviHeight = 64;
        CGFloat judgeSuperHeight = superHeight - naviHeight;
        //判断整体超过上下极限
        if ((selfY+selfH)>=superHeight) {
            //超过下限
            CGFloat centerY = superHeight - selfH/2;
            self.center = CGPointMake(centerX, centerY);
        }else if (selfY<=0){
            //超过上限
            CGFloat centerY = selfH/2;
            self.center = CGPointMake(centerX, centerY);
        }
         
    }else if (pan.state == UIGestureRecognizerStateEnded){//拖拽停止
        CGFloat selfY = CGRectGetMinY(self.frame);
        CGFloat selfW = CGRectGetWidth(self.frame);
        CGFloat selfH = CGRectGetHeight(self.frame);
        CGFloat superW = self.superview.frame.size.width;
        switch (_type) {
            case SuspensionTypeNone:
            {
                //自动识别贴边
                if (self.center.x >= superW/2) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        //按钮靠右自动吸边
                        CGFloat selfX = superW - selfW;
                        self.frame = CGRectMake(selfX, selfY, selfW, selfH);
                    }];
                }else{
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        //按钮靠左吸边
                        CGFloat selfX = 0;
                        self.frame = CGRectMake(selfX, selfY, selfW, selfH);
                    }];
                }
            }
                break;
            case SuspensionTypeLeft:
            {
                [UIView animateWithDuration:0.2 animations:^{
                    //按钮靠左吸边
                    CGFloat selfX = 0;
                    self.frame = CGRectMake(selfX, selfY, selfW, selfH);
                }];
            }
                break;
            case SuspensionTypeRight:
            {
                [UIView animateWithDuration:0.2 animations:^{
                    //按钮靠右自动吸边
                    CGFloat selfX = superW - selfW;
                    self.frame = CGRectMake(selfX, selfY, selfW, selfH);
                }];
            }
                break;
            default:
                break;
        }
    }
}

//取消按钮
- (void)cancelBtnThouch
{
    [_suspensView removeFromSuperview];
}

@end
