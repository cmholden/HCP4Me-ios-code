//
//  ProfileViewController.h
//  HCPSalesAid
//
//  Created by cmholden on 08/07/2015.
//  Copyright (c) 2015 cmholden. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AssessmentDataObject.h"
#import "AssetRetriever.h"
#import "UserAssetStatus.h"

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) NSString *userNameTxt;
@property (strong, nonatomic) NSString *userIdTxt;
@property (strong, nonatomic) UILabel *statsTitle;

@property (strong, nonatomic) UILabel *assessCompleted;
@property (strong, nonatomic) UILabel *assessCompletedTxt;
@property (strong, nonatomic) UILabel *assessNotCompleted;
@property (strong, nonatomic) UILabel *assessNotCompletedTxt;
@property (strong, nonatomic) UIImageView *assessCompletedImg;
@property (strong, nonatomic) UIButton *viewAssessments;

@property (strong, nonatomic) UILabel *assetCompleted;
@property (strong, nonatomic) UILabel *assetInProgress;
@property (strong, nonatomic) UILabel *assetNotStarted;

@property (strong, nonatomic) UILabel *assetCompletedTxt;
@property (strong, nonatomic) UILabel *assetInProgressTxt;
@property (strong, nonatomic) UILabel *assetNotStartedTxt;

@property (strong, nonatomic) UIImageView *assetCompletedImg;
@property (strong, nonatomic) UIImageView *assetInProgressImg;
@property (strong, nonatomic) UIImageView *assetNotStartedImg;

@property (strong, nonatomic) UIButton *viewAssets;

@property (strong, nonatomic) UIView *statsView;

@property (strong, nonatomic) AssetRetriever *assetUpdater;

- (void) setName : (NSString *)name : (NSString *) userId;

@end
