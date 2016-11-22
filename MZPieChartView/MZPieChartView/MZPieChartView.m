//
//  MZPieChartView.m
//  MZPieChartView
//
//  Created by MrZhao on 16/11/16.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "MZPieChartView.h"
#define ZFDecimalColor(r, g, b, a) [UIColor colorWithRed:r green:g blue:b alpha:a]

@interface MZPieChartView()<CAAnimationDelegate>

#pragma mark-  Property

/** The start angle array of all pie slices */

@property (nonatomic,strong) NSMutableArray *startAngleStore;

/** The percent array of all pie slices */

@property (nonatomic, strong) NSMutableArray *percentStore;

/** The percent text label array of all pie slices */

@property (nonatomic,strong) NSMutableArray *labelStore;

/** The shapelayer array of all pie slices */

@property (nonatomic,strong) NSMutableArray *shapeLayerStore;

/** When the percent of a pie slice < hiddenPercent，do not show the percent text of the pie slice. select the pie slice, line(lineLayer) points to percent text label in a blank area. */

@property (nonatomic,strong) CAShapeLayer *lineLayer;

/** Pie chart center text label */

@property (nonatomic,strong) UILabel *textLabel;

/** Pie chart center text label */

@property (nonatomic,strong) UILabel *valueLabel;

/** The radius of pie chart */

@property (nonatomic, assign) CGFloat radius;

/** The width of a pie slice */

@property (nonatomic, assign) CGFloat lineWidth;

/** The width of a selection pie slice */

@property (nonatomic, assign) CGFloat selectLineWidth;

/**  The center of a pie chart.
 
 Default is center of the MZPieChartView */

@property (nonatomic, assign) CGPoint pieChartCenter;

@end


@implementation MZPieChartView

#pragma mark- LifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationDuration = 0.75;
        self.selectIndex = -1;
//        self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        self.animation = YES;
        [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"bounds"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"bounds"]) {
        CGRect old = ((NSValue *)change[@"old"]).CGRectValue;
        CGRect new = ((NSValue *)change[@"new"]).CGRectValue;
        if (CGSizeEqualToSize(old.size, new.size) == NO) {
            
//            static int a = 0;
//            if (a == 1) {
//                return;
//            }
//            a = 1;
                NSInteger selectIndex = self.selectIndex;
            
                [self removeAll];
                
                [self initDatas];
                
                [self percetValue];
                
                [self addCenterTextAndValueLabel];
            
                if (selectIndex >= 0 && selectIndex < self.dataSet.valueStore.count   ) {
      
                    [self setSelectIndex_x:selectIndex formOut:YES];
                }
        }
    }
}

#pragma mark- Getter
- (NSMutableArray *)percentStore
{
    if (!_percentStore) {
        _percentStore = [[NSMutableArray alloc]init];
    }
    return _percentStore;
}
- (NSMutableArray *)startAngleStore
{
    if (!_startAngleStore) {
        _startAngleStore = [[NSMutableArray alloc]init];
    }
    return _startAngleStore;
}

- (NSMutableArray *)labelStore
{
    if (!_labelStore) {
        _labelStore = [[NSMutableArray alloc]init];
    }
    return _labelStore;
}
- (NSMutableArray *)shapeLayerStore
{
    if (!_shapeLayerStore) {
        _shapeLayerStore = [[NSMutableArray alloc]init];
    }
    return _shapeLayerStore;
}

-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
    }
    _textLabel.font = self.fontColorSet.centerTextFont;
    _textLabel.textColor = self.fontColorSet.centerTextColor;
    return _textLabel;
}

-(UILabel *)valueLabel{
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc]init];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
    }
    _valueLabel.font = self.fontColorSet.centerValueFont;
    _valueLabel.textColor = self.fontColorSet.centerValueColor;
    return _valueLabel;
}
- (MZPieChartSet *)set
{
    if (!_set) {
        _set = [[MZPieChartSet alloc]init];
    }
    return _set;
}

- (MZPieChartFontColorSet *)fontColorSet
{
    if (!_fontColorSet) {
        _fontColorSet = [[MZPieChartFontColorSet alloc]init];
    }
    return _fontColorSet;
}
#pragma mark- 饼状图绘图 Storke

-(void)stroke
{
    [self removeAll];
    
    [self initDatas];
    
    [self percetValue];
    
    [self addCenterTextAndValueLabel];
    
    if (self.animation) {
         [self addAnimationlayer];
    }
}

