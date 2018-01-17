//
//  TimerAnimationViewController.h
//  CoreAnimationSample
//
//  Created by fanqi on 17/6/7.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chipmunk.h"

@interface TimerAnimationViewController : UIViewController

@end

@interface Crate : UIImageView

@property (nonatomic, assign) cpBody *body;
@property (nonatomic, assign) cpShape *shape;

@end
