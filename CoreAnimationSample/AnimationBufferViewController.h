//
//  AnimationBufferViewController.h
//  CoreAnimationSample
//
//  Created by fanqi on 17/6/6.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationBufferViewController : UIViewController

extern float interpolate(float from, float to, float time);
extern float quadraticEaseInOut(float t);
extern float bounceEaseOut(float t);

@end