/** Remove all layer or subviews in the MZPieChartView. */

- (void)removeAll
{
    [self.labelStore enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [self.shapeLayerStore enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL * stop) {
        [obj removeFromSuperlayer];
    }];
    [self.lineLayer removeFromSuperlayer];
    self.percentStore = nil;
    self.labelStore = nil;
    self.startAngleStore = nil;
    self.percentStore = nil;
    self.shapeLayerStore = nil;
    self.selectIndex = -1;
}


/** Init data */

- (void)initDatas
{
    CGFloat min = MIN(self.width, self.height);
    
    self.pieChartCenter = CGPointMake(self.width/2, self.height/2);
    self.radius = min * self.set.radiusPercent;
    self.lineWidth = min * self.set.lineWidthPercent;
    self.selectLineWidth = min * self.set.selectLineWidthPercent;
    
    _textLabel.bounds = CGRectMake(0, 0, self.radius*1.6, 25);
    _textLabel.center = CGPointMake(self.width/2, self.height/2+10);
    _valueLabel.bounds = CGRectMake(0, 0, self.radius*1.6, 15);
    _valueLabel.center = CGPointMake(self.width/2, self.height/2-5);
}

//percent value
- (void)percetValue
{
    // check data
    if (self.dataSet == nil || self.dataSet.valueStore.count == 0) {
        return;
    }
    if (self.dataSet.valueStore.count != self.dataSet.textStore.count
        || self.dataSet.textStore.count != self.dataSet.colorStore.count
        ) {
        return;
    }
    
    //caculate sum value
    
    __block CGFloat sumValue = 0;
    [self.dataSet.valueStore enumerateObjectsUsingBlock:^(NSString * value, NSUInteger idx, BOOL * stop) {
        sumValue += value.floatValue;
    }];
    
    
    //if sumValue = 0 return
    
    if (sumValue < pow(0.1, 6)) {
        return;
    }

    //get percent of all pie slice
    __block CGFloat startAngle = self.set.startAngle;
    [self.dataSet.valueStore enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *  stop) {
        CGFloat percent = obj.floatValue/sumValue;
        [self.percentStore addObject:@(percent)];
        [self.startAngleStore addObject:@(startAngle)];
         startAngle += M_PI * 2 * percent;
    }];

    self.dataSet.value = [NSString stringWithFormat:[self.set piechartValueFormat],sumValue];
    [self.startAngleStore addObject:@(startAngle)];
    
    [self.dataSet.valueStore enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *  stop) {
        [self addShapeLayerByIndex:idx];
        [self addPercentLabelByIndex:idx];
    }];
}

- (void)addCenterTextAndValueLabel
{
    self.textLabel.text = self.dataSet.text;
    [self addSubview:self.textLabel];
    
    self.valueLabel.text = self.dataSet.value;
    [self addSubview:self.valueLabel];
}

- (void)addAnimationlayer
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:self.pieChartCenter radius:self.radius startAngle:self.set.startAngle endAngle:2 * M_PI + self.set.startAngle clockwise:YES];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 1;
    shapeLayer.strokeColor = ZFDecimalColor(0.97, 0.97, 0.97, 1).CGColor;
    shapeLayer.lineWidth = self.lineWidth + 2;
    
    self.layer.mask = shapeLayer;
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"strokeEnd";
    basicAnimation.fromValue = @0;
    basicAnimation.toValue = @1;
    basicAnimation.delegate = self;
    basicAnimation.duration = self.animationDuration;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeBackwards;
    [shapeLayer addAnimation:basicAnimation forKey:@"111"];
}
#pragma mark- Animation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.layer.mask removeAllAnimations];
    self.layer.mask = nil;
}

#pragma mark- Percent Label

- (UILabel *)percentLabelByIndex:(NSInteger)index
{
    UILabel *label;
    if (index < self.labelStore.count) {
        label = self.labelStore[index];
    }else{
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 15)];
        [self.labelStore addObject:label];
    }
    NSString *percenTitle = [NSString stringWithFormat:@"%.0f%%",((NSNumber *)self.percentStore[index]).floatValue * 100];

    label.center = [self percentLabelCenterByIndex:index];
    label.textColor = self.fontColorSet.percentTextColor;
    label.font = self.fontColorSet.percentTextFont;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = percenTitle;

    return label;
}

