//
//  ShapeLayerDrawingView.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/6/8.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "ShapeLayerDrawingView.h"

@interface ShapeLayerDrawingView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation ShapeLayerDrawingView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.path = [[UIBezierPath alloc] init];
        
        CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = 5;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.path addLineToPoint:point];
    
    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
}

@end
