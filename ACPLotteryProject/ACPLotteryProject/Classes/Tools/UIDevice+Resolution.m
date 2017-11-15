//
//  UIDevice+Resolution.m
//  JDBClient
//
//  Created by Tu You on 14/12/29.
//  Copyright (c) 2014年 JDB. All rights reserved.
//

#import "UIDevice+Resolution.h"

static int currentWidth = 0;
static int currentHeight = 0;

@implementation UIDevice (Resolutions)

NSString *NSStringFromResolution(UIDeviceResolution resolution)
{
    switch (resolution) {
        case UIDeviceResolution_iPhoneStandard:
            return @"iPhone Standard";
            break;
        case UIDeviceResolution_iPhoneRetina35:
            return @"iPhone Retina 3.5\"";
            break;
        case UIDeviceResolution_iPhoneRetina4:
            return @"iPhone Retina 4\"";
            break;
        case UIDeviceResolution_iPadStandard:
            return @"iPad Standard";
            break;
        case UIDeviceResolution_iPadRetina:
            return @"iPad Retina";
            break;
        case UIDeviceResolution_iPhoneRetina47:
        case UIDeviceResolution_iPhoneRetina47_Big:
            return @"iPhone Retina 4.7\"";
            break;
        case UIDeviceResolution_iPhoneRetina55:
        case UIDeviceResolution_iPhoneRetina55_Big:
            return @"iPhone Retina 5.5\"";
            break;
        case UIDeviceResolution_Unknown:
        default:
            return @"Unknown";
            break;
    }
}

- (UIDeviceResolution)mdf_resolution
{
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    CGFloat pixelWidth = (CGRectGetWidth(mainScreen.bounds) * scale);
    CGFloat pixel = pixelHeight > pixelWidth ? pixelHeight:pixelWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (scale == 3.0f && pixel == 2208.0f)
        {
            resolution = UIDeviceResolution_iPhoneRetina55;
        }
        else if (scale == 3.0f && pixel == 2001.0f)
        {
            resolution = UIDeviceResolution_iPhoneRetina55_Big;
        }
        else if (scale == 2.0f)
        {
            if (pixel == 960.0f)
            {
                resolution = UIDeviceResolution_iPhoneRetina35;
            }
            else if (pixel == 1136.0f)
            {
                // 注：iphone 6 放大模式与 4 寸 retina分辨率相同
                // resolution = UIDeviceResolution_iPhoneRetina47_Big;
                resolution = UIDeviceResolution_iPhoneRetina4;
            }
            else if (pixel == 1334.0f)
            {
                resolution = UIDeviceResolution_iPhoneRetina47;
            }
        }
        else if (scale == 1.0f && pixel == 480.0f)
        {
            resolution = UIDeviceResolution_iPhoneStandard;
        }
    }
    else
    {
        if (scale == 2.0f && pixel == 2048.0f)
        {
            resolution = UIDeviceResolution_iPadRetina;
            
        }
        else if (scale == 1.0f && pixel == 1024.0f)
        {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }
    
    return resolution;
}

- (CGSize)mdf_resolutionSize
{
    CGSize resolusionSize = CGSizeZero;
    UIDeviceResolution resolution = [[UIDevice currentDevice] mdf_resolution];
    switch (resolution) {
        case UIDeviceResolution_iPhoneStandard:
            resolusionSize = CGSizeMake(320, 480);
            break;
        case UIDeviceResolution_iPhoneRetina35:
            resolusionSize = CGSizeMake(640, 960);
            break;
        case UIDeviceResolution_iPhoneRetina4:
        case UIDeviceResolution_iPhoneRetina47_Big: // iphone 6 放大模式
            resolusionSize = CGSizeMake(640, 1136);
            break;
        case UIDeviceResolution_iPadStandard:
            resolusionSize = CGSizeMake(1024, 768);
            break;
        case UIDeviceResolution_iPadRetina:
            resolusionSize = CGSizeMake(2048, 1536);
            break;
        case UIDeviceResolution_iPhoneRetina47:
            resolusionSize = CGSizeMake(750, 1334);
            break;
        case UIDeviceResolution_iPhoneRetina55:
            resolusionSize = CGSizeMake(1242, 2208);
            break;
        case UIDeviceResolution_iPhoneRetina55_Big: // iphone 6 plus 放大模式
            resolusionSize = CGSizeMake(1125, 2001);
            break;
        default:
            break;
    }
    
    return resolusionSize;
}