- (CGPoint)percentLabelCenterByIndex:(NSInteger)index
{
    CGFloat start = ((NSNumber *) self.startAngleStore[index]).floatValue;
    CGFloat end = ((NSNumber *)self.startAngleStore[index + 1]).floatValue;
    
    CGFloat angle =(start + end) / 2.0;
    
    return [self pointByRadius:self.radius angle:angle];
}



- (CGPoint)pointByRadius:(CGFloat)radius angle:(CGFloat)angle
{
    CGFloat y = sin(angle) * radius + self.pieChartCenter.y;
    CGFloat x = cos(angle) * radius + self.pieChartCenter.x;
    return  CGPointMake(x, y);
}
#pragma mark- ShapeLayer
- (void)addShapeLayerByIndex:(NSInteger )index
{
    CAShapeLayer *shapeLayer = [self shapeLayerByIndex:index];
    [self.layer addSublayer:shapeLayer];
}
- (void)addPercentLabelByIndex:(NSInteger)index
{
    UILabel *percentLabel = [self percentLabelByIndex:index];
    [self addSubview:percentLabel];
    
    if (((NSNumber *)self.percentStore[index]).floatValue < self.set.hiddenPercent) {
        percentLabel.hidden = YES;
        percentLabel.textColor = self.fontColorSet.hiddenPercentTextColor;
        percentLabel.font = self.fontColorSet.hiddenPercentTextFont;
    }
}

- (CAShapeLayer *)shapeLayerByIndex:(NSInteger)index
{
    if (index >= self.dataSet.colorStore.count) {
        return nil;
    }
    CAShapeLayer *shaperLayer;
    if (index < self.shapeLayerStore.count) {
        shaperLayer = self.shapeLayerStore[index];
    }else{
        shaperLayer = [CAShapeLayer layer];
        [self.shapeLayerStore addObject:shaperLayer];
    }
    
    shaperLayer.strokeColor = ((UIColor *) self.dataSet.colorStore[index]).CGColor;
    shaperLayer.fillColor = [UIColor clearColor].CGColor;
    shaperLayer.path = [self shapLayerpathByIndex:index];
    shaperLayer.lineWidth = self.lineWidth;
    return shaperLayer;
}

- (CGPathRef)shapLayerpathByIndex:(NSInteger)index
{
    CGFloat start = ((NSNumber *)self.startAngleStore[index]).floatValue;
    CGFloat end  = ((NSNumber *)self.startAngleStore[index+1]).floatValue;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:self.pieChartCenter radius:self.radius startAngle:start endAngle:end clockwise:YES];
    return bezierPath.CGPath;
}

#pragma mark- Touche

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat dis_x = point.x - self.pieChartCenter.x;
    CGFloat dis_y = point.y - self.pieChartCenter.y;
    CGFloat radius_x = sqrt(pow(dis_x, 2) + pow(dis_y, 2));
    
    if (radius_x > self.radius + self.selectLineWidth/2 || radius_x < self.radius - self.selectLineWidth/2) {
        return;
    }
    
    CGFloat angle = atan2(dis_y, dis_x);
    if (dis_y < 0 && dis_x < 0) {
        angle += 2 * M_PI;
    }
    
    NSInteger index = [self findIndexByAngle:angle];
    if (index == -1) {
        return;
    }
    [self setSelectIndex_x:index formOut:NO];
}

-(void)selectOne:(NSUInteger)index
{
    if (index >= self.dataSet.valueStore.count) {
        return;
    }
    [self setSelectIndex_x:index formOut:YES];
}
- (void)deselectAll
{
    if (self.selectIndex == -1) {
        return;
    }
    [self setSelectIndex_x:self.selectIndex formOut:YES];
}
- (void)setSelectIndex_x:(NSInteger)index formOut:(BOOL)outSign{
    if (index < 0 || index >= self.dataSet.valueStore.count) {
        return;
    }
    if (self.selectIndex != -1) {
        [self selectOrNotLayer:self.selectIndex];
        [self showOrHiddenMinPercentLabel:self.selectIndex showOrHidden:YES];
        if (self.selectIndex == index) {
            self.selectIndex = -1;
            self.textLabel.text = self.dataSet.text;
            self.valueLabel.text = self.dataSet.value;
            if (!outSign) {
                self.deselect();
            }
            return;
        }
    }

    [self showOrHiddenMinPercentLabel:index showOrHidden:NO];
    CGFloat value = ((NSNumber *)self.dataSet.valueStore[index]).floatValue;
    self.textLabel.text = self.dataSet.textStore[index];
    self.valueLabel.text = [NSString stringWithFormat:[self.set piechartValueFormat],value];
    [self selectOrNotLayer:index];
    _selectIndex = index;
    if (!outSign) {
        self.selectOne(index);
    }
    
}

