//
//  ImplicitAnimationViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/5/31.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "ImplicitAnimationViewController.h"

@interface ImplicitAnimationViewController ()

@property (nonatomic, weak) UIView *layerView;
@property (nonatomic, weak) CALayer *colorLayer;

@end

@implementation ImplicitAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
//    layer.backgroundColor = [UIColor blueColor].CGColor;
//    
//    // 自定义动画行为（和 transitionChangeLayerColor 方法配合使用看效果）
//    CATransition *transition = [CATransition animation];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    transition.duration = 2;
//    layer.actions = @{@"backgroundColor": transition};
//    
//    [self.layerView.layer addSublayer:layer];
//    self.colorLayer = layer;
    
    
    
//    [self viewDisabledImplicitAnimationSample];
    
    [self presentationLayerSample];
}

- (void)changeColorClicked:(id)sender {
//    [self changeLayerColor];

//    [self changeViewColor];
    
    [self transitionChangeLayerColor];
}

/// 用事务改变CALayer的颜色
- (void)changeLayerColor {
    [CATransaction begin];
//    [CATransaction setDisableActions:YES];   // 禁用隐式动画
    
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setCompletionBlock:^{
        CGAffineTransform transform = self.colorLayer.affineTransform;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.colorLayer.affineTransform = transform;
    }];
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    [CATransaction commit];
}

/// 普通改变CALayer的颜色（和自定义动画行为配合使用看效果）
- (void)transitionChangeLayerColor {
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
}

/// 用事务改变UIView的颜色
- (void)changeViewColor {
    [CATransaction begin];
    
    [CATransaction setAnimationDuration:1.0];
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.layerView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    [CATransaction commit];
}

/// UIView 禁用隐式动画测试
- (void)viewDisabledImplicitAnimationSample {
    NSLog(@"Outside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    
    [UIView beginAnimations:nil context:nil];
    NSLog(@"Inside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    [UIView commitAnimations];
}

#pragma mark - 呈现与模型
/// 呈现与模型
- (void)presentationLayerSample {
    self.layerView.hidden = YES;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    layer.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    self.colorLayer = layer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    // 判断是否是呈现图层被点击 （把 self.colorLayer.presentationLayer 换成 self.colorLayer 看看效果！）
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
        
        NSLog(@"presentationLayer: %.2f -- %.2f \n layer: %.2f -- %.2f",
              self.colorLayer.presentationLayer.position.x,
              self.colorLayer.presentationLayer.position.y,
              self.colorLayer.position.x,
              self.colorLayer.position.y);
    } else {
        //otherwise (slowly) move the layer to new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
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

@end
