//
//  UIView+Addtions.m
//  PieChartView
//
//  Created by huangtao on 16/6/21.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "UIView+Addtions.h"

@implementation UIView (Addtions)
- (CGFloat)x
{
    return CGRectGetMinX(self.frame);
}
- (CGFloat)y{
    return CGRectGetMinY(self.frame);
}
- (CGFloat)width{
    return CGRectGetWidth(self.bounds);
}
- (CGFloat)height{
    return CGRectGetHeight(self.bounds);
}
- (CGFloat)midX{
    return CGRectGetMidX(self.frame);
}
- (CGFloat)midY{
    return CGRectGetMidY(self.frame);
}
- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}
- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}
- (void)setWidth:(CGFloat)width {
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, self.height);
}
- (void)setHeight:(CGFloat)height{
    self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.width, height);
}

@end
