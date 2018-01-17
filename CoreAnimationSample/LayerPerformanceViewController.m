//
//  LayerPerformanceViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/6/9.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "LayerPerformanceViewController.h"

#define ROW 100
#define COLUMN 100
#define DEPTH 10
#define SIZE 100
#define SPACING 150
#define CAMERA_DISTANCE 500
#define PERSPECTIVE(z) (float)CAMERA_DISTANCE/(z + CAMERA_DISTANCE)

@interface LayerPerformanceViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation LayerPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake((ROW - 1) * SPACING, (COLUMN - 1) * SPACING);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / CAMERA_DISTANCE;
    self.scrollView.layer.sublayerTransform = transform;
    
//    for (int i = DEPTH - 1; i >= 0; i--) {
//        for (int j = 0; j < ROW; j++) {
//            for (int k = 0; k < COLUMN; k++) {
//                CALayer *layer = [CALayer layer];
//                layer.frame = CGRectMake(0, 0, SIZE, SIZE);
//                layer.position = CGPointMake(j * SPACING, k * SPACING);
//                layer.zPosition = -i * SPACING;
//                layer.backgroundColor = [UIColor colorWithWhite:1 - i * (1.0 / DEPTH) alpha:1].CGColor;
//                [self.scrollView.layer addSublayer:layer];
//            }
//        }
//    }
}

#pragma mark - 减少图层数量

- (void)viewDidLayoutSubviews {
    [self updateLayers];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateLayers];
}

- (void)updateLayers {
    
//    CGRect bounds = self.scrollView.bounds;
//    bounds.origin = self.scrollView.contentOffset;
//    bounds = CGRectInset(bounds, -SIZE/2, -SIZE/2);
//    
//    NSMutableArray *visibleLayers = [NSMutableArray array];
//    for (int i = DEPTH - 1; i >= 0; i--) {
//        CGRect adjusted = bounds;
//        adjusted.size.width /= PERSPECTIVE(i * SPACING);
//        adjusted.size.height /= PERSPECTIVE(i * SPACING);
//        adjusted.origin.x -= (adjusted.size.width - bounds.size.width) / 2;
//        adjusted.origin.y -= (adjusted.size.height - bounds.size.height) / 2;
//        for (int j = 0; j < ROW; j++) {
//            if (j * SPACING < bounds.origin.x || j * SPACING > bounds.origin.x + bounds.size.width) {
//                continue;
//            }
//            for (int k = 0; k < COLUMN; k++) {
//                if (k * SPACING < bounds.origin.y || k * SPACING > bounds.origin.y + bounds.size.height) {
//                    continue;
//                }
//                
//                CALayer *layer = [CALayer layer];
//                layer.frame = CGRectMake(0, 0, SIZE, SIZE);
//                layer.position = CGPointMake(j * SPACING, k * SPACING);
//                layer.zPosition = -i * SPACING;
//                layer.backgroundColor = [UIColor colorWithWhite:1 - i * (1.0 / DEPTH) alpha:1].CGColor;
//                [visibleLayers addObject:layer];
//            }
//        }
//    }
//    
//    self.scrollView.layer.sublayers = visibleLayers;
    
    
    
    
    //calculate clipping bounds
    CGRect bounds = self.scrollView.bounds;
    bounds.origin = self.scrollView.contentOffset;
    bounds = CGRectInset(bounds, -SIZE/2, -SIZE/2);
    //create layers
    NSMutableArray *visibleLayers = [NSMutableArray array];
    for (int z = DEPTH - 1; z >= 0; z--)
    {
        //increase bounds size to compensate for perspective
        CGRect adjusted = bounds;
        adjusted.size.width /= PERSPECTIVE(z*SPACING);
        adjusted.size.height /= PERSPECTIVE(z*SPACING);
        adjusted.origin.x -= (adjusted.size.width - bounds.size.width) / 2;
        adjusted.origin.y -= (adjusted.size.height - bounds.size.height) / 2;
        for (int y = 0; y < COLUMN; y++) {
            //check if vertically outside visible rect
            if (y*SPACING < adjusted.origin.y || y*SPACING >= adjusted.origin.y + adjusted.size.height)
            {
                continue;
            }
            for (int x = 0; x < ROW; x++) {
                //check if horizontally outside visible rect
                if (x*SPACING < adjusted.origin.x ||x*SPACING >= adjusted.origin.x + adjusted.size.width)
                {
                    continue;
                }
                
                //create layer
                CALayer *layer = [CALayer layer];
                layer.frame = CGRectMake(0, 0, SIZE, SIZE);
                layer.position = CGPointMake(x*SPACING, y*SPACING);
                layer.zPosition = -z*SPACING;
                //set background color
                layer.backgroundColor = [UIColor colorWithWhite:1-z*(1.0/DEPTH) alpha:1].CGColor;
                //attach to scroll view
                [visibleLayers addObject:layer];
            }
        }
    }
    //update layers
    self.scrollView.layer.sublayers = visibleLayers;
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.delegate = self;
        scrollView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

@end
