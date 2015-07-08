//
//  AssetsCollectionHeaderView.h
//  HCPSalesAid
//
//  Created by cmholden on 29/06/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetsCollectionHeaderView : UICollectionReusableView

@property (nonatomic) BOOL isSelected;

@property (strong, nonatomic) UIImage *downImage;
@property (strong, nonatomic) UIImage *rightImage;
@property (strong, nonatomic) UIImageView *buttonImage;


- (void) setArrowImage : (BOOL) select;

@end
