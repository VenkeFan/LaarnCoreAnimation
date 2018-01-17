//
//  AnimationBufferViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/6/6.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "AnimationBufferViewController.h"

@interface AnimationBufferViewController ()

@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIView *ballView;

@end

@implementation AnimationBufferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self layoutColorLayer];
    
//    [self drawCAMediaTimingFunction];
    
    [self keyframeBufferSample];
}

#pragma mark - 动画速度
#pragma mark CAMediaTimingFunction

- (void)layoutColorLayer {
    [self.view.layer addSublayer:self.colorLayer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self changePosition:[[touches anyObject] locationInView:self.view]];
    
//    [self keyframeAnimationChangeColor];
    
//    [self animate];
    
    [self customEasingAnimaten];
}

- (void)changePosition:(CGPoint)point {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    self.colorLayer.position = point;
    
    [CATransaction commit];
}

- (void)keyframeAnimationChangeColor {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor];
    // 指定函数的个数一定要等于 keyframes 数组的元素个数减一,因为它是描述每一帧之间动画速度的函数
    CAMediaTimingFunction *timing = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.timingFunctions = @[timing, timing, timing];
    
    [self.colorLayer addAnimation:animation forKey:nil];
}

#pragma mark - 自定义缓冲函数

- (void)drawCAMediaTimingFunction {
    UIView *containerView = [UIView new];
    containerView.frame = CGRectMake(0, 0, 250, 250);
    containerView.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    containerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:containerView];
    
//    {
//        // 测试 geometryFlipped 不会翻转图片的方向
//        UIImageView *; = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WechatIMG2.jpeg"]];
//        imgView.frame = CGRectMake(0, 0, 50, 50);
//        [containerView addSubview:imgView];
//    }
    
//    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.75 :1];
    CAMediaTimingFunction *function = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // 获取控制点
    float controlPoint1[2], controlPoint2[2];
    [function getControlPointAtIndex:1 values:(float *)&controlPoint1];
    [function getControlPointAtIndex:2 values:(float *)&controlPoint2];
    
    CGPoint point1 = CGPointMake(controlPoint1[0], controlPoint1[1]);
    CGPoint point2 = CGPointMake(controlPoint2[0], controlPoint2[1]);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addCurveToPoint:CGPointMake(1, 1) controlPoint1:point1 controlPoint2:point2];
    [path applyTransform:CGAffineTransformMakeScale(200, 200)]; // 放大用来显示
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 4;
    shapeLayer.path = path.CGPath;
    [containerView.layer addSublayer:shapeLayer];
    
    // 把图层上几何图形翻转，这样(0, 0)就在左下角了
    containerView.layer.geometryFlipped = YES;
}

#pragma mark 基于关键帧的缓冲

- (void)keyframeBufferSample {
    [self.view addSubview:self.ballView];
}

- (void)animate {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1;
    animation.values = @[
                         [NSValue valueWithCGPoint:CGPointMake(150, 100)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 338)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 210)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 338)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 290)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 338)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 320)],
                         [NSValue valueWithCGPoint:CGPointMake(150, 338)]
                         ];
    animation.timingFunctions = @[
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
                                  ];
    // 每个关键帧的时间偏移
    animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
    
    self.ballView.layer.position = CGPointMake(150, 338);
    [self.ballView.layer addAnimation:animation forKey:nil];
}

#pragma mark 流程自动化

- (void)customEasingAnimaten {
    //reset ball to top of screen
    self.ballView.center = CGPointMake(150, 100);
    //set up animation parameters
    NSValue *fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 100)];
    NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(150, 338)];
    CFTimeInterval duration = 1.0;
    //generate keyframes
    NSInteger numFrames = duration * 60;
    NSMutableArray *frames = [NSMutableArray array];
    for (int i = 0; i < numFrames; i++) {
        float time = 1/(float)numFrames * i;
        //apply easing
        time = bounceEaseOut(time);
        //add keyframe
        [frames addObject:[self interpolateFromValue:fromValue toValue:toValue time:time]];
    }
    //create keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.values = frames;
    
    self.ballView.layer.position = CGPointMake(150, 338);
    //apply animation
    [self.ballView.layer addAnimation:animation forKey:nil];
}

float interpolate(float from, float to, float time)
{
    return (to - from) * time + from;
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    //provide safe default implementation
    return (time < 0.5)? fromValue: toValue;
}

float quadraticEaseInOut(float t)
{
    return (t < 0.5)? (2 * t * t): (-2 * t * t) + (4 * t) - 1;
}

float bounceEaseOut(float t)
{
    if (t < 4/11.0) {
        return (121 * t * t)/16.0;
    } else if (t < 8/11.0) {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    } else if (t < 9/10.0) {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
}


#pragma mark - Getter

- (CALayer *)colorLayer {
    if (!_colorLayer) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 100, 100);
        layer.position = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
        layer.backgroundColor = [UIColor blueColor].CGColor;
        _colorLayer = layer;
    }
    return _colorLayer;
}

- (UIView *)ballView {
    if (!_ballView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor redColor];
        view.layer.frame = CGRectMake(0, 0, 50, 50);
        view.layer.position = CGPointMake(150, 100);
        view.layer.cornerRadius = 25;
        _ballView = view;
    }
    return _ballView;
}

@end
