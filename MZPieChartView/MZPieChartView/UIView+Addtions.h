//
//  UIView+Addtions.h
//  PieChartView
//
//  Created by huangtao on 16/6/21.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addtions)
- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)midX;
- (CGFloat)midY;
- (CGFloat)maxX;
- (CGFloat)maxY;

- (void)setX:(CGFloat)x ;
- (void)setY:(CGFloat)y ;
- (void)setWidth:(CGFloat)width ;
- (void)setHeight:(CGFloat)height;

@end