- (NSInteger)findIndexByAngle:(CGFloat)angle
{
    __block NSInteger index = -1;
    [self.startAngleStore enumerateObjectsUsingBlock:^(NSNumber *  obj, NSUInteger idx, BOOL *  stop) {
        if (angle <= obj.floatValue) {
            index = idx - 1;
            *stop = YES;
        }
    }];
    return index;
}

#pragma mark- SelectOrNotLayer
- (void)selectOrNotLayer:(NSInteger)index
{
    
    CAShapeLayer *shapeLayer = self.shapeLayerStore[index];
    
    CGFloat width = self.lineWidth;
    CGFloat start = ((NSNumber *)self.startAngleStore[index]).floatValue;
    CGFloat end = ((NSNumber *)self.startAngleStore[index + 1]).floatValue;
    CGFloat percent_x = ((NSNumber *)self.percentStore[index]).floatValue * 100;
    CGFloat radius_x = self.radius;
    if (shapeLayer.lineWidth < self.selectLineWidth) {
        width = self.selectLineWidth;
        radius_x = self.radius+(self.selectLineWidth-self.lineWidth)/2;
        CGFloat percent = (end - start) /14;
        if (percent >= 0.07) {
            percent = 0.07;
        }
        CGFloat dis = end - start;
        if (!(percent_x >= 100 || self.dataSet.value.floatValue == [self.dataSet.valueStore[index] floatValue]) && dis > 0) {
            end -= percent;
            start += percent;
        }
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:self.pieChartCenter radius:radius_x startAngle:start endAngle:end clockwise:YES];
    
    shapeLayer.lineWidth = width;
    shapeLayer.path = bezierPath.CGPath;
    
}

- (void)showOrHiddenMinPercentLabel:(NSInteger)index showOrHidden:(BOOL)sign
{
    if(self.percentStore.count <= index || index < 0){
        return;
    }
    if (((NSNumber *)self.percentStore[index]).floatValue >= self.set.hiddenPercent) {
        return;
    }
    
    ((UILabel *)self.labelStore[index]).hidden = sign;
    if (sign) {
        //移除 线
        [self.lineLayer removeFromSuperlayer];
    }else{
        //显示 画线 label位置
        self.lineLayer = [self createLineLayerByIndex:index];
        [self.layer addSublayer:self.lineLayer];
    }
}

- (CAShapeLayer *)createLineLayerByIndex:(NSInteger)index
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = ((UIColor *)self.dataSet.colorStore[index]).CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 2;
    shapeLayer.path = [self linePathByIndex:index];
    return shapeLayer;
}

- (CGPathRef)linePathByIndex:(NSInteger)index
{
    
    CGFloat radius_x =self.radius + (self.selectLineWidth - self.lineWidth)/2 + self.selectLineWidth/2;
    
    CGFloat start = ((NSNumber *) self.startAngleStore[index]).floatValue;
    CGFloat end = ((NSNumber *)self.startAngleStore[index + 1]).floatValue;
    CGFloat centerAngle = (start + end) / 2.0;
    
    CGPoint point0 = [self pointByRadius:radius_x angle:centerAngle];
    CGPoint point1 = [self pointByRadius:radius_x + self.radius * 0.13  angle:centerAngle];
    CGPoint point2 = point1;
    CGPoint labelCenter = point1;
    if (fabs(centerAngle) < M_PI * 0.5) {
//        point2.x = self.width - self.width * 0.1;
        point2.x = point1.x + 40;
        if (point2.x > self.width - self.width * 0.1) {
            point2.x = self.width - self.width * 0.1;
        }
        labelCenter.x = point2.x + self.width * 0.05;
    }else{
//        point2.x = self.width * 0.1;
        point2.x = point1.x - 40;
        if (point2.x < self.width * 0.1) {
            point2.x = self.width * 0.1;
        }
        labelCenter.x = point2.x - self.width * 0.05;
    }
  
    ((UILabel *)self.labelStore[index]).center = labelCenter;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:point0];
    [bezierPath addLineToPoint:point1];
    [bezierPath addLineToPoint:point2];
    return bezierPath.CGPath;
}

@end
