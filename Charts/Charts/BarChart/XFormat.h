//
//  XFormat.h
//  ChartsDemo
//
//  Created by 东方不败 on 2018/5/7.
//  Copyright © 2018年 tailor. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Charts;

@interface XFormat : NSObject<IChartAxisValueFormatter>
-(id)initWithArr:(NSArray *)arr;
@end
