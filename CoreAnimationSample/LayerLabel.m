//
//  LayerLabel.m
//  CoreAnimationSample
//
//  Created by fanqi on 17/5/18.
//  Copyright © 2017年 fanqi. All rights reserved.
//

#import "LayerLabel.h"

@interface LayerLabel ()

@property (nonatomic, strong) CATextLayer *textLayer;

@end

@implementation LayerLabel

+ (Class)layerClass {
    return [CATextLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
//    self.text = self.text;
//    self.textColor = self.textColor;
//    self.font = self.font;
    
    self.textLayer.alignmentMode = kCAAlignmentJustified;
    self.textLayer.wrapped = YES;
    [self.layer display];   // 注释这行代码怎么也能显示？待查
}


#pragma mark - Setter & Getter

- (CATextLayer *)textLayer {
    return (CATextLayer *)self.layer;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    self.textLayer.string = text;
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    
    self.textLayer.foregroundColor = textColor.CGColor;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.textLayer.font = fontRef;
    self.textLayer.fontSize = font.pointSize;
    
    CFRelease(fontRef);
}

@end
