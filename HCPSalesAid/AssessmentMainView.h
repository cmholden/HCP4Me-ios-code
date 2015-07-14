//
//  AssessmentMainView.h
//  HCPSalesAid
//
//  Created by cmholden on 10/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentViewDelegate.h"
#import "AssessmentCollectionView.h"
#import "AssetsCollectionFooterView.h"
#import "AssetsCollectionHeaderView.h"
#import "AssessmentCollectionViewCell.h"
#import "CustomBadge.h"
#import "Utilities.h"

@interface AssessmentMainView : UIView


@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *outstandingNum;
@property (strong, nonatomic) UILabel *outstanding;
@property (strong, nonatomic) UILabel *completedNum;
@property (strong, nonatomic) UILabel *completed;
@property (strong, nonatomic) AssessmentCollectionView *assessmentCollectionView;

@property (strong, nonatomic) id<AssessmentViewDelegate> assessViewDelegate;

- (void) setup;
- (void) setData : (CustomBadge *)badge;

- (void) reloadData;

@end
