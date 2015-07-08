//
//  AssetDataObject.h
//  HCPSalesAid
//
//  Created by cmholden on 26/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AssetDataObject : NSObject <NSCoding>



@property (strong, nonatomic) NSString *fileName;

@property (strong, nonatomic) NSString *assetId;
@property (strong, nonatomic) NSString *assetType;
@property (strong, nonatomic) NSString *desc;
@property (nonatomic) double tstamp;
@property (nonatomic) int fileLength;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *format;
@property (strong, nonatomic) NSString *fileTime;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *trainingType;
@property (strong, nonatomic) NSString *topic;
@property (strong, nonatomic) NSString *sizeDesc;
@property (strong, nonatomic) NSString *internal;

@end
