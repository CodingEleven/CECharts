//
//  PieChartViewController.m
//  Charts
//
//  Created by CodingEleven on 2018/7/4.
//  Copyright © 2018年 CodingEleven. All rights reserved.
//

#import "PieChartViewController.h"
#import "Charts-Bridging-Header.h"
@interface PieChartViewController ()<ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *pieChartView;
@property (strong, nonatomic)  PieChartView *pieChart;
@property (strong , nonatomic) NSMutableArray *parties;

@end

@implementation PieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _parties  = [[NSMutableArray alloc]initWithObjects:@"OC",@"JAVA",@"C",@"C#",@"C++", nil];
}
- (IBAction)showPieChart:(UIButton *)sender {
    _pieChart = [[PieChartView alloc]initWithFrame:self.pieChartView.bounds];
    [self.pieChartView addSubview:_pieChart];
    [self pieChartInit];
    sender.userInteractionEnabled = NO;
    sender.backgroundColor = [UIColor lightGrayColor];
}
- (IBAction)updateData:(UIButton *)sender {
    [self setPieChartData:nil and:nil];
}

-(void)pieChartInit{
    _pieChart.delegate = self;
    //基本样式
    _pieChart.noDataText = @"好像缺了点数据什么的";
    [_pieChart setExtraOffsetsWithLeft:30 top:0 right:30 bottom:0];//饼状图距离边缘的距离
    _pieChart.usePercentValuesEnabled = YES;//将需要显示的数据转为%格式
    _pieChart.dragDecelerationEnabled = YES; // 拖拽后惯性效果
    _pieChart.drawSlicesUnderHoleEnabled = YES; //显示区块文本
    
    //设置中心圆样式 , 有两个同心圆  hole 跟 transparentCircle
    _pieChart.drawHoleEnabled = YES ; //设置饼状图空心
    _pieChart.holeRadiusPercent = 0.3 ; //中心内圆半径占比
    _pieChart.holeColor = [UIColor whiteColor]; //设置中心内圆颜色
    _pieChart.transparentCircleRadiusPercent = 0.32 ; //中心外圆半径占比
    _pieChart.transparentCircleColor = [UIColor colorWithRed:210/255.0 green:145/255.0 blue:165/255.0 alpha:0.3]; //中心外圆颜色
    
    //设置中心圆的文字
    if (_pieChart.isDrawHoleEnabled == YES) {
        _pieChart.drawCenterTextEnabled = YES;//是否显示中间文字
        //普通文本 , 不能设置颜色大小等
        //        self.pieChartView.centerText = @"编程语言";//中间文字
        //富文本
        NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"编程语言"];
        [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                                    NSForegroundColorAttributeName: [UIColor orangeColor]}
                            range:NSMakeRange(0, centerText.length)];
        _pieChart.centerAttributedText = centerText;
    }
        
        //设置图例
        _pieChart.legend.maxSizePercent = 1; //图例在饼状图中的大小占比,会影响图例的宽高
        _pieChart.legend.formToTextSpace = 8 ; //文本间隔
        _pieChart.legend.font = [UIFont systemFontOfSize:10]; //字体大小
        _pieChart.legend.textColor = [UIColor colorWithRed:(23.0/255) green:(203.0/255) blue:(236.0/255) alpha:1]; //字体颜色
        _pieChart.legend.form = ChartLegendFormCircle ; //图示样式圆形
        _pieChart.legend.formSize = 12; //图示大小
    
    [self setPieChartData:nil and:nil];
}

-(void)setPieChartData:(NSMutableArray *)xArray and:(NSMutableArray *)yArray{
    PieChartDataSet *dataSet = nil;
    double mult = 100;
    int count = 5;//饼状图总共有几块组成
    //每个区块的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        [yVals addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult+1) ) label:_parties[i % _parties.count] icon: nil]];
    }
    
    //如果图表有绘制过，可以在这里重新给data赋值就行,
    //如果没有，需要先定义set的属性。
    if (_pieChart.data.dataSetCount > 0)
    {
        dataSet = (PieChartDataSet *)_pieChart.data.dataSets[0];
        dataSet.values = yVals;
        //通知data去更新
        [_pieChart.data notifyDataChanged];
        //通知图表去更新
        [_pieChart notifyDataSetChanged];
    }
    else{
        //dataSet
        dataSet = [[PieChartDataSet alloc] initWithValues:yVals label:nil];
        dataSet.drawValuesEnabled = YES;//是否绘制显示数据
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
        [colors addObjectsFromArray:ChartColorTemplates.joyful];
        [colors addObjectsFromArray:ChartColorTemplates.colorful];
        [colors addObjectsFromArray:ChartColorTemplates.liberty];
        [colors addObjectsFromArray:ChartColorTemplates.pastel];
        [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
        dataSet.colors = colors;//区块颜色
        dataSet.sliceSpace = 2;//相邻区块之间的间距
        dataSet.selectionShift = 8;//选中区块时, 放大的半径
        dataSet.xValuePosition = PieChartValuePositionInsideSlice;//名称位置
        dataSet.yValuePosition = PieChartValuePositionOutsideSlice;//数据位置
        //数据与区块之间的用于指示的折线样式
        dataSet.valueLinePart1OffsetPercentage = 0.9;//折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
        dataSet.valueLinePart1Length = 0.5;//折线中第一段长度占比
        dataSet.valueLinePart2Length = 0.4;//折线中第二段长度最大占比
        dataSet.valueLineWidth = 1;//折线的粗细
        dataSet.valueLineColor = [UIColor blackColor];//折线颜色
        
        //data
        PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
        NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
        pFormatter.numberStyle = NSNumberFormatterPercentStyle;
        pFormatter.maximumFractionDigits = 1;
        pFormatter.multiplier = @1.f;
        pFormatter.percentSymbol = @" %";
        [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
        [data setValueTextColor: [UIColor blackColor]];
        //data赋值
        _pieChart.data = data;
    }
    
}
#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
