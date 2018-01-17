//
//  Transform3DViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/5/16.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "Transform3DViewController.h"

@interface Transform3DViewController ()

@property (weak, nonatomic) IBOutlet UIView *outerView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end

@implementation Transform3DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //    CALayer *layer = self.view.layer.sublayers.lastObject;
    ////    layer.doubleSided = NO; // 设置背面是否绘制
    //
    //    CATransform3D transform = CATransform3DIdentity;
    //    transform.m34 = -1.0 / 500; // 设置透视投影
    //    layer.transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    
    
    
    // innerView是outerView的子图层，view1和view2是平级关系
    CATransform3D outer = CATransform3DIdentity;
    outer.m34 = -1.0 / 500; // CATransform3D 的 m34 属性，用来做透视效果
    self.outerView.layer.transform = CATransform3DRotate(outer, M_PI_4, 0, 1, 0);
    self.view1.layer.transform = CATransform3DRotate(outer, M_PI_4, 0, 1, 0);
    
    //    CATransform3D inner = CATransform3DIdentity;
    //    inner.m34 = -1.0 / 500;
    //    self.innerView.layer.transform = CATransform3DRotate(inner, -M_PI_4, 0, 1, 0);
    //    self.view2.layer.transform = CATransform3DRotate(inner, -M_PI_4, 0, 1, 0);Transform3DViewController
}

@end
