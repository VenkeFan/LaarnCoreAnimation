//
//  DedicatedLayerViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/5/16.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "DedicatedLayerViewController.h"
#import <CoreText/CoreText.h>

#import "LayerLabel.h"
#import "ReflectionView.h"


#define kCenterPoint    CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5);

@interface DedicatedLayerViewController () <CALayerDelegate>

@end

@implementation DedicatedLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // CAShapeLayer
//    [self drawMatchstickMen];
//    [self drawAngle];
    
    // CATextLayer
//    [self textLayerSample];
    [self myLayerLabelSample];
    
    // CATransformLayer
//    [self transformLayerSample];
    
    // CAGradientLayer
//    [self gradientLayerSample];
    
    // CAReplicatorLayer
//    [self replicatorLayerSample];
//    [self reflectionSample];
//    [self transform3DTest];
    
    // CATiledLayer
//    [self tileCutter];
//    [self tiledLayerSample];
    
    // CAEmitterLayer
//    [self emitterLayerSample];
}

#pragma mark - CAShapeLayer

/// 画火柴人
- (void)drawMatchstickMen {
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(175, 100)];
    
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    [self setShapeLayer:path.CGPath];
    
    
    {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(175, 100, 6, 6)];
        tempView.backgroundColor = [UIColor blueColor];
        tempView.layer.cornerRadius = 3;
        tempView.layer.masksToBounds = YES;
        [self.view addSubview:tempView];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position";
        animation.path = path.CGPath;
        animation.duration = 20;
        [tempView.layer addAnimation:animation forKey:nil];
    }
}

/// 画角
- (void)drawAngle {
    CGRect rect = CGRectMake(50, 350, 100, 100);
    CGSize radii = CGSizeMake(20, 20);
    UIRectCorner coner = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:coner cornerRadii:radii];
    
    [self setShapeLayer:path.CGPath];
}

- (void)setShapeLayer:(CGPathRef)path {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path;
    
    [self.view.layer addSublayer:shapeLayer];
}

#pragma mark - CATextLayer

- (void)textLayerSample {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(10, 74, 200, 350);
    textLayer.borderWidth = 1;
    textLayer.contentsScale = [UIScreen mainScreen].scale; // 设置为屏幕分辨率，避免像素化
    [self.view.layer addSublayer:textLayer];
    
    // set text attributes
    textLayer.foregroundColor = [UIColor redColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    // set font
    UIFont *font = [UIFont systemFontOfSize:15];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    NSString *text = @"Edward III (1312–1377), King of England from 1327 until his death,"
    "restored royal authority after the unorthodox and disastrous reign of his father, Edward II."
    "Edward III transformed the Kingdom of England into one of the most formidable military powers in Europe."
    "His reign of fifty years, the second longest in medieval ";
    
    // rich text
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr setAttributes:@{NSForegroundColorAttributeName: [UIColor blueColor],
                             NSFontAttributeName: [UIFont systemFontOfSize:15]}
                     range:NSMakeRange(0, attrStr.length)];
    
    [attrStr setAttributes:@{(__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor greenColor].CGColor,
                             (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleDouble),
                             (__bridge id)kCTFontAttributeName: [UIFont systemFontOfSize:30 weight:UIFontWeightBold]}
                     range:NSMakeRange(0, 6)];
    
    
    textLayer.string = attrStr;
}

- (void)myLayerLabelSample {
    LayerLabel *myLab = [[LayerLabel alloc] initWithFrame:CGRectMake(20, 100, 200, 200)];
    myLab.text = @"MyLayerLabel Text";
    myLab.textColor = [UIColor greenColor];
    myLab.font = [UIFont systemFontOfSize:70 weight:UIFontWeightBold];
    [self.view addSubview:myLab];
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 350, 200, 200)];
    lab.text = @"UILabel Text";
    lab.textColor = [UIColor greenColor];
    lab.font = [UIFont systemFontOfSize:70 weight:UIFontWeightBold];
    [self.view addSubview:lab];
}

#pragma mark - CATransformLayer

- (void)transformLayerSample {
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500;
    self.view.layer.sublayerTransform = pt;
    
    // cube 1
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, 0, -100, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.view.layer addSublayer:cube1];
    
    // cube 2
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 0, 100, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.view.layer addSublayer:cube2];
}

- (CALayer *)cubeWithTransform:(CATransform3D)transform {
    CATransformLayer *cube = [CATransformLayer layer];
    
    CATransform3D ct = CATransform3DIdentity;
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // add cube face 2
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // face 3
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // face 4
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // face 5
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    // face 6
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    cube.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
    cube.transform = transform;
    
    return cube;
}

- (CALayer *)faceWithTransform:(CATransform3D)transform {
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    
    CGFloat red = rand() / (double)INT_MAX;
    CGFloat green = rand() / (double)INT_MAX;
    CGFloat blue = rand() / (double)INT_MAX;
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    face.transform = transform;
    
    return face;
}

#pragma mark - CAGradientLayer

- (void)gradientLayerSample {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, 100, 100);
    layer.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
    [self.view.layer addSublayer:layer];
    
    layer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
    // locations 属性是一个浮点数值的数组(以 NSNumber 包装)。这些浮点数定义了属性中每个不同颜色的位置,同样的,也是以单位坐标系进行标定。0.0代表着渐变的开始,1.0代表着结束。
    // locations 的数组大小和 colors 数组大小一定要相同,否则将会得到一个空白的渐变
    layer.locations = @[@(0.0), @(0.25)];
    
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 1);
}

#pragma mark - CAReplicatorLayer 

