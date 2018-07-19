//
//  XFormat.m
//  ChartsDemo
//
//  Created by 东方不败 on 2018/5/7.
//  Copyright © 2018年 tailor. All rights reserved.
//

#import "XFormat.h"

@implementation XFormat
{
    NSArray * _arr;
}

-(id)initWithArr:(NSArray *)arr{
    self = [super init];
    if (self)
    {
        _arr = arr;
        
    }
    return self;
}
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    return _arr[(NSInteger)value];

}
@end
