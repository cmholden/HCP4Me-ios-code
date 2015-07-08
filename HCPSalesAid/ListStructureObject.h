//
//  ListStructureObject.h
//  HCPSalesAid
//
// Keeps a category name and a list of files belonging to that category
// in an array
//  Created by cmholden on 30/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetDataObject.h"

@interface ListStructureObject : UICollectionReusableView<NSCoding>

@property (strong, nonatomic) NSString *category;

//@property (strong, nonatomic) NSArray *fileList;

@property (strong, nonatomic) NSArray *assetDataObjs;

@end