- (CGSize)mdf_resolutionIphoneOnly
{
    CGSize resolusionSize = CGSizeZero;
    UIDeviceResolution resolution = [[UIDevice currentDevice] mdf_resolution];
    switch (resolution) {
            
        case UIDeviceResolution_iPadStandard:
        case UIDeviceResolution_iPhoneStandard:
            resolusionSize = CGSizeMake(320, 480);
            break;
            
        case UIDeviceResolution_iPhoneRetina4:
        case UIDeviceResolution_iPhoneRetina47_Big: // iphone 6 放大模式
            resolusionSize = CGSizeMake(640, 1136);
            break;
            
        case UIDeviceResolution_iPadRetina:
        case UIDeviceResolution_iPhoneRetina35:
            resolusionSize = CGSizeMake(640, 960);
            break;
            
        case UIDeviceResolution_iPhoneRetina47:
            resolusionSize = CGSizeMake(750, 1334);
            break;
            
        case UIDeviceResolution_iPhoneRetina55:
            resolusionSize = CGSizeMake(1242, 2208);
            break;
        case UIDeviceResolution_iPhoneRetina55_Big: // iphone 6 plus 放大模式
            resolusionSize = CGSizeMake(1125, 2001);
            break;
        default:
            break;
    }
    
    return resolusionSize;
}

- (BOOL)mdf_retinaResolution
{
    BOOL isRetina = NO;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    if (scale > 1.0) {
        isRetina = YES;
    }
    return isRetina;
}

/**
 *  获取当前设备分辨率宽度
 *
 *  @return 宽度
 */
- (int)mdf_currentDeviceResolutionWidth
{
    if (currentWidth == 0)
    {
        UIDeviceResolution resolution = [[UIDevice currentDevice] mdf_resolution];
        switch (resolution) {
            case UIDeviceResolution_iPhoneStandard:
            case UIDeviceResolution_iPhoneRetina35:
            case UIDeviceResolution_iPhoneRetina4:
            case UIDeviceResolution_iPhoneRetina47_Big: // iphone 6 放大模式
                currentWidth = 320;
                break;
            case UIDeviceResolution_iPhoneRetina47:
            case UIDeviceResolution_iPhoneRetina55_Big: // iphone 6 plus 放大模式
                currentWidth = 375;
                break;
            case UIDeviceResolution_iPhoneRetina55:
                currentWidth = 414;
                break;
            default:
                break;
        }
    }
    return currentWidth;
}


// 获取当前设备分辨率高度
- (int)mdf_currentDeviceResolutionHeight
{
    if (currentHeight == 0)
    {
        UIDeviceResolution resolution = [[UIDevice currentDevice] mdf_resolution];
        switch (resolution) {
            case UIDeviceResolution_iPadStandard:
            case UIDeviceResolution_iPhoneStandard:
            case UIDeviceResolution_iPhoneRetina35:
                currentHeight = 480;
                break;
            case UIDeviceResolution_iPhoneRetina4:
            case UIDeviceResolution_iPhoneRetina47_Big: // iphone 6 放大模式
                currentHeight = 568;
                break;
            case UIDeviceResolution_iPhoneRetina47:
            case UIDeviceResolution_iPhoneRetina55_Big: // iphone 6 plus 放大模式
                currentHeight = 667;
                break;
            case UIDeviceResolution_iPhoneRetina55:
                currentHeight = 736;
                break;
            default:
                break;
        }
    }
    return currentHeight;
}

@end

