//
//  MainViewController.m
//  Charts
//
//  Created by CodingEleven on 2018/7/3.
//  Copyright © 2018年 CodingEleven. All rights reserved.
//

#import "MainViewController.h"
#import "LineChartViewController.h"
#import "BarChartViewController.h"
#import "PieChartViewController.h"
@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)gotoLineChart:(UIButton *)sender {
    LineChartViewController *lineChartVC = [[LineChartViewController alloc]init];
    [self presentViewController:lineChartVC animated:YES completion:nil];
}

- (IBAction)goBarChart:(id)sender {
    BarChartViewController *barChartVC = [[BarChartViewController alloc]init];
    [self presentViewController:barChartVC animated:YES completion:nil];
}
- (IBAction)goPieChart:(UIButton *)sender {
    PieChartViewController *pieChartVC = [[PieChartViewController alloc]init];
    [self presentViewController:pieChartVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
