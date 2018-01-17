//
//  ReflectionView.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/5/25.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "ReflectionView.h"

@implementation ReflectionView

+ (Class)layerClass {
    return [CAReplicatorLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
    layer.instanceCount = 2;
    
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = self.bounds.size.height + 2;
    
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 1, -1, 0);    // 为什么用这句实现的效果和下面的旋转的效果一样？这不是缩放吗？
//    transform = CATransform3DRotate(transform, M_PI, 1, 0, 0);
    
    layer.instanceTransform = transform;
    
    layer.instanceAlphaOffset = -0.6;
}

@end
