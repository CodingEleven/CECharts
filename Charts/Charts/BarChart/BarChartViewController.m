//
//  BarChartViewController.m
//  Charts
//
//  Created by CodingEleven on 2018/7/4.
//  Copyright © 2018年 CodingEleven. All rights reserved.
//

#import "BarChartViewController.h"
#import "Charts-Bridging-Header.h"
#import "XFormat.h"
@interface BarChartViewController ()
{
    int count;
}

@property (weak, nonatomic) IBOutlet UIView *barChartView;
@property (nonatomic,strong)BarChartView *barChart;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@end

@implementation BarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
    self.dataArray = [NSMutableArray arrayWithObjects:@"13",@"16",@"9",@"8",@"18",@"10",@"5",@"11",@"14",@"7",@"16",@"12", nil];
}
- (IBAction)updateData:(UIButton *)sender {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateBarChartData) userInfo:nil repeats:YES];
    sender.userInteractionEnabled = YES;
    sender.backgroundColor = [UIColor lightGrayColor];
}
- (IBAction)stopUpdate:(UIButton *)sender {
    [self.timer invalidate];
    self.timer = nil;
    self.updateButton.userInteractionEnabled = YES;
    self.updateButton.backgroundColor = [UIColor colorWithRed:(23.0/255) green:(203.0/255) blue:(236.0/255) alpha:1];
    
}

-(void)updateBarChartData{
    if(count>=12)
    {
        count = 0 ;
    }
    [self.dataArray replaceObjectAtIndex:count withObject:[NSString stringWithFormat:@"%.2f", (float)(arc4random() % 20) + 1]];
    count++;
    [self setBarChartData:self.dataArray];
}

- (IBAction)toShowBarChart:(UIButton *)sender {
    _barChart = [[BarChartView alloc]initWithFrame:self.barChartView.bounds];
    [self barChartInit];
    [self.barChartView addSubview:_barChart];
    [_barChart setVisibleXRangeMaximum:12];// 最大显示个数,如果太挤,可以设置小于12的值,其余的柱子可以scroll显示
    sender.userInteractionEnabled = NO;
    sender.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)barChartInit{
    //图表设置
    _barChart.backgroundColor = [UIColor clearColor];
    _barChart.noDataText = @"好像缺了点数据什么的";   //没有数据时的文字提示
    _barChart.drawValueAboveBarEnabled = YES;     //数值显示在柱形的上面还是下面
    _barChart.drawBarShadowEnabled = NO;          //是否绘制柱形的阴影背景
    _barChart.scaleYEnabled = NO;                 //取消Y轴缩放
    _barChart.scaleXEnabled = NO;                 //取消X轴缩放
    _barChart.doubleTapToZoomEnabled = NO;        //取消双击缩放
    _barChart.dragEnabled = YES;                  //启用拖拽图表
    _barChart.dragDecelerationEnabled = YES;      //拖拽后是否有惯性效果
    _barChart.dragDecelerationFrictionCoef = 0.9; //拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    //X轴设置
    ChartXAxis *xAxis = _barChart.xAxis;
    xAxis.axisLineWidth = 1;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis.drawGridLinesEnabled = NO;//不绘制网格线    
    xAxis.axisMinimum =-0.5;//可以设置第一个柱子到Y轴的边距
    xAxis.granularity = 1; //例如 : 如果值为3 , X轴label间隔3个数据显示一个label,X轴将显示1月,4月,7月,10月  . 可以自己修改值实践一下
    xAxis.axisLineColor = [UIColor colorWithRed:(140.0/255) green:(234.0/255) blue:1 alpha:1];//X轴颜色
    
    ChartYAxis *leftAxis = _barChart.leftAxis;//获取左边Y轴
    leftAxis.axisLineWidth = 1;//Y轴线宽
    leftAxis.axisLineColor = [UIColor colorWithRed:(140.0/255) green:(234.0/255) blue:1 alpha:1];//Y轴颜色
    leftAxis.axisMinimum = 0;
    
    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
    leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
    
    _barChart.rightAxis.enabled = NO;
    
    _barChart.legend.enabled = NO;//不显示图例说明
    _barChart.chartDescription.text = @"";//不显示，就设为空字符串即可
    [_barChart animateWithYAxisDuration:1.0f];
    // [_barChart setVisibleXRangeMaximum:8];
    
    //设置barChart的数据
    [self setBarChartData:self.dataArray];
}

-(void)setBarChartData:(NSMutableArray *)dataArray{
    if(!dataArray.count)
    {
        return;
    }
    BarChartDataSet *set1 = nil;
    
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] initWithObjects:@"1月", @"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月", nil];
    _barChart.xAxis.valueFormatter = [[XFormat alloc]initWithArr:xVals];
    [_barChart.xAxis setLabelCount:dataArray.count force:NO];
    
    //对应Y轴上面需要显示的数据,将Y轴数据以ChartDataEntry的形式保存下来，注意横坐标值一般是i的值，而不是你的数据,自定义X轴坐标label需新建一个XFormat类来赋值 ,见上面X轴数据设置

    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:[dataArray[i] floatValue]];
        [yVals addObject:entry];
    }
    //如果图表有绘制过，可以在这里重新给data赋值就行,
    //如果没有，需要先定义set的属性。
    if (_barChart.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_barChart.data.dataSets[0];
        set1.values = yVals;
        //通知data去更新
        [_barChart.data notifyDataChanged];
        //通知图表去更新
        [_barChart notifyDataSetChanged];
        
    }
    else{
        //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
        set1 =[[BarChartDataSet alloc] initWithValues:yVals label:nil];
        
        set1.drawValuesEnabled = YES;//是否在柱形图上面显示数值
        set1.highlightEnabled = NO;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        [set1 setColor:[UIColor colorWithRed:(140.0/255) green:(234.0/255) blue:1 alpha:1]];//设置柱形图颜色
        //将BarChartDataSet对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        //创建BarChartData对象, 此对象就是barChartView需要最终数据对象
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
//        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];//文字字体
//        [data setValueTextColor:[UIColor orangeColor]];//文字颜色
        _barChart.data = data;
        
        //    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        //    //自定义数据显示格式
        //    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        //    [formatter setPositiveFormat:@"#0.00"];
        //    [data setValueFormatter:formatter];
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
