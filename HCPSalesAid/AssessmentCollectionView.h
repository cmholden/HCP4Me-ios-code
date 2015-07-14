//
//  AssessmentTableView.h
//  HCPSalesAid
//
//  Created by cmholden on 09/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentViewDelegate.h"
#import "AssessmentDataObject.h"
#import "AssessmentCollectionViewCell.h"
#import "AssetsCollectionHeaderView.h"
#import "AssetRetriever.h"
#import "Utilities.h"

@interface AssessmentCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource>

@property(strong,nonatomic) AssetRetriever *assessRetriever;

@property (strong, nonatomic) id<AssessmentViewDelegate> assessViewDelegate;

-(void)setup;

-(NSMutableArray *) setData;

@end