- (void)replicatorLayerSample {
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.backgroundColor = [UIColor greenColor].CGColor;
    replicator.frame = CGRectMake(100, 100, 50, 100);
    replicator.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
    [self.view.layer addSublayer:replicator];
    
    replicator.instanceCount = 10;
    
    CATransform3D transform = CATransform3DIdentity;
//    transform = CATransform3DTranslate(transform, 0, 50, 0);
    transform = CATransform3DRotate(transform, M_PI / 5, 0, 0, 1); // 旋转是绕着哪个点的？？？？？？？？？改变replicator的宽高试试
//    transform = CATransform3DTranslate(transform, 0, -50, 0);

    //一定要设置CAReplicatorLayer的frame，因为instanceTransform是以 replicator.frame 的 center 为基准的
    replicator.instanceTransform = transform;
    
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    
    CALayer *layer = [self replicatorSubLayer];
    layer.frame = CGRectMake(100, 100, 100, 100);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicator addSublayer:layer];
}

- (CALayer *)replicatorSubLayer {
    CALayer *layer = [CALayer layer];
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(100, 100)];
    [path addLineToPoint:CGPointMake(-100, -100)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    [layer addSublayer:shapeLayer];
    
    return layer;
}

- (void)reflectionSample {
    ReflectionView *view = [[ReflectionView alloc] initWithFrame: CGRectMake(100, 100, 150, 150)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIImageView *subView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WechatIMG2.jpeg"]];
    subView.frame = view.bounds;
    subView.backgroundColor = [UIColor blueColor];
    [view addSubview:subView];
}

#pragma mark - CAScrollLayer


#pragma mark - CATiledLayer

- (void)tileCutter {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dirPath = [cachePath stringByAppendingPathComponent:@"CATiledLayer"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // tile size
    CGFloat tileSize = 256.0;
    
    // load image
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"timg_2048" ofType:@"jpeg"];
    UIImage *originalImage = [[UIImage alloc] initWithContentsOfFile:filePath];
    CGSize size = originalImage.size;
    
    NSInteger rows = ceil(size.height / tileSize);
    NSInteger columns = ceil(size.width / tileSize);
    
    CGImageRef imgRef = originalImage.CGImage;
    
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < columns; j++) {
            CGRect tileRect = CGRectMake(j * tileSize, i * tileSize, tileSize, tileSize);
            CGImageRef tileImageRef = CGImageCreateWithImageInRect(imgRef, tileRect);
            UIImage *tileImage = [UIImage imageWithCGImage:tileImageRef];
            
            NSString *fileName = [NSString stringWithFormat:@"%02d_%02d.jpg", j, i];
            NSData *tileImageData = UIImageJPEGRepresentation(tileImage, 1.0);
            [tileImageData writeToFile:[dirPath stringByAppendingPathComponent:fileName] atomically:NO];
            
            CFRelease(tileImageRef);
        }
    }
}

- (void)tiledLayerSample {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 256, 256)];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.layer.borderWidth = 1;
    scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    scrollView.center = kCenterPoint;
    [self.view addSubview:scrollView];
    
    
    CATiledLayer *layer = [CATiledLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;  // 屏幕的原生分辨率（注释这行看看效果对比）
    layer.frame = CGRectMake(0, 0, 2048, 2048);
    layer.delegate = self;
    [scrollView.layer addSublayer:layer];
    scrollView.contentSize = layer.frame.size;
    
    [layer setNeedsDisplay];
}

- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx {
    // 在多个线程中为每个小块同时调用 -drawLayer:inContext: 方法
    NSLog(@"%@", [NSThread currentThread]);
    
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    CGFloat scale = [UIScreen mainScreen].scale;    // 屏幕的原生分辨率
    NSInteger x = floor(bounds.origin.x / layer.tileSize.width * scale);
    NSInteger y = floor(bounds.origin.y / layer.tileSize.height * scale);
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dirPath = [cachePath stringByAppendingPathComponent:@"CATiledLayer"];
    NSString *imageName = [NSString stringWithFormat: @"%02d_%02d.jpg", (int)x, (int)y];
    NSString *imagePath = [dirPath stringByAppendingPathComponent:imageName];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:imagePath];
    
    UIGraphicsPushContext(ctx);
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}

#pragma mark - CAEmitterLayer

- (void)emitterLayerSample {
    CAEmitterLayer *layer = [CAEmitterLayer layer];
    layer.frame = CGRectMake(0, 0, 200, 200);
    layer.position = kCenterPoint;
    [self.view.layer addSublayer:layer];
    
    layer.renderMode = kCAEmitterLayerAdditive;
    layer.emitterPosition = CGPointMake(layer.frame.size.width / 2.0, layer.frame.size.height / 2.0);
    
    CAEmitterCell *cell = [CAEmitterCell new];
    cell.contents = (id)[UIImage imageNamed:@"spark"].CGImage;
    cell.birthRate = 150; // 每秒生成的粒子数
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor; // 混合图片内容颜色的混合色
    cell.alphaSpeed = -0.4; // 透明度每过一秒就是减少0.4
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI * 2;  // 360度任意位置反射出来
    
    layer.emitterCells = @[cell];
}

#pragma mark - CAEAGLLayer


#pragma mark - AVPlayerLayer


#pragma mark - Touches

- (void)transform3DTest {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 150, 150);
    layer.contents = (id)[UIImage imageNamed:@"WechatIMG2.jpeg"].CGImage;
    [self.view.layer addSublayer:layer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CALayer *layer = self.view.layer.sublayers.lastObject;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500;
    
//    transform = CATransform3DTranslate(transform, 0, 0, 100);
    
    // 以下两句的实现效果一样，不过为什么？他们的矩阵乘法的值怎么会一样？怎么乘的？？？？？
    transform = CATransform3DScale(transform, 1, -1, 1);
//    transform = CATransform3DRotate(transform, M_PI, 1, 0, 0);
    
    layer.transform = transform;
}


@end
