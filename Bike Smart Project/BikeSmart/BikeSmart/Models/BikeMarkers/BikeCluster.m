//
//  BikeCluster.m
//  BikeSmart
//
//  Created by Jimmy on 2018/1/15.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import "BikeCluster.h"
#import "UILabel+JLLabel.h"
#import "UIColor+JLColor.h"

static const CGFloat kInsetPercentage = 0.17f;
static const CGFloat kLineWidth = 2.0f;

@implementation BikeCluster

+(UIImage *) getClusterImageWithItems:(int) numberOfItem
                             forModel:(__weak BikeModel *) bikeModel
                             withSize:(CGSize) size {
    // TODO: change SIZE to MAX SIZE
    
    // CREATE FONT & PARAGRAPH
    UIFont *counterFont = [UIFont JLFontWithStyle:UIFontTextStyleBody withFontType:JLFONTTYPES_CAVIARDREAMS_BOLD];
    NSMutableParagraphStyle *paragraphicStyle = [NSMutableParagraphStyle new];
    paragraphicStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *counterAttr = @{NSFontAttributeName: counterFont,
                                  NSParagraphStyleAttributeName: paragraphicStyle,
                                  NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    // CREATE ATTRIBUTED STRING
    NSAttributedString *counterStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", numberOfItem] attributes:counterAttr];
    
    // CREATE LABEL
    UILabel *counterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    counterLabel.attributedText = counterStr;
    [counterLabel sizeToFitWithMaxWidth:size.width * (1 -kInsetPercentage)];
    
    // RECALCULATE LABEL ORIGIN
    // INCREASE WIDTH of counterRoundRect
    CGSize counterSize = counterLabel.frame.size;
    counterSize.width += 5;
    if (counterSize.height > counterSize.width){
        counterSize.width = counterSize.height;
    }
    CGPoint counterOrigin = CGPointMake(counterSize.width * kInsetPercentage / 2.0 + kLineWidth, counterSize.height * kInsetPercentage / 2.0 + kLineWidth);
    
    counterLabel.frame = (CGRect){counterOrigin, counterSize};
    
    // SETUP PATHs
    UIBezierPath *counterRoundRect = [UIBezierPath bezierPathWithRoundedRect:counterLabel.frame cornerRadius: counterLabel.frame.size.height / 2.0 - 5];
    
    counterRoundRect.lineWidth = kLineWidth;
    counterRoundRect.lineJoinStyle = kCGLineJoinRound;
    counterRoundRect.lineCapStyle = kCGLineCapRound;
    counterRoundRect.flatness = 0.0;
    
    CGFloat outlineHeight = counterSize.height * (1 + kInsetPercentage);
    CGFloat outlineWidth = counterSize.width * (1 + kInsetPercentage);
    
    UIBezierPath *counterOutline = [UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointMake(kLineWidth, kLineWidth), CGSizeMake(outlineWidth, outlineHeight)} cornerRadius: outlineHeight / 2.0 - 5];
    
    counterOutline.lineWidth = kLineWidth;
    counterOutline.lineJoinStyle = kCGLineJoinRound;
    counterOutline.lineCapStyle = kCGLineCapRound;
    counterOutline.flatness = 0.0;
    
    
    
    // CREATE IMAGE
    UIGraphicsImageRenderer *graphicRenderer = [[UIGraphicsImageRenderer alloc] initWithBounds:(CGRect){CGPointZero, size}];
    //draw Images
    UIImage *finalImage = [graphicRenderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        UIColor *mainColor = [UIColor districtColor:(int)[bikeModel getBikeType]];
        
        [mainColor setStroke];
        [mainColor setFill];
        [counterOutline stroke];
        [counterRoundRect fill];
        [counterStr drawInRect:counterLabel.frame];
    }];
    
    return finalImage;
}

+(UIView *)getClusterViewWithItems:(int) numberOfItem
                           forModel:(__weak BikeModel *) bikeModel
                          withSize:(CGSize) size {
    
    UIView *outterV = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, size}];
    
    CGSize mainVSize = CGSizeMake(outterV.frame.size.width * 0.8, outterV.frame.size.height * 0.9);
    CGPoint mainVOrigin = CGPointMake(5, outterV.frame.size.height - mainVSize.height);
    
    UIView *mainV = [[UIView alloc] initWithFrame:(CGRect){mainVOrigin, mainVSize}];
    
    mainV.backgroundColor = [bikeModel getPrimaryColor];
    
    UILabel *districtLabel = [UILabel new];
    districtLabel.frame = (CGRect){CGPointMake(5, 5), CGRectInset(mainV.frame, 5, 5).size};
    districtLabel.backgroundColor = [UIColor whiteColor];
    
    UIFont *font = [UIFont JLFontWithStyle:UIFontTextStyleHeadline withFontType:JLFONTTYPES_CAVIARDREAMS_BOLD];
    NSMutableParagraphStyle *paraStyle = [NSMutableParagraphStyle new];
    paraStyle.alignment = NSTextAlignmentCenter;
    NSAttributedString *bikeDistrictString = [[NSAttributedString alloc] initWithString:[bikeModel getStationDistrict] attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle}];
    
    districtLabel.attributedText = bikeDistrictString;
    districtLabel.adjustsFontSizeToFitWidth = true;
    districtLabel.layer.masksToBounds = true;
    districtLabel.layer.cornerRadius = 5;
    [mainV addSubview:districtLabel];
    
    [outterV addSubview:mainV];
    
    return outterV;
}

@end
