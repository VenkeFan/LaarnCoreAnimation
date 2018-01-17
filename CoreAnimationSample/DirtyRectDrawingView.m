//
//  DirtyRectDrawingView.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/6/8.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "DirtyRectDrawingView.h"

#define BRUSH_SIZE 30

@interface DirtyRectDrawingView ()

@property (nonatomic, strong) NSMutableArray *strokes;
@property (nonatomic, strong) UIImage *texture;

@end

@implementation DirtyRectDrawingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    [self addBrushStrokeAtPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    [self addBrushStrokeAtPoint:point];
}

- (void)addBrushStrokeAtPoint:(CGPoint)point {
    [self.strokes addObject:[NSValue valueWithCGPoint:point]];
    
    // 脏矩形大法
    [self setNeedsDisplayInRect:[self brushRectForPoint:point]];
}

- (CGRect)brushRectForPoint:(CGPoint)point {
    return CGRectMake(point.x - BRUSH_SIZE / 2.0, point.y - BRUSH_SIZE / 2.0, BRUSH_SIZE, BRUSH_SIZE);
}

- (void)drawRect:(CGRect)rect {
    for (NSValue *value in self.strokes) {
        CGPoint point = [value CGPointValue];
        CGRect brushRect = [self brushRectForPoint:point];
        
        // 脏矩形大法
        if (CGRectIntersectsRect(rect, brushRect)) {
            [self.texture drawInRect:brushRect];
        }
    }
}

#pragma mark - Getter

- (NSMutableArray *)strokes {
    if (!_strokes) {
        _strokes = [NSMutableArray array];
    }
    return _strokes;
}

- (UIImage *)texture {
    if (!_texture) {
        _texture = [UIImage imageNamed:@"brush"];
    }
    return _texture;
}

@end
