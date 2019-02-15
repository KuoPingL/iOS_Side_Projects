//
//  BikeClusterItem.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/24.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "BikeClusterItem.h"
#import "UIColor+JLColor.h"

static const float kInsetPercentage = 0.17f;

@interface BikeClusterItem()
@property (nonatomic) UIImage *markerImage;
@property (nonatomic) CGRect iconSize;
@property (nonatomic) int bikeApproximatePercentage;
@property (nonatomic) NSString *key, *stationName, *percentageKey;
@property (nonatomic) BOOL isFavorite;
@end

@implementation BikeClusterItem

#pragma mark - CLASS METHODs
+(UIImage *)getIconWithRect:(CGRect)iconSize
                forBikeModel:(BikeModel *) bikeModel {
    return [BikeClusterItem getDotIconforBikeModel:bikeModel withRect:iconSize];
}

// New Icon Image Getter
+(UIImage *)getDotIconforBikeModel:(BikeModel *)bikeModel
                          withRect:(CGRect)iconRect {
    UIColor *dotColor = [UIColor whiteColor];
    
    if ([bikeModel isActive]) {
        float percentage = ((float)[bikeModel getBikeNumber])/((float)[bikeModel getTotalSpaces]);
        dotColor = [UIColor colorForBikeAvailable:percentage];
    }
    
    CGRect outerRect = iconRect;
    
    CGFloat outerRectInset = 1.0f;
    outerRect = CGRectMake(outerRect.origin.x + outerRectInset, outerRect.origin.y + outerRectInset, outerRect.size.width - 2 * outerRectInset, outerRect.size.height - 2 * outerRectInset);
    
    CGFloat innerX = outerRect.size.width * kInsetPercentage;
    CGFloat innerY = outerRect.size.height * kInsetPercentage;
    CGFloat innerWidth = outerRect.size.width - 2 * innerX;
    CGFloat innerHeight = outerRect.size.height - 2 * innerY;
    
    CGRect innerRect = CGRectMake(innerX, innerY, innerWidth, innerHeight);
    
    // FONT
    UIFont *font = [UIFont JLFontWithStyle:UIFontTextStyleBody withFontType:JLFONTTYPES_CAVIARDREAMS_BOLD];
    NSMutableParagraphStyle *pargraphStyle = [NSMutableParagraphStyle new];
    pargraphStyle.alignment = NSTextAlignmentCenter;
    pargraphStyle.minimumLineHeight = innerRect.size.height / 2.0;
    
    NSDictionary *attr = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:pargraphStyle, NSForegroundColorAttributeName : [UIColor whiteColor] };
    
    NSAttributedString *bikeType = [[NSAttributedString alloc] initWithString:[bikeModel getBikeTypeString] attributes:attr];
    
    CGFloat strHeight = bikeType.size.height;
    CGFloat strWidth = bikeType.size.width;
    
    CGPoint strCenter = CGPointMake(innerX + innerWidth / 2.0, innerY + innerHeight / 2.0);
    CGRect strRect = CGRectMake(strCenter.x - strWidth / 2.0, strCenter.y - strHeight / 2.0, strWidth, strHeight);
    
    // Create a Images
    UIImage *outerImage = nil;
    if ([bikeModel isFavorite]) {
        outerImage = [UIImage imageNamed:@"FavoriteTop"];
    }
    
    
    // Create Path
    CGPoint center = CGPointMake(outerRect.size.width / 2.0, outerRect.size.height / 2.0);
    CGFloat radius = outerRect.size.width / 2.0 - 5;
    
    UIBezierPath *outerCircle = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2.0f clockwise:true];
    outerCircle.lineWidth = 2.0;
    outerCircle.lineJoinStyle = kCGLineJoinRound;
    outerCircle.lineCapStyle = kCGLineCapRound;
    outerCircle.flatness = 0;
    
    UIBezierPath *innerCircle = [UIBezierPath bezierPathWithOvalInRect:innerRect];
    
    
    // Create a Final Image
    //    UIGraphicsBeginImageContextWithOptions(iconSize.size, false, 1.0);
    
    UIGraphicsImageRenderer *graphicRenderer = [[UIGraphicsImageRenderer alloc] initWithBounds:iconRect];
    
    //draw Images
    UIImage *finalImage = [graphicRenderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        
        [[bikeModel getBikeAvailableColor] setStroke];
        [[bikeModel getBikeAvailableColor] setFill];
        
        if (outerImage != nil){
            [outerImage drawInRect:outerRect];
        } else {
            [outerCircle stroke];
        }
        
        [innerCircle fill];
        
        [bikeType drawInRect:strRect];
    }];
    
    return finalImage;
}

#pragma mark - INSTANCE METHODs
- (instancetype)initWithPosition:(CLLocationCoordinate2D)position
                       bikeModel:(BikeModel *) bikeModel {
    if ((self = [super init])) {
        _position       = position;
        _key            = [bikeModel getUniqueKey];
        _stationName    = [bikeModel getStationName];
        _percentageKey  = [[bikeModel getBikeTypeString] stringByAppendingFormat:@" %d", [self getBikeAveragePercentage:bikeModel]];
        _isFavorite     = [bikeModel isFavorite];
    }
    
    return self;
}


- (int)getBikeAveragePercentage:(BikeModel *)model {
    CGFloat bikeAvailablePercentage = (CGFloat)([model getBikeNumber]) / (CGFloat)([model getTotalSpaces]);
    
    _bikeApproximatePercentage = (int)(bikeAvailablePercentage * 100);
    
    return _bikeApproximatePercentage;
}

- (NSString *)getClusterItemKey {
    return _percentageKey;
}

- (NSString *)getUniqueKey {
    return _key;
}

- (BOOL)isFavorite {
    return _isFavorite;
}






@end
