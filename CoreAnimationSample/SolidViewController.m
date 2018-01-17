//
//  SolidViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/5/16.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "SolidViewController.h"
#import <GLKit/GLKit.h>

#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT   0.5

@interface SolidViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *faces;


@end

@implementation SolidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500;
    self.containerView.layer.sublayerTransform = perspective;
    
    // add cube face 1
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeTranslation(0, 0, 50);
    [self addFace:0 withTransform:transform];
    
    // add cube face 2
    transform = CATransform3DMakeTranslation(50, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    
    // face 3
    transform = CATransform3DMakeTranslation(0, -50, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    
    // face 4
    transform = CATransform3DMakeTranslation(0, 50, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    // face 5
    transform = CATransform3DMakeTranslation(-50, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    
    // face 6
    transform = CATransform3DMakeTranslation(0, 0, -50);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
}


- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform {
    UIView *face = self.faces[index];
    [self.containerView addSubview:face];
    
    CGSize containerSize = self.containerView.bounds.size;
    face.center = CGPointMake(containerSize.width * 0.5, containerSize.height * 0.5);
    
    face.layer.transform = transform;
    
    [self addLightingToFace:face.layer];
}

/// 光亮和阴影（怎么无效？待查）
- (void)addLightingToFace:(CALayer *)face {
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    
    // convert the face transform to matrix
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    
    // get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    
    // get dot product with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    
    // set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor =  color.CGColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CATransform3D perspective = CATransform3DIdentity;
    
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
//    self.containerView.layer.transform = perspective;
    self.containerView.layer.sublayerTransform = perspective;
}

@end
