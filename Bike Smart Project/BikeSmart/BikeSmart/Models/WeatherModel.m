//
//  WeatherModel.m
//  BikeSmart
//
//  Created by Jimmy on 2018/3/10.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import "WeatherModel.h"

@interface WeatherModel()
    
    @property (nonatomic, readonly) NSString    *primaryKey;
    @property (nonatomic, readonly) NSDate      *startTime;
    @property (nonatomic, readonly) NSDate      *endTime;
    @property (nonatomic, readonly) NSString    *WxElementValue;       // 天氣圖示代碼+描述 ie 多雲
    @property (nonatomic, readonly) NSNumber    *WxParameterValue;     //                    02
    @property (nonatomic, readonly) NSNumber    *PopElementValue;      // (Probability of Precipitation)
    @property (nonatomic, readonly) NSString    *PopElementMeasure;    // %
    @property (nonatomic, readonly) NSNumber    *PopSixHElementValue;
                                                    // (Probability of Precipitation in 6 Hour)
    @property (nonatomic, readonly) NSString   *PopSixHElementMeasure; // %
    @property (nonatomic, readonly) NSNumber   *ATElementValue;        // (Apparent Temperature)
    @property (nonatomic, readonly) NSString   *ATElementMeasure;      // C
    @property (nonatomic, readonly) NSNumber   *TElementValue;
    @property (nonatomic, readonly) NSString   *TElementMEasure;       // C
    @property (nonatomic, readonly) NSString   *CIParameterValue;      // 體感舒適度
    @property (nonatomic, readonly) NSString   *WindParameterEnValue;  // NE
    @property (nonatomic, readonly) NSString   *WindParameterZhValue;  // 東北方
    @property (nonatomic, readonly) NSString   *WindParameterSpeed;    // < 1
    @property (nonatomic, readonly) NSString   *WindParameterSpeedUnit;// m/s
    @property (nonatomic, readonly) NSString   *WeatherDescription;    // WeatherDescription
    
@end

@implementation WeatherModel



@end
