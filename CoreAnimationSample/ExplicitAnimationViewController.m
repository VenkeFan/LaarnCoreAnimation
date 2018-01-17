//
//  ExplicitAnimationViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/6/1.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "ExplicitAnimationViewController.h"
#import "ImplicitAnimationViewController.h"

@interface ExplicitAnimationViewController () <CAAnimationDelegate>

@property (nonatomic, weak) UIView *layerView;
@property (nonatomic, weak) CALayer *colorLayer;

@property (nonatomic, weak) UIImageView *plate;
@property (nonatomic, weak) UIImageView *hourHand;
@property (nonatomic, weak) UIImageView *minuteHand;
@property (nonatomic, weak) UIImageView *secondHand;

@property (nonatomic, weak) UIImageView *transitionImageView;
@property (nonatomic, weak) CALayer *transitionImageLayer;
@property (nonatomic, strong) NSArray<UIImage *> *imageArray;

@property (nonatomic, weak) CALayer *planeLayer;

@end

@implementation ExplicitAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self changeLayerColorSample];
    
//    [self clockSample];
    
//    [self keyframeAnimationWithPathSample];
    
    [self springAnimationSample];
    
//    [self virtualPropertySample];
    
//    [self animationGroupSample];
    
//    [self transitionAnimationSample];
    
//    [self cangelAnimationSample];
}

#pragma mark - 属性动画
#pragma mark 基础动画 CABasicAnimation

- (void)changeLayerColorSample {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor blueColor].CGColor;
    
    [self.layerView.layer addSublayer:layer];
    self.colorLayer = layer;
}

- (void)changeColorClicked:(id)sender {
    [self basicAnimationChangeColor];
    
//    [self keyframeAnimationChangeColor];
}

- (void)basicAnimationChangeColor {
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    // basic animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    
    /*
     这段代码是在动画开始之前更新属性值。这里用CATransaction来禁用隐式动画行为，否则默认的图层行为会干扰我们的显式动画（实际上，显式动画通常会覆盖隐式动画，但在文章中并没有提到，所以为了安全最好这么做）
     CAAnimationDelegate 的 animationDidStop:finished: 方法是在动画结束之后更新属性值。在委托回调里必须用用CATransaction来禁用隐式动画行为！！！！！！！！！！！
     二者效果一样
     */
//    CALayer *layer = self.colorLayer.presentationLayer ?: self.colorLayer;
//    animation.fromValue = (__bridge id)layer.backgroundColor;
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.colorLayer.backgroundColor = color.CGColor;
//    [CATransaction commit];
    
    animation.duration = 0.9;
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)color.CGColor;
    animation.delegate = self;
    
    [self.colorLayer addAnimation:animation forKey:nil];
}

- (void)clockSample {
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    [self updateHandsAnimated:NO];
}

- (void)tick {
    [self updateHandsAnimated:YES];
}

- (void)updateHandsAnimated:(BOOL)animated {
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    //calculate hour hand angle //calculate minute hand angle
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    //calculate second hand angle
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    
    // rotate hands
    [self setAngle:hoursAngle forHand:self.hourHand animated:animated];
    [self setAngle:minsAngle forHand:self.minuteHand animated:animated];
    [self setAngle:secsAngle forHand:self.secondHand animated:animated];
}

- (void)setAngle:(CGFloat)angle forHand:(UIView *)handView animated:(BOOL)animated {
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1);
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animation];
//        [self updateHandsAnimated:NO];    // 书中的示例代码在这里有这句！不知道为什么？不像是在动画开始之前设置属性值啊！！
        animation.keyPath = @"transform";
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        animation.duration = 0.9;
        [animation setValue:handView forKey:@"handView"];
        animation.delegate = self;
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1]; // 自定义缓冲函数
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [handView.layer addAnimation:animation forKey:nil];
    } else {
        handView.layer.transform = transform;
    }
}

#pragma mark CAAnimationDelegate

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
    /*
        设置一个新的事务,并且禁用图层行为。否则动画会发生两次,一个是因为显式的 CABasicAnimation,另一次是因为隐式动画
        在模拟器上动画正常，在真机上动画仍然有问题，可用 fillMode 属性来解决。
     */
    
    // changeColorSample
    
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.colorLayer.backgroundColor = (__bridge CGColorRef)anim.toValue;
//    [CATransaction commit];
    
    
    /*
        当有多个动画的时候,无法在在回调方法中区分。解决办法是使用 CAAnimation 的KVC。
     */
    
    // clockSample（因为UIView的图层默认禁用隐式动画，所以这里不需要设置一个新的事务）
    
    UIView *handView = [anim valueForKey:@"handView"];
    handView.layer.transform = [anim.toValue CATransform3DValue];
}

#pragma mark 关键帧动画 CAKeyframeAnimation

