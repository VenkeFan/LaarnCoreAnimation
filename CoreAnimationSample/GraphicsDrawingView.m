//
//  GraphicsDrawingView.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/6/8.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "GraphicsDrawingView.h"

@interface GraphicsDrawingView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation GraphicsDrawingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.path = [[UIBezierPath alloc] init];
        self.path.lineJoinStyle = kCGLineJoinRound;
        self.path.lineCapStyle = kCGLineCapRound;
        self.path.lineWidth = 5;
        
        // 测试 setNeedsDisplay 方法
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [btn setTitle:@"显示" forState:UIControlStateNormal];
//        [btn sizeToFit];
//        btn.center = CGPointMake(50, 80);
//        [btn addTarget:self action:@selector(displayBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btn];
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
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    // UIKit 绘制
//    [[UIColor redColor] setStroke];
//    [[UIColor clearColor] setFill];
    
//    [self.path stroke];
    
    
    // Core Graphics 绘制
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(context, 5);
    
    CGContextAddPath(context, self.path.CGPath);
    CGContextStrokePath(context);
}

- (void)displayBtnClicked {
    [self setNeedsDisplay];
}

@end
