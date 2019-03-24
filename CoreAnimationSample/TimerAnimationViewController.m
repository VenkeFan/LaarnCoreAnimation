//
//  TimerAnimationViewController.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/6/7.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "TimerAnimationViewController.h"
#import "AnimationBufferViewController.h"

@interface TimerAnimationViewController () <UIAccelerometerDelegate>

@property (nonatomic, strong) UIView *ballView;

// NSTimer
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval timeOffset;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;

// CADisplayLink
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval lastStep;

// chipmunk
@property (nonatomic, assign) cpSpace *space;

@end

@implementation TimerAnimationViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
    [_displayLink invalidate];
    _displayLink = nil;
    
    cpSpaceFree(_space);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height + 1);
        [self.view addSubview:scrollView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"start animation" forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.center = CGPointMake(self.view.bounds.size.width / 2.0, 120);
        [btn addTarget:self action:@selector(animateClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    
    
//    [self timerAnimationSample];
    
    [self displayLinkAnimationSample];
    
//    [self chipmunkSample];
    
//    [self chipmunkInteractionSample];
}

- (void)animateClicked {
//    [self timerAnimate];
    
    [self displayLinkAnimate];
    
//    [self chipmunkAnimate];
}

#pragma mark - 定时帧
#pragma mark NSTimer

- (void)timerAnimationSample {
    [self.view addSubview:self.ballView];
    
    [self timerAnimate];
}

- (void)timerAnimate {
    self.duration = 4.0;
    self.timeOffset = 0.0;
    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 100)];
    self.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 338)];
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(timerStep:) userInfo:nil repeats:YES];
}

- (void)timerStep:(NSTimer *)step {
    //update time offset
    self.timeOffset = MIN(self.timeOffset + 1/60.0, self.duration);
    //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration;
    //apply easing
    time = bounceEaseOut(time);
    //interpolate position
    id position = [self interpolateFromValue:self.fromValue
                                     toValue:self.toValue
                                        time:time];
    //move ball view to new position
    self.ballView.center = [position CGPointValue];
    //stop the timer if we've reached the end of the animation
    if (self.timeOffset >= self.duration) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (id)interpolateFromValue:(id)fromValue toValue:(id)toValue time:(float)time
{
    if ([fromValue isKindOfClass:[NSValue class]]) {
        //get type
        const char *type = [fromValue objCType];
        if (strcmp(type, @encode(CGPoint)) == 0) {
            CGPoint from = [fromValue CGPointValue];
            CGPoint to = [toValue CGPointValue];
            CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
            return [NSValue valueWithCGPoint:result];
        }
    }
    //provide safe default implementation
    return (time < 0.5)? fromValue: toValue;
}

#pragma mark -  CADisplayLink

- (void)displayLinkAnimationSample {
    [self.view addSubview:self.ballView];
    
    [self displayLinkAnimate];
}

- (void)displayLinkAnimate {
    self.duration = 4.0;
    self.timeOffset = 0.0;
    self.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 100)];
    self.toValue = [NSValue valueWithCGPoint:CGPointMake(150, 338)];
    
    [self.displayLink invalidate];
    self.lastStep = CACurrentMediaTime();
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkSetp:)];
    // 使用 NSRunLoopCommonModes 的话，要小心，因为如果动画在一个高帧率情况下运行,会发现一些别的类似于定时器的任务或者类似于滑动的其他iOS动画会暂停,直到动画结束
    // 暂时未搞懂上面这句话！！！！！因为经测试没有影响 UIScrollView 的滑动。可能是因为没在一个高帧率情况下运行！！！！！
//    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    //
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
}

