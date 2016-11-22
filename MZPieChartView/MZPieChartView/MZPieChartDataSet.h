//
//  MZPieChartDataSet.h
//  PieChartView
//
//  Created by MrZhao on 16/11/16.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MZPieChartDataSet : NSObject

/** Pie chart center text */

@property (nonatomic, copy) NSString *text;

/** Pie chart center value */

@property (nonatomic, assign) NSString *value;

/** Value array */

@property (nonatomic, copy) NSArray *valueStore;

/** Text array */

@property (nonatomic, copy) NSArray *textStore;

/** Color array */

@property (nonatomic, copy) NSArray *colorStore;

@end
