//
//  LineChartViewController.m
//  Charts
//
//  Created by CodingEleven on 2018/7/2.
//  Copyright © 2018年 CodingEleven. All rights reserved.
//

#import "LineChartViewController.h"
#import "Charts-Bridging-Header.h"
@interface LineChartViewController ()<ChartViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic,strong)LineChartView *lineChart;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSTimer *timer;


@end

@implementation LineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化要显示的数据
    self.dataArray = [NSMutableArray arrayWithObjects:@"12",@"22",@"9",@"28",@"2", nil];
}
- (IBAction)stopPadding:(UIButton *)sender {
    [self.timer invalidate];
    self.timer = nil;
    self.startButton.userInteractionEnabled = YES;
    self.startButton.backgroundColor = [UIColor colorWithRed:(23.0/255) green:(203.0/255) blue:(236.0/255) alpha:1];
}
- (IBAction)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)paddingData:(UIButton *)sender {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(updateLineChart) userInfo:nil repeats:YES];
    sender.userInteractionEnabled = NO;
    sender.backgroundColor = [UIColor lightGrayColor];

}


-(void)updateLineChart{
    [self.dataArray addObject:[NSString stringWithFormat:@"%.2f", (float)(arc4random() % 30) + 1]];
    [self setLineChartData:self.dataArray];
    
    //需要在设置了数据之后(即图标需要有了数据)再设置最大最小值
    [_lineChart setVisibleXRangeMaximum:6];// 最大显示
    // [_lineChart setVisibleXRangeMinimum:2];// 最小显示
    
    [_lineChart moveViewToX:self.dataArray.count-1];
}

- (IBAction)showChart:(UIButton *)sender {
    self.lineChart = [[LineChartView alloc]initWithFrame:self.chartView.bounds];
    [self.chartView addSubview:self.lineChart];
    [self lineChartInit];
    sender.userInteractionEnabled = NO;
    sender.backgroundColor = [UIColor lightGrayColor];
}

-(void)lineChartInit{
    /* 设置曲线图属性 */
    _lineChart.backgroundColor = [UIColor clearColor];  //图表背景
    _lineChart.noDataText = @"好像缺了点数据什么的";        //没数据时显示的文字
    _lineChart.chartDescription.enabled = NO;           //不显示图表描述文字
    _lineChart .dragEnabled = YES;                      //图表可以拖动
    _lineChart.legend.enabled = NO;                     //不显示图例
    _lineChart.scaleXEnabled = NO;                      //X轴不能缩放
    _lineChart.scaleYEnabled = NO;                      //Y轴不能缩放
    _lineChart.pinchZoomEnabled = NO;                   //不能捏合手势缩放
    _lineChart.delegate = self;                         //设置代理
    
    /* 设置坐标轴属性 */
    ChartXAxis *xAxis = _lineChart.xAxis;               //获取图表X轴
    xAxis.labelPosition = XAxisLabelPositionBottom;     //X轴标签位置
    xAxis.drawLabelsEnabled = YES;                      //显示X轴
    xAxis.drawGridLinesEnabled = NO;                    //隐藏X轴表格线
    //xAxis.axisMaximum = self.dataArray.count-1+0.3 ;          //设置左右边距
    xAxis.axisMinimum = -0.3 ;
    xAxis.axisLineWidth = 1.0;                          //X轴宽度
    xAxis.granularity = 1.0;
    xAxis.axisLineColor = [UIColor colorWithRed:(140.0/255) green:(234.0/255) blue:1 alpha:1];
    xAxis.spaceMin = 9;
    _lineChart.rightAxis.enabled = NO;                  //右边轴不显示
    
    ChartYAxis *leftAxis = _lineChart.leftAxis;         //获取左边轴
    leftAxis.enabled = YES;                             //显示左边轴
    leftAxis.drawGridLinesEnabled = NO;                 //隐藏Y轴表格线
    leftAxis.axisMinimum = 0;                           //Y轴最小值
    leftAxis.drawAxisLineEnabled = YES;                 //绘制Y轴
    leftAxis.axisLineWidth = 1.0;                       //X轴宽度
    leftAxis.axisLineColor = [UIColor colorWithRed:(140.0/255) green:(234.0/255) blue:1 alpha:1];

    [_lineChart animateWithXAxisDuration:0.5];
    
    [self setLineChartData:self.dataArray];
    
    
}

-(void)setLineChartData:(NSMutableArray *)dataArray{
    if(!dataArray.count)
    {
        return;
    }
    LineChartDataSet *set1 = nil;
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++)
    {
        //将横纵坐标以ChartDataEntry的形式保存下来，注意横坐标值一般是i的值，而不是你的数据,自定义X轴坐标label需新建一个XFormat类来赋值
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:[dataArray[i] floatValue] icon: nil]];
     }
    //如果图表有绘制过，可以在这里重新给data赋值就行,
    //如果没有，需要先定义set的属性。
    if (_lineChart.data.dataSetCount > 0)
     {
         set1 = (LineChartDataSet *)_lineChart.data.dataSets[0];
         set1.values = values;
         //通知data去更新
         [_lineChart.data notifyDataChanged];
        //通知图表去更新
        [_lineChart notifyDataSetChanged];
         
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:values label:@"DataSet 1"];
        //自定义set的各种属性
        [self configSet:set1];
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        //将set保存到data当中
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        _lineChart.data = data;
     }
}

-(void)configSet:(LineChartDataSet*)set{
    //是否绘制图标
    set.drawIconsEnabled = NO;
    //折线颜色
    [set setColor:[UIColor colorWithRed:(140.0/255) green:(234.0/255) blue:1 alpha:1]];
    //折线点的颜色
    [set setCircleColor:[UIColor colorWithRed:(140.0/255) green:(234.0/255) blue:1 alpha:1]];
    //折线的宽度
    set.lineWidth = 1.0;
    //折线点的宽度
    set.circleRadius = 3.0;
    //是否画空心圆
    set.drawCircleHoleEnabled = NO;
    //折线弧度
    set.mode = LineChartModeCubicBezier;
    set.cubicIntensity = 0.2;
    //折线点的值的大小
    set.valueFont = [UIFont systemFontOfSize:9.f];
    //图例的线宽
    set.formLineWidth = 1.0;
    //图例的字体大小
    set.formSize = 15.0;
    //显示颜色填充
    set.drawFilledEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