- (void)keyframeAnimationChangeColor {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor];
    [self.colorLayer addAnimation:animation forKey:nil];
}

- (void)keyframeAnimationWithPathSample {
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
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 5.0;
    animation.path = path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto; // 让图层根据切线的方向自动旋转
    animation.removedOnCompletion = NO; // 动画结束后不移除，需配合 fillMode = kCAFillModeForwards 使用
    animation.fillMode = kCAFillModeForwards;
    [imgLayer addAnimation:animation forKey:nil];
}

#pragma mark 弹簧动画 CASpringAnimation

- (void)springAnimationSample {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layerView.layer addSublayer:layer];
    
    CASpringAnimation * animation = [CASpringAnimation animationWithKeyPath:@"bounds"];
    animation.mass = 10.0; // 质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
    animation.stiffness = 5000; // 刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
    animation.damping = 100.0;// 阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
    animation.initialVelocity = 5.f;// 初始速率，动画视图的初始速度大小;速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
    animation.duration = animation.settlingDuration; // settlingDuration：结算时间（根据动画参数估算弹簧开始运动到停止的时间，动画设置的时间最好根据此时间来设置）
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation forKey:nil];
}

#pragma mark 虚拟属性

- (void)virtualPropertySample {
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 44, 50);
    shipLayer.position = CGPointMake(150, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed: @"plane"].CGImage;
    [self.view.layer addSublayer:shipLayer];
    
    /*
        不推荐的写法（有歧义）
     */
//    CABasicAnimation *animation = [CABasicAnimation animation];
//    animation.keyPath = @"transform";
//    animation.duration = 2.0;
//    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0, 0, 1)];
//    // 书上说这里用byValue的话，图片会变大，并不会做任何旋转。然而经测试实际上也旋转了（模拟器上）
////    animation.byValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0, 0, 1)];
//    [shipLayer addAnimation:animation forKey:nil];
    
    
    /*
        推荐的写法
     */
    CABasicAnimation *animation = [CABasicAnimation animation];
    
//    animation.keyPath = @"transform";
//    animation.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
    
    animation.keyPath = @"transform.rotation.z"; // 这句和上面注释的两句效果等价。
    animation.duration = 2.0;
    animation.toValue = @(M_PI * 2);
    [shipLayer addAnimation:animation forKey:nil];
}

#pragma mark - 动画组 CAAnimationGroup

- (void)animationGroupSample {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(20, 250)];
    [path addCurveToPoint:CGPointMake(300, 250) controlPoint1:CGPointMake(125, 150) controlPoint2:CGPointMake(225, 350)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 3.0;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
    
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(0, 0, 50, 50);
    colorLayer.position = CGPointMake(20, 250);
    colorLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:colorLayer];
    
    
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    animation1.keyPath = @"position";
    animation1.path = path.CGPath;
    animation1.rotationMode = kCAAnimationRotateAuto;
//    animation1.duration = 5;
//    [colorLayer addAnimation:animation1 forKey:nil];
    
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"backgroundColor";
    animation2.toValue = (id)[UIColor redColor].CGColor;
//    animation2.duration = 5;
//    [colorLayer addAnimation:animation2 forKey:nil];
    
    // 动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 5;
    group.animations = @[animation1, animation2];
    [colorLayer addAnimation:group forKey:nil];
}

#pragma mark - 过渡 CATransition

