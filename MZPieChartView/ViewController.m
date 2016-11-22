//
//  ViewController.m
//  MZPieChartView
//
//  Created by MrZhao on 16/11/16.
//  Copyright © 2016年 MrZhao. All rights reserved.
//

#import "ViewController.h"
#import "MZPieChartView.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) MZPieChartView *pieChartView;

@end

@implementation ViewController

#pragma mark- LifeCycle 
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pieChartView = [[MZPieChartView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [self.view addSubview:self.pieChartView];
    [self.pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view.mas_width);
        make.center.equalTo(self.view);
    }];
    //饼状图设置
    self.pieChartView.set = [self set];
    //饼状图数据源设置
    self.pieChartView.dataSet = [self dataSet];
    //饼状图颜色字体 设置
    self.pieChartView.fontColorSet = [self fontColorSetx];
    //选中回调
    self.pieChartView.selectOne = [self select];
    //取消选中回调
    self.pieChartView.deselect = [self deselect];
    //开始绘图
    [self.pieChartView stroke];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, self.view.height-70, 150, 45);
    button.center =  CGPointMake(self.view.width/4, self.view.height-100);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"Change frame" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, self.view.height-70, 150, 45);
    button.center =  CGPointMake(self.view.width*3/4, self.view.height-100);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"Select" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectPieChart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark- Button Action

- (void)change
{
    
    
        if (self.pieChartView.frame.size.width == self.view.width) {
//            self.pieChartView.transform = CGAffineTransformScale(self.pieChartView.transform, 0.8, 0.8);
            [self.pieChartView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.view).offset(-100);
                make.height.equalTo(self.view.mas_width).offset(-100);
            }];
        }else{
//            self.pieChartView.transform = CGAffineTransformIdentity;
            [self.pieChartView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.view);
                make.height.equalTo(self.view.mas_width);
            }];
        }
        [self.view layoutIfNeeded];
}

- (void)selectPieChart
{
    NSUInteger index = (NSUInteger)random() % self.pieChartView.dataSet.valueStore.count;
    NSLog(@"手动选择第%lu个",index);
    [self.pieChartView selectOne:index];
   
}

#pragma mark- MZPieChartView

/** 饼状图 设置 */
- (MZPieChartSet *)set
{
    MZPieChartSet *set = [[MZPieChartSet alloc]init];
    //饼状图收入小数位数 默认2.
    set.valueFractionDigits = 2;
    //饼状图 绘图起始角度 默认负90度.
    set.startAngle = -1 * M_PI_2;
    //饼状图 半径比例 默认0.24
    set.radiusPercent = 0.24;
    //饼状图 扇形线宽比例 默认0.14
    set.lineWidthPercent = 0.14;
    //饼状图 扇形选中线宽比例 默认0.18
    set.selectLineWidthPercent = 0.18;
    //当扇形对应比例小于0.05，扇形上的比例文字不显示，选中扇形时，在空白区域显示
    set.hiddenPercent = 0.05;
    return set;
}

/** 饼状图数据 设置 */
- (MZPieChartDataSet *)dataSet
{
    MZPieChartDataSet *dataSet = [[MZPieChartDataSet alloc]init];
    //标题
    dataSet.text = @"中国";
    //收入
    dataSet.valueStore = @[@"1",@"4",@"1",@"3",@"2",@"4",@"4",@"8",@"8",@"7",@"7",@"9",@"7",@"7",@"4",@"7",@"9",@"9",@"9",@"9",@"9",@"9",@"9"];
    //text
    dataSet.textStore = @[@"西南大学",@"北京大学",@"清华大学",@"东京大学",@"南京大学",@"西南民族大学",@"浙江大学",@"复旦大学",@"西华大学",@"哈尔冰工业大学",@"四川大学",@"电子科技大学",@"西安科技大学",@"西南大学",@"重庆大学",@"斯坦福大学",@"哈佛",@"纽约大学",@"西南石油大学",@"云南大学",@"贵州大学",@"西北大学",@"北京邮电大学"];
    //颜色
//    dataSet.colorStore = [ViewController colorStoreByCount:dataSet.valueStore.count];
    return dataSet;
}
                                      
/** 饼状图 字体及文本颜色设置 */
-(MZPieChartFontColorSet *)fontColorSetx
{
    MZPieChartFontColorSet *fontColorSet = [[MZPieChartFontColorSet alloc]init];
    //文本字体
    fontColorSet.centerTextFont = [UIFont systemFontOfSize:10.0];
    //收入字体
    fontColorSet.centerValueFont = [UIFont systemFontOfSize:14.0];
    //比例字体
    fontColorSet.percentTextFont = [UIFont systemFontOfSize:15.0];
    //空白区域比例文本字体
    fontColorSet.hiddenPercentTextFont = [UIFont systemFontOfSize:15.0];
    //文本颜色
    fontColorSet.centerTextColor = [UIColor blackColor];
    //收入文本颜色
    fontColorSet.centerValueColor = [UIColor blackColor];
    //比例文本颜色
    fontColorSet.percentTextColor = [UIColor whiteColor];
    //空白区域比例文本颜色
    fontColorSet.hiddenPercentTextColor = [UIColor blackColor];
    
    return fontColorSet;
}


/** 选中回调 */

- (SelectCallBack)select
{
    return ^(NSInteger index){
        NSLog(@"选中第%ld个",index);
    };
}

/** 取消选中回调 */

- (DeselectCallBack)deselect
{
   return ^{
        NSLog(@"取消选中饼状图");
    };
}


@end
