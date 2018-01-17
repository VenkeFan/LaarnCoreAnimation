//
//  EfficientDrawViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/6/8.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "EfficientDrawViewController.h"

#import "GraphicsDrawingView.h"
#import "ShapeLayerDrawingView.h"
#import "DirtyRectDrawingView.h"

@interface EfficientDrawViewController ()

@end

@implementation EfficientDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self graphicsDrawingSample];
    
//    [self shapeLayerDrawingSample];
    
//    [self dirtyRectDrawingSample];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 矢量图形

- (void)graphicsDrawingSample {
    GraphicsDrawingView *view = [[GraphicsDrawingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}

- (void)shapeLayerDrawingSample {
    ShapeLayerDrawingView *view = [[ShapeLayerDrawingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}

#pragma mark - 脏矩形

- (void)dirtyRectDrawingSample {
    DirtyRectDrawingView *view = [[DirtyRectDrawingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}

@end