- (void)transitionAnimationSample {
    self.imageArray = @[[UIImage imageNamed:@"WechatIMG3.jpeg"],
                        [UIImage imageNamed:@"WechatIMG4.jpeg"],
                        [UIImage imageNamed:@"WechatIMG5.jpeg"],
                        [UIImage imageNamed:@"WechatIMG6.jpeg"]];
    
    UIImageView *imgView = [UIImageView new];
    imgView.backgroundColor = [UIColor redColor];
    imgView.frame = CGRectMake(10, 100, 100, 100);
    [self.view addSubview:imgView];
    self.transitionImageView = imgView;
    
    CALayer *imgLayer = [CALayer layer];
    imgLayer.backgroundColor = [UIColor redColor].CGColor;
    imgLayer.frame = CGRectMake(120, 100, 100, 100);
    [self.view.layer addSublayer:imgLayer];
    self.transitionImageLayer = imgLayer;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"change image" forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.center = CGPointMake(imgView.center.x, imgView.frame.origin.y + imgView.frame.size.height + 30);
    [btn addTarget:self action:@selector(changeImageClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"transition push" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y + btn.frame.size.height + 20, 0, 0);
    [btn2 sizeToFit];
    [btn2 addTarget:self action:@selector(pushClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn3 setTitle:@"custom animation" forState:UIControlStateNormal];
    btn3.frame = CGRectMake(btn.frame.origin.x, btn2.frame.origin.y + btn2.frame.size.height + 20, 0, 0);
    [btn3 sizeToFit];
    [btn3 addTarget:self action:@selector(customAnimationClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
}

- (void)changeImageClicked {
    
    // CATransition
    CATransition *transition = [CATransition animation];
    /*
        私有 type:
        rippleEffect
        cube
        pageCurl
        pageUnCurl
        suckEffect
        oglFlip
     */
    transition.type = kCATransitionFade;
    // 注意！！这里的 key 不管设置成什么，过渡动画都会把它设成 transition
    [self.transitionImageView.layer addAnimation:transition forKey:@"changeImage"];
    
    UIImage *image = self.transitionImageView.image;
    NSInteger index = [self.imageArray indexOfObject:image];
    self.transitionImageView.image = self.imageArray[(index + 1) % self.imageArray.count];
    
    
    // UIKit提供的过渡动画
//    [UIView transitionWithView:self.transitionImageView
//                      duration:1.0
//                       options:UIViewAnimationOptionTransitionCurlUp
//                    animations:^{
//                        UIImage *image = self.transitionImageView.image;
//                        NSInteger index = [self.imageArray indexOfObject:image];
//                        
//                        self.transitionImageView.image = self.imageArray[(index + 1) % self.imageArray.count];
//                    }
//                    completion:^(BOOL finished) {
//                        
//                    }];
    
    
    
    // 隐式过渡
    // 改变Layer的属性时 默认就是 kCATransitionFade 效果
    self.transitionImageLayer.contents = (id)self.transitionImageView.image.CGImage;
}

#pragma mark 对图层树的动画

- (void)pushClicked {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 2;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    ImplicitAnimationViewController *ctr = [ImplicitAnimationViewController new];
    [self.navigationController pushViewController:ctr animated:YES];
}

#pragma mark 自定义动画

- (void)customAnimationClicked {
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *coverView = [[UIImageView alloc] initWithImage:coverImage];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
                         transform = CGAffineTransformRotate(transform, M_PI);
                         coverView.transform = transform;
                         coverView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [coverView removeFromSuperview];
                     }];
}

#pragma mark - 在动画过程中取消动画

- (void)cangelAnimationSample {
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 44, 50);
    shipLayer.position = CGPointMake(150, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed: @"plane"].CGImage;
    [self.view.layer addSublayer:shipLayer];
    self.planeLayer = shipLayer;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    btn.frame = CGRectMake(shipLayer.frame.origin.x, shipLayer.frame.origin.y + shipLayer.frame.size.height + 20, 0, 0);
    [btn sizeToFit];
    [btn addTarget:self action:@selector(startClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"stop" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(btn.frame.origin.x + btn.frame.size.width + 20, btn.frame.origin.y, 0, 0);
    [btn2 sizeToFit];
    [btn2 addTarget:self action:@selector(stopClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)startClicked {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.z";
    animation.toValue = @(M_PI * 2);
    animation.duration = 2.0;
    animation.repeatCount = INFINITY;
    [self.planeLayer addAnimation:animation forKey:@"rotateAnimation"];
}

- (void)stopClicked {
    [self.planeLayer removeAnimationForKey:@"rotateAnimation"];
}

#pragma mark - Getter

- (UIView *)layerView {
    if (!_layerView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 300)];
        view.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        view.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:view];
        _layerView = view;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"change color" forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.center = CGPointMake(view.bounds.size.width / 2.0, view.bounds.size.height - 30);
        [btn addTarget:self action:@selector(changeColorClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    
    return _layerView;
}

- (UIImageView *)plate {
    if (!_plate) {
        UIImageView *plateView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plate"]];
        plateView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        [self.view addSubview:plateView];
        _plate = plateView;
    }
    return _plate;
}

- (UIImageView *)hourHand {
    if (!_hourHand) {
        UIImageView *hourView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hourHand"]];
        hourView.center = CGPointMake(self.plate.bounds.size.width / 2.0, self.plate.bounds.size.height / 2.0);
        [self.plate addSubview:hourView];
        _hourHand = hourView;
    }
    return _hourHand;
}

- (UIImageView *)minuteHand {
    if (!_minuteHand) {
        UIImageView *minuteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minuteHand"]];
        minuteView.center = CGPointMake(self.plate.bounds.size.width / 2.0, self.plate.bounds.size.height / 2.0);
        [self.plate addSubview:minuteView];
        _minuteHand = minuteView;
    }
    return _minuteHand;
}

- (UIImageView *)secondHand {
    if (!_secondHand) {
        UIImageView *secondView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"secondHand"]];
        secondView.center = CGPointMake(self.plate.bounds.size.width / 2.0, self.plate.bounds.size.height / 2.0);
        [self.plate addSubview:secondView];
        _secondHand = secondView;
    }
    return _secondHand;
}

@end
