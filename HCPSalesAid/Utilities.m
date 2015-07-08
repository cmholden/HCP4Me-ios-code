//
//  Utilities.m
//  HCPSalesAid
//
//  Created by cmholden on 27/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities


+ (NSString *)urlEncodeWithString: (NSString*)string
{
    if( [string isEqual: [NSNull null]])
        return nil;
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    NULL,
                                                                    (CFStringRef)string,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                    kCFStringEncodingUTF8 );
    return (NSString *)CFBridgingRelease(urlString);
}


+ (NSString *)uRLDecode : (NSString *)result{
    if( [result isEqual: [NSNull null]])
        return @"";
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

+ (UIColor *) getSAPGold{
    return [UIColor colorWithRed:((float)240)/255 green:((float)171)/255 blue:0.0f alpha:1.0f];
}

+ (UIColor *) getSAPGoldAlt{
    return [UIColor colorWithRed:((float)248)/255 green:((float)194)/255 blue:((float)63)/255 alpha:1.0f];
}

+ (UIColor *) getLightGray{
    return [UIColor colorWithRed:((float)204)/255 green:((float)204)/255 blue:((float)204)/255 alpha:1.0f];
}
+ (UIColor *) getMediumGray{
    return [UIColor colorWithRed:((float)153)/255 green:((float)153)/255 blue:((float)153)/255 alpha:1.0f];
}
+ (UIColor *) getDarkGray{
    return [UIColor colorWithRed:((float)102)/255 green:((float)102)/255 blue:((float)102)/255 alpha:1.0f];
}

@end
