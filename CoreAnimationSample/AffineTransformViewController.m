//
//  AffineTransformViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/5/25.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "AffineTransformViewController.h"

@interface AffineTransformViewController ()

@property (nonatomic, weak) CALayer *layer;

@end

@implementation AffineTransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(10, 100, 50, 50);
    layer.backgroundColor = [UIColor redColor].CGColor;
    self.layer = layer;
    [self.view.layer addSublayer:layer];
    
    
    {
        int i = 0;
    
        NSMutableArray *mArray = [NSMutableArray array];
        [mArray addObject:@"a"];
        NSLog(@"调用前：%zd -- %p -- %p", i, mArray, &mArray);
        
        
        [self test:i mutArray:mArray];
        NSLog(@"调用后：%zd -- %p -- %p", i, mArray, &mArray);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)test:(int)i mutArray:(NSMutableArray *)mutArray {
    i = 2;
    [mutArray addObject:@"b"];
    NSLog(@"调用中：%zd -- %p -- %p", i, mutArray, &mutArray);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    transform = CGAffineTransformRotate(transform, M_PI / 6);
    transform = CGAffineTransformTranslate(transform, 200, 0);
    
    self.layer.affineTransform = transform;
}

@end
