//
//  Utilities.h
//  HCPSalesAid
//
//  Created by cmholden on 27/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject


+ (NSString *)urlEncodeWithString: (NSString*)string;

+ (NSString *)uRLDecode : (NSString *)result;
+ (UIColor *) getSAPGold;
+ (UIColor *) getSAPGoldAlt;
+ (UIColor *) getLightGray;
+ (UIColor *) getDarkGray;

+ (UIFont *) getBoldFont : (int) size;

+ (UIFont *) getFont : (int) size;

+ (UIFont *) getItalicFont : (int) size;

+ (NSString *) getSizeAsDiskSize : (int) len;

@end