- (void)displayLinkSetp:(CADisplayLink *)displayLink {
    //calculate time delta
    CFTimeInterval thisStep = CACurrentMediaTime();
    CFTimeInterval stepDuration = thisStep - self.lastStep;
    self.lastStep = thisStep;
    
    // update time offset
    self.timeOffset = MIN(self.timeOffset + stepDuration, self.duration);
    
    //get normalized time offset (in range 0 - 1)
    float time = self.timeOffset / self.duration;
    
    //apply easing
    time = bounceEaseOut(time);
    
    //interpolate position
    id position = [self interpolateFromValue:self.fromValue
                                     toValue:self.toValue
                                        time:time];
    
    //move ball view to new position
    self.ballView.center = [position CGPointValue];
    //stop the timer if we've reached the end of the animation
    if (self.timeOffset >= self.duration) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

#pragma mark - 物理模拟
#pragma mark Chipmunk

#define GRAVITY 1000

- (void)chipmunkSample {
    //invert view coordinate system to match physics
    self.view.layer.geometryFlipped = YES;
    
    //set up physics space
    self.space = cpSpaceNew();
    cpSpaceSetGravity(self.space, cpv(0, -GRAVITY));
    
    //add wall around edge of view
    [self addWallShapeWithStart:cpv(0, 100) end:cpv(self.view.bounds.size.width, 100)];
    
    //add a crate
    Crate *crate = [[Crate alloc] initWithFrame:CGRectMake(100, self.view.bounds.size.height - 170, 100, 100)];
    [self.view addSubview:crate];
    cpSpaceAddBody(self.space, crate.body);
    cpSpaceAddShape(self.space, crate.shape);
    
    // start timer
//    [self chipmunkAnimate];
}

- (void)chipmunkAnimate {
    self.lastStep = CACurrentMediaTime();
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(chipmunkStep:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)chipmunkStep:(CADisplayLink *)displayLink {
//    //calculate time delta
//    CFTimeInterval thisStep = CACurrentMediaTime();
//    CFTimeInterval stepDuration = thisStep - self.lastStep;
//    self.lastStep = thisStep;
//    
//    //update physics
//    cpSpaceStep(self.space, stepDuration);
//    
//    //update all the shapes
//    cpSpaceEachShape(self.space, &updateShape, NULL);
    
    
    /// 模拟实践以及固定的时间步长
    #define SIMULATION_STEP (1/120.0)
    
    //calculate frame step duration
    CFTimeInterval frameTime = CACurrentMediaTime();
    
    //update simulation
    while (self.lastStep < frameTime) {
        cpSpaceStep(self.space, SIMULATION_STEP);
        self.lastStep += SIMULATION_STEP;
    }
    
    //update all the shapes cpSpaceEachShape(self.space, &updateShape, NULL);
    cpSpaceEachShape(self.space, &updateShape, NULL);
}

void updateShape(cpShape *shape, void *unused)
{
    //get the crate object associated with the shape
    Crate *crate = (__bridge Crate *)shape->data;
    
    //update crate view position and angle to match physics shape
    cpBody *body = shape->body;
    crate.center = cpBodyGetPos(body);
    crate.transform = CGAffineTransformMakeRotation(cpBodyGetAngle(body));
    
//    NSLog(@"crate centerY: %f", crate.center.y);
}

#pragma mark 添加用户交互

- (void)chipmunkInteractionSample {
    //invert view coordinate system to match physics
    self.view.layer.geometryFlipped = YES;
    
    //set up physics space
    self.space = cpSpaceNew();
    cpSpaceSetGravity(self.space, cpv(0, -GRAVITY));
    
    //add wall around edge of view
    [self addWallShapeWithStart:cpv(0, 0) end:cpv(300, 0)];
    [self addWallShapeWithStart:cpv(300, 0) end:cpv(300, 300)];
    [self addWallShapeWithStart:cpv(300, 300) end:cpv(0, 300)];
    [self addWallShapeWithStart:cpv(0, 300) end:cpv(0, 0)];
    
    //add a crates
    [self addCrateWithFrame:CGRectMake(0, 0, 32, 32)];
    [self addCrateWithFrame:CGRectMake(32, 0, 32, 32)];
    [self addCrateWithFrame:CGRectMake(64, 0, 64, 64)];
    [self addCrateWithFrame:CGRectMake(128, 0, 32, 32)];
    [self addCrateWithFrame:CGRectMake(0, 32, 64, 64)];
    
    //start the timer
    self.lastStep = CACurrentMediaTime();
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(chipmunkStep:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    //update gravity using accelerometer
    [UIAccelerometer sharedAccelerometer].delegate = self;
    [UIAccelerometer sharedAccelerometer].updateInterval = 1/60.0;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    //update gravity
    cpSpaceSetGravity(self.space, cpv(acceleration.x * GRAVITY, acceleration.y * GRAVITY));
}

- (void)addCrateWithFrame:(CGRect)frame {
    Crate *crate = [[Crate alloc] initWithFrame:frame];
    [self.view addSubview:crate];
    cpSpaceAddBody(self.space, crate.body);
    cpSpaceAddShape(self.space, crate.shape);
}

- (void)addWallShapeWithStart:(cpVect)start end:(cpVect)end {
    cpShape *wall = cpSegmentShapeNew(self.space->staticBody, start, end, 1);
    cpShapeSetCollisionType(wall, 2);
    cpShapeSetFriction(wall, 0.5);
    cpShapeSetElasticity(wall, 0.8);
    cpSpaceAddStaticShape(self.space, wall);
    
    
    // 画线区分下墙的边界
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, start.x, start.y);
    CGPathAddLineToPoint(path, NULL, end.x, end.y);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 2;
    shapeLayer.path = path;
    [self.view.layer addSublayer:shapeLayer];
    
    CFRelease(path);
}

#pragma mark - Getter

- (UIView *)ballView {
    if (!_ballView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ball.jpeg"]];
        view.layer.frame = CGRectMake(0, 0, 50, 50);
        view.layer.position = CGPointMake(150, 100);
        _ballView = view;
    }
    return _ballView;
}

@end



@implementation Crate

#define MASS 100

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"crate.jpeg"];
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        self.body = cpBodyNew(MASS, cpMomentForBox(MASS, frame.size.width, frame.size.height));
        //create the shape
        cpVect corners[] = {
            cpv(0, 0),
            cpv(0, frame.size.height),
            cpv(frame.size.width, frame.size.height),
            cpv(frame.size.width, 0),
        };
        self.shape = cpPolyShapeNew(self.body, 4, corners, cpv(-frame.size.width/2, -frame.size.height/2));
        
        //set shape friction & elasticity
        cpShapeSetFriction(self.shape, 0.5);
        cpShapeSetElasticity(self.shape, 0.8);
        
        //link the crate to the shape
        //so we can refer to crate from callback later on
        self.shape->data = (__bridge void *)self;
        
        //set the body position to match view
        cpBodySetPos(self.body, cpv(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2));
    }
    return self;
}

- (void)dealloc {
    cpShapeFree(_shape);
    cpBodyFree(_body);
}

@end
