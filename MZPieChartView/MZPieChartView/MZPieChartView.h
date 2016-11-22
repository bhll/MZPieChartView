//
//  MZPieChartView.h
//  MZPieChartView
//
//  Created by MrZhao on 16/11/16.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Addtions.h"
#import "MZPieChartSet.h"
#import "MZPieChartDataSet.h"
#import "MZPieChartFontColorSet.h"

typedef void(^SelectCallBack)(NSInteger index);

typedef void(^DeselectCallBack)();

@interface MZPieChartView : UIView

/** Select one pie slice */

@property (nonatomic, copy) SelectCallBack selectOne;

/** Deselect pie slice */

@property (nonatomic, copy) DeselectCallBack deselect;

/** Index of the select pie slice.
 
 Default is -1,indicates does not select pie slice */

@property (nonatomic, assign) NSInteger selectIndex;

/** Pie chart show animation. Default is YES */

@property (nonatomic, assign) BOOL animation;

/** The total animation duration. Deault is 0.75 */

@property (nonatomic, assign) CGFloat animationDuration;


/**  MZPieChartView settings */

@property (nonatomic, strong) MZPieChartSet *set;

/**  MZPieChartView Data settings */

@property (nonatomic, strong) MZPieChartDataSet *dataSet;

/**  MZPieChartView font/textColor settings */

@property (nonatomic, strong) MZPieChartFontColorSet *fontColorSet;

/** Stroke path */

- (void)stroke;

/** select pie slice */

- (void)selectOne:(NSUInteger)index;

- (void)deselectAll;
@end
