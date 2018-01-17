//
//  MediaTimingViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/6/5.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "MediaTimingViewController.h"

@interface MediaTimingViewController ()

@property (nonatomic, weak) CALayer *doorLayer;
@property (nonatomic, weak) CALayer *imgLayer;

@end

@implementation MediaTimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self doorAnimation];
    
//    [self planeAnimation];
    
    [self manualAnimation];
}

#pragma mark - CAMediaTiming协议

- (void)doorAnimation {
    CALayer *doorLayer = [CALayer layer];
    doorLayer.contents = (id)[UIImage imageNamed:@"door"].CGImage;
    doorLayer.frame = CGRectMake(0, 0, 90, 175);
    doorLayer.position = CGPointMake(self.view.bounds.size.width / 2.0 - 45, self.view.bounds.size.height / 2.0);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    [self.view.layer addSublayer:doorLayer];
    
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1 / 500.0;
    self.view.layer.sublayerTransform = transform;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 2;
    animation.repeatCount = INFINITY;
    animation.autoreverses = YES;
    [doorLayer addAnimation:animation forKey:nil];
}

#pragma mark - 层级关系时间

- (void)planeAnimation {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(20, 250)];
    [path addCurveToPoint:CGPointMake(300, 250) controlPoint1:CGPointMake(125, 150) controlPoint2:CGPointMake(225, 350)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 3.0;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
    
    
    CALayer *imgLayer = [CALayer layer];
    imgLayer.frame = CGRectMake(0, 0, 44, 50);
    imgLayer.position = CGPointMake(20, 250);
    imgLayer.contents = (id)[UIImage imageNamed:@"plane"].CGImage;
    [self.view.layer addSublayer:imgLayer];
    self.imgLayer = imgLayer;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.path = path.CGPath;
    animation.duration = 5.0;
//    animation.beginTime = CACurrentMediaTime() + 1; // 动画延迟1秒执行
//    animation.timeOffset = 2; // 动画从2秒处执行
    animation.rotationMode = kCAAnimationRotateAuto; // 让图层根据切线的方向自动旋转
    animation.removedOnCompletion = NO; // 动画结束后不移除，需配合 fillMode = kCAFillModeForwards 使用
    animation.fillMode = kCAFillModeForwards;
    [imgLayer addAnimation:animation forKey:nil];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"Play" forState:UIControlStateNormal];
    btn.frame = CGRectMake(30, 400, 50, 25);
    [btn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"Pause" forState:UIControlStateNormal];
    btn.frame = CGRectMake(30, 430, 50, 25);
    [btn addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"快进" forState:UIControlStateNormal];
    btn.frame = CGRectMake(30, 460, 50, 25);
    [btn addTarget:self action:@selector(forward) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"倒退" forState:UIControlStateNormal];
    btn.frame = CGRectMake(30, 490, 50, 25);
    [btn addTarget:self action:@selector(backward) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)play {
    // 动画的暂停时间
    CFTimeInterval pausedTime = self.imgLayer.timeOffset;
    // 动画初始化
    self.imgLayer.speed = 1;
    self.imgLayer.timeOffset = 0;
    self.imgLayer.beginTime = 0;
    // 程序到这里，动画就能继续进行了，但不是连贯的，而是动画在背后默默“偷跑”的位置，如果超过一个动画周期，则是初始位置
    // 当前时间（恢复时的时间）
    CFTimeInterval continueTime = [self.imgLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 暂停到恢复之间的空档
    CFTimeInterval timePause = continueTime - pausedTime;
    // 动画从timePause的位置从动画头开始
    self.imgLayer.beginTime = timePause;
}

- (void)pause {
    // 当前时间（暂停时的时间）
    // CACurrentMediaTime() 是基于内建时钟的，能够更精确更原子化地测量，并且不会因为外部时间变化而变化（例如时区变化、夏时制、秒突变等）,但它和系统的uptime有关,系统重启后CACurrentMediaTime()会被重置
    CFTimeInterval pausedTime = [self.imgLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 停止动画
    self.imgLayer.speed = 0;
    // 动画的位置（动画进行到当前时间所在的位置，如timeOffset=1表示动画进行1秒时的位置）
    self.imgLayer.timeOffset = pausedTime;
}

- (void)forward {
    // 如何实现？
}

- (void)backward {
    
}

#pragma mark - 手动动画

- (void)manualAnimation {
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    slider.center = CGPointMake(self.view.bounds.size.width / 2.0, 150);
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    CALayer *doorLayer = [CALayer layer];
    doorLayer.contents = (id)[UIImage imageNamed:@"door"].CGImage;
    doorLayer.frame = CGRectMake(0, 0, 90, 175);
    doorLayer.position = CGPointMake(self.view.bounds.size.width / 2.0 - 45, self.view.bounds.size.height / 2.0);
    doorLayer.anchorPoint = CGPointMake(0, 0.5);
    doorLayer.speed = 0; // 暂停动画
    [self.view.layer addSublayer:doorLayer];
    self.doorLayer = doorLayer;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1 / 500.0;
    self.view.layer.sublayerTransform = transform;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 1;
    [doorLayer addAnimation:animation forKey:nil];
}

- (void)sliderValueChanged:(UISlider *)slider {
    self.doorLayer.timeOffset = slider.value;
}

@end
