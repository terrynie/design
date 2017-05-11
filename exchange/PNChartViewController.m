//
//  PNChartViewController.m
//  exchange
//
//  Created by Terry on 2017/5/6.
//  Copyright © 2017年 Terry. All rights reserved.
//

#import "PNChartViewController.h"
#import "Reachable.h"
#import "exchange-Bridging-Header.h"
#import "exchange-Swift.h"

@interface PNChartViewController ()<IChartAxisValueFormatter>
@property BarChartView *chartView;
@property LineChartView *lch;
@property NSMutableArray *banks;
@property NSMutableArray *json;
@property NSMutableArray *json2;
@property UISegmentedControl *sgctl;
@property UISegmentedControl *sgctl1;
@property UISegmentedControl *sgctl2;
@property UILabel *best;
@property UILabel *badest;
@property int days;
@end

@implementation PNChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.days = 7;
    
    _sgctl = [[UISegmentedControl alloc] initWithItems:@[@"汇率比价", @"汇率走势"]];
    _sgctl.frame = CGRectMake(self.view.bounds.size.width / 2 - 70, 70, 140, 30);
    [_sgctl setSelectedSegmentIndex:0];
    [_sgctl addTarget:self action:@selector(selectSgcl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_sgctl];
    
    _sgctl1 = [[UISegmentedControl alloc] initWithItems:@[@"钞买价", @"汇买价", @"卖出价", @"中间价"]];
    _sgctl1.frame = CGRectMake(0, 110, self.view.bounds.size.width, 30);
    [_sgctl1 setSelectedSegmentIndex:0];
    [_sgctl1 setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_sgctl1 addTarget:self action:@selector(selectSegment1:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_sgctl1];
    
    _sgctl2 = [[UISegmentedControl alloc] initWithItems:@[@"最近一周", @"最近一月"]];
    _sgctl2.frame = CGRectMake(100, 480, self.view.bounds.size.width - 200, 30);
    [_sgctl2 addTarget:self action:@selector(selectSegment1:) forControlEvents:UIControlEventValueChanged];
    
    _best = [[UILabel alloc] initWithFrame:CGRectMake(10, 480, self.view.bounds.size.width-20, 30)];
    _best.textAlignment = NSTextAlignmentCenter;
    _badest = [[UILabel alloc] initWithFrame:CGRectMake(10, 520, self.view.bounds.size.width-20, 30)];
    _badest.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_best];
    [self.view addSubview:_badest];
    
    //回调或者说是通知主线程刷新，
    _chartView = [[BarChartView alloc] initWithFrame:CGRectMake(10, 150, self.view.bounds.size.width - 20, 300)];
    _chartView.delegate = self;
    _chartView.drawValueAboveBarEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;

    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.valueFormatter = self;
    _chartView.rightAxis.minWidth = 0;
    
    [self.view addSubview:_chartView];
    
    _lch = [[LineChartView alloc] initWithFrame:CGRectMake(10, 150, self.view.bounds.size.width - 20, 300)];
    [self.view addSubview:_lch];
    [_lch removeFromSuperview];
    // 判断网络是否通畅
    if ([Reachable isConnectionAvailableInView:self.view]) {
        
        [self selectSgcl:_sgctl];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)sortObject:(NSMutableArray *)obj byKey:(NSString *)key {
    NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES];
    return [obj sortedArrayUsingDescriptors:@[descriptor]];
}

// 比价图
- (void)setDataWithXArray:(NSMutableArray *)xValArray andWithYArray:(NSMutableArray *)yValArray {
    _best.text = [NSString stringWithFormat:@"%@ %@",_best.text, [_banks objectAtIndex:0]];
    _best.textColor = [UIColor blueColor];
    _badest.text = [NSString stringWithFormat:@"%@ %@",_badest.text, [_banks objectAtIndex:[_banks count] - 1]];
    _badest.textColor = [UIColor redColor];
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < yValArray.count; i++) {
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:[[yValArray objectAtIndex:i] doubleValue]];
        [yVals addObject:entry];
    }
    
    BarChartDataSet *set1 = nil;
    
    if (_chartView.data.dataSetCount > 0) {
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yVals;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    } else {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:nil];
        [set1 setColors:ChartColorTemplates.material];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        data.barWidth = 0.9f;
        
        _chartView.data = data;
    }
}

// 汇率走势图
- (void)setDataToLineChartWithXArray: (NSMutableArray *)xArray andYArray:(NSMutableArray *)yArray {
    
    LineChartDataSet *set1 = nil;
    if (_lch.data.dataSetCount > 0) {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yArray;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    } else {
        set1 = [[LineChartDataSet alloc] initWithValues:yArray label:nil];
        
        set1.lineDashLengths = @[@5.f, @2.5f];
        set1.highlightLineDashLengths = @[@5.f, @2.5f];
        [set1 setColor:UIColor.blackColor];
        [set1 setCircleColor:UIColor.blackColor];
        set1.lineWidth = 0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.formLineDashLengths = @[@5.f, @2.5f];
        set1.formLineWidth = 0;
        set1.formSize = 15.0;
        
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        _lch.data = data;
    }
}


-(NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    return [_banks objectAtIndex:[[NSNumber numberWithDouble:value] integerValue]];
}


