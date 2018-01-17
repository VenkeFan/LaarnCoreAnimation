//
//  ViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/5/12.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "ViewController.h"

#define kCenterPoint    CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *solidBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self anchorPointFunc];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - AnchorPoint

- (void)anchorPointFunc {
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.bounds = CGRectMake(0, 0, 100, 140);
    [self.view.layer addSublayer:layer];
    
    NSLog(@"position = (%.1f-%.1f) / anchorPoint = (%.1f-%.1f) / frame = (%.1f-%.1f)",
          layer.position.x, layer.position.y,
          layer.anchorPoint.x, layer.anchorPoint.y,
          layer.frame.origin.x, layer.frame.origin.y);
}

- (void)anchorPointFuncTouched {
    CALayer *layer = self.view.layer.sublayers.lastObject;
    
    // position 不变，frame 随之变化
    //    CGPoint anchorPoint = layer.anchorPoint;
    //    anchorPoint.x -= 0.1;
    //    anchorPoint.y -= 0.1;
    //    layer.anchorPoint = anchorPoint;
    
    
    // anchorPoint 不变，frame 随之变化
    CGPoint position = layer.position;
    position.x += 10;
    position.y += 10;
    layer.position = position;
    
    NSLog(@"position = (%.1f-%.1f) / anchorPoint = (%.1f-%.1f) / frame = (%.1f-%.1f)",
          layer.position.x, layer.position.y,
          layer.anchorPoint.x, layer.anchorPoint.y,
          layer.frame.origin.x, layer.frame.origin.y);
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self anchorPointFuncTouched];
}


@end
