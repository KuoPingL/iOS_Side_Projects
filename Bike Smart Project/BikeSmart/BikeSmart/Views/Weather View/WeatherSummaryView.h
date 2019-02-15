//
//  WeatherSummaryView.h
//  BikeSmart
//
//  Created by Jimmy on 2018/3/7.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"

@protocol WeatherSummaryProtocol
-(void)didTriggerWeatherOpener;
@end

@interface WeatherSummaryView : UIView
-(void)setModel:(WeatherModel *)model;
@end
