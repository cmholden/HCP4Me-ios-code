//
//  ListToggleButton.h
//  HCPSalesAid
//
//  Created by cmholden on 01/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetsCollectionHeaderView.h"

@interface ListToggleButton : UIButton

@property (nonatomic) int sectionNum;
@property (nonatomic) AssetsCollectionHeaderView *headerView;

@end
