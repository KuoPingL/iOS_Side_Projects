//
//  UIColor+JLColor.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/4.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "UIColor+JLColor.h"

@implementation UIColor (JLColor)


/**
 Convert hex String to UIColor

 @param hex hexidecimal in string (example: @"#123456")
 @return UIColor *
 */
+ (UIColor *) colorWithHexString: (NSString *) hex {
    
    NSMutableString *newString = [NSMutableString new];
    
    if (hex.length == 6) {
        [newString appendFormat:@"01%@", hex];
    } else {
        [newString appendString:hex];
    }
    
    UInt32 x = (UInt32)strtoul([newString UTF8String], NULL, 16);
    /*
     Convert from String to Long
     1. str: 
     C-string beginning with the representation of an integral number.
     
     2. endptr
     Reference to an object of type char*, whose value is set by the function to the next character in str after the numerical value.
     This parameter can also be a null pointer, in which case it is not used.
     
     3. base
     Numerical base (radix) that determines the valid characters and their interpretation.
     If this is 0, the base used is determined by the format in the sequence (see above).
     
     */
    return [UIColor colorWithHex:(UInt32)x];
}


/**
 Convert hex UInt32 to UIColor

 @param hex hexidecimal (example: 0x123456)
 @return UIColor *
 */
+ (UIColor *)colorWithHex:(UInt32)hex {
    unsigned char r, g, b;
    b = hex & 0xFF;
    g = (hex >> 8) & 0xFF;
    r = (hex >> 16) & 0xFF;
    return [UIColor colorWithRed:(float) r/255.0f green:(float) g/255.0f blue:(float) b/255.0f alpha:1];
}

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    unsigned char r, g, b;
    b = hex & 0xFF;
    g = (hex >> 8) & 0xFF;
    r = (hex >> 16) & 0xFF;
        
    return [UIColor colorWithRed:(float) r/255.0f green:(float) g/255.0f blue:(float) b/255.0f alpha:alpha];
}

+ (UIColor *)BikeSmart_MainGray {
    return [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:205.0/255.0 alpha:1.0];
}

+ (UIColor *)colorForBikeAvailable:(float)bikeAvailable {
    if (bikeAvailable >= 0.7) {
        // green
        return [UIColor colorWithIntRed:29 green:190 blue:114 alpha:1.0];
    } else if (bikeAvailable <= 0.3) {
        // red
        return [UIColor colorWithIntRed:204 green:23 blue:44 alpha:1.0];
    }
    // blue
    return [UIColor colorWithIntRed:60 green:129 blue:194 alpha:1.0];
}

+ (UIColor *)districtColor:(int) rawBikeType {
    
    /*
     typedef enum : NSUInteger {
     CBike_KS = 1,   // 高雄
     EBike_CY,       // 嘉義
     IBike_TC,       // Taichung
     KBike_KM,       // Kinmen
     PBike_PD,       // 屏東
     TBike_TN,       // Tainan
     UBike_CH,       // 彰化 ... 無
     UBike_HC,       // 新竹 ... 無
     UBike_NTP,      // New Taipei
     UBike_TY,       // TaoYuan
     UBike_TP,       // Taipei
     } BikeTypes;
     */
    
    switch (rawBikeType) {
        case 1: // 高雄
            return [UIColor colorWithIntRed:253 green:132 blue:36 alpha:1.0];
            break;
        case 2: // 嘉義
            return [UIColor colorWithIntRed:216 green:38 blue:38 alpha:1.0];
            break;
        case 3: // Taichung
            return [UIColor colorWithIntRed:139 green:196 blue:70 alpha:1.0];
            break;
        case 4: // Kinmen
            return [UIColor colorWithIntRed:247 green:188 blue:44 alpha:1.0];
            break;
        case 5: // 屏東
            return [UIColor colorWithIntRed:7 green:188 blue:44 alpha:1.0];
            break;
        case 6: // Tainan
            return [UIColor colorWithIntRed:190 green:146 blue:38 alpha:1.0];
            break;
        case 7: // 彰化
            return [UIColor colorWithIntRed:254 green:217 blue:49 alpha:1.0];
            break;
        case 8: // 新竹
            return [UIColor colorWithIntRed:15 green:121 blue:58 alpha:1.0];
            break;
        case 9: // New Taipei
            return [UIColor colorWithIntRed:15 green:105 blue:180 alpha:1.0];
            break;
        case 10: // TaoYuan
            return [UIColor colorWithIntRed:234 green:201 blue:46 alpha:1.0];
            break;
        case 11: // Taipei
            return [UIColor colorWithIntRed:254 green:202 blue:46 alpha:1.0];
            break;
        default:
            return [UIColor blackColor];
            break;
    }
}

+ (UIColor *)colorWithIntRed:(int)r green:(int)g blue:(int)b alpha:(float)a {
    
    CGFloat red = (CGFloat)r / 255.0;
    CGFloat green = (CGFloat)g / 255.0;
    CGFloat blue = (CGFloat)b / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:a];
}



@end
