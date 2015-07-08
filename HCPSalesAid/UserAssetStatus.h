//
//  UserAssetStatus.h
//  HCPSalesAid
//
//  Created by cmholden on 03/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAssetStatus : NSObject<NSCoding>

@property (strong, nonatomic) NSString *fileName;

@property (nonatomic) double tstamp;
@property (nonatomic) double percentComplete;
@property (nonatomic) int numViews;

- (NSString *) valuesAsJSON;

@end