-(void)selectSegment1: (UISegmentedControl *)sender{
    // 汇率比价
    if ([self.sgctl selectedSegmentIndex] == 0) {
        _best.text = @"最优：";
        _badest.text = @"最差：";
        NSMutableArray *sorted = [[NSMutableArray alloc] init];
        NSMutableArray *exchange = [[NSMutableArray alloc] init];
        _banks = [[NSMutableArray alloc] init];
        NSString *key = [[NSString alloc] init];
        switch ([sender selectedSegmentIndex]) {
            case 3:
                key = @"cenPrice";
                self.chartView.descriptionText = @"中间价比价";
                _best.text = @"最优：";
                break;
            case 1:
                key = @"remittanceBuyPrice";
                self.chartView.descriptionText = @"汇买价比价";
                break;
            case 2:
                key = @"sellPrice";
                self.chartView.descriptionText = @"卖出价比价";
                break;
            default:
                key = @"cashBuyPrice";
                self.chartView.descriptionText = @"钞买价比价";
                break;
        }
        sorted = [self sortObject:_json byKey:key];
        
        for (int i = 0; i < [sorted count]; i++) {
            [exchange addObject:[[sorted objectAtIndex:i] valueForKey:key]];
            [_banks addObject:[[sorted objectAtIndex:i] valueForKey:@"bank"]];
            
        }
        
        ChartYAxis *yAxis = _chartView.leftAxis;
        if ([[exchange objectAtIndex:0] floatValue] == 0) {
            yAxis.axisMinValue = 0;
        } else {
            yAxis.axisMinValue = [[exchange objectAtIndex:0] floatValue] - 1;
            yAxis.axisMaxValue = [[exchange objectAtIndex:[exchange count] - 1] floatValue] + 1;
        }
        
        [self setDataWithXArray:_bank andWithYArray:exchange];
    } else {
        NSMutableArray *xArray = [[NSMutableArray alloc] init];
        NSMutableArray *yArray = [[NSMutableArray alloc] init];
        NSString *key = [[NSString alloc] init];
        switch ([sender selectedSegmentIndex]) {
            case 3:
                key = @"cenPrice";
                self.chartView.descriptionText = @"中间价走势图";
                break;
            case 1:
                key = @"remittanceBuyPrice";
                self.chartView.descriptionText = @"汇买价走势图";
                break;
            case 2:
                key = @"sellPrice";
                self.chartView.descriptionText = @"卖出价走势图";
                break;
            default:
                key = @"cashBuyPrice";
                self.chartView.descriptionText = @"钞买价走势图";
                break;
        }
        for (int i = 0; i < [_json2 count]; i++) {
            [xArray addObject:[[_json2 objectAtIndex:i] objectForKey:@"timestamp"]];
            ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[[[_json2 objectAtIndex:i] objectForKey:key] doubleValue]];
            [yArray addObject:entry];
        }
        
        ChartYAxis *yAxis = _lch.leftAxis;
        yAxis.axisMinValue = ([[[_json2 objectAtIndex:0] objectForKey:key] floatValue] + [[[_json2 objectAtIndex:[_json2 count] - 1] objectForKey:key] floatValue]) / 2 * 0.95;
        yAxis.axisMaxValue = ([[[_json2 objectAtIndex:0] objectForKey:key] floatValue] + [[[_json2 objectAtIndex:[_json2 count] - 1] objectForKey:key] floatValue]) / 2 * 1.05;
        
        [self setDataToLineChartWithXArray:xArray andYArray:yArray];

    }
    

}

-(void) selectSgcl: (UISegmentedControl *) sender {
    if ([_sgctl selectedSegmentIndex] == 0) {
        if (!_json) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *urlStr = [NSString stringWithFormat:@"https://exchange.terrynie.com/exchange/parity?currency=%@", _currency];
                NSString *encoding = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:encoding];
                NSError *err;
                NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&err];
                _json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                if (err) {
                    NSLog(@"%@", err);
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.lch removeFromSuperview];
                        [self.sgctl2 removeFromSuperview];
                        [self.view addSubview:_chartView];
                        [self.view addSubview:_badest];
                        [self.view addSubview:_best];
                        [self selectSegment1:_sgctl1];
                    });
                }
            });
        } else {
            [self.lch removeFromSuperview];
            [self.sgctl2 removeFromSuperview];
            [self.view addSubview:_chartView];
            [self.view addSubview:_badest];
            [self.view addSubview:_best];
            [self selectSegment1:_sgctl1];
        }
        
    } else {
        if(!_json2) {
            if ([_sgctl2 selectedSegmentIndex] == 0) {
                _days = 7;
            } else if ([_sgctl2 selectedSegmentIndex] == 1) {
                _days = 30;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *urlStr = [NSString stringWithFormat:@"https://exchange.terrynie.com/exchange/exchangeByDays?currency=%@&bank=%@&days=%d", _currency, _bank, _days];
                NSString *encoding = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:encoding];
                NSError *err;
                NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&err];
                _json2 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                if (err) {
                    NSLog(@"%@", err);
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                    [self selectSegment1:_sgctl1];
                        [self.chartView removeFromSuperview];
                        [_best removeFromSuperview];
                        [_badest removeFromSuperview];
                        [self.view addSubview:_lch];
                        [self.view addSubview:_sgctl2];
                        [self selectSegment1:_sgctl1];
                    });
                }
            });
        } else {
            [self.chartView removeFromSuperview];
            [_best removeFromSuperview];
            [_badest removeFromSuperview];
            [self.view addSubview:_lch];
            [self.view addSubview:_sgctl2];
            [self selectSegment1:_sgctl1];
        }
    }
}



@end
